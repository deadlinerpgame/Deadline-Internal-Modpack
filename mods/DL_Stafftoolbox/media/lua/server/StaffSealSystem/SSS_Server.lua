require "StaffSealSystem/SSS_Shared"

-- Fallback search: find first container-capable object on target square.
local function _findObjectAt(x, y, z)
    local square = getCell() and getCell():getGridSquare(x, y, z)
    if not square then
        return nil
    end

    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if StaffSealSystem.objectHasContainers(object) then
            return object
        end
    end

    return nil
end

-- Preferred search: resolve by object index, then fallback to generic lookup.
local function _findObjectAtIndex(x, y, z, index)
    local square = getCell() and getCell():getGridSquare(x, y, z)
    if not square then
        return nil
    end

    if index ~= nil and index >= 0 and index < square:getObjects():size() then
        local obj = square:getObjects():get(index)
        if StaffSealSystem.objectHasContainers(obj) then
            return obj
        end
    end

    return _findObjectAt(x, y, z)
end

-- Find an item with a specific ID in a container.
local function _findItemInContainer(container, itemId)
    if not container or itemId == nil then
        return nil
    end

    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and item.getID and item:getID() == itemId then
            return item
        end
    end

    return nil
end

-- Resolve item by ID from source object location, then fallback to player inventory.
local function _findItemForArgs(playerObj, args)
    local itemId = args and args.itemId
    if itemId == nil then
        return nil
    end

    local x = args and args.x
    local y = args and args.y
    local z = args and args.z
    local index = args and args.index

    -- First check world items on/near the square (for ground-targeted item sealing).
    if x ~= nil and y ~= nil and z ~= nil then
        for dy = -1, 1 do
            for dx = -1, 1 do
                local square = getCell() and getCell():getGridSquare(x + dx, y + dy, z)
                if square and square.getWorldObjects then
                    local wobs = square:getWorldObjects()
                    for wi = 0, wobs:size() - 1 do
                        local wob = wobs:get(wi)
                        local witem = wob and wob.getItem and wob:getItem() or nil
                        if witem and witem.getID and witem:getID() == itemId then
                            return witem
                        end
                    end
                end
            end
        end
    end

    if x ~= nil and y ~= nil and z ~= nil then
        local object = _findObjectAtIndex(x, y, z, index)
        if object then
            if object.getContainerCount and object.getContainerByIndex then
                for ci = 0, object:getContainerCount() - 1 do
                    local c = object:getContainerByIndex(ci)
                    local found = _findItemInContainer(c, itemId)
                    if found then
                        return found
                    end
                end
            end

            local c = object.getContainer and object:getContainer() or nil
            local found = _findItemInContainer(c, itemId)
            if found then
                return found
            end
        end
    end

    local inv = playerObj and playerObj.getInventory and playerObj:getInventory() or nil
    local foundInInv = _findItemInContainer(inv, itemId)
    if foundInInv then
        return foundInInv
    end

    -- Last resort: if no position was provided, search around player feet.
    if x == nil and y == nil and z == nil and playerObj then
        local px = math.floor(playerObj:getX())
        local py = math.floor(playerObj:getY())
        local pz = math.floor(playerObj:getZ())
        for dy = -2, 2 do
            for dx = -2, 2 do
                local square = getCell() and getCell():getGridSquare(px + dx, py + dy, pz)
                if square and square.getWorldObjects then
                    local wobs = square:getWorldObjects()
                    for wi = 0, wobs:size() - 1 do
                        local wob = wobs:get(wi)
                        local witem = wob and wob.getItem and wob:getItem() or nil
                        if witem and witem.getID and witem:getID() == itemId then
                            return witem
                        end
                    end
                end
            end
        end
    end

    return nil
end

-- Server-side authority check for who can apply seal state.
local function _isStaffPlayer(playerObj)
    if not playerObj then
        return false
    end

    local access = string.lower(tostring(playerObj:getAccessLevel() or ""))
    if access == "none" then
        access = ""
    end

    return access == "admin" or access == "moderator"
end

-- Handle incoming client requests to seal/unseal container objects.
Events.OnClientCommand.Add(function(module, command, playerObj, args)
    if module ~= "StaffSealSystem" then
        return
    end

    if not _isStaffPlayer(playerObj) then
        StaffSealSystem.log("Rejected " .. tostring(command) .. " from non-staff: " .. tostring(playerObj and playerObj:getUsername() or "unknown"))
        return
    end

    if command == "SetItemSeal" then
        local seal = args and args.seal == true
        local item = _findItemForArgs(playerObj, args)
        if not item then
            StaffSealSystem.log("No item found for SetItemSeal request from " .. tostring(playerObj:getUsername()) .. " itemId=" .. tostring(args and args.itemId) .. " pos=" .. tostring(args and args.x) .. "," .. tostring(args and args.y) .. "," .. tostring(args and args.z))
            return
        end

        StaffSealSystem.setItemSealState(item, seal, tostring(playerObj:getUsername()))
        StaffSealSystem.log((seal and "Sealed" or "Unsealed") .. " item " .. tostring(item.getFullType and item:getFullType() or "unknown") .. " by " .. tostring(playerObj:getUsername()))
        return
    end

    if command ~= "SetContainerSeal" then
        return
    end

    local x = args and args.x
    local y = args and args.y
    local z = args and args.z
    local index = args and args.index
    local seal = args and args.seal == true

    if x == nil or y == nil or z == nil then
        StaffSealSystem.log("Rejected SetContainerSeal with invalid args from " .. tostring(playerObj:getUsername()))
        return
    end

    local object = _findObjectAtIndex(x, y, z, index)
    if not object then
        StaffSealSystem.log("No container object found at " .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z))
        return
    end

    StaffSealSystem.setSealState(object, seal, tostring(playerObj:getUsername()))
    StaffSealSystem.log((seal and "Sealed" or "Unsealed") .. " container at " .. StaffSealSystem.getObjectPosition(object) .. " by " .. tostring(playerObj:getUsername()))
end)
