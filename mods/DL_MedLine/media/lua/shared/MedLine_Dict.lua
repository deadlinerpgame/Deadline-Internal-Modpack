MedLine_Dict = {};

MedLine_Dict.BLOOD_TYPES = 
{
    { type = "O+", chance = 37.4, canReceiveFrom = {"O+", "O-"} },

    { type = "O-", chance = 6.6, canReceiveFrom = { "O-" } },

    { type = "A+", chance = 35.7, canReceiveFrom = { "O+", "O-", "A+", "A-" } },

    { type = "A-", chance = 4.1, canReceiveFrom = { "O-", "A-" } },

    { type = "B+", chance = 8.5, canReceiveFrom = {"O+", "O-", "B+", "B-"} },

    { type = "B-", chance = 1.5, canReceiveFrom = { "O-", "B-" } },

    { type = "AB+", chance = 3.4, canReceiveFrom = { "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-" } },

    { type = "AB-", chance = 0.6, canReceiveFrom = { "O-", "A-", "B-", "AB-" } },
};

return MedLine_Dict;