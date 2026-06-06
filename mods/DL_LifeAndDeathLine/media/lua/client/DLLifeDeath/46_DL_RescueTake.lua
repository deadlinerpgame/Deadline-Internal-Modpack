require "TimedActions/ISBaseTimedAction"

DLRescueTake = ISBaseTimedAction:derive("DLRescueTake")

function DLRescueTake:isValid()
    if not self.character or not self.item or not self.srcInv then return false end
    if not isItemTransactionConsistent(self.item, self.srcInv, self.charInv) then return false end
    return self.srcInv:contains(self.item)
end

function DLRescueTake:start()
    createItemTransaction(self.item, self.srcInv, self.charInv)
end

function DLRescueTake:stop()
    removeItemTransaction(self.item, self.srcInv, self.charInv)
    ISBaseTimedAction.stop(self)
end

function DLRescueTake:perform()
    local item = self.item
    if isClient() then pcall(function() self.srcInv:removeItemOnServer(item) end) end
    pcall(function() self.srcInv:DoRemoveItem(item) end)
    pcall(function() self.charInv:AddItem(item) end)
    if self.wear then
        local loc = item.getBodyLocation and item:getBodyLocation()
        if loc and loc ~= "" then
            pcall(function() self.character:setWornItem(loc, item) end)
            triggerEvent("OnClothingUpdated", self.character)
        end
    end
    removeItemTransaction(self.item, self.srcInv, self.charInv)
    ISInventoryPage.renderDirty = true
    pcall(function() self.srcInv:setDrawDirty(true) end)
    pcall(function() self.charInv:setDrawDirty(true) end)
    ISBaseTimedAction.perform(self)
end

function DLRescueTake:new(character, item, srcInv, wear)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.item = item
    o.srcInv = srcInv
    o.charInv = character:getInventory()
    o.wear = wear and true or false
    o.stopOnWalk = false
    o.stopOnRun = false
    o.maxTime = 0
    return o
end
