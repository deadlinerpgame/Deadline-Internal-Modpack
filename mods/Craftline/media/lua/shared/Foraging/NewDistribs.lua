require 'Foraging/forageSystem'

Events.onAddForageDefs.Add(function()


	local Clay ={
	type = "aerx.Clay",
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
	xp=2,
        categories = { "Stones" },
	zones={ Forest=5, DeepForest=5, Vegitation=5, FarmLand=5, Farm=5, TrailerPark=5, TownZone=5, Nav=12 },
	spawnFuncs = { doGenericItemSpawn },
	forceOutside = false,
	canBeAboveFloor = true,
	itemSizeModifier = 0.5,
	isItemOverrideSize = true,
	};

	local AluminumScrap ={
		type = "aerx.AluminumScrap",
		xp=2,
			categories = { "Stones" },
				zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local NickelScrap ={
		type = "aerx.NickelScrap",
		xp=2,
			categories = { "Stones" },
				zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local IronScrap ={
		type = "aerx.IronScrap",
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local TinScrap ={
		type = "aerx.TinScrap",
		xp=2,
			categories = { "Stones" },
				zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local CopperScrap ={
		type = "aerx.CopperScrap",
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local ZincScrap ={
		type = "aerx.ZincScrap",
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local LeadScrap ={
		type = "aerx.LeadScrap",
		xp=2,
			categories = { "Stones" },
			zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local GoldScrap ={
		type = "aerx.GoldScrap",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local SilverScrap ={
		type = "aerx.SilverScrap",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
	
	
	
	
			local AluminumFragments ={
		type = "aerx.AluminumFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local IronFragments ={
		type = "aerx.IronFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local NickelFragments ={
		type = "aerx.NickelFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local TinFragments ={
		type = "aerx.TinFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local CopperFragments ={
		type = "aerx.CopperFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local ZincFragments ={
		type = "aerx.ZincFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
		spawnFuncs = { doGenericItemSpawn },
		forceOutside = false,
		canBeAboveFloor = true,
		itemSizeModifier = 0.5,
		isItemOverrideSize = true,
		};
	
		local LeadFragments ={
		type = "aerx.LeadFragments",
		xp=2,
			categories = { "Stones" },
		zones={ Forest=0, DeepForest=0, Vegitation=0, FarmLand=0, Farm=1, TrailerPark=2, TownZone=2, Nav=1 },
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
