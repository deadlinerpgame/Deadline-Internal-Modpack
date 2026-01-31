require "TimedActions/ISBaseTimedAction";

require "LogLineUtils";
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

local randInstance = newrandom();

DLOpenLootTicketAction = ISBaseTimedAction:derive("DLOpenLootTicketAction");

function DLOpenLootTicketAction:isValid()
    return true;
end

function DLOpenLootTicketAction:update()

end

function DLOpenLootTicketAction:start()
    ISBaseTimedAction.start(self);

    self:setAnimVariable("LootPosition", "mid");
	self:setOverrideHandModels(nil, nil);

    getPlayer():getEmitter():playSound("LootTicket_DrumRoll");
end

function DLOpenLootTicketAction:stop()
    ISBaseTimedAction.stop(self);
end

function DLOpenLootTicketAction:rollForLoot()
    if not self.item then
        getPlayer():setHaloNote("There was an error with this loot ticket, contact an admin.", 255, 100, 100, 250);
        LogLineUtils.LogFromClient("LootTicket", "Player " .. getPlayer():getUsername() .. " attempted to open loot ticket but DLOpenLootTicketAction item was not set.");
        return;
    end

    local lootData = self.item:getModData().LootTicket;
    if not lootData then
        getPlayer():setHaloNote("There was an error with this loot ticket, contact an admin.", 255, 100, 100, 250);
        LogLineUtils.LogFromClient("LootTicket", "Player " .. getPlayer():getUsername() .. " attempted to open loot ticket but ticket did not have loot data.");
        return;
    end

    local totalChance = 0;
    self.itemsToGive = {};
    local logStr = "[OPENING LOOT TICKET] Player: " .. getPlayer():getUsername() .. " || ID: " .. tostring(lootData.ID) ..  " || ";

    for _, itemData in ipairs(lootData.Items) do
        local chance = tonumber(itemData.item.Chance);
        itemData.item.hasRolledThisTurn = false;
        if chance < 100 then
            totalChance = totalChance + chance;
        else
            table.insert(self.itemsToGive, itemData);
        end
    end

    logStr = logStr .. string.format(" || Total Weight: %0d ", totalChance);

    

    local totalRolls = tonumber(lootData.MaxRolls);
    if not totalRolls or totalRolls < 1 then totalRolls = 1 end;

    logStr = logStr .. string.format(" || Total Rolls: %0d ", totalRolls);

    for rollNum = 1, totalRolls do
        local iteratedChance = randInstance:random(0, totalChance);
        local hasRolledSuccessfully = false;

        logStr = logStr .. string.format(" || Current Roll: %0d, Random Number Picked: %0d >", rollNum, iteratedChance);

        for _, rollItem in ipairs(lootData.Items) do
            logStr = logStr .. string.format(" [%s ", rollItem.item.Name);
            
            -- If the item is guaranteed, add it to the list.
            if tonumber(rollItem.item.Chance) < 100 then
                -- Make sure there's not already been an item selected for this roll (not withstanding the guaranteed ones.)
                if not hasRolledSuccessfully then

                    iteratedChance = iteratedChance - tonumber(rollItem.item.Chance);

                    logStr = logStr .. string.format("original: %0d, comp is: %0d", rollItem.item.Chance, iteratedChance);

                    if not lootData.AllowDuplicates and not rollItem.item.hasRolledThisTurn then
                        
                        if iteratedChance <= 0 then
                            logStr = logStr .. string.format(" !SUCCESS! ", iteratedChance);
                            hasRolledSuccessfully = true;
                            rollItem.item.hasRolledThisTurn = true;
                            table.insert(self.itemsToGive, rollItem);
                        end
                    else
                        logStr = logStr .. " !Has already rolled, no duplicates allowed ! ";
                    end
                else
                    logStr = logStr .. " skip";
                end

                logStr = logStr .. " ] ";
            end

            
        end
    end

    LogLineUtils.LogFromClient("LootTicket", logStr);

    logStr = "[REWARD] Giving player " .. getPlayer():getUsername() .. " the following items: ";
    for _, item in ipairs(self.itemsToGive) do
        local newItem = InventoryItemFactory.CreateItem(item.item.Name);
        if newItem then
            local wasAdded = getPlayer():getInventory():addItem(newItem);
            if not wasAdded then
                getPlayer():getSquare():AddWorldInventoryItemItem(newItem, 0, 0, 0);
                logStr = logStr .. newItem:getFullType() .. " [floor] | ";
            else
                logStr = logStr .. newItem:getFullType() .. " [inv] | ";
            end
        else
            logStr = logStr .. " [ERROR CREATING ITEM " .. item.item.Name .. "] ";
        end
    end

    LogLineUtils.LogFromClient("LootTicket", logStr);
end

function DLOpenLootTicketAction:perform()
    ISBaseTimedAction.perform(self);
    self:rollForLoot();
    local container = self.item:getContainer();
    container:DoRemoveItem(self.item);
end

function DLOpenLootTicketAction:new(item)
    local o = {};
	setmetatable(o, self);
	self.__index = self;
    o.character = getPlayer(); -- Required for an ISBaseTimedAction to work.
    o.stopOnWalk = true;
    o.item = item;
    o.maxTime = 250;
	return o;
end

