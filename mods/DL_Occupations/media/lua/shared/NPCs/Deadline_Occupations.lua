require('NPCs/MainCreationMethods');
require ("MoreTraitsMainCreationMethods")

if not getActivatedMods():contains("ProfessionFramework") then return end
local addProfession = ProfessionFramework.addProfession
local addTrait = ProfessionFramework.addTrait

ProfessionFramework.RemoveDefaultProfessions = true
ProfessionFramework.RemoveDefaultTraits = true

addProfession('unemployed', {
    name = "Jack of All Trades",
    icon = "jack2",
    cost = 7,
     
        traits = {
        "FastLearnerFree"
    }, 
        inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},

})


addProfession('carpenter', {
    name = "Carpenter",
    icon = "carp",
    cost = 7,
    xp = {
        [Perks.Woodwork] = 3,
    }, 
	 
    traits = {
    "Handy2",
    "profcarpenter"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
})

addProfession('cook', {
    name = "Cook",
    icon = "cook",
    cost = 7,
    xp = {
        [Perks.Cooking] = 3,
    }, 
    
    traits = {
    "profcook",
    "profcook2"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
    recipes = {"Remove Poison from Mushroom", "Remove Poison from Berries", "Make Cake Batter","Make Pie Dough","Make Chocolate Chip Cookie Dough","Make Chocolate Cookie Dough","Make Oatmeal Cookie Dough","Make Sugar Cookie Dough","Make Shortbread Cookie Dough","Make Bread Dough","Make Biscuits","Make Pizza","Make Flour Dough Wrapper","Fill Dumplings with Minced Meat","Fill Dumplings with Vegetables","Make Saucepan with Shui Zhu Yu in Stock","Cook Kung Pao Chicken in Wok Pan","Prepare Yakisoba in Wok Pan","Make Saucepan of Japanese Chicken Curry","Prepare Borscht","Prepare Risotto","Cook Tortellini","Cook Ravioli","Make Roasting Pan of Confit Byaldi Ratattouile","Roll out Croissaint Dough","Roll out Dough with Rolling Pin","Cut Doughnuts","Make Pasta Dough","Roll out Pasta Dough with Rolling Pin","Cut Pasta Dough","Fill Pasta Dough with Meat","Cut Ravioli","Cut Tortellini","Make Sausage Casings","Make Sausage Casings2","Make Sausage Casings3"}, 
})

addProfession('healer', {
    name = "Healer",
    icon = "firstaid",
    cost = 7,
    xp = {
        [Perks.Doctor] = 3,
    }, 
     
    traits = {
        "profhealer",
        "profhealer2"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
    recipes = {"Make Adderall Compound","Produce Adderall","Make Clonazepam Compound","Make Clonazepam","Make Codeine Compound","Make Codeine","Make Lean","Make Morphine Compound","Make Morphine","Make Oxycodone Compound","Make Oxycodone","Make Percocet Compound","Make Percocet","Make Phenobarbital Compound","Make Phenobarbital","Make Tramadol Compound","Make Tramadol","Make Vicodin Compound","Make Vicodin","Make Benzodiazepine Compound","Produce Xanax Compound","Dry Xanax Compound"}, 

})

addProfession('farmer', {
    name = "Farmer",
    icon = "farmer",
    cost = 7,
    xp = {
        [Perks.Farming] = 3,
    }, 
     
    traits = {
        "proffarmer"
    },
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
    recipes = {"Make Mildew Cure","Make Flies Cure"},
})

addProfession('forager', {
    name = "Forager",
    icon = "forage",
    cost = 7,
    xp = {
        [Perks.PlantScavenging] = 3,
    }, 
     
    traits = {
        "profforager",
        "profforager2"
    }, 
    recipes = { "Herbalist", "Identify Insect" },
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
})

addProfession('mechanic', {
    name = "Mechanic",
    icon = "mechanic",
    cost = 7,
    xp = {
        [Perks.Mechanics] = 3,
    }, 
     
    traits = {
        "profmechanic",
        "profmechanic2"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
        recipes = {"Basic Tuning","ATAVanillaRecipes", "ATAFiliRecipes","Make Performance Suspensions Type Standard","Make Performance Suspensions Type Heavy-Duty","Make Performance Suspensions Type Sport","Make Standard Gas Tank Type Standard","Make Big Gas Tank Type Standard","Make Standard Gas Tank Type Heavy-Duty","Make Big Gas Tank Type Heavy-Duty","Make Standard Gas Tank Type Sport","Make Big Gas Tank Type Sport","Make Average Muffler Type Standard","Make Performance Muffler Type Standard","Make Average Muffler Type Heavy-Duty","Make Performance Muffler Type Heavy-Duty","Make Average Muffler Type Sport","Make Performance Muffler Type Sport","Make Regular Tire Type Standard","Make Performance Tire Type Standard","Make Regular Tire Type Heavy-Duty","Make Performance Tire Type Heavy-Duty","Make Regular Tire Type Sport","Make Performance Tire Type Sport","Make Regular Brake Type Standard","Make Performance Brake Type Standard","Make Regular Brake Type Heavy-Duty","Make Performance Brake Type Heavy-Duty","Make Regular Brake Type Sport","Make Performance Brake Type Sport", "Basic Mechanics", "Intermediate Mechanics", "Advanced Mechanics"}, 
})

addProfession('metalworker', {
    name = "Metalworker",
    icon = "metalwork",
    cost = 7,
    xp = {
        [Perks.MetalWelding] = 3,
    }, 
     
    traits = {
        "profmetalworker"

    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
})

addProfession('musician', {
    name = "Musician",
    icon = "music",
    cost = 7,
    xp = {
    }, 
     
    traits = {
        "profmusician"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
})

addProfession('survivalist', {
    name = "Survivalist",
    icon = "survival",
    cost = 7,
    xp = {
        [Perks.Fishing] = 3,
        [Perks.Trapping] = 3,
    }, 
     
    traits = {
        "profsurvivalist",
        "profsurvivalist2",
        "profsurvivalist3"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
    recipes = {"Find Bait in Rotten Food", "Make Fishing Rod","Fix Fishing Rod", "Make Fishing Net","Get Wire Back", "Make Snare Trap", "Make Wooden Cage Trap", "Make Stick Trap", "Make Trap Box", "Make Cage Trap", "Craft Spear with Bone Head","Craft Spear with Long Bone Head","Craft a Bone Club","Craft a Sturdy Bone Club","Craft a Spiked Sturdy Bone Club","Craft a Jawbone Club","Craft a Jawbone Morningstar","Craft Long Spiked Club","Craft a Bone War Hatchet","Craft a Jawbone War Axe"}, 
})

addProfession('tailor', {
    name = "Tailor",
    icon = "tailor",
    cost = 7,
    xp = {
        [Perks.Tailoring] = 3,
    }, 
     
    traits = {
        "proftailor"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
})

addProfession('tinkerer', {
    name = "Tinkerer",
    icon = "electrician",
    cost = 7,
    xp = {
        [Perks.Electricity] = 3,
    }, 
     
    traits = {
        "proftinkerer",
        "proftinkerer2"
    }, 
    inventory = {["Base.RunicsMap"] = 1, ["Base.CannedSardines"] = 1, ["Base.Garbagebag"] = 1, ["Base.Mirror"] = 1, ["Base.WaterBottleFull"] = 1, ["ElliesTattooParlor.FilledTattooNeedle"] = 1, ["KeksTat.CharacterTatNeedle"] = 1, ["Radio.WalkieTalkie2"] = 1, ["SPolishItems.CharacterSheet"] = 1, ["aerx.TreeBranch_Nails"] = 1, ["aerx.BowlingPin"] = 1},
    recipes = {"Make Duct Tape from Glue", "Make Duct Tape from Wood Glue", "Generator", "Make Remote Controller V1", "Make Remote Controller V2", "Make Remote Controller V3", "Make Remote Trigger", "Make Timer", "Craft Makeshift Radio", "Craft Makeshift HAM Radio", "Craft Makeshift Walkie Talkie", "Make Aerosol bomb", "Make Flame bomb", "Make Pipe bomb", "Make Noise generator", "Make Smoke Bomb", "Craft a Tailoring Table Kit", "Craft a Brewing Station Kit", "Craft a Paint Mixing Kit", "Craft a Hand Press Kit", "Craft a Sculpting Table Kit", "Craft a Anaerobic Digester Kit" } ,
})




















