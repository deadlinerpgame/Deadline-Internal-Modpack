DLRepair = DLRepair or {}

DLRepair.DefaultReinforce = {
    levels = {
        { difficulty = "hard",   maintenanceMin = 3, xp = 8,
          items = { { item = "Base.DuctTape", count = 3 }, { item = "Base.MetalBar", count = 1 } },
          tools = { "Base.Hammer" } },
        { difficulty = "hard",   maintenanceMin = 4, xp = 10,
          items = { { item = "Base.MetalBar", count = 2 } },
          tools = { "Base.Hammer" } },
        { difficulty = "expert", maintenanceMin = 6, xp = 14,
          items = { { item = "Base.MetalBar", count = 3 }, { item = "Base.MetalPipe", count = 1 } },
          tools = { "Base.Hammer", "Base.Screwdriver" } },
        { difficulty = { base = 0.0, perLevel = 0.07, minLevel = 6 }, maintenanceMin = 7, xp = 18,
          items = { { item = "Base.MetalBar", count = 4 }, { item = "Base.MetalPipe", count = 2 } },
          tools = { "Base.BlowTorch", "Base.Hammer" } },
        { difficulty = { base = 0.0, perLevel = 0.06, minLevel = 8 }, maintenanceMin = 9, xp = 25,
          items = { { item = "Base.MetalBar", count = 6 }, { item = "Base.MetalPipe", count = 3 },
                    { item = "Base.WeldingRods", count = 2 } },
          tools = { "Base.BlowTorch", "Base.WeldingMask", "Base.Hammer" } },
    },
}

DLRepair.ReinforceProfiles = {

    ["Base.BaseballBat"] = {
        levels = {
            { difficulty = "normal", maintenanceMin = 2, xp = 6,
              items = { { item = "Base.DuctTape", count = 4 } }, tools = { "Base.Hammer" } },
            { difficulty = "hard",   maintenanceMin = 4, xp = 10,
              items = { { item = "Base.Plank", count = 1 }, { item = "Base.Nails", count = 4 } },
              tools = { "Base.Hammer" } },
            { difficulty = "expert", maintenanceMin = 6, xp = 16,
              items = { { item = "Base.MetalBar", count = 2 }, { item = "Base.Nails", count = 6 } },
              tools = { "Base.Hammer" } },
        },
    },

}

DLRepair.ReinforceDefaults = {
}
