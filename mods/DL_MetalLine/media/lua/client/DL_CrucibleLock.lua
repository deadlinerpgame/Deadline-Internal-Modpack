require "TimedActions/ISGrabItemAction"
require "TimedActions/ISInventoryTransferAction"

DL = DL or {}

local function hot(item)
    if not DL.Crucible.isCrucibleItem(item) then return false end
    local st = item:getModData().DLCrucible
    return type(st) == "table" and DL.Crucible.isHot(st)
end

local function refuse(action)
    if not action.dlTooHot then
        action.dlTooHot = true
        local character = action.character
        if character and character.setHaloNote then character:setHaloNote("Too hot to pick up") end
    end
    return false
end

local grabIsValid = ISGrabItemAction.isValid
function ISGrabItemAction:isValid()
    local it = self.item and self.item.getItem and self.item:getItem()
    if hot(it) then return refuse(self) end
    return grabIsValid(self)
end

local transferIsValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
    local src = self.srcContainer
    if src and src:getType() == "floor" and hot(self.item) then return refuse(self) end
    return transferIsValid(self)
end
