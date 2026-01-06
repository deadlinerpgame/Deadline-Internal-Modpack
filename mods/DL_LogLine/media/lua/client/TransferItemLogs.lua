LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

if isServer() then return end;

TransferMechanisms = {
    FromPlayer = 0,
    ToPlayer = 1,
}

local original_ISDropWorldItemAction_perform = ISDropWorldItemAction.perform;
function ISDropWorldItemAction:perform()
    original_ISDropWorldItemAction_perform(self);

    local srcStr = LogLineUtils.ContainerToLogStr(self.item) or "";
    local locationStr = string.format("(%0d,%0d,%0d)", self.xoffset, self.yoffset, self.zoffset);
    local logStr = string.format("[%s] Item: %s | From: %s | To: floor %s", self.character:getUsername(), srcStr, self.character:getUsername(), locationStr);

    print(logStr);
    LogLineUtils.LogFromClient("ItemTransfer", logStr);
end

local original_ISInventoryTransferAction_perform = ISInventoryTransferAction.perform;
function ISInventoryTransferAction:perform()
    original_ISInventoryTransferAction_perform(self);

    if not self.item then return end;
    if not self.srcContainer then return end;
    if not self.destContainer then return end;

    local srcStr = LogLineUtils.ContainerToLogStr(self.srcContainer) or "";
    local destStr = LogLineUtils.ContainerToLogStr(self.destContainer) or "";

    local transferStr = "";
    if instanceof(self.item, "InventoryContainer") and self.item:getItemContainer() then
        local items = {};
        local container = self.item:getItemContainer();
        local containerItems = container:getItems();

        for i = 0, containerItems:size() - 1 do
            local iteratedItem = containerItems:get(i);
            if iteratedItem then
                table.insert(items, iteratedItem);
            end
        end

        local amountDict = LogLineUtils.ItemListToAmountDict(items);
        if not amountDict then 
            transferStr = string.format("%s (INVALID_CONTAINER_AMT_DICT)", self.item:getFullType()); 
        else
            local parsedAmountDict = LogLineUtils.ParseAmountDict(amountDict);
            transferStr = string.format("[%s] Item: %s (%s) | From: %s | To: %s", getPlayer():getUsername(), LogLineUtils.LogSingleItem(self.item), parsedAmountDict, srcStr, destStr);
        end
    else
        transferStr = string.format("[%s] Item: %s | From: %s | To: %s", getPlayer():getUsername(), LogLineUtils.LogSingleItem(self.item) or str(self.item), srcStr or " INVALID SRC STR", destStr or " INVALID DEST STR");
    end

    print(transferStr);
    LogLineUtils.LogFromClient("ItemTransfer", transferStr);
end