print("Loaded PatchLine - UdderlyVehicleRespawn Cell Fix");

require "UdderlyVehicleRespawn_Shared";
UdderlyVehicleRespawn = UdderlyVehicleRespawn or {};

Events.OnServerStarted.Add(function()

    local original_getRandomZoneInRandomCell = UdderlyVehicleRespawn.GetRandomZoneInRandomCell;

    print("[PatchLine] UdderlyVehicleRespawn.GetRandomZoneInRandomCell Overwrite");

    UdderlyVehicleRespawn.GetRandomZoneInRandomCell = function()

        

        local world = getWorld()
        local grid = world:getMetaGrid()
        local minX = grid:getMinX()
        local minY = grid:getMinY()
        local maxX = grid:getMaxX()
        local maxY = grid:getMaxY()
        local worldWidth = maxX - minX
        local worldHeight = maxY - minY
        local found = false
        local zones = nil

        local topLeftStr = SandboxVars.PatchLine.UdderlyRandomCellTopLeft;
        local bottomRightStr = SandboxVars.PatchLine.UdderlyRandomCellBottomRight;

        local topLeftSplit = string.split(topLeftStr, " ");
        if #topLeftSplit == 2 then
            print("[PatchLine | UdderlyVehicleRespawn] Min X and Y override, currently: " .. tostring(minX) .. ", " .. tostring(minY));
            minX = tonumber(topLeftSplit[1]);
            minY = tonumber(topLeftSplit[2]);
            print("[PatchLine | UdderlyVehicleRespawn] New min X and Y: " .. tostring(minX) .. ", " .. tostring(minY));
        end

        local bottomRightSplit = string.split(bottomRightStr, " ");
        if #bottomRightSplit == 2 then
            print("[PatchLine | UdderlyVehicleRespawn] Max X and Y override, currently: " .. tostring(maxX) .. ", " .. tostring(maxY));
            maxX = tonumber(bottomRightSplit[1]);
            maxY = tonumber(bottomRightSplit[2]);
            print("[PatchLine | UdderlyVehicleRespawn] New max X and Y: " .. tostring(maxX) .. ", " .. tostring(maxY));
        end

        while not found do
            local randomCellX = ZombRand(minX, maxX);
            local randomCellY = ZombRand(minY, maxY);
            local key = randomCellX.."_"..randomCellY;

            if not UdderlyVehicleRespawn.CellsWithoutZones[key] then
                zones = UdderlyVehicleRespawn.GetZonesForCellAt(randomCellX, randomCellY)
                if #zones > 0 then
                    print("[PatchLine | UdderlyVehicleRespawn] Picked random cell at " .. tostring(randomCellX) .. ", " .. tostring(randomCellY));
                    found = true;
                else
                    UdderlyVehicleRespawn.CellsWithoutZones[key] = true;
                end
            end
        end

        return zones[ZombRand(1, #zones)];

    end

end);

