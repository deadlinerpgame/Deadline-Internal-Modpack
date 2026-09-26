DL = DL or {}

DL.AMBIENT   = 0
DL.MAX_TEMP  = 100
DL.HEAT_RATE = 8
DL.COOL_RATE = 5
DL.SOLIDUS   = 20
DL.FUEL_CAP  = 60

DL.MeltTemp = { [1] = 30, [2] = 60, [3] = 90 }

DL.CRUCIBLE_CAP = 4

DL.CRUCIBLE_TAG = "DLCrucible"
DL.CrucibleCapacity = {
    ["aerx.CeramicCrucibleSmall"] = 2,
    ["aerx.CeramicCrucible"]      = 4,
}
DL.WARM_TEMP = 5

DL.SALVAGE_FACTOR = 0.6
DL.REFINE_RATE    = 4

DL.FuelList = {
    { type = "Base.TreeBranch",  name = "Tree Branch", maxTemp = 40,  minutes = 4 },
    { type = "Base.WoodenStick", name = "Twigs",       maxTemp = 40,  minutes = 2 },
    { type = "Base.Plank",       name = "Plank",       maxTemp = 45,  minutes = 8 },
    { type = "Base.Log",         name = "Log",         maxTemp = 45,  minutes = 20 },
    { type = "Base.Charcoal",    name = "Charcoal",    maxTemp = 75,  minutes = 10 },
    { type = "Base.Coal",        name = "Coal",        maxTemp = 100, minutes = 15 },
}

DL.Fuel = {}
for _, f in ipairs(DL.FuelList) do DL.Fuel[f.type] = f end

DL.FIRE_SOURCES = { "Base.Lighter", "Base.Matches" }
DL.KINDLING     = { "Base.Twigs", "Base.TreeBranch", "Base.WoodenStick", "Base.RippedSheets", "Base.SheetPaper2", "Base.Newspaper" }

DL.LIGHT_TIME = 250
DL.POUR_TIME  = 150

function DL.getFuel(item)
    return item and DL.Fuel[item:getFullType()] or nil
end

DL.Junk = { "Junk_Slag", "Junk_Dross", "Junk_Clinker", "Junk_Residue" }
DL.JUNK_PER_UNIT = 0.5

function DL.requiredTemp(comp)
    local req = 0
    for m, u in pairs(comp or {}) do
        local md = DL.Metals[m]
        if md and not md.additive and (u or 0) > 0 then
            local t = DL.MeltTemp[md.tier or 1] or 30
            if t > req then req = t end
        end
    end
    return req
end

function DL.hasMeltableMetal(comp)
    for m, u in pairs(comp or {}) do
        local md = DL.Metals[m]
        if md and not md.additive and (u or 0) > 0 then return true end
    end
    return false
end
