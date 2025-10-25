require('NPCs/MainCreationMethods');
local addTrait = ProfessionFramework.addTrait

-- OCCUPATION TRAITS --

addTrait("Drogadicto", {
    name = "Drug Addict",
    description = "You are a Drug Addict. Your body will ask for drugs and you will get bored.\nYou're going to experience Withdrawal effects if you don't consume for 12 hours.\nYou can eventually outgrow your addiction if you don't consume in 21 days.\n(This trait will be added automatically if you consume a lot of drugs ingame)",
    cost = -6,
})

addTrait("Asthmatic", {
    name = "Asthmatic",
    description = "Faster endurance loss. -2 to Physical Endurance Rolls",
    cost = -4,
})

addTrait("Deaf", {
    name = "Deaf",
    description = "Can't hear sound. -2 to Notice Rolls",
    cost = -6,
})

addTrait("Hemophobic", {
    name = "Fear of Blood",
    description = "Panic when performing first aid on self, cannot perform first aid on others, gets stressed when bloody.",
    cost = -2,
})

addTrait("Illiterate", {
    name = "Illiterate",
    description = "Cannot read books.",
    cost = -6,
})

addTrait("SlowHealer", {
    name = "Slow Healer",
    description = "Recovers slowly from injuries and illness. -2 to Physical Endurance Rolls",
    cost = -4,
})

addTrait("SlowLearner", {
    name = "Slow Learner",
    description = "Decreased XP gains.",
    cost = -4,
})

addTrait("Thinskinned", {
    name = "Thin-skinned",
    description = "Increased chance of scratches, lacerations, or bites breaking the skin. -2 to Physical Endurance Rolls",
    cost = -4,
})

addTrait("Unlucky", {
    name = "Unlucky",
    description = "What could go wrong for you, often does. Rolling a 2 is a critical failure!",
    cost = -4,
})

addTrait("Codependant", {
    name = "Codependant",
    description = "Becomes sad when alone for extended periods of time.",
    cost = -4,
})

addTrait("Necrophobic", {
    name = "Necrophobic",
    description = "errified of the undead, Becomes panicked when being chased by zombies\nRefuses to carry corpses.",
    cost = -2,
})

addTrait("Nyctophobic", {
    name = "Nyctophobic",
    description = "Gets panicked when standing in darkness.",
    cost = -2,
})

addTrait("Photophobic", {
    name = "Photophobic",
    description = "Gets panicked when exposed to sunlight.",
    cost = -2,
})

addTrait("Sentimental", {
    name = "Sentimental",
    description = "Start with a randomized sentimental item, you will gain unhappiness if it is ever lost or destroyed.",
    cost = -2,
})

addTrait("StressEater", {
    name = "StressEater",
    description = "Becomes hungry when stressed, becomes stressed when hungry \nEating reduces stress.",
    cost = -2,
})

addTrait("AllThumbs", {
    name = "All Thumbs",
    description = "Transfers inventory items slowly. \nGain -1 to Initiative",
    cost = -2,
})

addTrait("Clumsy", {
    name = "Clumsy",
    description = "Makes more noise when moving. -1 to Stealth Rolls and -2 to Defense Close Rolls.",
    cost = -2,
})

addTrait("ClumsyStriker", {
    name = "Clumsy Striker (Dice Effects Only)",
    description = "Reduces Damage with Long Blade, Short Blade, and Short Blunt by 1.",
    cost = -2,
})

addTrait("Conspicuous", {
    name = "Conspicuous",
    description = "More likely to be spotted by zombies. -2 to Stealth Rolls",
    cost = -2,
})

addTrait("Disorganized", {
    name = "Disorganized",
    description = "Decreased container inventory capacity. \nGain -1 to Mental Endurance Rolls",
    cost = -2,
})

addTrait("FeatherFist", {
    name = "Feather Fist (Dice Effects Only)",
    description = "Reduces Unarmed Damage by 1.",
    cost = -2,
})

addTrait("Fragile", {
    name = "Fragile (Dice Effects Only)",
    description = "Reduces Hitpoints by 2.",
    cost = -2,
})

addTrait("Frail", {
    name = "Frail (Dice Effects Only)",
    description = "Decreases Physical Endurance by 2.",
    cost = -2,
})



addTrait("HardOfHearing", {
    name = "Hard of Hearing",
    description = "Smaller perception radius.\nSmaller hearing range. -1 to Notice Rolls",
    cost = -2,
})

addTrait("HeartyAppitite", {
    name = "Hearty Appetite",
    description = "Needs to eat more regularly.",
    cost = -2,
})

addTrait("HighThirst", {
    name = "High Thirst",
    description = "Needs more water to survive.",
    cost = -2,
})

addTrait("Lethargic", {
    name = "Lethargic (Dice Effects Only)",
    description = "Reduces Initiative Rolls by 2.",
    cost = -2,
})

addTrait("Pacifist", {
    name = "Pacifist",
    description = "Less effective with weapons.",
    cost = -2,
})

addTrait("ProneToIllness", {
    name = "Prone to Illness",
    description = "More prone to disease.\nFaster rate of zombification. -1 to Physical Endurance Rolls",
    cost = -2,
})

addTrait("PulledPunches", {
    name = "Pulled Punches (Dice Effects Only)",
    description = "Reduces hit chance by 2 with Unarmed Attacks.",
    cost = -2,
})

addTrait("Reckless", {
    name = "Reckless (Dice Effects Only)",
    description = "Decreases Physical and Mental Endurance by 1.",
    cost = -2,
})

addTrait("ShakyHands", {
    name = "Shaky Hands (Dice Effects Only)",
    description = "Reduces hit chance by 2 with Ranged Attacks.",
    cost = -2,
})

addTrait("ShortSighted", {
    name = "Short Sighted",
    description = "Smaller view distance.\nSlower visibility fade. -1 to Notice Rolls",
    cost = -2,
})

addTrait("SloppySwing", {
    name = "Sloppy Swing (Dice Effects Only)",
    description = "Reduces hit chance by 2 with Melee Attacks.",
    cost = -2,
})

addTrait("SlowReader", {
    name = "Slow Reader",
    description = "Takes longer to read books.",
    cost = -2,
})

addTrait("SlowReflexes", {
    name = "Slow Reflexes (Dice Effects Only)",
    description = "Reduces Defend Close by 2.",
    cost = -2,
})

addTrait("Smoker", {
    name = "Smoker",
    description = "Stress and unhappiness decrease after smoking tobacco. Unhappiness rises when tobacco is not smoked. -1 to Mental Endurance Rolls",
    cost = -2,
})

addTrait("SundayDriver", {
    name = "Sunday Driver",
    description = "Drives very slow.",
    cost = -2,
})

addTrait("Target", {
    name = "Target (Dice Effects Only)",
    description = "Reduces Defend Ranged by 2.",
    cost = -2,
})

addTrait("TriggerJitters", {
    name = "Trigger Jitters (Dice Effects Only)",
    description = "Reduces Ranged Damage by 1.",
    cost = -2,
})

addTrait("Unfit", {
    name = "Unfit",
    description = "Very low endurance, very low endurance regeneration.",
    cost = -2,
        xp = {
    [Perks.Fitness] = -5,
        },
})

addTrait("UnsteadyGrip", {
    name = "Unsteady Grip (Dice Effects Only)",
    description = "Reduces Damage with Axe, Long Blunt, and Spear by 1.",
    cost = -2,
})

addTrait("Weak", {
    name = "Weak",
    description = "Less knockback from melee weapons.\nDecreased carrying weight.",
    cost = -2,
        xp = {
    [Perks.Strength] = -5,
        },
})

addTrait("WeakStomach", {
    name = "Weak Stomach",
    description = "Higher chance to have food illness. -1 to Physical Endurance Rolls",
    cost = -2,
})

addTrait("WeakWilled", {
    name = "Weak-Willed (Dice Effects Only)",
    description = "Decreases Mental Endurance by 2.",
    cost = -2,
})

addTrait("FrailNerves", {
    name = "Frail Nerves (Dice Effects Only)",
    description = "Decreases Mental Endurance by 1.",
    cost = -1,
})

addTrait("Sluggish", {
    name = "Sluggish (Dice Effects Only)",
    description = "Decreases Physical Endurance by 1.",
    cost = -1,
})

addTrait("Feeble", {
    name = "Feeble",
    description = "Less knockback from melee weapons.\nDecreased carrying weight.",
    cost = -1,
        xp = {
    [Perks.Strength] = -2,
        },
})

addTrait("Out of Shape", {
    name = "Out of Shape",
    description = "Low endurance, low endurance regeneration.",
    cost = -1,
    xp = {
        [Perks.Fitness] = -2,
    },
})

addTrait("Handy", {
    name = "Handy",
    description = "Faster and stronger constructions.",
})

addTrait("MusicalSavant2", {
    name = "Musical Savant",
    description = "You have a natural talent for music.<br>You gain a bonus to all music skills.<br>Learn songs without playing.<br>Can transcribe music.",
    profession = true,
    
})


addTrait("NightOwl", {
    name = "Night Owl",
    description = "Requires little sleep.\nStays extra alert even when sleeping.",
    profession = true,
})

addTrait("Nutritionist2", {
    name = "Nutritionist",
    description = "Can see the nutritional values of any food.",
    profession = true,
})

addTrait("profcarpenter", {
    name = "Master Craftsman",
    description = "Saws more planks per log. Sawing logs reduces Stress, Boredom, and Unhappiness.",
    profession = true,

})

addTrait("profcook", {
    name = "Survival Chef",
    description = "Faster cooking, starts with all Recipes, able to request one new dish/recipe monthly to be added to Craftline (must have a model or provide one).",
    profession = true,
})

addTrait("proffarmer", {
    name = "Seed Reclamation",
    description = "Able to convert some rotten crops into seeds.\nFinds more and rarer seeds in mystery seed bags.",
    profession = true,

})

addTrait("profforager", {
    name = "Dumpster Diver",
    description = "Able to find additional items by rummaging in trash bags found in dumpsters.",
    profession = true,

})

addTrait("profhealer", {
    name = "Medical Practitioner",
    description = "Knowledge of making healing recipes/drugs/items. Bandages much faster than normal, and doesn't fail when treating wounds.\nGreatly reduces the duration of burns when cleaning them.",
    profession = true,
recipes = {"Make Adderall Compound","Produce Adderall","Make Clonazepam Compound","Make Clonazepam","Make Codeine Compound","Make Codeine","Make Lean","Make Morphine Compound","Make Morphine","Make Oxycodone Compound","Make Oxycodone","Make Percocet Compound","Make Percocet","Make Phenobarbital Compound","Make Phenobarbital","Make Tramadol Compound","Make Tramadol","Make Vicodin Compound","Make Vicodin","Make Benzodiazepine Compound","Produce Xanax Compound","Dry Xanax Compound"},
})

addTrait("profmechanic", {
    name = "Armorer",
    description = "Able to armor many types of cars.",
    profession = true,

})

addTrait("profmetalworker", {
    name = "Metalworker",
    description = "Receives more metal scrapping objects.\nStarts with basic metallurgy knowledge.",
    profession = true,

})

addTrait("profmusician", {
    name = "Musical Savant",
    description = "Learn songs faster and get the ability to transcribe songs.\nAble to request a song to be added to the performance pack monthly",
    profession = true,
 
})

addTrait("profsurvivalist", {
    name = "Survivalist",
    description = "Can instantly find bait in some rotten food.",
    profession = true,

})

addTrait("proftailor", {
    name = "Master of Fashion and Comfort",
    description = "Able to convert dyes from paint.\nAble to recut some clothing to add or remove insulation.",
    profession = true,

recipes = {
        "Make Earring: Hoop (Random Color)",
        "Make Earring: Cross (Random Color)",
        "Make Earring: Pillar (Random Color)",
        "Make Earring: Triangle (Random Color)",
        "Make Earring: Dot (Random Color)",
        "Make Earring: Dot Triangle (Random Color)",
        "Make Earring: X (Random Color)",
        "Make Earring: Cash (Random Color)",
        "Make Earring: Gun (Random Color)",
        "Make Earring: Triangle Closed (Random Color)",
        "Make Earring: Heart (Random Color)",
        "Make Earring: Lightning 1 (Random Color)",
        "Make Earring: Lightning 2 (Random Color)",

        "Make Glasses: Aviator Black (Random Color)",
        "Make Glasses: Aviator Silver (Random Color)",
        "Make Glasses: Aviator Gold (Random Color)",
        "Make Glasses: Polarized Black (Random Color)",
        "Make Glasses: Polarized Silver (Random Color)",
        "Make Glasses: Polarized Gold (Random Color)",
        "Make Glasses: Circular Black (Random Color)",
        "Make Glasses: Circular Silver (Random Color)",
        "Make Glasses: Circular Gold (Random Color)",
        "Make Glasses: Round Black (Random Color)",
        "Make Glasses: Round Silver (Random Color)",
        "Make Glasses: Round Gold (Random Color)",
        "Make Glasses: Pixel (Random Color)",
        "Make Glasses: Party (Random Color)",

        "Make Piercing: Round (Random Color)",
        "Make Piercing: Cross (Random Color)",
        "Make Piercing: Large Cross (Random Color)",


        "Make Necklace: Basic (Random Color)",
        "Make Necklace Pendant: Cross (Random Color)",
        "Make Necklace Pendant: Cash (Random Color)",
        "Make Necklace Pendant: X (Random Color)",
        "Make Necklace Pendant: Lightning1 (Random Color)",
        "Make Necklace Pendant: Lightning2 (Random Color)",
        "Make Necklace Pendant: Gun (Random Color)",
        "Make Necklace Pendant: Heart (Random Color)",
        "Make Necklace Pendant: Pillar (Random Color)",
        "Make Necklace Pendant: Triforce",

        "Make Cropped Sweater: Army (Random Pattern)",
        "Make Cropped Sweater: Solid (Random Pattern)",
        "Make Cropped Sweater: Bomber (Random Pattern)",
        "Make Cropped Sweater: Ink Print (Random Pattern)",
        "Make Cropped Sweater: Blur Print (Random Pattern)",
        "Make Cropped Sweater: Oriental Print (Random Pattern)",
        "Make Cropped Sweater: Zebra Print (Random Pattern)",
        "Make Cropped Sweater: Leopard Print (Random Pattern)",
        "Make Cropped Sweater: Geometric Print (Random Pattern)",

        "Make Cropped Sweater: White Tartan (Random Pattern)",
        "Make Cropped Sweater: Black Tartan (Random Pattern)",
        "Make Cropped Sweater: Red Tartan (Random Pattern)",
        "Make Cropped Sweater: Green Tartan (Random Pattern)",
        "Make Cropped Sweater: Blue Tartan (Random Pattern)",
        "Make Cropped Sweater: Orange Tartan (Random Pattern)",
        "Make Cropped Sweater: Purple Tartan (Random Pattern)",
        "Make Cropped Sweater: Pink Tartan (Random Pattern)",
        "Make Cropped Sweater: Tartan (Random Pattern)",
        "Make Cropped Sweater: Tartan with Leather (Random Pattern)",

        "Make Sleeveless Cropped Sweater: Army (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Solid (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Bomber (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Ink Print (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Blur Print (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Oriental Print (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Zebra Print (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Leopard Print (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Geometric Print (Random Pattern)",

        "Make Sleeveless Cropped Sweater: White Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Black Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Red Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Green Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Blue Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Orange Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Purple Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Pink Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Tartan (Random Pattern)",
        "Make Sleeveless Cropped Sweater: Tartan with Leather (Random Pattern)",

        "Make Jacket: Army (Random Pattern)",
        "Make Jacket: Solid (Random Pattern)",
        "Make Jacket: Bomber (Random Pattern)",
        "Make Jacket: Ink Print (Random Pattern)",
        "Make Jacket: Blur Print (Random Pattern)",
        "Make Jacket: Oriental Print (Random Pattern)",
        "Make Jacket: Zebra Print (Random Pattern)",
        "Make Jacket: Leopard Print (Random Pattern)",
        "Make Jacket: Geometric Print (Random Pattern)",

        "Make Jacket: White Tartan (Random Pattern)",
        "Make Jacket: Black Tartan (Random Pattern)",
        "Make Jacket: Red Tartan (Random Pattern)",
        "Make Jacket: Green Tartan (Random Pattern)",
        "Make Jacket: Blue Tartan (Random Pattern)",
        "Make Jacket: Orange Tartan (Random Pattern)",
        "Make Jacket: Purple Tartan (Random Pattern)",
        "Make Jacket: Pink Tartan (Random Pattern)",

        "Cropped Jacket: Army (Random Pattern)",
        "Cropped Jacket: Solid (Random Pattern)",
        "Cropped Jacket: Bomber (Random Pattern)",
        "Cropped Jacket: Ink Print (Random Pattern)",
        "Cropped Jacket: Blur Print (Random Pattern)",
        "Cropped Jacket: Oriental Print (Random Pattern)",
        "Cropped Jacket: Zebra Print (Random Pattern)",
        "Cropped Jacket: Leopard Print (Random Pattern)",
        "Cropped Jacket: Geometric Print (Random Pattern)",

        "Cropped Jacket: White Tartan (Random Pattern)",
        "Cropped Jacket: Black Tartan (Random Pattern)",
        "Cropped Jacket: Red Tartan (Random Pattern)",
        "Cropped Jacket: Green Tartan (Random Pattern)",
        "Cropped Jacket: Blue Tartan (Random Pattern)",
        "Cropped Jacket: Orange Tartan (Random Pattern)",
        "Cropped Jacket: Purple Tartan (Random Pattern)",
        "Cropped Jacket: Pink Tartan (Random Pattern)",

        "Make Pants: Army (Random Pattern)",
        "Make Pants: Silk (Random Pattern)",
        "Make Pants: Basic (Random Pattern)",

        "Make Long Dress: Army (Random Pattern)",
        "Make Long Dress: Tartan (Random Pattern)",
        "Make Long Dress: Denim (Random Pattern)",
        "Make Long Dress: Silk (Random Pattern)",
        "Make Long Dress: Stamp (Random Pattern)",

        "Make Sleeveless Long Dress: Army (Random Pattern)",
        "Make Sleeveless Long Dress: Tartan (Random Pattern)",
        "Make Sleeveless Long Dress: Denim (Random Pattern)",
        "Make Sleeveless Long Dress: Silk (Random Pattern)",
        "Make Sleeveless Long Dress: Stamp (Random Pattern)",

        "Make Sleeveless Short Dress: Army (Random Pattern)",
        "Make Sleeveless Short Dress: Tartan (Random Pattern)",
        "Make Sleeveless Short Dress: Denim (Random Pattern)",
        "Make Sleeveless Short Dress: Silk (Random Pattern)",
        "Make Sleeveless Short Dress: Stamp (Random Pattern)",

        "Make Short Dress: Army (Random Pattern)",
        "Make Short Dress: Tartan (Random Pattern)",
        "Make Short Dress: Denim (Random Pattern)",
        "Make Short Dress: Silk (Random Pattern)",
        "Make Short Dress: Stamp (Random Pattern)",

        "Make Shorts: Basic (Random Color)",
        "Make Shorts: Tartan (Random Color)",
        "Make Shorts: Denim (Random Color)",
        "Make Shorts: Silk (Random Color)",
        "Make Shorts: Camo (Random Pattern)",

        "Make Large Shorts: Basic (Random Color)",
        "Make Large Shorts: Tartan (Random Color)",
        "Make Large Shorts: Denim (Random Color)",
        "Make Large Shorts: Silk (Random Color)",
        "Make Large Shorts: Camo (Random Pattern)",

        "Make Short Shorts: Basic (Random Color)",
        "Make Short Shorts: Tartan (Random Color)",
        "Make Short Shorts: Denim (Random Color)",
        "Make Short Shorts: Silk (Random Color)",
        "Make Short Shorts: Camo (Random Pattern)",

        "Make Boxing Shorts: Basic (Random Color)",
        "Make Boxing Shorts: Sport (Random Pattern)",
        "Make Boxing Shorts: Camo (Random Pattern)",

	},
})

addTrait("proftinkerer", {
    name = "At Least They'll Find Ya Handy",
    description = "Fix generators faster, knowledge of solar panels and electronics, able to make workbenches for most other professions, able to make & recharge batteries",
    recipes = {"Craft a Tailoring Table Kit", "Brewing Station Kit", "Paint Mixing Kit", "Craft a Hand Press Kit", "Craft a Sculpting Table Kit", "Craft a Anaerobic Digester Kit"},    
    profession = true,

})

addTrait("profcook2", {
    name = "What Doesn't Kill You",
    description = "Starts knowing the level 10 recipe to convert poisonous mushrooms and berries into edible ones. ",
    profession = true,
})

addTrait("profhealer2", {
    name = "Critical Stabilization",
    description = "Able to treat wounds resulting from a critical injury roll.",
    profession = true,
})

addTrait("proffarmer2", {
    name = "No Crop Wasted",
    description = "At level 10, able to convert non-rotten crops into Waste packs for the anaerobic digester (propane & fuel)",
    profession = true,
})

addTrait("proftinkerer2", {
    name = "Explosive Knowledge",
    description = "Know how to make fire bombs, aerosol bombs and pipe bombs.",
    profession = true,
})

addTrait("profforager2", {
    name = "Waste Not, Want Not",
    description = " can identify bugs before consuming them which removes the Unhappiness malus.\nAble to make some bug-based recipes. ",
    profession = true,
})

addTrait("profmechanic2", {
    name = "Reconditioner",
    description = "May combine 2 lower quality parts to make one higher quality part.",
    profession = true,
})

addTrait("profsurvivalist2", {
    name = "Bone Builder",
    description = "Can make tools and equipment out of bone.",
    profession = true,
})

addTrait("profsurvivalist3", {
    name = "Flayer's Art",
    description = "Able to skin animal bodies for hides, which can be tanned for high quality leather used by tailors.",
    profession = true,
})

addTrait("CitizenOfTheWorld", {
    name = "Citizen of the World",
    description = "Polyglot.",
    cost = 1,
    xp = {
        [Perks.ExLang] = 2,
    },
})

addTrait("IndependentWestFarming", {
    name = "Independent West - Farming",
    description = "Adds +1 to Farming.",
    cost = 1,
    xp = {
        [Perks.Farming] = 1,
    },
})

addTrait("IndependentWestTailoring", {
    name = "Independent West - Tailoring",
    description = "Adds +1 to Tailoring.",
    cost = 1,
    xp = {
        [Perks.Tailoring] = 1,
    },
})

addTrait("MerchantIslandCooking", {
    name = "Merchant Island - Cooking",
    description = "Adds +1 to Cooking.",
    cost = 1,
    xp = {
        [Perks.Cooking] = 1,
    },
})

addTrait("MerchantIslandFirstAid", {
    name = "Merchant Island - First Aid",
    description = "Adds +1 to First Aid.",
    cost = 1,
    xp = {
        [Perks.Doctor] = 1,
    },
})

addTrait("MerchantIslandFishing", {
    name = "Merchant Island - Fishing & Trapping",
    description = "Adds +1 to Fishing and Trapping.",
    cost = 1,
    xp = {
        [Perks.Fishing] = 1,
        [Perks.Trapping] = 1,
    },
})

addTrait("MerchantIslandMusic", {
    name = "Merchant Island - Music",
    description = "Adds +1 to Music.",
    cost = 1,
    xp = {
        [Perks.Music] = 1,
    },
})

addTrait("PanAtlanticUnionCarpentry", {
    name = "Pan-Atlantic Union - Carpentry",
    description = "Adds +1 to Carpentry.",
    cost = 1,
    xp = {
        [Perks.Woodwork] = 1,
    },
})

addTrait("PanAtlanticUnionElectrical", {
    name = "Pan-Atlantic Union - Tinkerer",
    description = "Adds +1 to Tinkering.",
    cost = 1,
    xp = {
        [Perks.Electricity] = 1,
    },
})

addTrait("SplintersFishing", {
    name = "Splinters - Fishing & Trapping",
    description = "Adds +1 to Fishing and Trapping.",
    cost = 1,
    xp = {
        [Perks.Fishing] = 1,
        [Perks.Trapping] = 1,
    },
})

addTrait("SplintersForaging", {
    name = "Splinters - Foraging",
    description = "Adds +1 to Foraging.",
    cost = 1,
    xp = {
        [Perks.PlantScavenging] = 1,
    },
})

addTrait("SteelSyndicateMechanics", {
    name = "Steel Syndicate - Mechanics",
    description = "Adds +1 to Mechanics.",
    cost = 1,
    xp = {
        [Perks.Mechanics] = 1,
    },
})

addTrait("SteelSyndicateMetalworking", {
    name = "Steel Syndicate - Metalworking",
    description = "Adds +1 to Metalworking.",
    cost = 1,
    xp = {
        [Perks.MetalWelding] = 1,
    },
})

addTrait("NightVision", {
    name = "Cat's Eyes",
    description = "Better vision at night. +1 to Notice Rolls",
    cost = 2,
})

addTrait("FastReader", {
    name = "Fast Reader",
    description = "Takes less time to read books.",
    cost = 2,
})

addTrait("Graceful", {
    name = "Graceful",
    description = "Makes less noise when moving. +1 to Stealth Rolls",
    cost = 2,
})

addTrait("HobbyAxe", {
    name = "Hobby Axe",
    description = "Adds +1 to Axe. +1 to Axe Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.Axe] = 1,
    },
})

addTrait("HobbySneaking", {
    name = "Hobby Sneaking",
    description = "Adds +1 to Sneaking. +1 to Defense Ranged Rolls.",
    cost = 2,
    xp = {
        [Perks.Sneak] = 1,
    },
})

addTrait("HobbySprinting", {
    name = "Hobby Sprinting",
    description = "Adds +1 to Sprinting. +1 to Defense Close Rolls.",
    cost = 2,
    xp = {
        [Perks.Sprinting] = 1,
    },
})

addTrait("HobbyLightfoot", {
    name = "Hobby Lightfoot",
    description = "Adds +1 to Lightfooted. +1 to Defense Ranged Rolls.",
    cost = 2,
    xp = {
        [Perks.Lightfoot] = 1,
    },
})

addTrait("HobbyNimble", {
    name = "Hobby Nimble",
    description = "Adds +1 to Nimble. +1 to Defense Close Rolls.",
    cost = 2,
    xp = {
        [Perks.Nimble] = 1,
    },
})


addTrait("HobbyCarpentry", {
    name = "Hobby Carpentry",
    description = "Adds +1 to Carpentry.",
    cost = 2,
    xp = {
        [Perks.Woodwork] = 1,
    },
})

addTrait("HobbyCooking", {
    name = "Hobby Cooking",
    description = "Adds +1 to Cooking.",
    cost = 2,
    xp = {
        [Perks.Cooking] = 1,
    },
})

addTrait("HobbyFarming", {
    name = "Hobby Farming",
    description = "Adds +1 to Farming and +1 to Cultivation.",
    cost = 2,
    xp = {
        [Perks.Farming] = 1,
    },
})

addTrait("HobbyFirearms", {
    name = "Hobby Firearms",
    description = "Adds +1 to Aiming and +1 to Reloading. +1 to Ranged Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.Aiming] = 1,
        [Perks.Reloading] = 1,
    },
})

addTrait("HobbyFirstAid", {
    name = "Hobby First Aid",
    description = "Adds +1 to First Aid.",
    cost = 2,
    xp = {
        [Perks.Doctor] = 1,
    },
})

addTrait("HobbyFishing", {
    name = "Hobby Fishing & Trapping",
    description = "Adds +1 to Fishing and Trapping.",
    cost = 2,
    xp = {
        [Perks.Fishing] = 1,
        [Perks.Trapping] = 1,
    },
})

addTrait("HobbyForaging", {
    name = "Hobby Foraging",
    description = "Adds +1 to Foraging.",
    cost = 2,
    xp = {
        [Perks.PlantScavenging] = 1,
    },
})

addTrait("HobbyLongBlade", {
    name = "Hobby Long Blade",
    description = "Adds +1 to Long Blade. +1 to Long Blade Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.LongBlade] = 1,
    },
})

addTrait("HobbyLongBlunt", {
    name = "Hobby Long Blunt",
    description = "Adds +1 to Long Blunt. +1 to Long Blunt Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.Blunt] = 1,
    },
})

addTrait("HobbyMaintenance", {
    name = "Hobby Maintenance",
    description = "Adds +1 to Maintenance.",
    cost = 2,
    xp = {
        [Perks.Maintenance] = 1,
    },
})

addTrait("HobbyMechanics", {
    name = "Hobby Mechanics",
    description = "Adds +1 to Mechanics.",
    cost = 2,
    xp = {
        [Perks.Mechanics] = 1,
    },
})

addTrait("HobbyMetalworking", {
    name = "Hobby Metalworking",
    description = "Adds +1 to Metalworking.",
    cost = 2,
    xp = {
        [Perks.MetalWelding] = 1,
    },
})

addTrait("HobbyMusic", {
    name = "Hobby Music",
    description = "Adds +1 to Music.",
    cost = 2,
    xp = {
        [Perks.Music] = 1,
    },
})

addTrait("HobbyShortBlade", {
    name = "Hobby Short Blade",
    description = "Adds +1 to Short Blade. +1 to Short Blade Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.SmallBlade] = 1,
    },
})

addTrait("HobbyShortBlunt", {
    name = "Hobby Short Blunt",
    description = "Adds +1 to Short Blunt. +1 to Short Blunt Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.SmallBlunt] = 1,
    },
})

addTrait("HobbySpear", {
    name = "Hobby Spear",
    description = "Adds +1 to Spear. +1 to Spear Attack Rolls.",
    cost = 2,
    xp = {
        [Perks.Spear] = 1,
    },
})

addTrait("HobbyTailoring", {
    name = "Hobby Tailoring",
    description = "Adds +1 to Tailoring.",
    cost = 2,
    xp = {
        [Perks.Tailoring] = 1,
    },
})

addTrait("HobbyTinkering", {
    name = "Hobby Tinkering",
    description = "Adds +1 to Electrical.",
    cost = 2,
    xp = {
        [Perks.Electricity] = 1,
    },
})

addTrait("IronGut", {
    name = "Iron Gut",
    description = "Less chance to have food illness. +1 to Physical Endurance Rolls",
    cost = 2,
})

addTrait("LightEater", {
    name = "Light Eater",
    description = "Needs to eat less regularly.",
    cost = 2,
})

addTrait("LowThirst", {
    name = "Low Thirst",
    description = "Needs less water to survive.",
    cost = 2,
})

addTrait("Nutritionist", {
    name = "Nutritionist",
    description = "Can see the nutritional values of any food.",
    cost = 2,
})

addTrait("Offroader", {
    name = "Offroader",
    description = "Vehicles handle much better off road.",
    cost = 2,
})

addTrait("Polyglot", {
    name = "Polyglot",
    description = "Gains two extra languages.",
    cost = 2,

})

addTrait("Resilient", {
    name = "Resilient",
    description = "Less prone to disease.\nSlower rate of zombification. +1 to Physical Endurance Rolls",
    cost = 2,
})

addTrait("Spiritual", {
    name = "Spiritual",
    description = "Can write prayers that can slightly reduce stress, boredom and unhappiness.",
    cost = 1,
    recipes = {"Write A Prayer"},
})

addTrait("Brawler", {
    name = "Brawler (Dice Effects Only)",
    description = "Adds +2 to hit with Unarmed Attacks.",
    cost = 3,
})

addTrait("BrutalStriker", {
    name = "Brutal Striker (Dice Effects Only)",
    description = "Adds +1 to Unarmed Damage.",
    cost = 3,
})

addTrait("BulletDodger", {
    name = "Bullet Dodger (Dice Effects Only)",
    description = "Adds +2 to Defend Ranged.",
    cost = 2,
})

addTrait("Dextrous", {
    name = "Dextrous",
    description = "Transfers inventory items quickly. \nGain +1 to Initiative",
    cost = 4,
})

addTrait("EagleEyed", {
    name = "Eagle Eyed",
    description = "Faster visibility fade.\nHigher visibility arc. +2 to Notice Rolls",
    cost = 4,
})

addTrait("FastHealer", {
    name = "Fast Healer",
    description = "Recovers quickly from injuries and illness. +2 to Physical Endurance Rolls",
    cost = 4,
})

addTrait("Fighter", {
    name = "Fighter (Dice Effects Only)",
    description = "Adds +2 to hit with Melee Attacks.",
    cost = 3,
})

addTrait("Fit", {
    name = "Fit",
    description = "Fit.",
    cost = 4,
    xp = {
        [Perks.Fitness] = 2,
    },
})

addTrait("Inconspicuous", {
    name = "Inconspicuous",
    description = "Less likely to be spotted by zombies. +2 to Stealth Rolls",
    cost = 4,
})

addTrait("KeenHearing", {
    name = "Keen Hearing",
    description = "Larger perception radius. +2 to Notice Rolls",
    cost = 4,
})

addTrait("Lucky", {
    name = "Lucky",
    description = "Sometimes, things just go your way. Rolling a 19 is a critical hit!",
    cost = 4,
})

addTrait("Marksman", {
    name = "Marksman (Dice Effects Only)",
    description = "Adds +2 to hit with Ranged Attacks.",
    cost = 3,
})

addTrait("Lobber", {
    name = "Lobber (Dice Effects Only)",
    description = "Adds +2 to hit with Throwables.",
    cost = 3,
})

addTrait("Organized", {
    name = "Organized",
    description = "Increased container inventory capacity. \nGain +1 to Mental Endurance Rolls",
    cost = 4,
})

addTrait("PowerStriker", {
    name = "Power Striker (Dice Effects Only)",
    description = "Adds +1 Damage with Axe, Long Blunt, and Spear.",
    cost = 3,
})

addTrait("PrecisionStriker", {
    name = "Precision Striker (Dice Effects Only)",
    description = "Adds +1 Damage with Long Blade, Short Blade, and Short Blunt.",
    cost = 3,
})

addTrait("QuickReflexes", {
    name = "Quick Reflexes (Dice Effects Only)",
    description = "Adds +2 to Defend Close.",
    cost = 2,
})

addTrait("ReadyForAction", {
    name = "Ready for Action (Dice Effects Only)",
    description = "Adds +2 to Initiative Rolls.",
    cost = 2,
})

addTrait("Resolute", {
    name = "Resolute (Dice Effects Only)",
    description = "Increases Physical and Mental Endurance by 1.",
    cost = 2,
})

addTrait("SharpShooter", {
    name = "Sharp Shooter (Dice Effects Only)",
    description = "Adds +1 Damage with Guns.",
    cost = 3,
})

addTrait("SkilledSneaking", {
    name = "Skilled Sneaking",
    description = "Adds +2 to Sneaking. +2 to Defense Ranged Rolls.",
    cost = 4,
    xp = {
        [Perks.Sneak] = 2,
    },
})

addTrait("SkilledSprinting", {
    name = "Skilled Sprinting",
    description = "Adds +2 to Sprinting. +2 to Defense Close Rolls.",
    cost = 4,
    xp = {
        [Perks.Sprinting] = 2,
    },
})

addTrait("SkilledLightfoot", {
    name = "Skilled Lightfoot",
    description = "Adds +2 to Lightfooted. +2 to Defense Ranged Rolls.",
    cost = 4,
    xp = {
        [Perks.Lightfoot] = 2,
    },
})

addTrait("SkilledNimble", {
    name = "Skilled Nimble",
    description = "Adds +2 to Nimble. +2 to Defense Close Rolls.",
    cost = 4,
    xp = {
        [Perks.Nimble] = 2,
    },
})


addTrait("SkilledAxe", {
    name = "Skilled Axe",
    description = "Adds +2 to Axe. +2 to Axe Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.Axe] = 2,
    },
})

addTrait("SkilledCarpentry", {
    name = "Skilled Carpentry",
    description = "Adds +2 to Carpentry.",
    cost = 4,
    xp = {
        [Perks.Woodwork] = 2,
    },
})

addTrait("SkilledCooking", {
    name = "Skilled Cooking",
    description = "Adds +2 to Cooking.",
    cost = 4,
    xp = {
        [Perks.Cooking] = 2,
    },
})

addTrait("SkilledFarming", {
    name = "Skilled Farming",
    description = "Adds +2 to Farming",
    cost = 4,
    xp = {
        [Perks.Farming] = 2,
    },
})

addTrait("SkilledFirearms", {
    name = "Skilled Firearms",
    description = "Adds +2 to Aiming and Reloading. +2 to Ranged Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.Aiming] = 2,
        [Perks.Reloading] = 2,
    },
})

addTrait("SkilledFirstAid", {
    name = "Skilled First Aid",
    description = "Adds +2 to First Aid.",
    cost = 4,
    xp = {
        [Perks.Doctor] = 2,
    },
})

addTrait("SkilledFishing", {
    name = "Skilled Fishing & Trapping",
    description = "Adds +2 to Fishing and Trapping.",
    cost = 4,
    xp = {
        [Perks.Fishing] = 2,
        [Perks.Trapping] = 2,
    },
})

addTrait("SkilledForaging", {
    name = "Skilled Foraging",
    description = "Adds +2 to Foraging.",
    cost = 4,
    xp = {
        [Perks.PlantScavenging] = 2,
    },
})

addTrait("SkilledLongBlade", {
    name = "Skilled Long Blade",
    description = "Adds +2 to Long Blade. +2 to Long Blade Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.LongBlade] = 2,
    },
})

addTrait("SkilledLongBlunt", {
    name = "Skilled Long Blunt",
    description = "Adds +2 to Long Blunt. +2 to Long Blunt Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.Blunt] = 2,
    },
})

addTrait("SkilledMaintenance", {
    name = "Skilled Maintenance",
    description = "Adds +2 to Maintenance.",
    cost = 4,
    xp = {
        [Perks.Maintenance] = 2,
    },
})

addTrait("SkilledMechanics", {
    name = "Skilled Mechanics",
    description = "Adds +2 to Mechanics.",
    cost = 4,
    xp = {
        [Perks.Mechanics] = 2,
    },
})

addTrait("SkilledMetalworking", {
    name = "Skilled Metalworking",
    description = "Adds +2 to Metalworking.",
    cost = 4,
    xp = {
        [Perks.MetalWelding] = 2,
    },
})

addTrait("SkilledMusic", {
    name = "Skilled Music",
    description = "Adds +2 to Music.",
    cost = 4,
    xp = {
        [Perks.Music] = 2,
    },
})

addTrait("SkilledShortBlade", {
    name = "Skilled Short Blade",
    description = "Adds +2 to Short Blade. +2 to Short Blade Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.SmallBlade] = 2,
    },
})

addTrait("SkilledShortBlunt", {
    name = "Skilled Short Blunt",
    description = "Adds +2 to Short Blunt. +2 to Short Blunt Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.SmallBlunt] = 2,
    },
})

addTrait("SkilledSpear", {
    name = "Skilled Spear",
    description = "Adds +2 to Spear. +2 to Spear Attack Rolls.",
    cost = 4,
    xp = {
        [Perks.Spear] = 2,
    },
})

addTrait("SkilledTailoring", {
    name = "Skilled Tailoring",
    description = "Adds +2 to Tailoring.",
    cost = 4,
    xp = {
        [Perks.Tailoring] = 2,
    },
})

addTrait("SkilledTinkering", {
    name = "Skilled Tinkering",
    description = "Adds +2 to Electrical.",
    cost = 4,
    xp = {
        [Perks.Electricity] = 2,
    },
})

addTrait("SpeedDemon", {
    name = "Speed Demon",
    description = "Drives very fast.",
    cost = 2,
})

addTrait("Spliffsavant", {
    name = "Spliff Savant",
    description = "Experienced in weedcraft.",
    cost = 2,
    xp = {
        [Perks.Cultivation] = 2,
    },
})

addTrait("Stalwart", {
    name = "Stalwart (Dice Effects Only)",
    description = "Increases Physical Endurance by 2.",
    cost = 2,
})

addTrait("Spry", {
    name = "Spry (Dice Effects Only)",
    description = "Increases Physical Endurance by 1.",
    cost = 1,
})

addTrait("Stout", {
    name = "Stout",
    description = "Extra knockback from melee weapons.\nIncreased carrying weight.",
    cost = 4,
    xp = {
        [Perks.Strength] = 2,
    },
})

addTrait("Sturdy", {
    name = "Sturdy (Dice Effects Only)",
    description = "Adds +2 to Hitpoints.",
    cost = 2,
})

addTrait("Tranquil", {
    name = "Tranquil (Dice Effects Only)",
    description = "Increases Mental Endurance by 2.",
    cost = 2,
})

addTrait("Clearheaded", {
    name = "Clearheaded (Dice Effects Only)",
    description = "Increases Mental Endurance by 1.",
    cost = 1,
})

addTrait("Athletic", {
    name = "Athletic",
    description = "Faster running speed.\nCan run for longer without tiring.",
    cost = 6,
    xp = {
        [Perks.Fitness] = 4,
    },
})

addTrait("Burglar", {
    name = "Burglar",
    description = "Can hotwire vehicles, less chance of breaking the lock of a window.\nCan lockpick into building doors and windows with a lockpick or paperclip.\nGain +2 to Stealth Rolls.",
    cost = 6,
})

addTrait("Drugsmith", {
    name = "Drugsmith",
    description = "Able to make recreational drugs.",
    cost = 6,
    recipes = {"Make Ephedrine Compound","Produce Meth Compound","Dry the Meth Compound","Make Acid Base","Make Acid Compound","Dry the Acid Compound","Make Benzodiazepine Compound","Produce Xanax Compound","Dry Xanax Compound","Make Raw Cocaine Compound","Refine Cocaine Compound","Dry Refined Cocaine","Extract Psilocybin","Mix Psilocybin Compound","Grow and Pack Shrooms","Extract Morphine Compound","Produce Refined Heroin","Dry Refined Heroin","Make Fentanyl Compound","Dry and Pack Fentanyl","Make Amphetamine Salts","Extract Crack Compound","Dry and Pack the Crack","Extract Phenylethylamine"},

})

addTrait("FastLearner", {
    name = "Fast Learner",
    description = "Increased XP gains.\n Adds +3 to Mental Endurance Rolls.",
    cost = 6,
})

addTrait("FastLearnerFree", {
    name = "I Learned From Watching You",
    description = "Learns skills through roleplay in half the time required.",
    profession = true,
})

addTrait("Handy2", {
    name = "Handy",
    description = "Faster and stronger constructions.",
    swap = "Handy",
})

addTrait("Outdoorsman", {
    name = "Outdoorsman",
    description = "Not affected by harsh weather conditions. +3 to Physical Endurance Rolls",
    cost = 6,
})

addTrait("Persona", {
    name = "Persona (Dice Effects Only)",
    description = "You have a convincing alter ego. *See Disguise rules",
    cost = 4,
})

addTrait("Strong", {
    name = "Strong",
    description = "Extra knockback from melee weapons.\nIncreased carrying weight.",
    cost = 6,
    xp = {
        [Perks.Strength] = 4,
    },
})


-- Weight Related Skills

addTrait("Very Underweight", {
    name = "UI_trait_veryunderweight",
    description = "UI_trait_veryunderweightdesc",
    profession = true,
})

addTrait("Underweight", {
    name = "UI_trait_underweight",
    description = "UI_trait_underweightdesc",
    profession = true,
})

addTrait("Overweight", {
    name = "UI_trait_overweight",
    description = "UI_trait_overweightdesc",
    profession = true,
})

addTrait("Obese", {
    name = "UI_trait_obese",
    description = "UI_trait_obesedesc",
    profession = true,
})

addTrait("Emaciated", {
    name = "UI_trait_emaciated",
    description = "UI_trait_emaciateddesc",
    profession = true,
})