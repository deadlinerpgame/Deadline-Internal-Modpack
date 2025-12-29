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

Events.OnPlayerUpdate.Add(function(p)
    if not p then return end

    -- only fire when the player changes tile
    local pid = p:getOnlineID() or 0
    local x, y, z = math.floor(p:getX()), math.floor(p:getY()), p:getZ()
    local key = x .. "," .. y .. "," .. z
    if DD_lastTileKeyByPID[pid] == key then return end
    DD_lastTileKeyByPID[pid] = key

    local info = DD_ReadSquareTransport(p:getSquare())
    if info and isKeyDown(Keyboard.KEY_F) then
        print(string.format("[Transport] Standing on '%s' -> %d,%d,%d", info.name, info.x, info.y, info.z))
        p:setHaloNote("Moving to " .. info.name)
        local md   = p and p:getSquare():getModData()
        local dest = md and md.ddTeleDest and { x = md.ddTeleDest.x, y = md.ddTeleDest.y, z = md.ddTeleDest.z }
        DD_TeleportWithFade(pid, dest, 1, 1)
    end
end)

function DD_TeleportWithFade(pid, dest, durOut, durIn)
    local p = getSpecificPlayer(0); if not p or not dest then return end
    local f = DD_GetFader(pid or 0)

    f:fadeOutIn(durOut or 1, durIn or 1, pid, dest.x, dest.y, dest.z, function()
    

    end)


end