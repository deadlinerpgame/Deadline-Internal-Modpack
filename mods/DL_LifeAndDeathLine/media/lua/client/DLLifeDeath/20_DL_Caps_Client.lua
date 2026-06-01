DL = DL or {}

local function onLevelPerk(character, perk, level, increased)
    if character == nil or not character:isLocalPlayer() then return end
    if not increased then return end
    local _ = (function()
        DL.Caps.clampPerk(character, perk)
    end)()
end
Events.LevelPerk.Add(onLevelPerk)

local pinTick = 0
Events.OnPlayerUpdate.Add(function(player)
    if player == nil or not player:isLocalPlayer() then return end
    pinTick = pinTick + 1
    if pinTick % 10 ~= 0 then return end
    local _ = (function() DL.Caps.pinAtCap(player) end)()
end)

DL.log("caps client wiring loaded (LevelPerk + continuous pin)")
