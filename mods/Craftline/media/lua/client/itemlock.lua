local function onPlayerDeath(player)
    local playerName = player:getUsername()

    local token = InventoryItemFactory.CreateItem("Base.CorpseTicket")
    player:getInventory():AddItem(token)
    token:setName(playerName .. "'s Corpse Token")
    token:getModData().corpseOwner = playerName

    
end

Events.OnPlayerDeath.Add(onPlayerDeath)

local original_ISInventoryTransferAction_isValid = ISInventoryTransferAction.isValid

function ISInventoryTransferAction:isValid()
    local player = self.character
    local sourceContainer = self.srcContainer
    local destContainer = self.destContainer

    if sourceContainer and player then
        local items = sourceContainer:getItems()
        if items then
            for i = 0, items:size() - 1 do
                local item = items:get(i)
                local ownerName = item:getModData().corpseOwner
                if ownerName then
                    if ownerName ~= player:getUsername() then
                        player:Say("You can't take items from " .. ownerName .. "'s corpse.")
                        return false 
                    end
                end
            end
        end
    end

    -- If player is trying to drop a corpse token onto the floor, destroy it.
    if item and item:getType() == "Base.CorpseTicket" and destContainer and destContainer:getType() == "floor" then
        local ownerName = item:getModData().corpseOwner;
        if ownerName ~= player:getUsername() then return false end;

        item:getContainer():DoRemoveItem(item);
        player:Say("Corpse ticket deleted!");
        return false;
    end

    return original_ISInventoryTransferAction_isValid(self)
end

local original_ISGrabCorpseAction_isValid = ISGrabCorpseAction.isValid

function ISGrabCorpseAction:isValid()
    -- Keep original check first
    if self.corpseBody:getStaticMovingObjectIndex() < 0 then
        return false
    end

    if self.character:getInventory():getItemCount("Base.CorpseMale") > 0 then
        return false
    end

    if instanceof(self.corpseBody, "IsoDeadBody") then
        local inventory = self.corpseBody:getContainer()
        if inventory then
            local items = inventory:getItems()
            for i = 0, items:size() - 1 do
                local item = items:get(i)
                local ownerName = item:getModData().corpseOwner
                if ownerName and ownerName ~= self.character:getUsername() then
                    self.character:Say("You can't pick up this corpse.")
                    return false
                end
            end
        end
    end

    return true
end


local upperLayer_ISInventoryPage_isRemoveButtonVisible = ISInventoryPage.isRemoveButtonVisible

function ISInventoryPage:isRemoveButtonVisible()
    local vanillaRemoveAll = upperLayer_ISInventoryPage_isRemoveButtonVisible(self)
    if vanillaRemoveAll then return vanillaRemoveAll end

    if self.onCharacter then return false end
    if self.inventory:isEmpty() then return false end
    if isClient() and not getServerOptions():getBoolean("TrashDeleteAll") then return false end

    local obj = self.inventory:getParent()
    if not obj or not instanceof(obj, "IsoObject") then return false end
    if instanceof(obj, "BaseVehicle") then return false end
    if instanceof(obj, "IsoDeadBody") then return false end
    if self.toggleStove:getIsVisible() then return false end
    if obj:getContainer() ~= self.inventory then return false end

    local items = self.inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local modData = item:getModData()
if modData and modData.corpseOwner then
    return false
end
    end

    return true
end