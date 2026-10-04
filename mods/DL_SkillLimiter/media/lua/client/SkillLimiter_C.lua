DL = DL or {}

local function isLocalPlayer(character)
    return character ~= nil and instanceof(character, "IsoPlayer") and character:isLocalPlayer()
end

local function onLevelPerk(character, perk, level, increased)
    if not increased or not isLocalPlayer(character) then return end
    DL.Caps.clampPerk(character, perk)
end
Events.LevelPerk.Add(onLevelPerk)

local pinTick = 0
Events.OnPlayerUpdate.Add(function(player)
    if not isLocalPlayer(player) then return end
    pinTick = pinTick + 1
    if pinTick % 10 ~= 0 then return end
    DL.Caps.pinAtCap(player)
end)

Events.OnNewGame.Add(function(player, square)
    if not isLocalPlayer(player) then return end
    DL.Caps.markNewCharacter(player)
end)

DL.log("caps client wiring loaded (LevelPerk + continuous pin)")
