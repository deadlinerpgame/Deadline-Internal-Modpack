require "Definitions/MakeUpDefinitions"
function addNewMakeUpDefinition(name, item, category)
    local makeup = {};
    makeup.name = name;
    makeup.category = category;
    makeup.item = item;
    makeup.makeuptypes = {};
    makeup.makeuptypes[category] = true;
    makeup.makeuptypes["All"] = true;
    makeup.makeuptypes["Tattoo"] = true;
    table.insert(MakeUpDefinitions.makeup, makeup);
end

addNewMakeUpDefinition("Back_Web_Heart", "ElliesTattooParlor.Back_Web_Heart", "Back_Tattoo")
addNewMakeUpDefinition("Back_Wings", "ElliesTattooParlor.Back_Wings", "Back_Tattoo")
addNewMakeUpDefinition("Chest_Map", "ElliesTattooParlor.Chest_Map", "UpperBody_Tattoo")
addNewMakeUpDefinition("Chest_Moon_Leaves", "ElliesTattooParlor.Chest_Moon_Leaves", "UpperBody_Tattoo")
addNewMakeUpDefinition("Chest_No_Ragerts", "ElliesTattooParlor.Chest_No_Ragerts", "UpperBody_Tattoo")
addNewMakeUpDefinition("Chest_Spriggs", "ElliesTattooParlor.Chest_Spriggs", "UpperBody_Tattoo")
addNewMakeUpDefinition("Chest_Tribal", "ElliesTattooParlor.Chest_Tribal", "UpperBody_Tattoo")
addNewMakeUpDefinition("L_Arm_Harvested", "ElliesTattooParlor.L_Arm_Harvested", "LeftArm_Tattoo")
addNewMakeUpDefinition("L_Arm_Mail", "ElliesTattooParlor.L_Arm_Mail", "LeftArm_Tattoo")
addNewMakeUpDefinition("L_Arm_Map", "ElliesTattooParlor.L_Arm_Map", "LeftArm_Tattoo")
addNewMakeUpDefinition("L_Arm_Tribal", "ElliesTattooParlor.L_Arm_Tribal", "LeftArm_Tattoo")
addNewMakeUpDefinition("Neck_Harvested", "ElliesTattooParlor.Neck_Harvested", "Face_Tattoo")
addNewMakeUpDefinition("R_Arm_Harvested", "ElliesTattooParlor.R_Arm_Harvested", "RightArm_Tattoo")
addNewMakeUpDefinition("R_Arm_Mail", "ElliesTattooParlor.R_Arm_Mail", "RightArm_Tattoo")
addNewMakeUpDefinition("R_Arm_Map", "ElliesTattooParlor.R_Arm_Map", "RightArm_Tattoo")
addNewMakeUpDefinition("R_Arm_Tribal", "ElliesTattooParlor.R_Arm_Tribal", "RightArm_Tattoo")
addNewMakeUpDefinition("Tramp_Stamp", "ElliesTattooParlor.Tramp_Stamp", "LowerBody_Tattoo")
addNewMakeUpDefinition("Tribal_Face_1", "ElliesTattooParlor.Tribal_Face_1", "Face_Tattoo")
addNewMakeUpDefinition("Tribal_Face_2", "ElliesTattooParlor.Tribal_Face_2", "Face_Tattoo")
addNewMakeUpDefinition("Tribal_Face_3", "ElliesTattooParlor.Tribal_Face_3", "Face_Tattoo")
