LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

if isServer() then return end;



--[[
        This logs items given and received via a trade. 
        As it is clientside based, it will create 2 logs, one for each party in the search.
        If there is a discrepancy in the two entries, there is a problem.
--]] 
local original_ISFinalizeDealAction_perform = ISFinalizeDealAction.perform;
function ISFinalizeDealAction:perform()
    original_ISFinalizeDealAction_perform(self);

    local receiverName = "RECEIVER_INVALID";
    local receiverPos = {};
    if self.character then
        receiverName = self.character:getUsername();
    end

    local giverName = "GIVER_INVALID";
    if self.otherPlayer then
        giverName = self.otherPlayer:getUsername();
    end

    local giveList = {};
    if self.itemsToGive then
        giveList = LogLineUtils.ItemListToAmountDict(self.itemsToGive);
    end

    local receiveList = {};
    if self.itemsToReceive then
        receiveList = LogLineUtils.ItemListToAmountDict(self.itemsToReceive);
    end

    local logStr = string.format("Player %s [%s] finalized trade with %s [%s]", receiverName, LogLineUtils.PlayerCoordsStr(self.character), giverName, LogLineUtils.PlayerCoordsStr(self.otherPlayer));
    LogLineUtils.LogFromClient("Trade", logStr);

    local receiveString = "";
    local giveString = "";
    local parsedReceiveList = LogLineUtils.ParseAmountDict(receiveList, receiveString);
    local parsedGiveList = LogLineUtils.ParseAmountDict(giveList, giveString)

    logStr = string.format(" --> Player %s has received: %s", receiverName, parsedReceiveList);
    LogLineUtils.LogFromClient("Trade", logStr);
    
    logStr = string.format(" --> Player %s has given: %s", receiverName, parsedGiveList);
    LogLineUtils.LogFromClient("Trade", logStr);
end
