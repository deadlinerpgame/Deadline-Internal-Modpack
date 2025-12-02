function CacheVehicleForTP(context, player, vehicle)
    player:getModData().DL_CachedVehicleTeleport = vehicle;
    print("Vehicle cached!");
end

function TeleportCachedVehicle(context, player)
    local vehicle = player:getModData().DL_CachedVehicleTeleport;
    if not vehicle then return end;

    PatchLine_VehicleTeleport.TeleportToPlayer(getPlayer(), vehicle);

    sendClientCommand(player, "DL_VehicleTeleport", "TeleportVehicle", { id = vehicle:getId() });

end

function OnFillWorldObjectContextMenu_VehicleTeleport(playerNum, context, worldObjects, test)

    if not isDebugEnabled() and not isAdmin() then return end;

    if test then return end;
    if not worldObjects then return end;
    
    if not getPlayer():getVehicle() and not getPlayer():getModData().DL_CachedVehicleTeleport then return end;

    local vehicle = getPlayer():getVehicle();

    if vehicle and not getPlayer():getModData().DL_CachedVehicleTeleport then
        context:addOptionOnTop("Cache Vehicle for Teleporting", context, CacheVehicleForTP, getPlayer(), vehicle);
    elseif vehicle and getPlayer():getModData().DL_CachedVehicleTeleport then
        context:addOptionOnTop("Override Cached Vehicle for Teleporting", context, CacheVehicleForTP, getPlayer(), vehicle);
    elseif not vehicle then
        context:addOptionOnTop("Teleport Cached Vehicle Here", context, TeleportCachedVehicle, getPlayer());
    end
end

Events.OnFillWorldObjectContextMenu.Add(OnFillWorldObjectContextMenu_VehicleTeleport);