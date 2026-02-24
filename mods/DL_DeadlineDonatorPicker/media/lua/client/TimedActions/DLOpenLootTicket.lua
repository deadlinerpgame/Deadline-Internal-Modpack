require "TimedActions/ISBaseTimedAction";

require "LogLineUtils";
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

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

    sendClientCommand("LootTicket", "RequestRoll", { ticket = self.item, lootData = lootData });

    --LogLineUtils.LogFromClient("LootTicket", logStr);
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
    o.maxTime = 250;
	return o;
end

