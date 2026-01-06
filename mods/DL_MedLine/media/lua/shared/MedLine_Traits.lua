require "NPCs/MainCreationMethods";

MedLine_Traits = {};

function MedLine_Traits.AddBloodTypeTraits()
    TraitFactory.addTrait("BloodOPositive", getText("UI_trait_bloodopositive"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
    TraitFactory.addTrait("BloodAPositive", getText("UI_trait_bloodapositive"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
    TraitFactory.addTrait("BloodBPositive", getText("UI_trait_bloodbpositive"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
    TraitFactory.addTrait("BloodABPositive", getText("UI_trait_bloodabpositive"), 0, getText("UI_trait_bloodgroupdesc"), false, false);

    TraitFactory.addTrait("BloodONegative", getText("UI_trait_bloodonegative"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
    TraitFactory.addTrait("BloodANegative", getText("UI_trait_bloodanegative"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
    TraitFactory.addTrait("BloodBNegative", getText("UI_trait_bloodbnegative"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
    TraitFactory.addTrait("BloodABNegative", getText("UI_trait_bloodabnegative"), 0, getText("UI_trait_bloodgroupdesc"), false, false);
end


Events.OnGameBoot.Add(MedLine_Traits.AddBloodTypeTraits);

return MedLine_Traits;