DL = DL or {}
DL.MetalContent = {
    ["DL_MetalLine.Scrap_Iron_S"] = { units = 0.05, metal = "iron", composition = { iron = 1.0 } },
    ["DL_MetalLine.Scrap_Iron_M"] = { units = 0.25, metal = "iron", composition = { iron = 1.0 } },
    ["DL_MetalLine.Scrap_Iron_L"] = { units = 0.5, metal = "iron", composition = { iron = 1.0 } },
    ["DL_MetalLine.Scrap_Copper_S"] = { units = 0.05, metal = "copper", composition = { copper = 1.0 } },
    ["DL_MetalLine.Scrap_Copper_M"] = { units = 0.25, metal = "copper", composition = { copper = 1.0 } },
    ["DL_MetalLine.Scrap_Copper_L"] = { units = 0.5, metal = "copper", composition = { copper = 1.0 } },
    ["DL_MetalLine.Scrap_Aluminum_S"] = { units = 0.05, metal = "aluminum", composition = { aluminum = 1.0 } },
    ["DL_MetalLine.Scrap_Aluminum_M"] = { units = 0.25, metal = "aluminum", composition = { aluminum = 1.0 } },
    ["DL_MetalLine.Scrap_Aluminum_L"] = { units = 0.5, metal = "aluminum", composition = { aluminum = 1.0 } },
    ["DL_MetalLine.Scrap_Tin_S"] = { units = 0.05, metal = "tin", composition = { tin = 1.0 } },
    ["DL_MetalLine.Scrap_Tin_M"] = { units = 0.25, metal = "tin", composition = { tin = 1.0 } },
    ["DL_MetalLine.Scrap_Tin_L"] = { units = 0.5, metal = "tin", composition = { tin = 1.0 } },
    ["DL_MetalLine.Scrap_Zinc_S"] = { units = 0.05, metal = "zinc", composition = { zinc = 1.0 } },
    ["DL_MetalLine.Scrap_Zinc_M"] = { units = 0.25, metal = "zinc", composition = { zinc = 1.0 } },
    ["DL_MetalLine.Scrap_Zinc_L"] = { units = 0.5, metal = "zinc", composition = { zinc = 1.0 } },
    ["DL_MetalLine.Scrap_Lead_S"] = { units = 0.05, metal = "lead", composition = { lead = 1.0 } },
    ["DL_MetalLine.Scrap_Lead_M"] = { units = 0.25, metal = "lead", composition = { lead = 1.0 } },
    ["DL_MetalLine.Scrap_Lead_L"] = { units = 0.5, metal = "lead", composition = { lead = 1.0 } },
    ["DL_MetalLine.Scrap_Nickel_S"] = { units = 0.05, metal = "nickel", composition = { nickel = 1.0 } },
    ["DL_MetalLine.Scrap_Nickel_M"] = { units = 0.25, metal = "nickel", composition = { nickel = 1.0 } },
    ["DL_MetalLine.Scrap_Nickel_L"] = { units = 0.5, metal = "nickel", composition = { nickel = 1.0 } },
    ["DL_MetalLine.Scrap_Chromium_S"] = { units = 0.05, metal = "chromium", composition = { chromium = 1.0 } },
    ["DL_MetalLine.Scrap_Chromium_M"] = { units = 0.25, metal = "chromium", composition = { chromium = 1.0 } },
    ["DL_MetalLine.Scrap_Chromium_L"] = { units = 0.5, metal = "chromium", composition = { chromium = 1.0 } },
    ["DL_MetalLine.Scrap_Silver_S"] = { units = 0.05, metal = "silver", composition = { silver = 1.0 } },
    ["DL_MetalLine.Scrap_Silver_M"] = { units = 0.25, metal = "silver", composition = { silver = 1.0 } },
    ["DL_MetalLine.Scrap_Silver_L"] = { units = 0.5, metal = "silver", composition = { silver = 1.0 } },
    ["DL_MetalLine.Scrap_Gold_S"] = { units = 0.05, metal = "gold", composition = { gold = 1.0 } },
    ["DL_MetalLine.Scrap_Gold_M"] = { units = 0.25, metal = "gold", composition = { gold = 1.0 } },
    ["DL_MetalLine.Scrap_Gold_L"] = { units = 0.5, metal = "gold", composition = { gold = 1.0 } },
    ["DL_MetalLine.Scrap_Titanium_S"] = { units = 0.05, metal = "titanium", composition = { titanium = 1.0 } },
    ["DL_MetalLine.Scrap_Titanium_M"] = { units = 0.25, metal = "titanium", composition = { titanium = 1.0 } },
    ["DL_MetalLine.Scrap_Titanium_L"] = { units = 0.5, metal = "titanium", composition = { titanium = 1.0 } },
    ["DL_MetalLine.Scrap_Carbon_S"] = { units = 0.05, metal = "carbon", composition = { carbon = 1.0 } },
    ["DL_MetalLine.Scrap_Carbon_M"] = { units = 0.25, metal = "carbon", composition = { carbon = 1.0 } },
    ["DL_MetalLine.Scrap_Carbon_L"] = { units = 0.5, metal = "carbon", composition = { carbon = 1.0 } },
}

function DL.getItemMetal(item)
    if not item then return nil end
    local reg = DL.MetalContent[item:getFullType()]
    if reg then return reg.units, reg.composition end
    return nil
end

function DL.isMeltable(item)
    return item ~= nil and DL.MetalContent[item:getFullType()] ~= nil
end

