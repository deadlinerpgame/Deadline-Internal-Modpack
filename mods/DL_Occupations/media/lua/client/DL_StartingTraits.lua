require "XpSystem/ISUI/ISCharacterScreen"

DL = DL or {}
local O = DL.Occupations

local granted = false

local function onNewGame(player)
    if DBNO.Respawn._lastRespawn ~= nil then return end
    local traits = player:getTraits()
    for id, trait in pairs(O.traits) do
        if trait.grant ~= nil and traits:contains(id) and not traits:contains(trait.grant) then
            traits:add(trait.grant)
            granted = true
        end
    end
end

local function onCreatePlayer(index, player)
    if not granted or not player:isLocalPlayer() then return end
    granted = false
    SyncXp(player)
end

local vanillaSetDisplayedTraits = ISCharacterScreen.setDisplayedTraits
ISCharacterScreen.setDisplayedTraits = function(self)
    vanillaSetDisplayedTraits(self)
    for i = #self.displayedTraits, 1, -1 do
        local trait = O.traits[self.displayedTraits[i]:getType()]
        if trait ~= nil and trait.invisible then
            table.remove(self.displayedTraits, i)
        end
    end
end

Events.OnNewGame.Add(onNewGame)
Events.OnCreatePlayer.Add(onCreatePlayer)
