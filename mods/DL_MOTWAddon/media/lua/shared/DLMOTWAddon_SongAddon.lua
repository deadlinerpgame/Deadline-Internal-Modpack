require "motw/Core"

MOTW_Core = MOTW_Core or {};

local function DL_MOTW_OnGameBoot()
    -- BASS MEDIUM CAKE SHORT SKIRT LONG JACKET
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_ShortSkirtLongJacket", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_ShortSkirtLongJacket", -- The name of the sound file as registerd in scripts/
        duration = 63, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 2, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- BASS BEGINNER FOO FIGHTERS THE PRETENDER 
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_ThePretender", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_ThePretender", -- The name of the sound file as registerd in scripts/
        duration = 47, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 1, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    })

    -- BASS EXPERT DRAGONFORCE TRHOUGH THE FIRE AND FLAMES 
    MOTW_Core:registerSong({
        name = "IGUI_DLMOTWAddon_GuitarElectricBass_ThroughtheFireandFlames", -- The name of the song as it appears in the game (use translations)
        instrumentType = "GuitarElectricBass", -- The instrument type that can play this song (GuitarAcoustic, GuitarElectric, GuitarElectricBass, Synthesizer, Flute, Saxophone, Trumpet, Violin, DrumKit)
        soundFile = "DLMOTWAddon_GuitarElectricBass_ThroughtheFireandFlames", -- The name of the sound file as registerd in scripts/
        duration = 76, -- The duration of the song in seconds (round up to the nearest second)
        difficulty = 3, -- The difficulty of the song (1-3)
        isKnown = false, -- Whether the song is known by default or needs to be learned
    });
end


Events.OnGameBoot.Add(DL_MOTW_OnGameBoot);