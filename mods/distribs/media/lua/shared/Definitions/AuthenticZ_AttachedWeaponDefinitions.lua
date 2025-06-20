require "Definitions/AttachedWeaponDefinitions"
-- define weapons to be attached to zombies when creating them

--These will be applied to all zombies on random. 
--Chance for a Meat chunk!
AttachedWeaponDefinitions.MeatChunk = {
	chance = 6,
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticMeatChunk1",
		"AuthenticZLite.AuthenticMeatChunk2",
		"AuthenticZLite.AuthenticMeatChunk3",
		"AuthenticZLite.AuthenticMeatChunk4",
		"AuthenticZLite.AuthenticMeatChunk5",
	},
}
--Chance for an organ!
AttachedWeaponDefinitions.Organ = {
	chance = 1,
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticOrgan_Liver",
		"AuthenticZLite.AuthenticOrgan_Brain",
--		"AuthenticZLite.AuthenticOrgan_Hand",
		"AuthenticZLite.AuthenticOrgan_Heart",
		"AuthenticZLite.AuthenticOrgan_Kidney",
}
}
-- For Specific Outfits --

AttachedWeaponDefinitions.AndySign = {
	id = "AndySign",
	chance = 100,
	outfit = {"AuthenticAndyDotD"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_AndyBoard",
	},
}

AttachedWeaponDefinitions.Bandages= {
	chance = 25,
	outfit = {"AuthenticBillOverbeck", "AuthenticZoey", "AuthenticLouis", "AuthenticFrancis", "AuthenticCoach", "AuthenticRochelle", "AuthenticNick", "AuthenticEllis"},
	weaponLocation = {"Pills Left", "Pills Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Authentic_Bandages",
	},
}

AttachedWeaponDefinitions.Balloon= {
	id = "PZBalloon",
	chance = 100,
	outfit = {"AuthenticClownBarotrauma","AuthenticClown","AuthenticClownParty","AuthenticClownObese","AuthenticClownWrinkles"},
	weaponLocation =  {"Balloon Left", "Balloon Right", "Balloon Center"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticBalloon_White",
		"AuthenticZLite.AuthenticBalloon_Blue",
		"AuthenticZLite.AuthenticBalloon_Purple",
		"AuthenticZLite.AuthenticBalloon_Pink",
		"AuthenticZLite.AuthenticBalloon_Red",
		"AuthenticZLite.AuthenticBalloon_Green",
		"AuthenticZLite.AuthenticBalloon_Yellow",		
	},
}
AttachedWeaponDefinitions.BalloonP1= {
	id = "BalloonP1",
	chance = 100,
	outfit = {"AuthenticClownPennywise"},
	weaponLocation =  {"Balloon Left"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticBalloon_White",
		"AuthenticZLite.AuthenticBalloon_Blue",
		"AuthenticZLite.AuthenticBalloon_Purple",
		"AuthenticZLite.AuthenticBalloon_Pink",
		"AuthenticZLite.AuthenticBalloon_Red",
		"AuthenticZLite.AuthenticBalloon_Green",
		"AuthenticZLite.AuthenticBalloon_Yellow",		
	},
}
AttachedWeaponDefinitions.BalloonP2= {
	id = "BalloonP2",
	chance = 100,
	outfit = {"AuthenticClownPennywise"},
	weaponLocation =  {"Balloon Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticBalloon_White",
		"AuthenticZLite.AuthenticBalloon_Blue",
		"AuthenticZLite.AuthenticBalloon_Purple",
		"AuthenticZLite.AuthenticBalloon_Pink",
		"AuthenticZLite.AuthenticBalloon_Red",
		"AuthenticZLite.AuthenticBalloon_Green",
		"AuthenticZLite.AuthenticBalloon_Yellow",		
	},
}
AttachedWeaponDefinitions.BalloonP3= {
	id = "BalloonP3",
	chance = 100,
	outfit = {"AuthenticClownPennywise"},
	weaponLocation =  {"Balloon Center"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticBalloon_White",
		"AuthenticZLite.AuthenticBalloon_Blue",
		"AuthenticZLite.AuthenticBalloon_Purple",
		"AuthenticZLite.AuthenticBalloon_Pink",
		"AuthenticZLite.AuthenticBalloon_Red",
		"AuthenticZLite.AuthenticBalloon_Green",
		"AuthenticZLite.AuthenticBalloon_Yellow",		
	},
}

AttachedWeaponDefinitions.BigLollipop = {
	id = "AZBigLollipop",
	chance = 100,
	outfit = {"AuthenticClownObese"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.BigLollipop",
	},
}

AttachedWeaponDefinitions.BrickBusterVHS = {
	id = "AZVHS",
	chance = 100,
	outfit = {"AuthenticBrickBuster"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "Base.VHS_Retail",
	},
}

AttachedWeaponDefinitions.BoomMic = {
	id = "BoomMic",
	chance = 100,
	outfit = {"AuthenticReporter5Cameraman"},
	weaponLocation = {"Shovel Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.BoomMicrophone",
	},
}

AttachedWeaponDefinitions.BouquetFlowers = {
	id = "AZBouquetFlowers",
	chance = 100,
	outfit = {"AuthenticFuneralFormal","AuthenticFuneralCoat"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_BouquetFlowers",
	},
}

-- Broom
AttachedWeaponDefinitions.Broom = {
	id = "AZBroom",
	chance = 100,
	outfit = {"AuthenticJanitor"},
	weaponLocation = {"Shovel Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Broom",
	},
}

-- Candle 
AttachedWeaponDefinitions.CandleCultist = {
	id = "AZCandle",
	chance = 100,
	outfit = {"AuthenticCultist"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "Base.Candle",
	},
}

-- Canteen 
AttachedWeaponDefinitions.AuthenticCanteen = {
	id = "AuthenticCanteen",
	chance = 100,
	outfit = {"PrivateMilitia","AuthenticDayZHeroBleu", "AuthenticB4BHoffman", "AuthenticSurvivorHazardSuit", "AuthenticSurvivorPolice", "AuthenticSurvivorRanger"},
	weaponLocation = {"Canteen Left", "Canteen Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.AuthenticCanteenSilver",
	"AuthenticZLite.AuthenticCanteenGrey",
	"AuthenticZLite.AuthenticCanteenForestGreen",
	"AuthenticZLite.AuthenticCanteenDarkGrey",
	"AuthenticZLite.AuthenticCanteenDarkGreen",
	"AuthenticZLite.AuthenticCanteenCadetBlue",
	},
}

-- Chainsaw 
AttachedWeaponDefinitions.chainsawAsh= {
	id = "chainsawAshEvilDead",
	chance = 100,
	outfit = {"AuthenticAshEvilDead","AuthenticLeatherFace","AuthenticChainsawMaid"},
	weaponLocation =  {"Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Chainsaw",
	},
}

-- Cigarette Holder 
AttachedWeaponDefinitions.CigaretteHolder= {
	id = "AuthenticCigaretteHolder",
	chance = 100,
	outfit = {"AuthenticLadyD"},
	weaponLocation =  {"Left Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticCigaretteHolder",
	},
}

-- Coffee Cup
AttachedWeaponDefinitions.CoffeeCup= {
	id = "CoffeeCup",
	chance = 100,
	outfit = {"AuthenticCook_Seahorse"},
	weaponLocation =  {"Left Hand Item", "Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Authentic_CoffeeCup",
	},
}

-- Screwdriver on construction worker
AttachedWeaponDefinitions.constructionWorkerScrewdriver2 = {
	chance = 80,
	outfit = {"AuthenticNateAnderson"},
	weaponLocation = {"Belt Left Screwdriver", "Belt Right Screwdriver"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Screwdriver",
	},
}

--Doll
AttachedWeaponDefinitions.Doll = {
	id = "AZDoll",
	chance = 100,
	outfit = {"AuthenticFat02Cheese"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Doll",
	},
}

--Elderly Bingo
AttachedWeaponDefinitions.ElderlyBingo = {
	chance = 100,
	outfit = {"AuthenticElderly"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.AuthenticBingoDotter",
    "AuthenticZLite.AuthenticBingoDotterOrange",
    "AuthenticZLite.AuthenticBingoDotterRed",
    "AuthenticZLite.AuthenticBingoDotterTeal",
    "AuthenticZLite.AuthenticBingoDotterYellow",
	},
}

--Elderly Cane 
AttachedWeaponDefinitions.ElderlyCane = {
	chance = 100,
	outfit = {"AuthenticElderly"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.AuthenticWalkingCane",
    "AuthenticZLite.AuthenticWalkingCaneMetal",
    "AuthenticZLite.AuthenticWalkingCaneGrandFather",
    "AuthenticZLite.AuthenticWalkingCane",
    "AuthenticZLite.AuthenticWalkingCaneMetal",
    "AuthenticZLite.AuthenticWalkingCaneGrandFather",	
    "AuthenticZLite.AuthenticWalkingCaneJP",
	},
}

--Feather Duster
AttachedWeaponDefinitions.FeatherDuster = {
	id = "AZFeatherDuster",
	chance = 100,
	outfit = {"AuthenticMaid"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_FeatherDuster",
	},
}

--Fishing Rod
AttachedWeaponDefinitions.FishingRod = {
	id = "AZFishingRod",
	chance = 100,
	outfit = {"AuthenticFat01Fisherman"},
	weaponLocation =  {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.FishingRod",
	},
} 

--Gardening Spray
AttachedWeaponDefinitions.GardeningSpray = {
	id = "AZGardeningSpray",
	chance = 100,
	outfit = {"AuthenticJanitor"},
	weaponLocation = {"Holster Left", "Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"farming.GardeningSprayEmpty",
	},
}

AttachedWeaponDefinitions.GhostbusterTrap= {
	id = "GhostbusterTrap",
	chance = 100,
	outfit = {"AuthenticGhostbusterSpengler", "AuthenticGhostbusterStantz","AuthenticGhostbusterVenkman", "AuthenticGhostbusterZeddemore"},
	weaponLocation =  {"Left Hand Item", "Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticGhostbusterTrap",
	},
}

-- Mop
AttachedWeaponDefinitions.Mop = {
	id = "AZMop",
	chance = 100,
	outfit = {"AuthenticJanitor"},
	weaponLocation = {"Shovel Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Mop",
	},
}

AttachedWeaponDefinitions.PaintBrush= {
	id = "PaintBrush",
	chance = 100,
	outfit = {"AuthenticBobRoss","AuthenticConstructionPainter"},
	weaponLocation =  {"Left Hand Item", "Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Authentic_Paintbrush",
	},
}

AttachedWeaponDefinitions.PaintBrush2= {
	id = "Paintbrush2",
	chance = 100,
	outfit = {"AuthenticConstructionPainter"},
	weaponLocation =  {"Left Hand Item", "Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Paintbrush",
	},
}

-- Pills
AttachedWeaponDefinitions.Pills= {
	id = "Pills",
	chance = 25,
	outfit = {"AuthenticBillOverbeck", "AuthenticZoey", "AuthenticLouis", "AuthenticFrancis", "AuthenticCoach", "AuthenticRochelle", "AuthenticNick", "AuthenticEllis", "AuthenticSexyNurse", "AuthenticSurvivorL4D"},
	weaponLocation = {"Pills Left", "Pills Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Authentic_Pills",
	},
}

-- Pistol
AttachedWeaponDefinitions.handgunJill= {
	id = "handgunJill",
	chance = 100,
	outfit = {"AuthenticJillValentine", "AuthenticPostalDude"},
	weaponLocation =  {"Holster Left"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	ensureItem = "Base.HolsterSimple",
	weapons = {

	},
}

-- Pistol2
AttachedWeaponDefinitions.handgunBub = {
	chance = 100,
	outfit = {"AuthenticBub"},
	weaponLocation = {"Left Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

-- Revolver_Short
AttachedWeaponDefinitions.handgunSamRivot= {
	id = "handgunSamRivot",
	chance = 100,
	outfit = {"AuthenticSamRivot","AuthenticCFTDJim", "AuthenticFlyboy", "AuthenticDIPurnaJackson"},
	weaponLocation =  {"Holster Left"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	ensureItem = "Base.HolsterSimple",
	weapons = {

	},
}

-- Revolver_Short
AttachedWeaponDefinitions.handgunFlyboy= {
	id = "handgunFlyboy",
	chance = 100,
	outfit = {"AuthenticFlyboy", "AuthenticJoker"},
	weaponLocation =  {"Left Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

-- Revolver_Long
AttachedWeaponDefinitions.handgunRickGrimes = {
	id = "handgunRickGrimes",
	chance = 100,
	outfit = {"AuthenticRickGrimes"},
	weaponLocation =  {"Holster Left"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	ensureItem = "Base.HolsterSimple",
	weapons = {

	},
}

AttachedWeaponDefinitions.handgunJohnMorgan = {
	chance = 100,
	outfit = {"AuthenticDIJohnMorgan", "AuthenticNMRIHWally","AuthenticNMRIHBadass", "AuthenticB4BHoffman","AuthenticAndyDotD"},
	weaponLocation = {"Holster Left", "Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

-- Stack of Money
AttachedWeaponDefinitions.PoliticianMoney= {
	id = "StackofMoney",
	chance = 100,
	outfit = {"AuthenticPolitician"},
	weaponLocation =  {"Left Hand Item", "Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Authentic_MoneyStack",
		"AuthenticZLite.Authentic_MoneyStack",
	},
}

AttachedWeaponDefinitions.ReporterMicAll = {
	id = "AZReporterMicAll",
	chance = 100,
	outfit = {"AuthenticReporter1Formal"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",	
	"AuthenticZLite.ReporterMicrophoneMuffler_Media04",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media04",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media05",
    "AuthenticZLite.ReporterMicrophone_Media04",
    "AuthenticZLite.ReporterMicrophone_Media04",
    "AuthenticZLite.ReporterMicrophone_Media05",	
	},
}

AttachedWeaponDefinitions.ReporterMicLBMW = {
	id = "AZReporterMicLBMW",
	chance = 100,
	outfit = {"AuthenticReporter1Formal"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",
    "AuthenticZLite.ReporterMicrophone_Media03",	
	"AuthenticZLite.ReporterMicrophoneMuffler_Media04",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media04",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media05",
    "AuthenticZLite.ReporterMicrophone_Media04",
    "AuthenticZLite.ReporterMicrophone_Media04",
    "AuthenticZLite.ReporterMicrophone_Media05",	
	},
}

AttachedWeaponDefinitions.ReporterMicLBMWRadio = {
	id = "AZReporterMicLBMWRadio",
	chance = 100,
	outfit = {"AuthenticReporter3LMBWRadio"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",
    "AuthenticZLite.ReporterMicrophone_Media02",	
    "AuthenticZLite.ReporterMicrophoneMuffler_Media04",
    "AuthenticZLite.ReporterMicrophone_Media04",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media05",	
    "AuthenticZLite.ReporterMicrophone_Media05",	
	},
}

AttachedWeaponDefinitions.ReporterMic3N= {
	id = "AZReporterMic3N",
	chance = 100,
	outfit = {"AuthenticReporter43N"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",
    "AuthenticZLite.ReporterMicrophone_Media01",	
    "AuthenticZLite.ReporterMicrophoneMuffler_Media04",
    "AuthenticZLite.ReporterMicrophoneMuffler_Media05",
    "AuthenticZLite.ReporterMicrophone_Media04",
    "AuthenticZLite.ReporterMicrophone_Media05",
	
	},
}

AttachedWeaponDefinitions.RotaryPhone= {
	id = "RotaryPhone",
	chance = 100,
	outfit = {"AuthenticBub"},
	weaponLocation =  {"Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.RotaryPhone_AZ",
	},
}

AttachedWeaponDefinitions.StopSign= {
	id = "stopSign",
	chance = 100,
	outfit = {"AuthenticCrossingGuard"},
	weaponLocation =  {"Left Hand Item", "Right Hand Item"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Stop_Sign",
		"AuthenticZLite.Stop_Sign",
		"AuthenticZLite.Go_Sign",
	},
}

AttachedWeaponDefinitions.TagillaSledgehammer = {
	chance = 100,
	outfit = {"AuthenticTagilla"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.AuthenticTagillaSledgehammer",
	},
}

AttachedWeaponDefinitions.revolverTF2Spy = {
	id = "revolverTf2Shpee",
	chance = 100,
	outfit = {"AuthenticTF2SpyBlue", "AuthenticTF2SpyRed"},
	weaponLocation =  {"Holster Left", "Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}
-- random weapon on police zombies holster
AttachedWeaponDefinitions.handgunHolsterAZ = {
	id = "handgunHolsterAZ",
	chance = 50,
	outfit = {"AuthenticSurvivorHazardSuit", "AuthenticSecretService", "AuthenticSurvivorPolice", "AuthenticSurvivorRanger", "AuthenticBillyChumpez", "AuthenticBankRobber", "AuthenticDawnoftheDead", "AuthenticLeonKennedy"},
	weaponLocation =  {"Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	ensureItem = "Base.HolsterSimple",
	weapons = {

	},
}

-- shotgun on police's back
AttachedWeaponDefinitions.shotgunPoliceAZ = {
	id = "shotgunPoliceAZ",
	chance = 20,
	outfit = {"AuthenticSurvivorHazardSuit", "AuthenticSurvivorPolice", "AuthenticSurvivorRanger", "AuthenticDawnoftheDead", "AuthenticFrancis", "AuthenticEllis", "AuthenticCoach", "AuthenticNateAnderson", "AuthenticTheyLive", "AuthenticLeonKennedy"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

-- assault rifle on back
AttachedWeaponDefinitions.HazardassaultRifleOnBack = {
	id = "HazardassaultRifleOnBack",
	chance = 20,
	outfit = {"AuthenticSurvivorHazardSuit"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		
	},
}

-- varmint/hunting rifle on back
AttachedWeaponDefinitions.SnowGhillie = {
	id = "SnowGhillieRifle",
	chance = 30,
	outfit = {"AuthenticSnowGhillie"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 125,
	weapons = {

	},
}

-- random construction tools on construction worker
AttachedWeaponDefinitions.HammerTime = {
	id = "HammerTime",
	chance = 80,
	outfit = {"AuthenticSurvivorHazardSuit", "AuthenticSurvivorPolice", "AuthenticSurvivorRanger"},
	weaponLocation = {"Belt Left", "Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Hammer",
		"Base.ClubHammer",
		"Base.WoodenMallet",
		"Base.BallPeenHammer",
	},
}

AttachedWeaponDefinitions.handaxeLoganCarter = {
	chance = 100,
	outfit = {"AuthenticDILoganCarter"},
	weaponLocation = {"Belt Left", "Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

-- M16 as Leg
AttachedWeaponDefinitions.M16Cherry = {
	id = "CherryLeg",
	chance = 100,
	outfit = {"AuthenticGrindhouseCherry"},
	weaponLocation =  {"CherryLeg"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

AttachedWeaponDefinitions.Katana= {
	chance = 100,
	outfit = {"AuthenticBlackMamba"},
	weaponLocation = {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}
-- melee on back!
AttachedWeaponDefinitions.CricketBat = {
	chance = 100,
	outfit = {"AuthenticShaunoftheDead"},
	weaponLocation = {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.AuthenticCricketBat",
	},
}

AttachedWeaponDefinitions.SpikedBat = {
	chance = 100,
	outfit = {"AuthenticB4BHolly"},
	weaponLocation = {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.BaseballBatNails",
	},
}

AttachedWeaponDefinitions.HammerOnlyBelt = {
	chance = 100,
	outfit = {"AuthenticDISamB", "AuthenticNMRIHJive", "AuthenticWichammer"},
	weaponLocation = {"Belt Left", "Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.BallPeenHammer",
		"Base.Hammer",
		"Base.HammerStone",
		"Base.ClubHammer",
	},
}

-- knives in belt right
AttachedWeaponDefinitions.knivesBeltAZ = {
	chance = 80,
	outfit = {"Bandit","AuthenticSurvivorHazardSuit", "AuthenticSurvivorPolice", "AuthenticSurvivorRanger", "AuthenticBillyChumpez", "AuthenticBankRobber", "AuthenticDawnoftheDead","AuthenticDIXianMei"},
	weaponLocation = {"Belt Right Upside"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

		"Base.KitchenKnife",
	},
}

-- crowbar or machete in back
AttachedWeaponDefinitions.bladeInBackAZ = {
	chance = 20,
	outfit = {"AuthenticBankRobber"},
	weaponLocation = {"Blade On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}
-- crowbar in back
AttachedWeaponDefinitions.Crowbar = {
	chance = 2,
	outfit = {"AuthenticGordonFreeman", "AuthenticDianneCaldwell"},
	weaponLocation = {"Blade On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Crowbar",
	},
}
-- machete in back
AttachedWeaponDefinitions.macheteInBack2 = {
	chance = 20,
	outfit = {"AuthenticJasonPart3","AuthenticB4BEvangelo"}, 
	weaponLocation = {"Blade On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
	},
}
-- Pickaxe on back
AttachedWeaponDefinitions.pickaxeInBack = {
	chance = 100,
	outfit = {"AuthenticJasonPart2"},
	weaponLocation = {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.PickAxe",
	},
}
-- Pickaxe on back
AttachedWeaponDefinitions.pickaxeInBack2 = {
	chance = 50,
	outfit = {"AuthenticMiner"},
	weaponLocation = {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.PickAxe",
	},
}
-- Pickaxe on back
AttachedWeaponDefinitions.MinerLightbulb = {
	id = "MinerLightbulb",
	chance = 100,
	outfit = {"AuthenticMiner"},
	weaponLocation = {"MinerLight"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"AuthenticZLite.Authentic_MinerLightbulb",
	},
}
-- Kitchen Knife in Right Hand
AttachedWeaponDefinitions.KniveinHand = {
	chance = 100,
	outfit = {"AuthenticHalloween", "AuthenticTrueEyeCult", "AuthenticJasonPart2", "AuthenticGhostFace"},
	weaponLocation = {"Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.KitchenKnife",
	},
}
--Hunting Knife in Right Hand
AttachedWeaponDefinitions.HuntingKniveinHand = {
	chance = 100,
	outfit = {"AuthenticDRTrueEyeCult"},
	weaponLocation = {"Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

AttachedWeaponDefinitions.axeRochelle = {
	chance = 5,
	outfit = {"AuthenticRochelle", "AuthenticNMRIHBateman"},
	weaponLocation = {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Axe",
	},
}
--Spatula in hands
AttachedWeaponDefinitions.Spatula = {
	chance = 100,
	outfit = {"AuthenticFat02Cook"},
	weaponLocation = {"Right Hand", "Left Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Spatula",
	},
}
-- shotgun on police's back
AttachedWeaponDefinitions.shotgunMadMax = {
	id = "shotgunMadMax",
	chance = 100,
	outfit = {"AuthenticMadMax", "AuthenticAshEvilDead","AuthenticB4BMom"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

-- sawnoff shotgun on back
AttachedWeaponDefinitions.shotgunDukeNukem = {
	id = "shotgunDukeNukem",
	chance = 100,
	outfit = {"AuthenticDukeNukem"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

AttachedWeaponDefinitions.MeatCleaver = {
	id = "MeatCleaver",
	chance = 100,
	outfit = {"AuthenticNMRIHButcher"},
	weaponLocation = {"MeatCleaver Belt Left", "MeatCleaver Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.MeatCleaver",
	},
}

-- nightstick in belt
AttachedWeaponDefinitions.nightstickAZ = {
	chance = 30,
	outfit = {"AuthenticSurvivorPolice", "AuthenticDawnoftheDead"},
	weaponLocation = {"Nightstick Left"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Nightstick",
	},
}

AttachedWeaponDefinitions.AuthenticTravelingBand = {
	id = "AuthenticTravelingBand",
	chance = 60,
	outfit = {"AuthenticTravelingBand"},
	weaponLocation = {"Guitar"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

    "Base.GuitarElectricBassBlack",
    "Base.GuitarElectricBassBlue",
    "Base.GuitarElectricBassRed",
    "Base.GuitarElectricBlack",
    "Base.GuitarElectricBlue",
    "Base.GuitarElectricRed",
    "Base.Guitarcase",
    "Base.Trumpet",
    "Base.Violin",
    "Base.GuitarAcoustic",
    "Base.Flute",
    "Base.Banjo",
    "Base.Keytar",

	},
}
AttachedWeaponDefinitions.AuthenticCountrySinger = {
	chance = 60,
	outfit = {"AuthenticCountrySinger"},
	weaponLocation = {"Guitar Acoustic"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "Base.GuitarAcoustic",
	},
}
AttachedWeaponDefinitions.AuthenticZoey = {
	id = "AuthenticZoey",
	chance = 100,
	outfit = {"AuthenticZoey", "AuthenticBillOverbeck", "AuthenticCoach", "AuthenticEllis", "AuthenticNick", "AuthenticRochelle", "AuthenticB4BHoffman", "AuthenticB4BWalker"},
	weaponLocation = {"Holster Left", "Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}
AttachedWeaponDefinitions.AuthenticDianneCaldwell = {
	chance = 100,
	outfit = {"AuthenticDianneCaldwell", "AuthenticDayZHeroBleu","AuthenticDRBradGarrison", "AuthenticNMRIHRoje"},
	weaponLocation = {"Holster Left", "Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

AttachedWeaponDefinitions.PostalPaper= {
	chance = 100,
	outfit = {"AuthenticPostalDude"},
	weaponLocation = {"Left Hand", "Wrench Left"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Postal_Petition",
	},
}

AttachedWeaponDefinitions.PomPom= {
	id = "PomPom",
	chance = 100,
	outfit = {"AuthenticCheerleader"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_PomPomWhite",
	"AuthenticZLite.Authentic_PomPomBlack",
	},
}
AttachedWeaponDefinitions.PomPom2= {
	id = "PomPom2",
	chance = 100,
	outfit = {"AuthenticCheerleaderLV"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_PomPomRed",
	"AuthenticZLite.Authentic_PomPomBlack",
	},
}

AttachedWeaponDefinitions.PostalShovel = {
	chance = 100,
	outfit = {"AuthenticPostalDude"},
	weaponLocation = {"Shovel Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Shovel",
	},
}
AttachedWeaponDefinitions.PostalScythe = {
	chance = 100,
	outfit = {"AuthenticPostalDude"},
	weaponLocation = {"Belt Left", "Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.HandScythe",
	},
}

AttachedWeaponDefinitions.Molotov = {
	id = "Molotov",
	chance = 100,
	outfit = {"AuthenticBillyChumpez", "AuthenticNMRIHMolotov", "AuthenticSurvivorL4D"},
	weaponLocation = {"Belt Left", "Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "Base.Molotov",
	"Base.Molotov",
	},
}
AttachedWeaponDefinitions.PipeBomb = {
	id = "PipeBomb",
	chance = 100,
	outfit = {"AuthenticSurvivorL4D"},
	weaponLocation = {"Pipe Waist"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.AuthenticPipeBomb",
	"AuthenticZLite.AuthenticSmokeBomb",
	},
}

AttachedWeaponDefinitions.Football = {
	id = "Football",
	chance = 20,
	outfit = {"AuthenticFootballPlayerBlueStar","AuthenticFootballChiefs","AuthenticFootballGreenBayPacker","AuthenticFootballPatriots","AuthenticFootballPlayerRedSkull"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Football3",
	},
}

AttachedWeaponDefinitions.ToiletPlungerOdd = {
	id = "AZToiletPlungerOdd",
	chance = 33,
	outfit = {"AuthenticJanitor"},
	weaponLocation = {"BucketHead", "PlungerFace", "PlungerHead"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "Base.Plunger",
    "Base.BucketEmpty",	
	},
}

AttachedWeaponDefinitions.ToiletPlungerBelt = {
	id = "AZToiletPlungerBelt",
	chance = 100,
	outfit = {"AuthenticJanitor"},
	weaponLocation = {"Belt Left", "Belt Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "Base.Plunger",
	},
}

AttachedWeaponDefinitions.TorchMelee = {
	chance = 100,
	outfit = {"AuthenticNMRIHBadass"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.TorchMelee",
	},
}

AttachedWeaponDefinitions.WaldoCane = {
	chance = 100,
	outfit = {"AuthenticWaldo"},
	weaponLocation = {"Left Hand", "Right Hand"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.AuthenticWalkingCane",
	},
}

AttachedWeaponDefinitions.AuthenticLouis = {
	chance = 100,
	outfit = {"AuthenticLouis"},
	weaponLocation = {"Holster Left", "Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
	},
}

AttachedWeaponDefinitions.AuthenticBillOverbeck = {
	chance = 100,
	outfit = {"AuthenticBillOverbeck"},
	weaponLocation =  {"Big Weapon On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}
AttachedWeaponDefinitions.AuthenticNick = {
	id = "AuthenticNick",
	chance = 100,
	outfit = {"AuthenticNick", "AuthenticNMRIHHunter"},
	weaponLocation =  {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {

	},
}

AttachedWeaponDefinitions.AuthenticWalkieTalkie = {
	chance = 100,
	outfit = {"AuthenticB4BHoffman"},
	weaponLocation = {"WalkieTalkie Left", "WalkieTalkie Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_WalkieTalkie",
	},
}


AttachedWeaponDefinitions.AuthenticMilitaryFlashlight = {
	id = "AuthenticMilitaryFlashlight",
	chance = 100,
	outfit = {"AuthenticB4BEvangelo", "AuthenticB4BHoffman","AuthenticB4BMom", "AuthenticB4BHolly", "AuthenticB4BWalker"},
	weaponLocation = {"Military Flashlight Left", "Military Flashlight Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
    "AuthenticZLite.Authentic_MilitaryFlashlightGreen",
	"AuthenticZLite.Authentic_MilitaryFlashlightGrey",
	},
}

-- Define some custom weapons attached on some specific outfit, so for example police have way more chance to have guns in holster and not simply a spear in stomach or something

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticAndyDotD = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.AndySign, 
		AttachedWeaponDefinitions.handgunJohnMorgan,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticAshEvilDead = {
	chance = 50;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.chainsawAsh,
		AttachedWeaponDefinitions.shotgunMadMax, 
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticB4BEvangelo = {
	chance = 100;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.macheteInBack2,
		AttachedWeaponDefinitions.AuthenticMilitaryFlashlight,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticB4BHoffman = {
	chance = 80;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.AuthenticWalkieTalkie,
		AttachedWeaponDefinitions.AuthenticCanteen,
		AttachedWeaponDefinitions.AuthenticMilitaryFlashlight,
		AttachedWeaponDefinitions.AuthenticZoey,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticB4BHolly = {
	chance = 100;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.SpikedBat,
		AttachedWeaponDefinitions.AuthenticMilitaryFlashlight,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticB4BMom = {
	chance = 70;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.shotgunMadMax,
		AttachedWeaponDefinitions.AuthenticMilitaryFlashlight,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticB4BWalker = {
	chance = 80;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.AuthenticMilitaryFlashlight,
		AttachedWeaponDefinitions.AuthenticZoey,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBillOverbeck = {
	chance = 80;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.AuthenticBillOverbeck,
		AttachedWeaponDefinitions.handgunHolsterAZ,		
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,	
	},
} 
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBlackMamba = {
	chance = 90;
	weapons = {
		AttachedWeaponDefinitions.Katana, 
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBrickBuster = {
	chance = 50;
	maxitem = 1;	
	weapons = {
		AttachedWeaponDefinitions.BrickBusterVHS, 
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBobRoss = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.PaintBrush, 
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBub = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunBub,
		AttachedWeaponDefinitions.RotaryPhone,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticChainsawMaid = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.chainsawAsh, 
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCheerleader = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.PomPom,
		AttachedWeaponDefinitions.PomPom,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCheerleaderLV = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.PomPom2,
		AttachedWeaponDefinitions.PomPom2,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticClown = {
	chance = 40;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.Balloon,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticClownBarotrauma = {
	chance = 40;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.Balloon,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticClownParty = {
	chance = 40;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.Balloon,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticClownObese = {
	chance = 40;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Balloon,
		AttachedWeaponDefinitions.BigLollipop,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticClownWrinkles = {
	chance = 40;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.Balloon,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticClownPennywise = {
	chance = 100;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.BalloonP1,
		AttachedWeaponDefinitions.BalloonP2,
		AttachedWeaponDefinitions.BalloonP3,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCountrySinger = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.AuthenticCountrySinger,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCrossingGuard = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.StopSign,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCultist = {
	chance = 66;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.CandleCultist,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDianneCaldwell = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Crowbar,
		AttachedWeaponDefinitions.AuthenticDianneCaldwell,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDIJohnMorgan = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunJohnMorgan,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDILoganCarter = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handaxeLoganCarter,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDIPurnaJackson = {
	chance = 80;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunSamRivot,
		AttachedWeaponDefinitions.handgunSamRivot,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDISamB = {
	chance = 100;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.HammerOnlyBelt,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDIXianMei = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.knivesBeltAZ,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDRBradGarrison = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.AuthenticDianneCaldwell,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFat02Cheese = {
	chance = 12;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Doll,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFat01Fisherman = {
	chance = 10;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.FishingRod, 
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFuneralFormal = {
	chance = 12;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.BouquetFlowers,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFuneralCoat = {
	chance = 12;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.BouquetFlowers,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticElderly = {
	chance = 30;
	maxitem = 1;	
	weapons = {
		AttachedWeaponDefinitions.ElderlyCane,
		AttachedWeaponDefinitions.ElderlyBingo,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFat02Cook = {
	chance = 100;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.Spatula,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSnowGhillie = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.SnowGhillie,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.HockeyPsycho = {
	chance = 100;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.macheteInBack,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFootballPlayerRedSkull = {
	chance = 33;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.Football,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFootballPatriots = {
	chance = 33;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Football,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFootballGreenBayPacker = {
	chance = 33;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Football,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFootballChiefs = {
	chance = 33;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Football,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFootballPlayerBlueStar = {
	chance = 33;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Football,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGhostFace = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.KniveinHand,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGhostbusterSpengler = {
	chance = 25;
	weapons = {
		AttachedWeaponDefinitions.GhostbusterTrap,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGhostbusterStantz = {
	chance = 25;
	weapons = {
		AttachedWeaponDefinitions.GhostbusterTrap,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGhostbusterVenkman = {
	chance = 25;
	weapons = {
		AttachedWeaponDefinitions.GhostbusterTrap,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGhostbusterZeddemore = {
	chance = 25;
	weapons = {
		AttachedWeaponDefinitions.GhostbusterTrap,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticHalloween = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.KniveinHand,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticJanitor = {
	chance = 80;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.Broom,
		AttachedWeaponDefinitions.ToiletPlungerOdd,
		AttachedWeaponDefinitions.ToiletPlungerBelt,
		AttachedWeaponDefinitions.Mop,
		AttachedWeaponDefinitions.GardeningSpray,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticJasonPart3 = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.macheteInBack2,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticJasonPart2 = {
	chance = 100;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.KniveinHand,
		AttachedWeaponDefinitions.pickaxeInBack,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticJoker = {
	chance = 90;
	weapons = {
		AttachedWeaponDefinitions.handgunFlyboy,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticLeatherFace = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.chainsawAsh,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticLadyD = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.CigaretteHolder,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticConstructionPainter = {
	chance = 80;
	maxitem = 1;	
	weapons = {
		AttachedWeaponDefinitions.PaintBrush,
		AttachedWeaponDefinitions.PaintBrush2,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDRTrueEyeCult = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.HuntingKniveinHand,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGordonFreeman = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.Crowbar,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticTravelingBand = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.AuthenticTravelingBand,

	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticPostalDude = {
	chance = 100;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.PostalPaper,
		AttachedWeaponDefinitions.PostalShovel,
		AttachedWeaponDefinitions.PostalScythe,
		AttachedWeaponDefinitions.handgunJill,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticMadMax = {
	chance = 70;
	weapons = {
		AttachedWeaponDefinitions.shotgunMadMax,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticMaid = {
	chance = 33;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.FeatherDuster,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticMiner = {
	chance = 75;
	maxitem = 2;	
	weapons = {
		AttachedWeaponDefinitions.pickaxeInBack2,
		AttachedWeaponDefinitions.MinerLightbulb,		
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDayZHeroBleu = {
	chance = 70;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.AuthenticDianneCaldwell,
		AttachedWeaponDefinitions.AuthenticCanteen,		
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticGrindhouseCherry = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.M16Cherry,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDukeNukem = {
	chance = 80;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.shotgunDukeNukem,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticTheyLive = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticLeonKennedy = {
	chance = 80;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.handgunHolsterAZ,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFrancis = {
	chance = 80;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticEllis = {
	chance = 80;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.handgunHolsterAZ,		
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNick = {
	chance = 80;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.AuthenticNick,
		AttachedWeaponDefinitions.handgunHolsterAZ,		
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCoach = {
	chance = 80;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticRochelle = {
	chance = 80;
	maxitem = 5;	
	weapons = {
		AttachedWeaponDefinitions.axeRochelle,
		AttachedWeaponDefinitions.handgunHolsterAZ,		
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNateAnderson = {
	chance = 80;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.constructionWorkerScrewdriver2,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticPolitician = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.PoliticianMoney,
		AttachedWeaponDefinitions.PoliticianMoney,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticShaunoftheDead = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.CricketBat,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticJillValentine = {
	chance = 80;
	weapons = {
		AttachedWeaponDefinitions.handgunJill,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticLouis = {
	chance = 80;
	weapons = {
		AttachedWeaponDefinitions.AuthenticLouis,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticReporter1Formal = {
	chance = 100;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.ReporterMicAll,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticReporter2LBMW = {
	chance = 100;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.ReporterMicLBMW,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticReporter3LMBWRadio = {
	chance = 100;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.ReporterMicLBMWRadio,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticReporter43N = {
	chance = 100;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.ReporterMic3N,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticReporter5Cameraman = {
	chance = 33;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.BoomMic,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticRickGrimes = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.handgunRickGrimes,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticTF2SpyBlue = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.revolverTF2Spy,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticTF2SpyRed = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.revolverTF2Spy,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSamRivot = {
	chance = 80;
	weapons = {
		AttachedWeaponDefinitions.handgunSamRivot,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticFlyboy = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunFlyboy,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSexyNurse = {
	chance = 50;
	weapons = {
		AttachedWeaponDefinitions.Pills,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCFTDJim = {
	chance = 80;
	weapons = {
		AttachedWeaponDefinitions.handgunSamRivot,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHBadass = {
	chance = 90;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunJohnMorgan,
		AttachedWeaponDefinitions.TorchMelee,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHBateman = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.axeRochelle,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHButcher = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.MeatCleaver,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHHunter = {
	chance = 80;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.AuthenticNick,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHMolotov = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.Molotov,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHJive = {
	chance = 100;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.HammerOnlyBelt,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHRoje = {
	chance = 80;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.AuthenticDianneCaldwell,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticNMRIHWally = {
	chance = 90;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunJohnMorgan,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticDawnoftheDead = {
	chance = 40;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.HazardassaultRifleOnBack,
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.nightstickAZ,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSurvivorHazardSuit= {
	chance = 60;
	maxitem = 3;
	weapons = {
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.HazardassaultRifleOnBack,
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.HammerTime,
		AttachedWeaponDefinitions.AuthenticCanteen,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSecretService = {
	chance = 70;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunHolsterAZ,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticTagilla = {
	chance = 100;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.TagillaSledgehammer,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBillyChumpez = {
	chance = 70;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.molotov,
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticBankRobber = {
	chance = 50;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.meleeInBack,
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.bladeInBackAZ,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSurvivorPolice = {
	chance = 50;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.nightstickAZ,
		AttachedWeaponDefinitions.AuthenticCanteen,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSurvivorRanger = {
	chance = 50;
	maxitem = 2;
	weapons = {
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.knivesBeltAZ,
		AttachedWeaponDefinitions.shotgunPoliceAZ,
		AttachedWeaponDefinitions.AuthenticCanteen,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticSurvivorL4D = {
	chance = 75;
	maxitem = 5;
	weapons = {
		AttachedWeaponDefinitions.handgunHolsterAZ,
		AttachedWeaponDefinitions.Molotov,
		AttachedWeaponDefinitions.Pills,
		AttachedWeaponDefinitions.PipeBomb,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticCook_Seahorse = {
	chance = 50;
	weapons = {
		AttachedWeaponDefinitions.CoffeeCup,
	},
}
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticWaldo = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.WaldoCane, 
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticWichammer = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.HammerOnlyBelt, 
	},
}


AttachedWeaponDefinitions.attachedWeaponCustomOutfit.AuthenticZoey = {
	chance = 75;
	maxitem = 4;
	weapons = {
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.AuthenticZoey,
		AttachedWeaponDefinitions.Bandages,
		AttachedWeaponDefinitions.Pills,
	},
}