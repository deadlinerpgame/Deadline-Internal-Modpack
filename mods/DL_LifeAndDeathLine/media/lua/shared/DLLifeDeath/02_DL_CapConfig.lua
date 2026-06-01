DL = DL or {}
DL.Config = DL.Config or {}

DL.Config.capBonuses = {

    traits = {
         AdrenalineJunkie = { Fitness = 2, Strength = 1 },
         Strong   = { Strength = 3 },
         Stout    = { Strength = 1 },
         Fit      = { Fitness = 1 },
    },

    occupations = {
         carpenter   = { Woodwork = 2 },
         fireofficer = { Sprinting = 1, Fitness = 1 },
         mechanic    = { Mechanics = 2 },
    },
}

DL.log("cap bonus config loaded (traits=" ..
    tostring(DL.Config.capBonuses.traits and "set" or "empty") ..
    ", occupations=" .. tostring(DL.Config.capBonuses.occupations and "set" or "empty") .. ")")
