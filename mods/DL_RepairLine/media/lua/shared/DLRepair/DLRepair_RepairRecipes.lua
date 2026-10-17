DLRepair = DLRepair or {}

DLRepair.Profiles = {

    ["Base.BaseballBat"] = {
        options = {
            { difficulty = "easy",   amount = 2, maxUses = 2, items = { { item = "Base.DuctTape", count = 1 } } },
            { difficulty = "normal", amount = 3, maxUses = 3, items = { { item = "Base.Log",      count = 1 } } },
            { difficulty = "hard",   amount = 6, maxUses = 1, items = { { item = "Base.Plank", count = 1 },
                                                                       { item = "Base.Nails", count = 2 } },
              tools = { "Base.Hammer" } },
        },
    },

    ["Base.Axe"] = {
        options = {
            { difficulty = "normal", restore = 0.45, items = { { item = "Base.DuctTape", count = 2 } } },
            { difficulty = "hard",   restore = 0.80, items = { { item = "Base.MetalBar", count = 1 } },
              maintenanceMin = 3 },
        },
    },

    ["Base.Hammer"] = {
        options = {
            { difficulty = "easy",   amount = 2, items = { { item = "Base.DuctTape", count = 1 } } },
            { difficulty = "normal", amount = 4, items = { { item = "Base.Woodglue", count = 1 } } },
            { difficulty = "hard",   amount = 6, items = { { item = "Base.Plank", count = 1 },
                                                           { item = "Base.Nails", count = 2 } } },
        },
    },

}

DLRepair.Defaults = {

    blade = {
        options = {
            { difficulty = "normal", restore = 0.40, items = { { item = "Base.DuctTape", count = 2 } } },
            { difficulty = "hard",   restore = 0.70, items = { { item = "Base.MetalBar", count = 1 } },
              maintenanceMin = 2 },
            { difficulty = "expert", restore = 0.85, items = { { item = "Base.MetalBar", count = 1 },
                                                               { item = "Base.DuctTape", count = 1 } },
              maintenanceMin = 4 },
        },
    },

    blunt = {
        options = {
            { difficulty = "easy",   restore = 0.45, items = { { item = "Base.DuctTape", count = 1 } } },
            { difficulty = "normal", restore = 0.50, items = { { item = "Base.Glue",     count = 1 } } },
            { difficulty = "hard",   restore = 0.75, items = { { item = "Base.Plank", count = 1 },
                                                              { item = "Base.Nails", count = 2 } },
              tools = { "Base.Hammer" } },
        },
    },

    generic = {
        options = {
            { difficulty = "easy",   restore = 0.40, items = { { item = "Base.DuctTape", count = 1 } } },
            { difficulty = "normal", restore = 0.45, items = { { item = "Base.Glue",     count = 1 } } },
            { difficulty = "hard",   restore = 0.70, items = { { item = "Base.Plank", count = 1 },
                                                              { item = "Base.Nails", count = 2 } },
              tools = { "Base.Hammer" } },
        },
    },

    firearm = {
        options = {
            { difficulty = "easy",   restore = 0.30, items = { { item = "Base.DuctTape", count = 2 } } },
            { difficulty = "normal", restore = 0.50, items = { { item = "Base.ScrapMetal", count = 2 } },
              tools = { "Base.Screwdriver" }, maintenanceMin = 2 },
            { difficulty = "hard",   restore = 0.75, items = { { item = "Base.MetalBar", count = 1 },
                                                              { item = "Base.ScrapMetal", count = 2 } },
              tools = { "Base.Screwdriver" }, maintenanceMin = 4 },
        },
    },

}
