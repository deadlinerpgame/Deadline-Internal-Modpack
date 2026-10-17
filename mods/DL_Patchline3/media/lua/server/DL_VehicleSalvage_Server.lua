local function onClientCommand(module, command, player, args)
    if module ~= "DLSalvage" or command ~= "markSalvaged" then return end
    local vehicle = getVehicleById(args.vehicle)
    if vehicle == nil then return end
    DLSalvage.setSalvaged(vehicle)
    sendServerCommand("DLSalvage", "salvaged", { vehicle = args.vehicle })
end

Events.OnClientCommand.Add(onClientCommand)
