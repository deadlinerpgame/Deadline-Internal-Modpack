require "StaffSealSystem/SSS_Shared"

-- Shared client-side seal command helpers used by context menu and toolbar.

-- Resolve local player once for optimistic local updates and SP writes.
local function _localPlayer()
    if getPlayer then
        return getPlayer()
    end

    return nil
end

-- Build MP args for item-seal actions from known item/container/world context.
local function _buildItemSealArgs(item, shouldSeal, contextSquare)
    local args = {
        itemId = item and item.getID and item:getID() or nil,
        seal = shouldSeal,
    }

    if contextSquare then
        args.x = contextSquare:getX()
        args.y = contextSquare:getY()
        args.z = contextSquare:getZ()
    end

    local worldItem = item and item.getWorldItem and item:getWorldItem() or nil
    if worldItem then
        args.x = worldItem:getX()
        args.y = worldItem:getY()
        args.z = worldItem:getZ()
    end

    local srcContainer = item and item.getContainer and item:getContainer() or nil
    local sourceGrid = srcContainer and srcContainer.getSourceGrid and srcContainer:getSourceGrid() or nil
    if sourceGrid and args.x == nil then
        args.x = sourceGrid:getX()
        args.y = sourceGrid:getY()
        args.z = sourceGrid:getZ()
    end

    local parent = srcContainer and srcContainer.getParent and srcContainer:getParent() or nil
    if parent then
        args.x = parent:getX()
        args.y = parent:getY()
        args.z = parent:getZ()
        args.index = parent:getObjectIndex()
    end

    return args
end

-- Build MP args for container-seal actions.
local function _buildContainerSealArgs(object, shouldSeal)
    return {
        x = object:getX(),
        y = object:getY(),
        z = object:getZ(),
        index = object:getObjectIndex(),
        seal = shouldSeal,
    }
end

-- Unified sender for item-seal actions.
function StaffSealSystem.sendItemSealCommand(item, shouldSeal, contextSquare)
    if not item then
        return
    end

    local args = _buildItemSealArgs(item, shouldSeal, contextSquare)
    StaffSealSystem.log("SetItemSeal itemId=" .. tostring(args.itemId) .. " pos=" .. tostring(args.x) .. "," .. tostring(args.y) .. "," .. tostring(args.z) .. " seal=" .. tostring(shouldSeal))

    -- Optimistic local update: keeps local restrictions in sync immediately.
    local actorLocal = StaffSealSystem.getPlayerName(_localPlayer())
    StaffSealSystem.setItemSealState(item, shouldSeal, actorLocal)

    if isClient and isClient() then
        sendClientCommand("StaffSealSystem", "SetItemSeal", args)
    else
        local actor = StaffSealSystem.getPlayerName(_localPlayer())
        StaffSealSystem.setItemSealState(item, shouldSeal, actor)
        StaffSealSystem.log((shouldSeal and "Sealed" or "Unsealed") .. " item " .. tostring(item.getFullType and item:getFullType() or "unknown") .. " by " .. actor)
    end

    if StaffSealSystem.requestHighlightRefresh then
        StaffSealSystem.requestHighlightRefresh()
    end
end

-- Unified sender for container-seal actions.
function StaffSealSystem.sendContainerSealCommand(object, shouldSeal)
    if not object then
        return
    end

    local args = _buildContainerSealArgs(object, shouldSeal)

    if isClient and isClient() then
        sendClientCommand("StaffSealSystem", "SetContainerSeal", args)
    else
        local actor = StaffSealSystem.getPlayerName(_localPlayer())
        StaffSealSystem.setSealState(object, shouldSeal, actor)
        StaffSealSystem.log((shouldSeal and "Sealed" or "Unsealed") .. " container at " .. StaffSealSystem.getObjectPosition(object) .. " by " .. actor)
    end

    if StaffSealSystem.requestHighlightRefresh then
        StaffSealSystem.requestHighlightRefresh()
    end
end
