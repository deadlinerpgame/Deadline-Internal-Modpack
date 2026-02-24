require "motw/Core"

MOTW_Core = MOTW_Core or {};

local function DL_MOTW_OnGameBoot()
    -- ELVIS CAMPBELL - MASTER OF PUPPETS
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_MasterOfPuppets", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_MasterOfPuppets", -- The name of the sound file as registerd in scripts/
        duration = 56, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - IRON MAN
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_IronMan", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_IronMan", -- The name of the sound file as registerd in scripts/
        duration = 35, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 2, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - WAR PIGS & PARANOID MIX
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_WarPigsParanoidMix", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_WarPigsParanoidMix", -- The name of the sound file as registerd in scripts/
        duration = 44, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 2, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - CRAZY TRAIN
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_CrazyTrain", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_CrazyTrain", -- The name of the sound file as registerd in scripts/
        duration = 29, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - SMOKE ON THE WATER
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_SmokeOnTheWater", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_SmokeOnTheWater", -- The name of the sound file as registerd in scripts/
        duration = 51, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 1, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - THE TROOPER
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_TheTrooper", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_TheTrooper", -- The name of the sound file as registerd in scripts/
        duration = 48, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - TORNADO OF SOULS
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_TornadoOfSouls", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_TornadoOfSouls", -- The name of the sound file as registerd in scripts/
        duration = 60, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - ANGEL OF DEATH
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_AngelOfDeath", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_AngelOfDeath", -- The name of the sound file as registerd in scripts/
        duration = 50, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- ELVIS CAMPBELL - FADE TO BLACK
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_FadeToBlack", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_FadeToBlack", -- The name of the sound file as registerd in scripts/
        duration = 119, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- JEFFREY PARKER - BEST OF YOU (DRUMS)
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_DrumKit_BestOfYou", -- The name of the song as it appears in the game (use translations)
        instrumentType = "DrumKit", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_DrumKit_BestOfYou", -- The name of the sound file as registerd in scripts/
        duration = 60, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 1, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- JEFFREY PARKER - BEST OF YOU (GUITAR)
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectric_BestOfYou", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectric", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectric_BestOfYou", -- The name of the sound file as registerd in scripts/
        duration = 60, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 1, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- JEFFREY PARKER - THE PRETENDER
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_DrumKit_ThePretender", -- The name of the song as it appears in the game (use translations)
        instrumentType = "DrumKit", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_DrumKit_ThePretender", -- The name of the sound file as registerd in scripts/
        duration = 45, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 1, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- JEFFREY PARKER - NEVER ENOUGH
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarAcoustic_NeverEnough", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarAcoustic", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarAcoustic_NeverEnough", -- The name of the sound file as registerd in scripts/
        duration = 124, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- JEFFREY PARKER - UNA MALAGEÑA
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarAcoustic_UnaMalaguenya", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarAcoustic", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarAcoustic_UnaMalaguenya", -- The name of the sound file as registerd in scripts/
        duration = 138, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- JEFFREY PARKER - YOU AND I
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarAcoustic_YouAndI", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarAcoustic", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarAcoustic_YouAndI", -- The name of the sound file as registerd in scripts/
        duration = 84, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 2, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    ;
end


Events.OnGameBoot.Add(DL_MOTW_OnGameBoot);