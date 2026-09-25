
if isServer() and not isClient() then return end

local function onServerCommand(module, command, args)
    if module ~= "ServerPoints" or command ~= "deliver" or args == nil then return end
    local p = getPlayer()
    if p == nil then return end
    if args.kind == "ITEM" and args.target then
        p:getInventory():AddItems(args.target, args.quantity or 1)
    elseif args.kind == "XP" and args.target and Perks[args.target] then
        p:getXp():AddXP(Perks[args.target], args.quantity or 1, true, false, false)
    end
end
Events.OnServerCommand.Add(onServerCommand)

Events.OnCreatePlayer.Add(function(idx, player)
    if player == getPlayer() then
        sendClientCommand("ServerPoints", "checkin", nil)
    end
end)
