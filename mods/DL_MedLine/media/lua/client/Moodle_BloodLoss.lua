if not getActivatedMods():contains("MoodleFramework") then return end;

require "MF_ISMoodle";

MedLine_Moodles = {};

MF.createMoodle("BloodLoss");
MF.createMoodle("BloodTransfusion");

return MedLine_Moodles;