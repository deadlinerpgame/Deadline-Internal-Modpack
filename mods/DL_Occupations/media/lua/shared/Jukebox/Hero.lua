-- JukeboxHero Trait

local Jukebox = require("Jukebox/Utility")

local JukeboxHero = {}

JukeboxHero.trait = function()

end

Events.OnGameBoot.Add(JukeboxHero.trait)

JukeboxHero.giveMusic = function(player)

end

JukeboxHero.gifts = function(playerIndex, player)

end

Events.OnCreatePlayer.Add(JukeboxHero.gifts)

return JukeboxHero