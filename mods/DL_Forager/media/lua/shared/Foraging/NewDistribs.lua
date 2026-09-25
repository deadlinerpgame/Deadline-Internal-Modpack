require 'Foraging/forageSystem'

Events.onAddForageDefs.Add(function()


	local Clay ={
	type = "aerx.Clay",
	minCount = 1,
	maxCount = 5,
	xp=2,
        categories = { "Stones" },
	zones={ Forest=4, DeepForest=4, Vegitation=4, FarmLand=4, Farm=4, TrailerPark=4, TownZone=4, Nav=4 },
	spawnFuncs = { doGenericItemSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
	};

	local Stone ={
	type = "Base.Stone",
	minCount = 1,
	maxCount = 3,
	xp=2,
        categories = { "Stones" },
	zones={ Forest=5, DeepForest=5, Vegitation=5, FarmLand=5, Farm=5, TrailerPark=5, TownZone=5, Nav=22 },
	spawnFuncs = { doGenericItemSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
	};

	local Scrap_Aluminum_M ={
		type = "DL_MetalLine.Scrap_Aluminum_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
				zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Nickel_M ={
		type = "DL_MetalLine.Scrap_Nickel_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
				zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Iron_M ={
		type = "DL_MetalLine.Scrap_Iron_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Tin_M ={
		type = "DL_MetalLine.Scrap_Tin_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
				zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Copper_M ={
		type = "DL_MetalLine.Scrap_Copper_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Zinc_M ={
		type = "DL_MetalLine.Scrap_Zinc_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Lead_M ={
		type = "DL_MetalLine.Scrap_Lead_M",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Gold_S ={
		type = "DL_MetalLine.Scrap_Gold_S",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Silver_S ={
		type = "DL_MetalLine.Scrap_Silver_S",
	minCount = 1,
	maxCount = 2,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
	
	
	
	
			local Scrap_Aluminum_S ={
		type = "DL_MetalLine.Scrap_Aluminum_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Iron_S ={
		type = "DL_MetalLine.Scrap_Iron_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Nickel_S ={
		type = "DL_MetalLine.Scrap_Nickel_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Tin_S ={
		type = "DL_MetalLine.Scrap_Tin_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Copper_S ={
		type = "DL_MetalLine.Scrap_Copper_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Zinc_S ={
		type = "DL_MetalLine.Scrap_Zinc_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local Scrap_Lead_S ={
		type = "DL_MetalLine.Scrap_Lead_S",
	minCount = 1,
	maxCount = 10,
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=1, Farm=3, TrailerPark=4, TownZone=4, Nav=2 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
	
	
	forageSystem.addItemDef(Scrap_Aluminum_M);
	forageSystem.addItemDef(Scrap_Nickel_M);
	forageSystem.addItemDef(Scrap_Iron_M);
	forageSystem.addItemDef(Scrap_Tin_M);
	forageSystem.addItemDef(Scrap_Copper_M);
	forageSystem.addItemDef(Scrap_Zinc_M);
	forageSystem.addItemDef(Scrap_Lead_M);
	forageSystem.addItemDef(Scrap_Gold_S);
	forageSystem.addItemDef(Scrap_Silver_S);
	
	forageSystem.addItemDef(Scrap_Aluminum_S);
	forageSystem.addItemDef(Scrap_Nickel_S);
	forageSystem.addItemDef(Scrap_Iron_S);
	forageSystem.addItemDef(Scrap_Tin_S);
	forageSystem.addItemDef(Scrap_Copper_S);
	forageSystem.addItemDef(Scrap_Zinc_S);
	forageSystem.addItemDef(Scrap_Lead_S);

forageSystem.addItemDef(Clay);
forageSystem.addItemDef(Stone);

end)
