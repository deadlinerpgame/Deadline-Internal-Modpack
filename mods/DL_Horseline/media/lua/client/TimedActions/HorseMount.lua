HorseMount = ISBaseTimedAction:derive("HorseMount")


function HorseMount:isValid()
    if not self.character or not self.item then
        return false
    end
    if self.mount then
        if not isItemTransactionConsistent(self.item, self.itemInv, self.characterInv) then
            return false
        end
        return self.item:getWorldItem() ~= nil
    else
        if not isItemTransactionConsistent(self.item, self.characterInv, self.floorInv) then
            return false
        end
        if self.character:getWornItem("Horse") ~= self.item then
            return false
        end
        return true
    end
end


function HorseMount:perform()
    print(self.mount)
    if self.mount then
    local worldItem = self.item:getWorldItem()
    local itemSquare = worldItem:getSquare()
    itemSquare:transmitRemoveItemFromSquare(worldItem)
    itemSquare:removeWorldObject(worldItem)
    self.item:setWorldItem(nil)
    self.characterInv:AddItem(self.item);

    self.item:setWeight(0.1)
    self.item:setActualWeight(0.1)
    self.item:setCustomWeight(true)

    self.character:setWornItem(self.item:getBodyLocation(), self.item)
    triggerEvent("OnClothingUpdated", self.character)
    
    removeItemTransaction(self.item, self.itemInv, self.characterInv)
    
    ISInventoryPage.renderDirty = true
    triggerEvent("OnClothingUpdated", self.character)
    self.itemInv:setDrawDirty(true)
    self.characterInv:setDrawDirty(true)

        
    else
        self.item:setWeight(60)
        self.item:setActualWeight(60)
        self.item:setCustomWeight(false)
        local worldItem = self.sq:AddWorldInventoryItem(self.item, self.xpos, self.ypos, self.zpos, false)
        if worldItem then
            worldItem:setWorldZRotation(self.rotation)
            worldItem:getWorldItem():setIgnoreRemoveSandbox(true)
        end
        worldItem:getWorldItem():transmitCompleteItemToServer()
        self.characterInv:Remove(self.item)
        self.character:setWornItem("Horse", nil, false)
        removeItemTransaction(self.item, self.characterInv, self.floorInv)
        self.item:setJobDelta(0.0)
        triggerEvent("OnClothingUpdated", self.character)
        ISInventoryPage.renderDirty = true
        self.itemInv:setDrawDirty(true)


    end
    ISBaseTimedAction.perform(self)
end

function HorseMount:new(character, item, mount, sq, xpos, ypos, zpos, rotation)
    local o = ISBaseTimedAction.new(self, player)
    o.item = item
    o.mount = mount
    o.sq = sq
    o.characterInv = character:getInventory()
    o.itemInv = item:getContainer()
    o.xpos = xpos
    o.ypos = ypos
    o.zpos = zpos
    o.rotation = rotation
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 1
    return o
end