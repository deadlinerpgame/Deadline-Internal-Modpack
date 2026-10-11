DL = DL or {}

DL.ScrapTiers = {
    copper   = { fragments = "DL_MetalLine.Scrap_Copper_S",   scrap = "DL_MetalLine.Scrap_Copper_M",   chunk = "DL_MetalLine.Scrap_Copper_L"   },
    tin      = { fragments = "DL_MetalLine.Scrap_Tin_S",      scrap = "DL_MetalLine.Scrap_Tin_M",      chunk = "DL_MetalLine.Scrap_Tin_L"      },
    aluminum = { fragments = "DL_MetalLine.Scrap_Aluminum_S", scrap = "DL_MetalLine.Scrap_Aluminum_M", chunk = "DL_MetalLine.Scrap_Aluminum_L" },
    iron     = { fragments = "DL_MetalLine.Scrap_Iron_S",     scrap = "DL_MetalLine.Scrap_Iron_M",     chunk = "DL_MetalLine.Scrap_Iron_L"     },
    lead     = { fragments = "DL_MetalLine.Scrap_Lead_S",     scrap = "DL_MetalLine.Scrap_Lead_M",     chunk = "DL_MetalLine.Scrap_Lead_L"     },
    zinc     = { fragments = "DL_MetalLine.Scrap_Zinc_S",     scrap = "DL_MetalLine.Scrap_Zinc_M",     chunk = "DL_MetalLine.Scrap_Zinc_L"     },
    nickel   = { fragments = "DL_MetalLine.Scrap_Nickel_S",   scrap = "DL_MetalLine.Scrap_Nickel_M",   chunk = "DL_MetalLine.Scrap_Nickel_L"   },
    silver   = { scrap = "DL_MetalLine.Scrap_Silver_S" },
    gold     = { scrap = "DL_MetalLine.Scrap_Gold_S"   },
}

function DL.scrapItem(metal, tier)
    local row = DL.ScrapTiers[metal]
    return row and row[tier] or nil
end

DL.ScrapYields = {
    ["Base.SmallSheetMetal"] = {
        { item = "DL_MetalLine.Scrap_Iron_S", n = 5 },
        { choice = { "DL_MetalLine.Scrap_Zinc_S", "DL_MetalLine.Scrap_Nickel_S" }, n = 2 },
    },
    ["Base.SheetMetal"] = {
        { item = "DL_MetalLine.Scrap_Iron_M",     n = 1 },
        { item = "DL_MetalLine.Scrap_Iron_S", n = 6 },
        { choice = { "DL_MetalLine.Scrap_Zinc_S", "DL_MetalLine.Scrap_Nickel_S" }, n = 8 },
    },

    ["Base.BeerCanEmpty"] = { { item = "DL_MetalLine.Scrap_Aluminum_S", n = 4 } },
    ["Base.PopEmpty"]     = { { item = "DL_MetalLine.Scrap_Aluminum_S", n = 4 } },
    ["Base.Pop2Empty"]    = { { item = "DL_MetalLine.Scrap_Aluminum_S", n = 4 } },
    ["Base.Pop3Empty"]    = { { item = "DL_MetalLine.Scrap_Aluminum_S", n = 4 } },
    ["Base.TinCanEmpty"]  = { { item = "DL_MetalLine.Scrap_Tin_S",      n = 4 } },
    ["Radio.ElectricWire"] = { { item = "DL_MetalLine.Scrap_Copper_S",  n = 4 } },

    ["Base.ElectronicsScrap"] = {
        { item = "DL_MetalLine.Scrap_Copper_S",   n = 1 },
        { item = "DL_MetalLine.Scrap_Aluminum_S", n = 1 },
    },

    ["Base.UnusableMetal"] = {
        { rolls = 10, from = {
            "DL_MetalLine.Scrap_Aluminum_S", "DL_MetalLine.Scrap_Tin_S",  "DL_MetalLine.Scrap_Copper_S",
            "DL_MetalLine.Scrap_Nickel_S",   "DL_MetalLine.Scrap_Lead_S", "DL_MetalLine.Scrap_Iron_S",
            "DL_MetalLine.Scrap_Zinc_S",     false,
        } },
    },
}
