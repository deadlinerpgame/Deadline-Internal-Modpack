require "motw/Core"

MOTW_Core = MOTW_Core or {};

local function DL_MOTW_OnGameBoot()
    -- HOT STUFF
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_HotStuff", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_HotStuff", -- The name of the sound file as registerd in scripts/
        duration = 205, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
        notFindable = true, -- This song won't spawn in the world
    })

    -- EVERYONE ELSE IS AN ASSHOLE 
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_Asshole", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_Asshole", -- The name of the sound file as registerd in scripts/
        duration = 244, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
        notFindable = true, -- This song won't spawn in the world
    })

    -- COUNTRY ROADS TAKE ME HOME
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_CountryRoads", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_CountryRoads", -- The name of the sound file as registerd in scripts/
        duration = 244, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
        notFindable = true, -- This song won't spawn in the world
    })

    -- WHITE COLLARS 
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_WhiteCollars", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_WhiteCollars", -- The name of the sound file as registerd in scripts/
        duration = 201, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
        notFindable = true, -- This song won't spawn in the world
    })

    -- JUMP 
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_Jump", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_Jump", -- The name of the sound file as registerd in scripts/
        duration = 169, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
        notFindable = true, -- This song won't spawn in the world
    });
end


Events.OnGameBoot.Add(DL_MOTW_OnGameBoot);