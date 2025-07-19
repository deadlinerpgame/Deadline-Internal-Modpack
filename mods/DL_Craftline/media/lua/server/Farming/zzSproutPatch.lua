require "Farming/farming_vegetableconf"

-- Pumpkin 
farming_vegetableconf.props["Pumpkin"] = {};
farming_vegetableconf.props["Pumpkin"].seedsRequired = 6;
farming_vegetableconf.props["Pumpkin"].texture = "trees_farming_02_30";
farming_vegetableconf.props["Pumpkin"].waterLvl = 75;
farming_vegetableconf.props["Pumpkin"].timeToGrow = ZombRand(89, 103);
farming_vegetableconf.props["Pumpkin"].minVeg = 2;
farming_vegetableconf.props["Pumpkin"].maxVeg = 3;
farming_vegetableconf.props["Pumpkin"].minVegAutorized = 5;
farming_vegetableconf.props["Pumpkin"].maxVegAutorized = 6;
farming_vegetableconf.props["Pumpkin"].vegetableName = "Pumpkin";
farming_vegetableconf.props["Pumpkin"].growCode = "farming_vegetableconf.growPumpkin";
farming_vegetableconf.props["Pumpkin"].seedName = "Sprout.PumpkinSeed";
farming_vegetableconf.props["Pumpkin"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Pumpkin"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Pumpkin"].phaseName6 = "Farming_Ready for Harvest";


-- Pineapple 
farming_vegetableconf.props["Pineapple"] = {};
farming_vegetableconf.props["Pineapple"].seedsRequired = 1;
farming_vegetableconf.props["Pineapple"].texture = "crop_farming_01_38";
farming_vegetableconf.props["Pineapple"].waterLvl = 75;
farming_vegetableconf.props["Pineapple"].waterLvlMax = 85;
farming_vegetableconf.props["Pineapple"].timeToGrow = ZombRand(56, 62);
farming_vegetableconf.props["Pineapple"].minVeg = 2;
farming_vegetableconf.props["Pineapple"].maxVeg = 2;
farming_vegetableconf.props["Pineapple"].minVegAutorized = 2;
farming_vegetableconf.props["Pineapple"].maxVegAutorized = 2;
farming_vegetableconf.props["Pineapple"].vegetableName = "Pineapple";
farming_vegetableconf.props["Pineapple"].growCode = "farming_vegetableconf.growPineapple";
farming_vegetableconf.props["Pineapple"].seedName = "Sprout.PineappleSeed";
farming_vegetableconf.props["Pineapple"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Pineapple"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Pineapple"].phaseName6 = "Farming_Ready for Harvest";

-- SugarCane 
farming_vegetableconf.props["SugarCane"] = {};
farming_vegetableconf.props["SugarCane"].seedsRequired = 4;
farming_vegetableconf.props["SugarCane"].texture = "crop_farming_02_54";
farming_vegetableconf.props["SugarCane"].waterLvl = 75;
farming_vegetableconf.props["SugarCane"].waterLvlMax = 95;
farming_vegetableconf.props["SugarCane"].timeToGrow = ZombRand(54, 62);
farming_vegetableconf.props["SugarCane"].minVeg = 2;
farming_vegetableconf.props["SugarCane"].maxVeg = 4;
farming_vegetableconf.props["SugarCane"].minVegAutorized = 2;
farming_vegetableconf.props["SugarCane"].maxVegAutorized = 4;
farming_vegetableconf.props["SugarCane"].vegetableName = "Sprout.SugarCane";
farming_vegetableconf.props["SugarCane"].growCode = "farming_vegetableconf.growSugarCane";
farming_vegetableconf.props["SugarCane"].seedName = "Sprout.SugarCaneSeed";
farming_vegetableconf.props["SugarCane"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["SugarCane"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["SugarCane"].phaseName6 = "Farming_Ready for Harvest";

-- Rice
farming_vegetableconf.props["Rice"] = {};
farming_vegetableconf.props["Rice"].seedsRequired = 6;
farming_vegetableconf.props["Rice"].texture = "crop_farming_03_14";
farming_vegetableconf.props["Rice"].waterLvl = 95;
farming_vegetableconf.props["Rice"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Rice"].minVeg = 2;
farming_vegetableconf.props["Rice"].maxVeg = 3;
farming_vegetableconf.props["Rice"].minVegAutorized = 2;
farming_vegetableconf.props["Rice"].maxVegAutorized = 3;
farming_vegetableconf.props["Rice"].vegetableName = "Rice";
farming_vegetableconf.props["Rice"].growCode = "farming_vegetableconf.growRice";
farming_vegetableconf.props["Rice"].seedName = "Sprout.RiceSeed";
farming_vegetableconf.props["Rice"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Rice"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Rice"].phaseName6 = "Farming_Ready for Harvest";