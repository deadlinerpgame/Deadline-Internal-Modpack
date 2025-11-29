---@class BuildingMenu
local BuildingMenu = require("BuildingMenu01_Main");


local function initBuildingMenuRecipes()

    local SurvivalBigLogWallCount = SandboxVars.BuildingMenuRecipes.SurvivalBigLogWallCount or 4;
    local SurvivalBigLogWallRippedSheetsCount = SandboxVars.BuildingMenuRecipes.SurvivalBigLogWallRippedSheetsCount or 4;
    local SurvivalBigLogWallRopesCount = SandboxVars.BuildingMenuRecipes.SurvivalBigLogWallRopesCount or 2;

    local SurvivalSmallLogWallCount = SandboxVars.BuildingMenuRecipes.SurvivalSmallLogWallCount or 2;
    local SurvivalSmallLogWallRippedSheetsCount = SandboxVars.BuildingMenuRecipes.SurvivalSmallLogWallRippedSheetsCount or 4;
    local SurvivalSmallLogWallRopesCount = SandboxVars.BuildingMenuRecipes.SurvivalSmallLogWallRopesCount or 2;

    local SurvivalbigWallWoodCount = SandboxVars.BuildingMenuRecipes.bigWallWoodCount or 4;
    local SurvivalbigWallNailsCount = SandboxVars.BuildingMenuRecipes.bigWallNailsCount or 3;

    local SurvivalsmallWallWoodCount = SandboxVars.BuildingMenuRecipes.bigWallWoodCount or 2;
    local SurvivalsmallWallNailsCount = SandboxVars.BuildingMenuRecipes.bigWallNailsCount or 1;

    local survivalCarpentryLevel6 = 6;
    local survivalCarpentryLevel5 = 5;
    local survivalCarpentryLevel4 = 4;
    local survivalCarpentryLevel3 = 3;
    local survivalCarpentryLevel2 = 2;
    local survivalCarpentryLevel1 = 1;

    local carpentryXpPerLevel = SandboxVars.BuildingMenuRecipes.carpentryXpPerLevel or 2.5;
    local metalweldingXpPerLevel = SandboxVars.BuildingMenuRecipes.metalweldingXpPerLevel or 2.5;

    local metalBarsCount1highfence = SandboxVars.BuildingMenuRecipes.metalBarsCount1highfence or 2;
    local sheetMetalCountWalls1highfence = SandboxVars.BuildingMenuRecipes.sheetMetalCountWalls1highfence or 1;
    local scrapMetalCountFences1highfence = SandboxVars.BuildingMenuRecipes.scrapMetalCountFences1highfence or 2;

    local metalBarsCount1highfencePost = SandboxVars.BuildingMenuRecipes.metalBarsCount1highfencePost or 1;
    local sheetMetalCountWalls1highfencePost = SandboxVars.BuildingMenuRecipes.sheetMetalCountWalls1highfencePost or 1;
    local scrapMetalCountFences1highfencePost = SandboxVars.BuildingMenuRecipes.scrapMetalCountFences1highfencePost or 2;

    local sheetMetalCountForContainers = SandboxVars.BuildingMenuRecipes.sheetMetalCountForDoors or 4;
    local screwsCount = SandboxVars.BuildingMenuRecipes.screwsCount or 10;



-- [[ LEVEL 6 STUFF ]]

-- SURVIVAL BIG LIGHT LOG WALL RECIPE
    BuildingMenu.SurvivalBigLogWallLevel6Recipe = {
 --[[        neededTools = {
            "Hammer",
            "Screwdriver"
        }, ]]--
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Log",
                Amount = SurvivalBigLogWallCount,
            },
            { -- Alternative Groups
                {
                    Material = { "Base.Rope", "Base.SheetRope" }, -- Alternative Items: Within this group these items can be combined to meet the requirement
                    Amount = SurvivalBigLogWallRopesCount,
                },
                {
                    Material = "Base.RippedSheets", -- This can be used as an alternative to the entire first alternative group. (seen with an "or" in front in the material name)
                    Amount = SurvivalBigLogWallRippedSheetsCount,
                }
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }
-- SURVIVAL SMALL LIGHT LOG WALL RECIPE
    BuildingMenu.SurvivalSmallLogWallLevel6Recipe = {
 --[[        neededTools = {
            "Hammer",
            "Screwdriver"
        }, ]]--
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Log",
                Amount = SurvivalSmallLogWallCount,
            },
            { -- Alternative Groups
                {
                    Material = { "Base.Rope", "Base.SheetRope" }, -- Alternative Items: Within this group these items can be combined to meet the requirement
                    Amount = SurvivalSmallLogWallRopesCount,
                },
                {
                    Material = "Base.RippedSheets", -- This can be used as an alternative to the entire first alternative group. (seen with an "or" in front in the material name)
                    Amount = SurvivalSmallLogWallRippedSheetsCount,
                }
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }

-- SURVIVAL BIG LIGHT WALL RECIPE
    BuildingMenu.SurvivalBigWoodWallLevel6Recipe = {
         neededTools = {
            "Hammer",
        }, 
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Plank",
                Amount = SurvivalbigWallWoodCount,
            },
            { -- Material that is required and have no alternatives
                Material = "Base.Nails",
                Amount = SurvivalbigWallNailsCount,
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }
-- SURVIVAL SMALL LIGHT WALL RECIPE
    BuildingMenu.SurvivalSmallWoodWallLevel6Recipe = {
         neededTools = {
            "Hammer",
        }, 
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Plank",
                Amount = SurvivalsmallWallWoodCount,
            },
            { -- Material that is required and have no alternatives
                Material = "Base.Nails",
                Amount = SurvivalsmallWallNailsCount,
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }

-- SURVIVAL WHITE BIG WALL RECIPE
    BuildingMenu.SurvivalWhiteBigWoodWallLevel6Recipe = {
         neededTools = {
            "Hammer",
            "Paintbrush",
        }, 
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Plank",
                Amount = SurvivalbigWallWoodCount,
            },
            { -- Material that is required and have no alternatives
                Material = "Base.Nails",
                Amount = SurvivalbigWallNailsCount,
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.SurvivalWhiteBigWoodWallLevel6Recipe, {
        { type = "Base.PaintWhite", amount = 1 },
    })
-- SURVIVAL WHITE SMALL WALL RECIPE
    BuildingMenu.SurvivalWhiteSmallWoodWallLevel6Recipe = {
         neededTools = {
            "Hammer",
            "Paintbrush",
        }, 
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Plank",
                Amount = SurvivalsmallWallWoodCount,
            },
            { -- Material that is required and have no alternatives
                Material = "Base.Nails",
                Amount = SurvivalsmallWallNailsCount,
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.SurvivalWhiteSmallWoodWallLevel6Recipe, {
        { type = "Base.PaintWhite", amount = 1 },
    })

-- SURVIVAL RED BIG WALL RECIPE
    BuildingMenu.SurvivalRedBigWoodWallLevel6Recipe = {
         neededTools = {
            "Hammer",
            "Paintbrush",
        }, 
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Plank",
                Amount = SurvivalbigWallWoodCount,
            },
            { -- Material that is required and have no alternatives
                Material = "Base.Nails",
                Amount = SurvivalbigWallNailsCount,
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.SurvivalRedBigWoodWallLevel6Recipe, {
        { type = "Base.PaintRed", amount = 1 },
    })
-- SURVIVAL RED SMALL WALL RECIPE
    BuildingMenu.SurvivalRedSmallWoodWallLevel6Recipe = {
         neededTools = {
            "Hammer",
            "Paintbrush",
        }, 
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Plank",
                Amount = SurvivalsmallWallWoodCount,
            },
            { -- Material that is required and have no alternatives
                Material = "Base.Nails",
                Amount = SurvivalsmallWallNailsCount,
            },
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel6,
                Xp = BuildingMenu.round(survivalCarpentryLevel6 * carpentryXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.SurvivalRedSmallWoodWallLevel6Recipe, {
        { type = "Base.PaintRed", amount = 1 },
    })



-- [[ LEVEL 0 STUFF ]]

-- SURVIVAL BIG LOG WALL RECIPE
    BuildingMenu.SurvivalBigLogWallLevel0Recipe = {
 --[[        neededTools = {
            "Hammer",
            "Screwdriver"
        }, ]]--
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Log",
                Amount = SurvivalBigLogWallCount,
            },
            { -- Alternative Groups
                {
                    Material = { "Base.Rope", "Base.SheetRope" }, -- Alternative Items: Within this group these items can be combined to meet the requirement
                    Amount = SurvivalBigLogWallRopesCount,
                },
                {
                    Material = "Base.RippedSheets", -- This can be used as an alternative to the entire first alternative group. (seen with an "or" in front in the material name)
                    Amount = SurvivalBigLogWallRippedSheetsCount,
                }
            },
        },
 --[[        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel0,
                Xp = BuildingMenu.round(survivalCarpentryLevel1 * carpentryXpPerLevel)
            }
        } ]]
    }
-- SURVIVAL SMALL LOG WALL RECIPE
    BuildingMenu.SurvivalSmallLogWallLevel0Recipe = {
 --[[        neededTools = {
            "Hammer",
            "Screwdriver"
        }, ]]--
        neededMaterials = { -- Contains Groups of Materials
            { -- Material that is required and have no alternatives
                Material = "Base.Log",
                Amount = SurvivalSmallLogWallCount,
            },
            { -- Alternative Groups
                {
                    Material = { "Base.Rope", "Base.SheetRope" }, -- Alternative Items: Within this group these items can be combined to meet the requirement
                    Amount = SurvivalSmallLogWallRopesCount,
                },
                {
                    Material = "Base.RippedSheets", -- This can be used as an alternative to the entire first alternative group. (seen with an "or" in front in the material name)
                    Amount = SurvivalSmallLogWallRippedSheetsCount,
                }
            },
        },
 --[[        skills = {
            {
                Skill = "Woodwork",
                Level = survivalCarpentryLevel0,
                Xp = BuildingMenu.round(survivalCarpentryLevel1 * carpentryXpPerLevel)
            }
        } ]]
    }





-- [[ METAL STUFF ]]
-- HIGH FENCE METAL BARS BLACK
    BuildingMenu.HighMetalBarsFenceBlackRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }

    BuildingMenu.HighMetalBarsFencePostBlackRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }

    BuildingMenu.HighMetalBarsDoorBlackRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }

-- HIGH FENCE METAL BARS WHITE
    BuildingMenu.HighMetalBarsFenceWhiteRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFenceWhiteRecipe, {
        { type = "Base.PaintWhite", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostWhiteRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostWhiteRecipe, {
        { type = "Base.PaintWhite", amount = 1 },
    })
    
    BuildingMenu.HighMetalBarsDoorWhiteRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorWhiteRecipe, {
        { type = "Base.PaintWhite", amount = 1 },
    })
-- HIGH FENCE METAL BARS GREEN
    BuildingMenu.HighMetalBarsFenceGreenRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFenceGreenRecipe, {
        { type = "Base.PaintGreen", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostGreenRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostGreenRecipe, {
        { type = "Base.PaintGreen", amount = 1 },
    })
    BuildingMenu.HighMetalBarsDoorGreenRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorGreenRecipe, {
        { type = "Base.PaintGreen", amount = 1 },
    })
-- HIGH FENCE METAL BARS YELLOW
    BuildingMenu.HighMetalBarsFenceYellowRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFenceYellowRecipe, {
        { type = "Base.PaintYellow", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostYellowRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostYellowRecipe, {
        { type = "Base.PaintYellow", amount = 1 },
    })
    BuildingMenu.HighMetalBarsDoorYellowRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorYellowRecipe, {
        { type = "Base.PaintYellow", amount = 1 },
    })
-- HIGH FENCE METAL BARS RED
    BuildingMenu.HighMetalBarsFenceRedRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFenceRedRecipe, {
        { type = "Base.PaintRed", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostRedRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostRedRecipe, {
        { type = "Base.PaintRed", amount = 1 },
    })
    BuildingMenu.HighMetalBarsDoorRedRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorRedRecipe, {
        { type = "Base.PaintRed", amount = 1 },
    })
-- HIGH FENCE METAL BARS GREY
    BuildingMenu.HighMetalBarsFenceGreyRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFenceGreyRecipe, {
        { type = "Base.PaintGrey", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostGreyRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostGreyRecipe, {
        { type = "Base.PaintGrey", amount = 1 },
    })
    BuildingMenu.HighMetalBarsDoorGreyRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorGreyRecipe, {
        { type = "Base.PaintGrey", amount = 1 },
    })
-- HIGH FENCE METAL BARS BLUE
    BuildingMenu.HighMetalBarsFenceBlueRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFenceBlueRecipe, {
        { type = "Base.PaintBlue", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostBlueRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostBlueRecipe, {
        { type = "Base.PaintBlue", amount = 1 },
    })
    BuildingMenu.HighMetalBarsDoorBlueRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorBlueRecipe, {
        { type = "Base.PaintBlue", amount = 1 },
    })
-- HIGH FENCE METAL BARS PURPLE
    BuildingMenu.HighMetalBarsFencePurpleRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 2
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 5,
                Xp = BuildingMenu.round(5 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePurpleRecipe, {
        { type = "Base.PaintPurple", amount = 1 },
    })
    BuildingMenu.HighMetalBarsFencePostPurpleRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfencePost
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfencePost
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfencePost
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfencePost
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2)
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            },
        },
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsFencePostPurpleRecipe, {
        { type = "Base.PaintPurple", amount = 1 },
    })
    BuildingMenu.HighMetalBarsDoorPurpleRecipe = {
        neededTools = {
            "BlowTorch",
            "WeldingMask"
        },
        neededMaterials = {
            {
                {
                    Material = "Base.MetalBar",
                    Amount = metalBarsCount1highfence,
                },
                {
                    Material = "Base.MetalPipe",
                    Amount = metalBarsCount1highfence,
                },
            },
            {
                Material = "Base.SmallSheetMetal",
                Amount = sheetMetalCountWalls1highfence
            },
            {
                Material = "Base.ScrapMetal",
                Amount = scrapMetalCountFences1highfence
            },
            {
                Material = "Base.Screws",
                Amount = 10,
            },
            {
                Material = "Base.Hinge",
                Amount = 2,
            },
            {
                Material = "Base.Doorknob",
                Amount = 1,
            }
        },
        useConsumable = {
            {
                Consumable = "Base.BlowTorch",
                Amount = 1,
            },
            {
                Consumable = "Base.WeldingRods",
                Amount = BuildingMenu.weldingRodUses(2),
            }
        },
        skills = {
            {
                Skill = "MetalWelding",
                Level = 4,
                Xp = BuildingMenu.round(4 * metalweldingXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.HighMetalBarsDoorPurpleRecipe, {
        { type = "Base.PaintPurple", amount = 1 },
    })

-- 100 CAPACITY METAL CONTAINERS
    BuildingMenu.MetalCounterBigRecipeDouble = {
            neededTools = {
                "BlowTorch",
                "WeldingMask",
                "Screwdriver",
            },
            neededMaterials = {
                {
                    Material = "Base.SheetMetal",
                    Amount = BuildingMenu.round(sheetMetalCountForContainers * 2.5)
                },
                {
                    Material = "Base.SmallSheetMetal",
                    Amount = BuildingMenu.round(sheetMetalCountForContainers * 1.5)
                },
                {
                    Material = "Base.Screws",
                    Amount = BuildingMenu.round(screwsCount * 2)
                }
            },
            useConsumable = {
                {
                    Consumable = "Base.BlowTorch",
                    Amount = 10
                },
                {
                    Consumable = "Base.WeldingRods",
                    Amount = BuildingMenu.weldingRodUses(10)
                }
            },
            skills = {
                {
                    Skill = "MetalWelding",
                    Level = 6,
                    Xp = BuildingMenu.round(6 * metalweldingXpPerLevel)
                }
            }
        }



-- Random thing used as example
    BuildingMenu.RedBrownBigWoodWallRecipe = {
        neededTools = {
            "Hammer",
            "Paintbrush"
        },
        neededMaterials = {
            {
                Material = "Base.Plank",
                Amount = bigWallWoodCount
            },
            {
                BuildingMenu.generateGroupAlternatives(BuildingMenu.GroupsAlternatives.Nails, bigWallNailsCount, "Material")
            }
        },
        skills = {
            {
                Skill = "Woodwork",
                Level = bigObjectsCarpentrySkill,
                Xp = BuildingMenu.round(bigObjectsCarpentrySkill * carpentryXpPerLevel)
            }
        }
    }
    BuildingMenu.addPaintToRecipe(BuildingMenu.RedBrownBigWoodWallRecipe, {
        { type = "Base.PaintRed", amount = 1 },
        { type = "Base.PaintBrown", amount = 1 },
    })

end

Events.OnInitializeBuildingMenuRecipes.Add(function()
    initBuildingMenuRecipes()
end)