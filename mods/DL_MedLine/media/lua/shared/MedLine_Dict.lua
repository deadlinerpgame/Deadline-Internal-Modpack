MedLine_Dict = {};

MedLine_Dict.BLOOD_TYPES = 
{
    { type = "O+", chance = 37.4, canReceiveFrom = {"O+", "O-"}, traitStr = "BloodOPositive" },

    { type = "O-", chance = 6.6, canReceiveFrom = { "O-" }, traitStr = "BloodONegative" },

    { type = "A+", chance = 35.7, canReceiveFrom = { "O+", "O-", "A+", "A-" }, traitStr = "BloodAPositive" },

    { type = "A-", chance = 4.1, canReceiveFrom = { "O-", "A-" }, traitStr = "BloodANegative" },

    { type = "B+", chance = 8.5, canReceiveFrom = {"O+", "O-", "B+", "B-"}, traitStr = "BloodBPositive" },

    { type = "B-", chance = 1.5, canReceiveFrom = { "O-", "B-" }, traitStr = "BloodBNegative" },

    { type = "AB+", chance = 3.4, canReceiveFrom = { "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-" }, traitStr = "BloodABPositive" },

    { type = "AB-", chance = 0.6, canReceiveFrom = { "O-", "A-", "B-", "AB-" }, traitStr = "BloodABNegative"},
};

MedLine_Dict.EventModes = {
    BloodActions = { draw = 1, transfusion = 2 }
};

MedLine_Dict.ModDataKeys = {
    UserData = "MedLine_UserData",
};

return MedLine_Dict;