require 'Foraging/forageSystem'

local function doGenericItemSpawn(_character, _inventory, _itemDef, _items)
	for item in iterList(_items) do
		if item:IsDrainable() then
			item:setUsedDelta(ZombRandFloat(0.0, 1.0)); -- Randomize the item uses remaining
		end;
		local conditionMax = item:getConditionMax();
		if conditionMax > 0 then
			item:setCondition(ZombRand(conditionMax) + 1); -- Randomize the weapon condition
		end;
	end;
	return _items; --custom spawn scripts must return an arraylist of items (or nil)
end

Events.onAddForageDefs.Add(function()

    local Armadillo = {
		type = "Fauna.Armadillo",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 9,
		dayChance = -50,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0,	TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		
	};


	local Racoon_sitted = {
		type = "Fauna.Racoon_sitted",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0,	TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local Racoon = {
		type = "Fauna.Racoon",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 9,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0,	TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local Pig = {
		type = "Fauna.Pig",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=3, TrailerPark=0,	TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local Pig_sleeping = {
		type = "Fauna.Pig_sleeping",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=3, TrailerPark=0,	TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local Black_cat = {
		type = "Fauna.Black_cat",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=1.5, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1.5},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local BlackWhite_cat = {
		type = "Fauna.BlackWhite_cat",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=1.5, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1.5},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local European_cat = {
		type = "Fauna.European_cat",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=1.5, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1.5},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Tabby_cat = {
		type = "Fauna.F_Tabby_cat",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=1.5, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1.5},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Hen = {
		type = "Fauna.F_Hen",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 4,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=3, Farm=3, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Hen_white = {
		type = "Fauna.F_Hen_white",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 4,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=3, Farm=3, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Chick_01 = {
		type = "Fauna.F_Chick_01",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		categories = { "Animals" },
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=3, Farm=3, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Chick_03 = {
		type = "Fauna.F_Chick_03",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=3, Farm=3, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Chick_03 = {
		type = "Fauna.F_Chick_03",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=3, Farm=3, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Rooster = {
		type = "Fauna.F_Rooster",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=3, Farm=3, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Cow_f_bw = {
		type = "Fauna.F_Cow_f_bw",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 8,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Cow_f_bb = {
		type = "Fauna.F_Cow_f_bb",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 8,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Bull = {
		type = "Fauna.F_Bull",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 10,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Sheep = {
		type = "Fauna.F_Sheep",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Sheep_01 = {
		type = "Fauna.F_Sheep_01",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Mutton = {
		type = "Fauna.F_Mutton",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 8,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Horse = {
		type = "Fauna.F_Horse",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 8,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Horse_01 = {
		type = "Fauna.F_Horse_01",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 8,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Foal = {
		type = "Fauna.F_Foal",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 9,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=0},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local German_shepard = {
		type = "Fauna.German_shepard",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Australian_puppy = {
		type = "F_Australian_puppy",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Australian_puppy_sitting = {
		type = "F_Australian_puppy_sitting",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local Belgian_shepard_01 = {
		type = "Fauna.Belgian_shepard_01",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local Belgian_shepard_03 = {
		type = "Fauna.Belgian_shepard_03",
		minCount = 1,
		maxCount = 1,
		xp = 30,
		skill = 7,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_rat_01 = {
		type = "Fauna.F_rat_01",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 4,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_rat_03 = {
		type = "Fauna.F_rat_03",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 4,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_opossum_01 = {
		type = "Fauna.F_opossum_01",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_opossum_03 = {
		type = "Fauna.F_opossum_03",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 6,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0.8, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Bunny_01 = {
		type = "Fauna.F_Bunny_01",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 5,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Bunny_03 = {
		type = "Fauna.F_Bunny_03",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 5,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	local F_Skunk = {
		type = "Fauna.F_Skunk",
		minCount = 1,
		maxCount = 1,
		xp = 3,
		skill = 5,
		dayChance = -50,
		nightChance = -35,
        rainChance = -10,
		categories = { "Animals" },
		zones = {Forest=0.8, Vegitation=0.8, FarmLand=0.8, Farm=0.8, TrailerPark=0.8, TownZone=0, Nav=1},
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
	};


	forageSystem.addItemDef(Armadillo);
	forageSystem.addItemDef(Racoon_sitted);
	forageSystem.addItemDef(Racoon);
	forageSystem.addItemDef(Pig);
	forageSystem.addItemDef(Pig_sleeping);
	forageSystem.addItemDef(Black_cat);
	forageSystem.addItemDef(BlackWhite_cat);
	forageSystem.addItemDef(European_cat);
	forageSystem.addItemDef(F_Tabby_cat);
	forageSystem.addItemDef(F_Hen);
	forageSystem.addItemDef(F_Hen_white);
	forageSystem.addItemDef(F_Chick_01);
	forageSystem.addItemDef(F_Chick_03);
	forageSystem.addItemDef(F_Chick_03);
	forageSystem.addItemDef(F_Rooster);
	forageSystem.addItemDef(F_Cow_f_bw);
	forageSystem.addItemDef(F_Cow_f_bb);
	forageSystem.addItemDef(F_Bull);
	forageSystem.addItemDef(F_Sheep);
	forageSystem.addItemDef(F_Sheep_01);
	forageSystem.addItemDef(F_Mutton);
	forageSystem.addItemDef(F_Horse);
	forageSystem.addItemDef(F_Horse_01);
	forageSystem.addItemDef(F_Foal);
	forageSystem.addItemDef(German_shepard);
	forageSystem.addItemDef(F_Australian_puppy);
	forageSystem.addItemDef(F_Australian_puppy_sitting);
	forageSystem.addItemDef(Belgian_shepard_01);
	forageSystem.addItemDef(Belgian_shepard_03);
	forageSystem.addItemDef(F_rat_01);
	forageSystem.addItemDef(F_rat_03);
	forageSystem.addItemDef(F_opossum_01);
	forageSystem.addItemDef(F_opossum_03);
	forageSystem.addItemDef(F_Bunny_01);
	forageSystem.addItemDef(F_Bunny_03);
	forageSystem.addItemDef(F_Skunk);

	print("[FaunaDistribs] All fauna items added to Deadline Forage Table.");
end)