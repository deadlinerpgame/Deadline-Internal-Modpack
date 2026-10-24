require "DL_TransportHours"
local DD_lastTileKeyByPID = {}

local function DD_ReadSquareTransport(sq)
    if not sq then return nil end
    local md = sq:getModData()
    if md and md.ddTeleDest then
        return {
            name = md.ddTeleName or "Transport",
            x = tonumber(md.ddTeleDest.x) or md.ddTeleDest.x,
            y = tonumber(md.ddTeleDest.y) or md.ddTeleDest.y,
            z = tonumber(md.ddTeleDest.z) or md.ddTeleDest.z or 0,
        }
    end
    return nil
end

local nextTileNotification = 0;

Events.OnPlayerUpdate.Add(function(p)
    if not p then return end

    if isKeyDown(Keyboard.KEY_E) then
        local x,y,z = math.floor(p:getX()), math.floor(p:getY()), p:getZ()
        local pid = p:getOnlineID() or 0;

        local info = DD_ReadSquareTransport(p:getSquare());
        if not info then return end;

        local md = p:getSquare():getModData()
        local hours = md.ddTeleHours
        if not DL_TransportHours.isOpen(hours, nil, md.ddTeleEvenDays, md.ddTeleOddDays) then
            if getTimestamp() >= nextTileNotification then
                p:setHaloNote("Travel to: " .. info.name .. " - " .. DL_TransportHours.closedMessage(hours, md.ddTeleEvenDays, md.ddTeleOddDays), 255, 200, 100, 300)
                nextTileNotification = getTimestamp() + 2
            end
            return
        end

        print(string.format("[Transport] Standing on '%s' -> %d,%d,%d", info.name, info.x, info.y, info.z))
        p:setHaloNote("Moving to " .. info.name, 255, 255, 255, 300);
        local dest = md and md.ddTeleDest and { x = md.ddTeleDest.x, y = md.ddTeleDest.y, z = md.ddTeleDest.z }
        DD_TeleportWithFade(pid, dest, 1, 1);
        return;
    else
        local pid = p:getOnlineID() or 0
        local x, y, z = math.floor(p:getX()), math.floor(p:getY()), p:getZ()
        local key = x .. "," .. y .. "," .. z .. "," .. DL_TransportHours.currentHour()

        if DD_lastTileKeyByPID[pid] == key and nextTileNotification > getTimestamp() then return end;
        DD_lastTileKeyByPID[pid] = key;
        
        local info = DD_ReadSquareTransport(p:getSquare());
        if not info then return end;

        local md = p:getSquare():getModData()
        local hours = md.ddTeleHours
        local message = DL_TransportHours.isOpen(hours, nil, md.ddTeleEvenDays, md.ddTeleOddDays)
            and ("Travel to: " .. info.name .. " - press E to enter.")
            or ("Travel to: " .. info.name .. " - " .. DL_TransportHours.closedMessage(hours, md.ddTeleEvenDays, md.ddTeleOddDays))
        p:setHaloNote(message, 255, 255, 255, 300);
        nextTileNotification = getTimestamp() + 15;
    end
end)

function DD_TeleportWithFade(pid, dest, durOut, durIn)
    local p = getSpecificPlayer(0); if not p or not dest then return end
    local f = DD_GetFader(pid or 0)

    f:fadeOutIn(durOut or 1, durIn or 1, pid, dest.x, dest.y, dest.z, function()
    

    end)


end