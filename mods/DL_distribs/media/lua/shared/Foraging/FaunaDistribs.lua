require 'Foraging/forageSystem'

FaunaSpawnChances =
{
	["Fauna.Armadillo"] = 0.03,
	["Fauna.Racoon_sitted"] = 0.03,
	["Fauna.Racooon"] = 0.03,
	["Fauna.Pig"] = 0.053,
	["Fauna.Pig_sleeping"] = 0.03,
	["Fauna.Black_cat"] = 0.15,
	["Fauna.BlackWhite_cat"] = 0.15,
	["Fauna.European_cat"] = 0.15,
	["Fauna.F_Tabby_cat"] = 0.15,
	["Fauna.F_Hen"] = 0.3,
	["Fauna.F_Hen_white"] = 0.3,
	["Fauna.F_Chick_01"] = 0.5,
	["Fauna.F_Chick_02"] = 0.5,
	["Fauna.F_Chick_03"] = 0.5,
	["Fauna.F_Rooster"] = 0.5,
	["Fauna.F_Cow_f_bw"] = 0.35,
	["Fauna.F_Cow_f_bb"] = 0.35,
	["Fauna.F_Bull"] = 0.3,
	["Fauna.F_Sheep"] = 0.4,
	["Fauna.F_Sheep_01"] = 0.4,
	["Fauna.F_Mutton"] = 0.4,
	["Fauna.F_Horse"] = 0.01,
	["Fauna.F_Horse_01"] = 0.01,
	["Fauna.F_Foal"] = 0.005,
	["Fauna.German_shepard"] = 0.02,
	["Fauna.Belgian_shepard_01"] = 0.02,
	["Fauna.Belgian_shepard_02"] = 0.02,
	["Fauna.F_rat_01"] = 0.5,
	["Fauna.F_rat_02"] = 0.5,
	["Fauna.F_opossum_01"] = 0.5,
	["Fauna.F_opossum_02"] = 0.5,
	["Fauna.F_Bunny_01"] = 0.65,
	["Fauna.F_Bunny_02"] = 0.65,
	["Fauna.F_Skunk"] = 0.3,
};


local function doFaunaSpawn(_character, _inventory, _itemDef, _items)

	print("[Deadline_FaunaDistribs] doFaunaSpawn ");
	print("Character: " .. (_character:getUsername() or "invalid_char"));

	local levelMultiplier = 0.05;

	local characterMultiplier = 1;
	-- Get character skill level.
	if _character then
		local forageLvl = _character:getPerkLevel(Perks.PlantScavenging) or 1;
		if forageLvl ~= 0 then
			characterMultiplier = (levelMultiplier * forageLvl);
		end
	end

	print("[Deadline_FaunaDistribs] Character multiplier is: " .. tostring(characterMultiplier));

	-- Now calculate the actual chance out of 100.
	local type = _itemDef.type;
	if not type then
		print("[Deadline_FaunaDistribs] ItemDef does not have type, spawning nothing.");
		return ArrayList.new();
	end

	local chance = FaunaSpawnChances[_itemDef.type];
	if not chance then
		print("[Deadline_FaunaDistribs] Could not find item type " .. tostring(item:getFullType()) .. " despite it calling doFaunaSpawn.");
		return ArrayList.new();
	end

	local rolledChance = ZombRand(0, 100);
	local actualChance = rolledChance - characterMultiplier; -- subtract it IOT get as low as possible (makes the maths easy!)

	local neededChance = math.ceil(chance * 100);

	local chanceStr = string.format("[Deadline_FaunaDistribs] Rolled chance: %s, needed: %s", tostring(actualChance), tostring(neededChance));
	print(chanceStr);

	if actualChance > neededChance then
		print("[Deadline_FaunaDistribs] Failed roll. Do not spawn fauna.");
		return ArrayList.new();
	end

	return _items; --custom spawn scripts must return an arraylist of items (or nil)
end

Events.onAddForageDefs.Add(function()

    local Armadillo = {
	type = "Fauna.Armadillo",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 9,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=0,	TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
	
};


local Racoon_sitted = {
	type = "Fauna.Racoon_sitted",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=0,	TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local Racoon = {
	type = "Fauna.Racoon",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 9,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=0,	TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local Pig = {
	type = "Fauna.Pig",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=0,	TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local Pig_sleeping = {
	type = "Fauna.Pig_sleeping",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=0,	TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local Black_cat = {
	type = "Fauna.Black_cat",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=5},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local BlackWhite_cat = {
	type = "Fauna.BlackWhite_cat",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=5},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local European_cat = {
	type = "Fauna.European_cat",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=5},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Tabby_cat = {
	type = "Fauna.F_Tabby_cat",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=5},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Hen = {
	type = "Fauna.F_Hen",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 4,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Hen_white = {
	type = "Fauna.F_Hen_white",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 4,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Chick_01 = {
	type = "Fauna.F_Chick_01",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	categories = { "Animals" },
	dayChance = -25,
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Chick_02 = {
	type = "Fauna.F_Chick_02",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Chick_03 = {
	type = "Fauna.F_Chick_03",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Rooster = {
	type = "Fauna.F_Rooster",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Cow_f_bw = {
	type = "Fauna.F_Cow_f_bw",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 8,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Cow_f_bb = {
	type = "Fauna.F_Cow_f_bb",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 8,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Bull = {
	type = "Fauna.F_Bull",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 10,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Sheep = {
	type = "Fauna.F_Sheep",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Sheep_01 = {
	type = "Fauna.F_Sheep_01",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Mutton = {
	type = "Fauna.F_Mutton",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 8,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Horse = {
	type = "Fauna.F_Horse",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 8,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Horse_01 = {
	type = "Fauna.F_Horse_01",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 8,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Foal = {
	type = "Fauna.F_Foal",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 9,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=0},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local German_shepard = {
	type = "Fauna.German_shepard",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Australian_puppy = {
	type = "F_Australian_puppy",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Australian_puppy_sitting = {
	type = "F_Australian_puppy_sitting",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local Belgian_shepard_01 = {
	type = "Fauna.Belgian_shepard_01",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local Belgian_shepard_02 = {
	type = "Fauna.Belgian_shepard_02",
	minCount = 1,
	maxCount = 1,
	xp = 20,
	skill = 7,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_rat_01 = {
	type = "Fauna.F_rat_01",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 4,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_rat_02 = {
	type = "Fauna.F_rat_02",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 4,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_opossum_01 = {
	type = "Fauna.F_opossum_01",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_opossum_02 = {
	type = "Fauna.F_opossum_02",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 6,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=1, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Bunny_01 = {
	type = "Fauna.F_Bunny_01",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 5,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Bunny_02 = {
	type = "Fauna.F_Bunny_02",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 5,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=1},
	spawnFuncs = { doFaunaSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
};


local F_Skunk = {
	type = "Fauna.F_Skunk",
	minCount = 1,
	maxCount = 1,
	xp = 2,
	skill = 5,
	dayChance = -25,
	categories = { "Animals" },
	zones = {Forest=1, Vegitation=1, FarmLand=1, Farm=1, TrailerPark=1, TownZone=0, Nav=1},
	spawnFuncs = { doFaunaSpawn },
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
forageSystem.addItemDef(F_Chick_02);
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
forageSystem.addItemDef(Belgian_shepard_02);
forageSystem.addItemDef(F_rat_01);
forageSystem.addItemDef(F_rat_02);
forageSystem.addItemDef(F_opossum_01);
forageSystem.addItemDef(F_opossum_02);
forageSystem.addItemDef(F_Bunny_01);
forageSystem.addItemDef(F_Bunny_02);
forageSystem.addItemDef(F_Skunk);

end)
