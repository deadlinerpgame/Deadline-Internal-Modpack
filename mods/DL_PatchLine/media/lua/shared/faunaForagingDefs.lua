require 'Foraging/forageSystem';

FaunaAnimals = {};

Events.onAddForageDefs.Add(function()

    print("[PatchLine] onAddForageDefs fauna patch.");

    FaunaAnimals.Armadillo = {
		type = "Fauna.Armadillo",
		minCount = 1,
		maxCount = 1,
		skill = 7,
		xp = 20,
		categories = { "DeadAnimals" },
		zones = {
			Forest          = 2,
			Vegitation      = 1,
			FarmLand        = 1,
			Farm            = 1,
			TrailerPark     = 1,
			TownZone        = 1,
			Nav             = 2,
		},
		bonusMonths = { 6, 7, 8 },
		malusMonths = { 11, 12 },
    }

    FaunaAnimals.Racoon_sitted = {
            type = "Fauna.Racoon_sitted",
            minCount = 1,
            maxCount = 1,
            skill = 6,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 2,
                Vegitation      = 2,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 2,
                TownZone        = 3,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.Racoon = {
            type = "Fauna.Racoon",
            minCount = 1,
            maxCount = 1,
            skill = 6,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 2,
                Vegitation      = 2,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 2,
                TownZone        = 3,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.Pig = {
            type = "Fauna.Pig",
            minCount = 1,
            maxCount = 1,
            skill = 9,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 0,
                Vegitation      = 1,
                FarmLand        = 3,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.Pig_sleeping = {
            type = "Fauna.Pig_sleeping",
            minCount = 1,
            maxCount = 1,
            skill = 9,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 3,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }


    FaunaAnimals.Black_cat = {
            type = "Fauna.Black_cat",
            minCount = 1,
            maxCount = 1,
            skill = 5,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 3,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 4,
                Nav             = 1,
            },

    }

    FaunaAnimals.BlackWhite_cat = {
            type = "Fauna.BlackWhite_cat",
            minCount = 1,
            maxCount = 1,
            skill = 5,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 3,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 4,
                Nav             = 1,
            },

    }


    FaunaAnimals.European_cat = {
            type = "Fauna.European_cat",
            minCount = 1,
            maxCount = 1,
            skill = 5,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 3,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 4,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Tabby_cat = {
            type = "Fauna.F_Tabby_cat",
            minCount = 1,
            maxCount = 1,
            skill = 5,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 3,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 4,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Hen = {
            type = "Fauna.F_Hen",
            minCount = 1,
            maxCount = 1,
            skill = 5,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 3,
                FarmLand        = 5,
                Farm            = 5,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.F_Hen_white = {
            type = "Fauna.F_Hen_white",
            minCount = 1,
            maxCount = 1,
            skill = 5,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 3,
                FarmLand        = 5,
                Farm            = 5,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.F_Chick_01 = {
        type = "Fauna.F_Chick_01",
        minCount = 1,
        maxCount = 1,
        skill = 5,
        xp = 20,
        categories = { "DeadAnimals" },
        zones = {
            Forest          = 1,
            Vegitation      = 1,
            FarmLand        = 1,
            Farm            = 1,
            TrailerPark     = 1,
            TownZone        = 1,
            Nav             = 1,
        },
        bonusMonths = { 6, 7, 8 },
        malusMonths = { 11, 12 },
    }

    FaunaAnimals.F_Chick_02 = {
        type = "Fauna.F_Chick_02",
        minCount = 1,
        maxCount = 1,
        skill = 5,
        xp = 20,
        categories = { "DeadAnimals" },
        zones = {
            Forest          = 1,
            Vegitation      = 1,
            FarmLand        = 1,
            Farm            = 1,
            TrailerPark     = 1,
            TownZone        = 1,
            Nav             = 1,
        },
        bonusMonths = { 6, 7, 8 },
        malusMonths = { 11, 12 },
    }

    FaunaAnimals.F_Chick_03 = {
        type = "Fauna.F_Chick_03",
        minCount = 1,
        maxCount = 1,
        skill = 5,
        xp = 20,
        categories = { "DeadAnimals" },
        zones = {
            Forest          = 1,
            Vegitation      = 1,
            FarmLand        = 1,
            Farm            = 1,
            TrailerPark     = 1,
            TownZone        = 1,
            Nav             = 1,
        },
        bonusMonths = { 6, 7, 8 },
        malusMonths = { 11, 12 },
    }

    FaunaAnimals.F_Rooster = {
            type = "Fauna.F_Rooster",
            minCount = 1,
            maxCount = 1,
            skill = 6,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 4,
                Farm            = 4,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.F_Cow_f_bw = {
            type = "Fauna.F_Cow_f_bw",
            minCount = 1,
            maxCount = 1,
            skill = 8,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 2,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },

    }

    FaunaAnimals.F_Cow_f_bb = {
            type = "Fauna.F_Cow_f_bb",
            minCount = 1,
            maxCount = 1,
            skill = 8,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 2,
                FarmLand        = 2,
                Farm            = 3,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },

    }

    FaunaAnimals.F_Bull = {
            type = "Fauna.F_Bull",
            minCount = 1,
            maxCount = 1,
            skill = 8,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 2,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },

    }

    FaunaAnimals.F_Sheep = {
            type = "Fauna.F_Sheep",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 3,
                FarmLand        = 3,
                Farm            = 4,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Sheep_01 = {
            type = "Fauna.F_Sheep_01",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 3,
                FarmLand        = 3,
                Farm            = 4,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Mutton = {
            type = "Fauna.F_Mutton",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 3,
                FarmLand        = 3,
                Farm            = 4,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Horse = {
            type = "Fauna.F_Horse",
            minCount = 1,
            maxCount = 1,
            skill = 8,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Horse_01 = {
            type = "Fauna.F_Horse_01",
            minCount = 1,
            maxCount = 1,
            skill = 8,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Foal = {
            type = "Fauna.F_Foal",
            minCount = 1,
            maxCount = 1,
            skill = 8,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },
            bonusMonths = { 6, 7, 8 },
            malusMonths = { 11, 12 },
    }

    FaunaAnimals.German_shepard = {
            type = "Fauna.German_shepard",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 2,
                Farm            = 2,
                TrailerPark     = 3,
                TownZone        = 3,
                Nav             = 1,
            },

    }


    FaunaAnimals.F_Australian_puppy = {
            type = "F_Australian_puppy",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 2,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Australian_puppy_sitting = {
            type = "F_Australian_puppy_sitting",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 2,
                TrailerPark     = 1,
                TownZone        = 1,
                Nav             = 1,
            },

    }

    FaunaAnimals.Belgian_shepard_01 = {
            type = "Fauna.Belgian_shepard_01",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 2,
                Farm            = 2,
                TrailerPark     = 3,
                TownZone        = 3,
                Nav             = 1,
            },

    }

    FaunaAnimals.Belgian_shepard_02 = {
            type = "Fauna.Belgian_shepard_02",
            minCount = 1,
            maxCount = 1,
            skill = 7,
            xp = 20,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 2,
                Farm            = 2,
                TrailerPark     = 3,
                TownZone        = 3,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_rat_01 = {
            type = "Fauna.F_rat_01",
            minCount = 1,
            maxCount = 1,
            skill = 0,
            xp = 2,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 7,
                TownZone        = 7,
                Nav             = 1,
            },
    }

    FaunaAnimals.F_rat_02 = {
            type = "Fauna.F_rat_02",
            minCount = 1,
            maxCount = 1,
            skill = 0,
            xp = 2,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 7,
                TownZone        = 7,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_opossum_01 = {
            type = "Fauna.F_opossum_01",
            minCount = 1,
            maxCount = 1,
            skill = 0,
            xp = 2,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 7,
                TownZone        = 7,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_opossum_02 = {
            type = "Fauna.F_opossum_02",
            minCount = 1,
            maxCount = 1,
            skill = 0,
            xp = 2,
            categories = { "DeadAnimals" },
            zones = {
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 7,
                TownZone        = 7,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Bunny_01 = {
            type = "Fauna.F_Bunny_01",
            minCount = 1,
            maxCount = 1,
            skill = 6,
            xp = 2,
            categories = { "DeadAnimals" },
            zones = {
                DeepForest      = 2,
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Bunny_02 = {
            type = "Fauna.F_Bunny_02",
            minCount = 1,
            maxCount = 1,
            skill = 6,
            xp = 2,
            categories = { "DeadAnimals" },
            zones = {
                DeepForest      = 2,
                Forest          = 1,
                Vegitation      = 1,
                FarmLand        = 1,
                Farm            = 1,
                TrailerPark     = 1,
                TownZone        = 0,
                Nav             = 1,
            },

    }

    FaunaAnimals.F_Skunk = {
        type = "Fauna.F_Skunk",
        minCount = 1,
        maxCount = 1,
        skill = 6,
        xp = 2,
        categories = { "DeadAnimals" },
        zones = {
            DeepForest      = 2,
            Forest          = 1,
            Vegitation      = 1,
            FarmLand        = 1,
            Farm            = 1,
            TrailerPark     = 1,
            TownZone        = 0,
            Nav             = 1,
        },

    }

    for i, v in ipairs(FaunaAnimals) do
        local item = FaunaAnimals[i];
        if item then
            forageSystem.addItemDef(item);
            print("[PatchLine] Added animal " .. tostring(item.type) .. " to foraging definitions.");
        end
    end
end)
