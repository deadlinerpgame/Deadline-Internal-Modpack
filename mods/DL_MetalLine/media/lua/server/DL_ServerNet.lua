DL = DL or {}

local function onClientCommand(module, command, player, args)
    if module ~= DL.MODULE or not player then return end

    if command == "ReloadAlloys" then
        local lvl = player.getAccessLevel and player:getAccessLevel() or "None"
        if lvl ~= "None" and lvl ~= "" then
            local ok = DL.Resolver.load()
            sendServerCommand(player, DL.MODULE, "AlloysReloaded", { ok = ok })
        end
    end
end
Events.OnClientCommand.Add(onClientCommand)

Events.OnInitGlobalModData.Add(function() DL.Resolver.load() end)
