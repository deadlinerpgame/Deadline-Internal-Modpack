function OnClientCommand_VehicleTeleport(module, command, player, args)
    if module ~= "DL_VehicleTeleport" then return end;

    if command == "TeleportVehicle" then
        print("Teleporting vehicle...");
        local vehId = args.id;
        local vehicle = getVehicleById(vehId);

        if vehicle then
            -- This will need to use reflection.

            -- We need to get the transform field and since we can't transform.new we have to use the script.
            PatchLine_VehicleTeleport.TeleportToPlayer(player, vehicle);
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand_VehicleTeleport);