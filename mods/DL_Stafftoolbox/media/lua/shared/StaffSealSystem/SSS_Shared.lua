StaffSealSystem = StaffSealSystem or {}

-- Shared modData keys used by container sealing.
StaffSealSystem.Keys = {
    containerSealed = "SSS_ContainerSealed",
    sealedBy = "SSS_SealedBy",
    sealedAt = "SSS_SealedAt",
    itemSealed = "SSS_ItemSealed",
    itemSealedBy = "SSS_ItemSealedBy",
    itemSealedAt = "SSS_ItemSealedAt",
}

-- Resolve the local player's access level string when available.
local function _accessLevel()
    if getAccessLevel then
        return tostring(getAccessLevel() or "")
    end

    return ""
end

-- Normalize access level values across SP/Host/MP variants.
local function _normalizedAccessLevel()
    local level = _accessLevel()
    if level == "None" then
        return ""
    end

    return string.lower(level)
end

-- True for admins/moderators. Used to bypass seal restrictions.
function StaffSealSystem.isStaff(player)
    -- Prefer access level from the provided player object when available.
    if player and player.getAccessLevel then
        local pLevel = string.lower(tostring(player:getAccessLevel() or ""))
        if pLevel ~= "" then
            -- If the server sets a concrete level for this player, trust it over globals.
            return pLevel == "admin" or pLevel == "moderator"
        end
    end

    if isAdmin and isAdmin() then
        return true
    end

    if isCoopHost and isCoopHost() then
        return true
    end

    local level = _normalizedAccessLevel()
    return level == "admin" or level == "moderator"
end

-- Return a readable player name for logs and metadata.
function StaffSealSystem.getPlayerName(player)
    if player and player.getUsername then
        return tostring(player:getUsername())
    end

    if getOnlineUsername then
        return tostring(getOnlineUsername())
    end

    return "unknown"
end

-- Check whether an IsoObject exposes one or more item containers.
function StaffSealSystem.objectHasContainers(object)
    if not object then
        return false
    end

    if object.getContainerCount then
        return object:getContainerCount() > 0
    end

    return object.getContainer ~= nil and object:getContainer() ~= nil
end

-- Return current sealed state from object modData.
function StaffSealSystem.objectIsSealed(object)
    if not object or not object.getModData then
        return false
    end

    local md = object:getModData()
    return md and md[StaffSealSystem.Keys.containerSealed] == true
end

-- Write or clear seal metadata on an object and transmit to clients.
function StaffSealSystem.setSealState(object, shouldSeal, actorName)
    if not object or not object.getModData then
        return false
    end

    local md = object:getModData()
    if shouldSeal then
        md[StaffSealSystem.Keys.containerSealed] = true
        md[StaffSealSystem.Keys.sealedBy] = actorName or "unknown"
        md[StaffSealSystem.Keys.sealedAt] = tostring(getTimestampMs and getTimestampMs() or "")
    else
        md[StaffSealSystem.Keys.containerSealed] = nil
        md[StaffSealSystem.Keys.sealedBy] = nil
        md[StaffSealSystem.Keys.sealedAt] = nil
    end

    if object.transmitModData then
        object:transmitModData()
    end

    return true
end

-- Return current sealed state from item modData.
function StaffSealSystem.itemIsSealed(item)
    if not item or not item.getModData then
        return false
    end

    local md = item:getModData()
    return md and md[StaffSealSystem.Keys.itemSealed] == true
end

-- Write or clear seal metadata on an item and transmit to clients when possible.
function StaffSealSystem.setItemSealState(item, shouldSeal, actorName)
    if not item or not item.getModData then
        return false
    end

    local md = item:getModData()
    if shouldSeal then
        md[StaffSealSystem.Keys.itemSealed] = true
        md[StaffSealSystem.Keys.itemSealedBy] = actorName or "unknown"
        md[StaffSealSystem.Keys.itemSealedAt] = tostring(getTimestampMs and getTimestampMs() or "")
    else
        md[StaffSealSystem.Keys.itemSealed] = nil
        md[StaffSealSystem.Keys.itemSealedBy] = nil
        md[StaffSealSystem.Keys.itemSealedAt] = nil
    end

    if item.transmitModData then
        item:transmitModData()
    end

    return true
end

-- Format object world coordinates for human-readable logs.
function StaffSealSystem.getObjectPosition(object)
    if not object then
        return "unknown"
    end

    local x = object.getX and math.floor(object:getX()) or "?"
    local y = object.getY and math.floor(object:getY()) or "?"
    local z = object.getZ and math.floor(object:getZ()) or "?"
    return tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
end

-- Central log helper to keep log output shape consistent.
function StaffSealSystem.log(message)
    local line = "[StaffSealSystem] " .. tostring(message)
    if writeLog then
        writeLog("StaffSeal", line)
    end
    print(line)
end
