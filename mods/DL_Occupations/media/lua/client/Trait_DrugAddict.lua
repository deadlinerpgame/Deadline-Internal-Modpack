if isServer() then return end;

if not getActivatedMods():contains("MoodleFramework") then
    return error("Trait - drug addict relies on Moodle Framework which is not loaded.");
end

local trait_points = 6; -- + 6 points.


local function OnGameBoot_DrugAddict()

    if MF then
        MF.createMoodle("DrugWithdrawal");
    end

    -- addTrait(String type, String name, int cost, String desc, boolean profession, boolean removeInMP)
    TraitFactory.addTrait("DL_DrugAddict", getText("UI_Trait_DrugAddict"), trait_points, getText("UI_Trait_DrugAddictDesc"), false, false);
end

Events.OnGameBoot.Add(OnGameBoot_DrugAddict);