PatchLine_VehicleTeleport = {};


function PatchLine_VehicleTeleport.TeleportToPlayer(player, vehicle)

    local TRANSFORM_FIELD_NAME = "public final zombie.core.physics.Transform zombie.vehicles.BaseVehicle.jniTransform";
    local cachedTransform = nil;

    for i = 0, getNumClassFields(vehicle) - 1 do
        local field = getClassField(vehicle, i);

        if field and tostring(field) == TRANSFORM_FIELD_NAME then
            print("Found transform field.");
            cachedTransform = field;
        end
    end

    if cachedTransform then
        local cachedTransformVal = getClassFieldVal(vehicle, cachedTransform);
        print("Cached transform value obtained.");

        -- Needs to be stored in a temp variable.
        local tempTransform = vehicle:getWorldTransform(cachedTransformVal);
        print("Temp transport.");

        local transformOriginField = getClassField(tempTransform, 1);
        local transformOriginVal = getClassFieldVal(tempTransform, transformOriginField);

        transformOriginVal:set(player:getX(), transformOriginVal:y(), player:getY());
        vehicle:setWorldTransform(tempTransform);
        print("World transform set.");
    end

    if not isClient() then return end;

    pcall(vehicle.update, vehicle);
    pcall(vehicle.updateControls, vehicle);
    pcall(vehicle.updateBulletStats, vehicle);
    pcall(vehicle.updatePhysics, vehicle);
    pcall(vehicle.updatePhysicsNetwork, vehicle);
end