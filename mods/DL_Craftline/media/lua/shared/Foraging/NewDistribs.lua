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

	local AluminumScrap ={
		type = "aerx.AluminumScrap",
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
	
		local NickelScrap ={
		type = "aerx.NickelScrap",
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
	
		local IronScrap ={
		type = "aerx.IronScrap",
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
	
		local TinScrap ={
		type = "aerx.TinScrap",
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
	
		local CopperScrap ={
		type = "aerx.CopperScrap",
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
	
		local ZincScrap ={
		type = "aerx.ZincScrap",
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
	
		local LeadScrap ={
		type = "aerx.LeadScrap",
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
	
		local GoldScrap ={
		type = "aerx.GoldScrap",
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
	
		local SilverScrap ={
		type = "aerx.SilverScrap",
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
	
	
	
	
	
			local AluminumFragments ={
		type = "aerx.AluminumFragments",
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
	
		local IronFragments ={
		type = "aerx.IronFragments",
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
	
		local NickelFragments ={
		type = "aerx.NickelFragments",
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
	
		local TinFragments ={
		type = "aerx.TinFragments",
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
	
		local CopperFragments ={
		type = "aerx.CopperFragments",
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
	
		local ZincFragments ={
		type = "aerx.ZincFragments",
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
	
		local LeadFragments ={
		type = "aerx.LeadFragments",
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
	
	
	
	forageSystem.addItemDef(AluminumScrap);
	forageSystem.addItemDef(NickelScrap);
	forageSystem.addItemDef(IronScrap);
	forageSystem.addItemDef(TinScrap);
	forageSystem.addItemDef(CopperScrap);
	forageSystem.addItemDef(ZincScrap);
	forageSystem.addItemDef(LeadScrap);
	forageSystem.addItemDef(GoldScrap);
	forageSystem.addItemDef(SilverScrap);
	
	forageSystem.addItemDef(AluminumFragments);
	forageSystem.addItemDef(NickelFragments);
	forageSystem.addItemDef(IronFragments);
	forageSystem.addItemDef(TinFragments);
	forageSystem.addItemDef(CopperFragments);
	forageSystem.addItemDef(ZincFragments);
	forageSystem.addItemDef(LeadFragments);

forageSystem.addItemDef(Clay);
forageSystem.addItemDef(Stone);

end)
