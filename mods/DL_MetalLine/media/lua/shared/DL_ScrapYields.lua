DL = DL or {}

DL.ScrapTiers = {
    copper   = { fragments = "aerx.CopperFragments",   scrap = "aerx.CopperScrap",   chunk = "aerx.CopperChunk"   },
    tin      = { fragments = "aerx.TinFragments",      scrap = "aerx.TinScrap",      chunk = "aerx.TinChunk"      },
    aluminum = { fragments = "aerx.AluminumFragments", scrap = "aerx.AluminumScrap", chunk = "aerx.AluminumChunk" },
    iron     = { fragments = "aerx.IronFragments",     scrap = "aerx.IronScrap",     chunk = "aerx.IronChunk"     },
    lead     = { fragments = "aerx.LeadFragments",     scrap = "aerx.LeadScrap",     chunk = "aerx.LeadChunk"     },
    zinc     = { fragments = "aerx.ZincFragments",     scrap = "aerx.ZincScrap",     chunk = "aerx.ZincChunk"     },
    nickel   = { fragments = "aerx.NickelFragments",   scrap = "aerx.NickelScrap",   chunk = "aerx.NickelChunk"   },
    silver   = { scrap = "aerx.SilverScrap" },
    gold     = { scrap = "aerx.GoldScrap"   },
}

function DL.scrapItem(metal, tier)
    local row = DL.ScrapTiers[metal]
    return row and row[tier] or nil
end

DL.ScrapYields = {
    ["Base.SmallSheetMetal"] = {
        { item = "aerx.IronFragments", n = 5 },
        { choice = { "aerx.ZincFragments", "aerx.NickelFragments" }, n = 2 },
    },
    ["Base.SheetMetal"] = {
        { item = "aerx.IronScrap",     n = 1 },
        { item = "aerx.IronFragments", n = 6 },
        { choice = { "aerx.ZincFragments", "aerx.NickelFragments" }, n = 8 },
    },

    ["Base.BeerCanEmpty"] = { { item = "aerx.AluminumFragments", n = 4 } },
    ["Base.PopEmpty"]     = { { item = "aerx.AluminumFragments", n = 4 } },
    ["Base.Pop2Empty"]    = { { item = "aerx.AluminumFragments", n = 4 } },
    ["Base.Pop3Empty"]    = { { item = "aerx.AluminumFragments", n = 4 } },
    ["Base.TinCanEmpty"]  = { { item = "aerx.TinFragments",      n = 4 } },
    ["Radio.ElectricWire"] = { { item = "aerx.CopperFragments",  n = 4 } },

    ["Base.ElectronicsScrap"] = {
        { item = "aerx.CopperFragments",   n = 1 },
        { item = "aerx.AluminumFragments", n = 1 },
    },

    ["Base.UnusableMetal"] = {
        { rolls = 10, from = {
            "aerx.AluminumFragments", "aerx.TinFragments",  "aerx.CopperFragments",
            "aerx.NickelFragments",   "aerx.LeadFragments", "aerx.IronFragments",
            "aerx.ZincFragments",     false,
        } },
    },
}
