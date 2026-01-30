require "TimedActions/ISBaseTimedAction";

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
        return;
    end

    local lootData = self.item:getModData().LootTicket;
    if not lootData then
        getPlayer():setHaloNote("There was an error with this loot ticket, contact an admin.", 255, 100, 100, 250);
        return;
    end

    local totalChance = 0;

    for _, itemData in ipairs(lootData.Items) do
        local chance = tonumber(itemData.item.Chance);
        totalChance = totalChance + chance;
        itemData.item.hasRolledThisTurn = false;
    end

    print("Total weight is " .. totalChance);

    self.itemsToGive = {};
    local itemsGiven = 0;

    local totalRolls = tonumber(lootData.MaxRolls);
    if not totalRolls or totalRolls < 1 then totalRolls = 1 end;

    print("Total rolls is: " .. tostring(totalRolls));

    for _ = 1, totalRolls do
        local iteratedChance = randInstance:random(0, totalChance);
        local hasRolledSuccessfully = false;

        print("For roll, iteratedChance is " .. tostring(iteratedChance));
        
        for _, rollItem in ipairs(lootData.Items) do
            print("Rolled item " .. tostring(rollItem.item.Name));
            
            -- If the item is guaranteed, add it to the list.
            if tonumber(rollItem.item.Chance) >=  100 then
                print("     > Chance is guaranteed so added.");
                table.insert(self.itemsToGive, rollItem);
            else

                -- Make sure there's not already been an item selected for this roll (not withstanding the guaranteed ones.)
                if not hasRolledSuccessfully then

                    iteratedChance = iteratedChance - tonumber(rollItem.item.Chacne);
                    print("     > Iterated chance is now " .. tostring(iteratedChance));

                    if not lootData.AllowDuplicates and not rollItem.item.hasRolledThisTurn then
                        print("     > Duplicates not allowed and this item hasn't been used this turn.");

                        if iteratedChance <= 0 then
                            hasRolledSuccessfully = true;
                            rollItem.item.hasRolledThisTurn = true;
                            table.insert(self.itemsToGive, rollItem);
                        end
                    end
                end
            end
        end
    end

    print("You have won:")
    for _, item in ipairs(self.itemsToGive) do
        print("    > " .. item.item.Name);
    end
end

function DLOpenLootTicketAction:perform()
    ISBaseTimedAction.perform(self);
    self:rollForLoot();
end

function DLOpenLootTicketAction:new(item)
    local o = {};
	setmetatable(o, self);
	self.__index = self;
    o.character = getPlayer(); -- Required for an ISBaseTimedAction to work.
    o.stopOnWalk = true;
    o.item = item;
    o.maxTime = 300;
	return o;
end

