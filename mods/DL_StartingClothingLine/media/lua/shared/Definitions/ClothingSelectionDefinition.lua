-- define here all the clothing that'll be available for a specific profession.
-- the default will always been available

ClothingSelectionDefinitions = ClothingSelectionDefinitions or {};

-- default selection, always available
ClothingSelectionDefinitions.default = {
	-- Shared additions are offered to unemployed Female and Male.
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BaseballCap", "Base.Hat_BucketHat", "Base.Hat_GolfHat", "Base.Hat_Fedora", "Base.Hat_Visor_WhiteTINT", "DesertShemagh.DesertShemaghScarf_Green", "Base.Accessory_Wild_Rag_Scarf", "Base.Hat_BonnieHat_CamoGreen", "AuthenticZLite.Hat_BandanaDesert", "HCustoms.Hat_BrimmedHat"},
		},
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_Normal", "Base.Glasses_Reading", "HCustoms.Glasses_DustGoggles", "BWardrobe.Glasses_Cool", "AuthenticZLite.Glasses_AviatorsSunset"},
		},
		TankTop = {
			chance = 10,
			items = {"Base.Vest_DefaultTEXTURE_TINT", "BWardrobe.Top_Cropped2_Solid", "BWardrobe.Top_Cropped1_Bomber", "AuthenticZLite.HoodieDOWN_CropTopTINT"},
		},
		Shirt = {
			chance = 10,
			items = {"Base.Shirt_FormalTINT", "Base.Shirt_FormalWhite_ShortSleeveTINT", "Base.Shirt_HawaiianTINT", "Base.Tshirt_DefaultTEXTURE", "Base.Tshirt_DefaultTEXTURE_TINT", "Base.Tshirt_WhiteTINT", "Base.Tshirt_SuperColor", "Base.Tshirt_Sport", "Base.Tshirt_SportDECAL", "Base.Tshirt_TieDye", "Base.Tshirt_PoloTINT", "Base.Tshirt_PoloStripedTINT", "Base.Shirt_Denim", "Base.Shirt_HawaiianRed", "Base.Shirt_Lumberjack", "Base.Shirt_Lumberjack_Green", "Base.Shirt_Lumberjack_TINT", "Base.Shirt_FormalWhite_ShortSleeve", "Base.Denim_Shirt_10", "Base.Denim_Shirt_11", "Base.Denim_Shirt_12", "Base.Denim_Shirt_15", "Base.Denim_Shirt_20", "Base.Denim_Shirt_21", "Base.Denim_Shirt_22", "Base.Denim_Shirt_25", "Base.Denim_Sleeveless_Shirt_10", "Base.Denim_Sleeveless_Shirt_11", "Base.Denim_Sleeveless_Shirt_12", "Base.Denim_Sleeveless_Shirt_15", "Base.Lumberjack_Shirt_10", "Base.Lumberjack_Shirt_11", "Base.Lumberjack_Shirt_12", "Base.Lumberjack_Shirt_15", "Base.Lumberjack_Shirt_20", "Base.Lumberjack_Shirt_21", "Base.Lumberjack_Shirt_22", "Base.Lumberjack_Shirt_25", "Base.Lumberjack_Sleeveless_Shirt_10", "Base.Lumberjack_Sleeveless_Shirt_11", "Base.Lumberjack_Sleeveless_Shirt_12", "Base.Lumberjack_Sleeveless_Shirt_15", "Base.T_Cotton_Shirt_02", "AuthenticZLite.Thin01_TShirt", "AuthenticZLite.Tshirt_Wichammer"},
		},
		Tshirt = {
			items = {"Base.Tshirt_DefaultTEXTURE_TINT", "Base.Tshirt_WhiteLongSleeveTINT", "Base.Tshirt_PoloStripedTINT", "Base.Tshirt_PoloTINT", "Base.Shirt_CropTopTINT", "Base.Shirt_CropTopNoArmTINT", "Base.BoobTube"},
		},
		Pants = {
			items = {"Base.Trousers_DefaultTEXTURE_TINT", "Base.Trousers_Denim", "Base.Shorts_LongDenim", "Base.Shorts_ShortDenim", "Base.Shorts_ShortFormal", "Base.Shorts_ShortSport", "Base.Mesh_Denim_LongShorts", "Base.Mesh_Denim_Shorts", "Base.Mesh_Denim_Pants", "Base.Mesh_Denim_PantsFlared", "Base.Skin_Denim_Pants_J", "Base.TMesh_TannedLeather_LongShorts", "Base.TMesh_TannedLeather_Shorts", "BWardrobe.Legs_Pants1", "BWardrobe.Legs_Pants1_Basic", "HCustoms.Trousers_CargoPants", "Base.Mesh_Denim_Pants_J", "Base.Mesh_Denim_Pants_High", "Base.Mesh_Denim_Pants_Low", "Base.Mesh_Denim_Pants_Lower", "Base.Mesh_Denim_Pants_V", "Base.Mesh_Denim_PantsChaps"},
		},
		Skirt = {
			chance = 50,
			items = {"Base.Skirt_Knees", "Base.Skirt_Long", "Base.Skirt_Mini", "Base.Skirt_Normal", "Base.Skirt_Short", "Base.Denim_Skirt_Longer", "Base.Denim_Skirt_Long", "Base.TannedLeather_Long_Skirt", "Base.TannedLeather_Skirt_Mid", "Base.TannedLeather_Skirt_Short"},
		},
		Dress = {
			chance = 10,
			items = {"Base.Dress_Normal", "Base.Dress_Knees", "Base.Dress_Long", "Base.Dress_long_Straps", "Base.Dress_SmallStrapless", "Base.Dress_Straps", "Base.DressKnees_Straps", "Base.Dress_SmallStraps", "Base.Dress_Short", "Base.Dress_SmallBlackStraps", "BWardrobe.Dress1_Long_Stamp", "BWardrobe.Dress2_Long_Tartan", "UndeadSurvivor.AmazonaDress"},
		},
		Socks = {
			items = {"Base.Socks_Ankle", "Base.Socks_Long"},
		},
		Shoes = {
			items = {"Base.Shoes_Random", "Base.Shoes_TrainerTINT", "Base.Shoes_Strapped", "Base.Shoes_Black", "Base.Shoes_Brown", "Base.Shoes_BlueTrainers", "Base.Shoes_RedTrainers", "Base.Shoes_Slippers", "Base.Shoes_TireSandals", "Base.FF_Shoe_Common", "Base.FF_Shoe_Trainers", "Base.FF_Shoe_TrainersBlack", "Base.FF_Shoe_TrainersWhite", "Base.FF_Shoe_Moccasin", "Base.FF_Boots_Common", "Base.FF_Shoe_Boots_Ankle", "Base.FF_Boots_Leather_Short", "Base.FF_Boots_Cowboy_Plain", "MoreShoes.Shoes_Converse", "MoreShoes.Shoes_NewBalance", "MoreShoes.Shoes_Jordan1s_Special", "Base.FF_Shoe_Boots_Ankle_Platform", "Base.FF_Shoe_Boots_Ankle_Steel", "Base.FF_BootsRE_Leather_Heel", "Base.FF_BootsRE_Leather_KneehighHeel", "Base.FF_BootsRE_Leather_DwarfHeel", "Base.FF_BootsRE_Leather_ThighhighHeel", "Base.FF_Boots_Military_Kneehigher", "Base.FF_Boots_Military_Kneehigh", "Base.FF_Boots_Military_Ankle", "Base.FF_Boots_Military_Thighhigh", "Base.FF_Boots_PointySkull_Kneehigh", "Base.FF_Boots_PointySkull_AnkleLow", "Base.FF_Boots_Pointy_Ankle", "Base.FF_Boots_Pointy_Kneehigh", "Base.FF_Boots_Pointy_AnkleLow", "Base.FF_Shoes_Pointy", "Base.FF_Shoes_Gator", "Base.FF_Boots_HF_New", "Base.FF_Boots_HighHeels", "Base.FF_Boots_HF_New_Longer", "Base.FF_Boots_HF_New_Long", "Base.FF_Boots_HF_New_Longest"},
		},
		Sweater = {
			chance = 0,
			items = {"Base.Jumper_DiamondPatternTINTROLL", "Spongie.Jumper_MilitaryROLL", "Base.Jumper_DiamondPatternTINT"},
		},
		Jacket = {
			chance = 0,
			items = {"Base.Denim_Overshirt", "Base.Denim_Overshirt_O", "Base.Denim_Jacket", "Base.Denim_Jacket_O", "Base.Denim_JacketShort", "Base.Jacket_Shellsuit_Blue", "MoreJackets.Jacket_CanvasOPEN", "AuthenticZLite.Thin01_JacketVarsity", "Base.Jacket_Varsity"},
		},
		Mask = {
			chance = 0,
			items = {"Base.Accessory_Wild_Rag", "Base.Accessory_Wild_Rag_Bandana", "HCustoms.Hat_ShemScarfFull", "HCustoms.Hat_ShemScarf"},
		},
		Scarf = {
			chance = 0,
			items = {"HCustoms.Scarf_ClothPoncho"},
		},
	},
	Male = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BaseballCap", "Base.Hat_BucketHat", "Base.Hat_GolfHat", "Base.Hat_Fedora", "Base.Hat_Visor_WhiteTINT", "DesertShemagh.DesertShemaghScarf_Green", "Base.Accessory_Wild_Rag_Scarf", "Base.Hat_BonnieHat_CamoGreen", "AuthenticZLite.Hat_BandanaDesert", "HCustoms.Hat_BrimmedHat"},
		},
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_Normal", "Base.Glasses_Reading", "HCustoms.Glasses_DustGoggles", "BWardrobe.Glasses_Cool", "AuthenticZLite.Glasses_AviatorsSunset"},
		},
		TankTop = {
			chance = 30,
			items = {"Base.Vest_DefaultTEXTURE_TINT", "BWardrobe.Top_Cropped2_Solid", "BWardrobe.Top_Cropped1_Bomber", "AuthenticZLite.HoodieDOWN_CropTopTINT"},
		},
		Shirt = {
			chance = 10,
			items = {"Base.Shirt_FormalTINT", "Base.Shirt_FormalWhite_ShortSleeveTINT", "Base.Shirt_HawaiianTINT", "Base.Tshirt_DefaultTEXTURE", "Base.Tshirt_DefaultTEXTURE_TINT", "Base.Tshirt_WhiteTINT", "Base.Tshirt_SuperColor", "Base.Tshirt_Sport", "Base.Tshirt_SportDECAL", "Base.Tshirt_TieDye", "Base.Tshirt_PoloTINT", "Base.Tshirt_PoloStripedTINT", "Base.Shirt_Denim", "Base.Shirt_HawaiianRed", "Base.Shirt_Lumberjack", "Base.Shirt_Lumberjack_Green", "Base.Shirt_Lumberjack_TINT", "Base.Shirt_FormalWhite_ShortSleeve", "Base.Denim_Shirt_10", "Base.Denim_Shirt_11", "Base.Denim_Shirt_12", "Base.Denim_Shirt_15", "Base.Denim_Shirt_20", "Base.Denim_Shirt_21", "Base.Denim_Shirt_22", "Base.Denim_Shirt_25", "Base.Denim_Sleeveless_Shirt_10", "Base.Denim_Sleeveless_Shirt_11", "Base.Denim_Sleeveless_Shirt_12", "Base.Denim_Sleeveless_Shirt_15", "Base.Lumberjack_Shirt_10", "Base.Lumberjack_Shirt_11", "Base.Lumberjack_Shirt_12", "Base.Lumberjack_Shirt_15", "Base.Lumberjack_Shirt_20", "Base.Lumberjack_Shirt_21", "Base.Lumberjack_Shirt_22", "Base.Lumberjack_Shirt_25", "Base.Lumberjack_Sleeveless_Shirt_10", "Base.Lumberjack_Sleeveless_Shirt_11", "Base.Lumberjack_Sleeveless_Shirt_12", "Base.Lumberjack_Sleeveless_Shirt_15", "Base.T_Cotton_Shirt_02", "AuthenticZLite.Thin01_TShirt", "AuthenticZLite.Tshirt_Wichammer"},
		},
		Tshirt = {
			items = {"Base.Tshirt_DefaultTEXTURE_TINT", "Base.Tshirt_WhiteLongSleeveTINT", "Base.Tshirt_PoloStripedTINT", "Base.Tshirt_PoloTINT"},
		},
		Pants = {
			items = {"Base.Trousers_DefaultTEXTURE_TINT", "Base.Trousers_Denim", "Base.Shorts_LongDenim", "Base.Shorts_ShortDenim", "Base.Shorts_ShortFormal", "Base.Shorts_ShortSport", "Base.Mesh_Denim_LongShorts", "Base.Mesh_Denim_Shorts", "Base.Mesh_Denim_Pants", "Base.Mesh_Denim_PantsFlared", "Base.Skin_Denim_Pants_J", "Base.TMesh_TannedLeather_LongShorts", "Base.TMesh_TannedLeather_Shorts", "BWardrobe.Legs_Pants1", "BWardrobe.Legs_Pants1_Basic", "HCustoms.Trousers_CargoPants", "Base.Mesh_Denim_Pants_J", "Base.Mesh_Denim_Pants_High", "Base.Mesh_Denim_Pants_Low", "Base.Mesh_Denim_Pants_Lower", "Base.Mesh_Denim_Pants_V", "Base.Mesh_Denim_PantsChaps"},
		},
		Socks = {
			items = {"Base.Socks_Ankle", "Base.Socks_Long"},
		},
		Shoes = {
			items = {"Base.Shoes_Random", "Base.Shoes_TrainerTINT", "Base.Shoes_Black", "Base.Shoes_Brown", "Base.Shoes_BlueTrainers", "Base.Shoes_RedTrainers", "Base.Shoes_Slippers", "Base.Shoes_Strapped", "Base.Shoes_TireSandals", "Base.FF_Shoe_Common", "Base.FF_Shoe_Trainers", "Base.FF_Shoe_TrainersBlack", "Base.FF_Shoe_TrainersWhite", "Base.FF_Shoe_Moccasin", "Base.FF_Boots_Common", "Base.FF_Shoe_Boots_Ankle", "Base.FF_Boots_Leather_Short", "Base.FF_Boots_Cowboy_Plain", "MoreShoes.Shoes_Converse", "MoreShoes.Shoes_NewBalance", "MoreShoes.Shoes_Jordan1s_Special", "Base.FF_Shoe_Boots_Ankle_Platform", "Base.FF_Shoe_Boots_Ankle_Steel", "Base.FF_BootsRE_Leather_Heel", "Base.FF_BootsRE_Leather_KneehighHeel", "Base.FF_BootsRE_Leather_DwarfHeel", "Base.FF_BootsRE_Leather_ThighhighHeel", "Base.FF_Boots_Military_Kneehigher", "Base.FF_Boots_Military_Kneehigh", "Base.FF_Boots_Military_Ankle", "Base.FF_Boots_Military_Thighhigh", "Base.FF_Boots_PointySkull_Kneehigh", "Base.FF_Boots_PointySkull_AnkleLow", "Base.FF_Boots_Pointy_Ankle", "Base.FF_Boots_Pointy_Kneehigh", "Base.FF_Boots_Pointy_AnkleLow", "Base.FF_Shoes_Pointy", "Base.FF_Shoes_Gator", "Base.FF_Boots_HF_New", "Base.FF_Boots_HighHeels", "Base.FF_Boots_HF_New_Longer", "Base.FF_Boots_HF_New_Long", "Base.FF_Boots_HF_New_Longest"},
		},
		Sweater = {
			chance = 0,
			items = {"Base.Jumper_DiamondPatternTINTROLL", "Spongie.Jumper_MilitaryROLL", "Base.Jumper_DiamondPatternTINT"},
		},
		Jacket = {
			chance = 0,
			items = {"Base.Denim_Overshirt", "Base.Denim_Overshirt_O", "Base.Denim_Jacket", "Base.Denim_Jacket_O", "Base.Denim_JacketShort", "Base.Jacket_Shellsuit_Blue", "MoreJackets.Jacket_CanvasOPEN", "AuthenticZLite.Thin01_JacketVarsity", "Base.Jacket_Varsity"},
		},
		Skirt = {
			chance = 0,
			items = {"Base.Skirt_Short", "Base.Skirt_Normal", "Base.Skirt_Long", "Base.Denim_Skirt_Longer", "Base.Denim_Skirt_Long", "Base.TannedLeather_Long_Skirt", "Base.TannedLeather_Skirt_Mid", "Base.TannedLeather_Skirt_Short"},
		},
		Dress = {
			chance = 0,
			items = {"Base.Dress_Short", "Base.Dress_SmallStraps", "Base.Dress_SmallBlackStraps", "Base.Dress_Straps", "BWardrobe.Dress1_Long_Stamp", "BWardrobe.Dress2_Long_Tartan", "UndeadSurvivor.AmazonaDress"},
		},
		Mask = {
			chance = 0,
			items = {"Base.Accessory_Wild_Rag", "Base.Accessory_Wild_Rag_Bandana", "HCustoms.Hat_ShemScarfFull", "HCustoms.Hat_ShemScarf"},
		},
		Scarf = {
			chance = 0,
			items = {"HCustoms.Scarf_ClothPoncho"},
		},
	},
}

ClothingSelectionDefinitions.fireofficer = {
	Female = {
		Tshirt = {
			items = {"Base.Tshirt_Profession_FiremanBlue", "Base.Tshirt_Profession_FiremanRed", "Base.Tshirt_Profession_FiremanRed02", "Base.Tshirt_Profession_FiremanWhite"},
		},
		
		Pants = {
--			chance = 30,
			items = {"Base.Trousers_Fireman"},
		},
		
--		Jacket = {
--			items = {"Base.Jacket_Fireman"},
--		},
		
--		Sweater = {
--			items = {};
--		},
		
		Shoes = {
			items = {"Base.Shoes_Black", "Base.Shoes_ArmyBoots"};
		},
	},
}

ClothingSelectionDefinitions.policeofficer = {
	Female = {
	
		Hat = {
			chance = 10,
			items = {"Base.Hat_Police",},
		},
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses", "Base.Glasses_Aviators"},
		},
		
		Shirt = {
			chance = 20,
			items = {"Base.Shirt_OfficerWhite", "Base.Shirt_PoliceBlue" , "Base.Tshirt_PoliceBlue"},
		},
		
		Tshirt = {
--			chance = 20,
			items = {"Base.Tshirt_Profession_PoliceBlue", "Base.Tshirt_Profession_PoliceWhite"},
		},
		
--		Jacket = {
--			chance = 20,
--			items = {"Base.Jacket_Police"},
--		},
		
		Pants = {
			items = {"Base.Trousers_Police"},
		},
		
		-- we remove sweater from this outfit, you can still select one if you want
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.parkranger = {
	Female = {
	
		Hat = {
			chance = 10,
			items = {"Base.Hat_Ranger",},
		},
		
		Shirt = {
			items = {"Base.Shirt_Ranger", "Base.Tshirt_Ranger",},
		},
		
		Tshirt = {
--			chance = 20,
			items = {"Base.Tshirt_Profession_RangerBrown", "Base.Tshirt_Profession_RangerGreen"},
		},
		
--		Jacket = {
--			chance = 20,
--			items = {"Base.Jacket_Ranger"},
--		},
		
		Pants = {
			items = {"Base.Trousers_Ranger"},
		},
		
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.constructionworker = {
	Female = {
		Shirt = {
			items = {"Base.Shirt_Denim"},
		},
		
		TorsoExtra = {
			chance = 30,
			items = {"Base.Vest_HighViz"},
		},
		
		Pants = {
--			chance = 50,
			items = {"Base.Trousers_JeanBaggy"},
		},
		
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.securityguard = {
	Female = {
--		Neck = {
----			chance = 70,
--			items = {"Base.Tie_Full"},
--		},
		
		Shirt = {
			items = {"Base.Shirt_FormalWhite"},
		},
		
		Pants = {
			items = {"Base.Trousers_Black"},
		},
		
--		Sweater = {
--			items = {};
--		},
--
--		Jacket = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.carpenter = {
	Female = {
		Mask = {
			chance = 5,
			items = {"Base.Hat_DustMask", },
		},	
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_SafetyGoggles"},
		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack",},
		},
		
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Pants = {
--			chance = 50,
			items = {"Base.Trousers_JeanBaggy"},
		},
		
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.burglar = {
	Female = {
		Hat = {
			chance = 10,
			items = { "Base.Hat_Beany", },
		},
		
		Mask = {
			chance = 5,
			items = {"Base.Hat_BandanaMaskTINT", },
		},
		
		MaskFull = {
			chance = 5,
			items = {"Base.Hat_BalaclavaFull",},
		},
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_Sun"},
		},
		
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Pants = {
			items = {"Base.Trousers_Denim"},
		},
		
	}
}

ClothingSelectionDefinitions.chef = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_ChefHat", },
		},
		Jacket = {
			chance = 50,
			items = {"Base.Jacket_Chef"},
		},
		
		Pants = {
			items = {"Base.Trousers_Chef"},
		},
	}
}

ClothingSelectionDefinitions.repairman = {
	Female = {
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Shirt = {
			items = {"Base.Shirt_Denim"},
		},
		
		Pants = {
			items = {"Base.Trousers_Denim"},
		},
		
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.farmer = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Cowboy", "Base.Hat_SummerHat"},
		},
		
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
		
		Pants = {
--			chance = 50,
			items = {"Base.Trousers_Denim"},
		},
		
		Shoes = {
			chance = 20,
			items = {"Base.Shoes_Wellies"},
		},
	},
	Male = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Cowboy", },
		},
		
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
		
		Pants = {
--			chance = 50,
			items = {"Base.Trousers_Denim"},
		},
		
		Shoes = {
			chance = 20,
			items = {"Base.Shoes_Wellies"},
		},
	},
}

ClothingSelectionDefinitions.fisherman = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Beany", "Base.Hat_BonnieHat_CamoGreen" },
		},
		
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
		
		Pants = {
--			chance = 50,
			items = {"Base.Trousers_JeanBaggy"},
		},
		
		Shoes = {
			chance = 20,
			items = {"Base.Shoes_Wellies"},
		},
	},
}

ClothingSelectionDefinitions.doctor = {
	Female = {
		Neck = {
			chance = 70,
			items = {"Base.Tie_Full", },
		},

		Hat = {
			chance = 5,
			items = {"Base.Hat_SurgicalMask_Blue", "Base.Hat_SurgicalMask_Green", },
		},
		
		Shirt = {
			items = {"Base.Shirt_FormalTINT"},
		},
		
		Hands = {
			chance = 5,
			items = {"Base.Gloves_Surgical"},
		},
		
		-- Jacket = {
			-- items = {"Base.JacketLong_Doctor"},
		-- },
		
		Pants = {
			items = {"Base.Trousers_SuitTEXTURE"},
		},
		
	},
}

ClothingSelectionDefinitions.veteran = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BaseballCapArmy", "Base.Hat_BeretArmy", "Base.Hat_BonnieHat_CamoGreen", "Base.Hat_Bandana", },
		},
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_Eyepatch_Left", "Base.Glasses_Eyepatch_Right", "Base.Glasses_Shooting"},
		},
		
		Shirt = {
			chance = 10,
			items = {"Base.Shirt_CamoGreen",},
		},
		
		Tshirt = {
			items = {"Base.Tshirt_Profession_VeterenGreen", "Base.Tshirt_Profession_VeterenRed"},
		},
		
		Pants = {
			items = {"Base.Shorts_CamoGreenLong"},
		},
		
		Shoes = {
			items = {"Base.Shoes_TrainerTINT"},
		},
		
		Necklace = {
			chance = 80,
			items = {"Base.Necklace_DogTag"},
		},
	},
}

ClothingSelectionDefinitions.nurse = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Hat_SurgicalCap_Blue", "Base.Hat_SurgicalCap_Green" },
		},
		
		Mask = {
			chance = 5,
			items = {"Base.Hat_SurgicalMask_Blue", "Base.Hat_SurgicalMask_Green", },
		},
		
		Shirt = {
			items = {"Base.Shirt_Scrubs"},
		},
		
		Hands = {
			chance = 5,
			items = {"Base.Gloves_Surgical"},
		},
		
		Pants = {
			items = {"Base.Trousers_Scrubs"},
		},
		
		Shoes = {
			items = {"Base.Shoes_TrainerTINT"},
		},
		
--		Jacket = {
--			items = {};
--		},
--
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.lumberjack = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Beany",},
		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
		
	
		Tshirt = {
			items = {"Base.Tshirt_McCoys"},
		},
		
--		Hands = {
----			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Pants = {
--			chance = 50,
			items = {"Base.Trousers_JeanBaggy"},
		},
		
--		Sweater = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.fitnessInstructor = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Sweatband",},
		},
		
		Tshirt = {
--			chance = 30,
			items = {"Base.Tshirt_Sport"},
		},
		
		Hands = {
			chance = 20,
			items = {"Base.Gloves_FingerlessGloves"},
		},
		
		Pants = {
			items = {"Base.Shorts_LongSport", "Base.Shorts_ShortSport", },
		},
		
		Shoes = {
			items = {"Base.Shoes_TrainerTINT"},
		},
		
--		Sweater = {
--			items = {};
--		},
--
--		Jacket = {
--			items = {};
--		},
	},
}

ClothingSelectionDefinitions.burgerflipper = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_FastFood_Spiffo", },
		},
--		TankTop = {
--			items = {"Base.Vest_DefaultTEXTURE_TINT",},
--		},
		
		Shirt = {
			items = {};
		},
		
		Tshirt = {
			items = {"Base.Tshirt_BusinessSpiffo"};
		},
		
		Shoes = {
			items = {"Base.Shoes_TrainerTINT"},
		},
		
		Pants = {
			items = {"Base.Trousers_Denim"},
		},
		
--		Sweater = {
--			items = {};
--		},
--
--		Jacket = {
--			items = {};
--		},
		
--		TorsoExtra = {
--			items = {"Base.Apron_White"},
--		}
	},
}

ClothingSelectionDefinitions.electrician = {
	Female = {
		Mask = {
			chance = 5,
			items = {"Base.Hat_DustMask", },
		},	
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_SafetyGoggles"},
		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
		
--		Hands = {
--			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Pants = {
			items = {"Base.Trousers_Denim"},
		},
		
--		Sweater = {
--			items = {};
--		},
		
--		FullSuit = {
--			chance = 20,
--			items = {"Boilersuit"},
--		},
		
		TorsoExtra = {
			chance = 30,
			items = {"Base.Vest_HighViz"},
		},
	},
}

ClothingSelectionDefinitions.metalworker = {
	Female = {
		Mask = {
			chance = 5,
			items = {"Base.Hat_DustMask", },
		},	
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_SafetyGoggles"},
		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
		
--		Hands = {
--			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Pants = {
			items = {"Base.Trousers_Denim"},
		},
		
--		Sweater = {
--			items = {};
--		},
		
--		FullSuit = {
--			chance = 20,
--			items = {"Boilersuit"},
--		},
		
		TorsoExtra = {
			chance = 30,
			items = {"Base.Vest_HighViz"},
		},
	},
}

ClothingSelectionDefinitions.engineer = {
	Female = {
		Hat = {
			chance = 5,
			items = {"Base.Hat_DustMask", },
		},	
		
		Neck = {
			chance = 20,
			items = {"Base.Tie_Full"},
		},
		
		Shirt = {
			items = {"Base.Shirt_FormalTINT"},
		},
		
		Pants = {
			items = {"Base.Trousers_SuitTEXTURE"},
		},
		
--		Sweater = {
--			items = {};
--		},
		
		TorsoExtra = {
			chance = 30,
			items = {"Base.Vest_HighViz"},
		},
	},
}

ClothingSelectionDefinitions.mechanics = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Bandana", },
		},	
		
		Mask = {
			chance = 5,
			items = {"Base.Hat_DustMask", },
		},	
		
		Eyes = {
			chance = 10,
			items = {"Base.Glasses_SafetyGoggles"},
		},
		
		Shirt = {
			items = {"Base.Shirt_Denim", "Base.Shirt_Lumberjack"},
		},
	
		Tshirt = {
			items = {"Base.Tshirt_Fossoil", "Base.Tshirt_Gas2Go", "Base.Tshirt_ThunderGas"},
		},
		
--		Hands = {
--			chance = 20,
--			items = {"Base.Gloves_LeatherGloves"},
--		},
		
		Pants = {
			items = {"Base.Trousers_Denim"},
		},
		
--		Sweater = {
--			items = {};
--		},
		
--		FullSuit = {
--			chance = 20,
--			items = {"Boilersuit"},
--		},
		
--		TorsoExtra = {
--			chance = 30,
--			items = {"Base.Vest_HighViz"},
--		},
	},
}

-- Optional clothing mods may be absent. Remove unresolved additions before
-- character creation reads the lists; the full vanilla override remains intact.
-- local function filterMissingStartingClothes()
--     if not ScriptManager or not ScriptManager.instance then return end
--     for _, definition in pairs(ClothingSelectionDefinitions.default) do
--         for location, slot in pairs(definition) do
--             for index = #slot.items, 1, -1 do
--                 if not ScriptManager.instance:FindItem(slot.items[index]) then
--                     table.remove(slot.items, index)
--                 end
--             end
--             if #slot.items == 0 then definition[location] = nil end
--         end
--     end
-- end
-- if Events and Events.OnGameBoot then
--     Events.OnGameBoot.Add(filterMissingStartingClothes)
-- end
