DL = DL or {}
DL.Config = DL.Config or {}
if DL.Config.debugKillMenu == nil then DL.Config.debugKillMenu = true end

local function killSelf(player)
    local _ = (function()
        if player.Kill then player:Kill(player); return end
    end)()

end

Events.OnFillWorldObjectContextMenu.Add(function(playerIndex, context, worldobjects, test)
    if test then return end
    if not DL.Config.debugKillMenu then return end
    local player = getSpecificPlayer(playerIndex)
    if player == nil or player:isDead() then return end
    context:addOption("kill", player, killSelf)
end)

DL.log("debug kill option loaded (right-click -> kill)")
