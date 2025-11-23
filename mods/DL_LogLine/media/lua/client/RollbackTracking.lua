LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

LogLine_RollbackTracking = {};

LogLine_RollbackTracking.NextSaveTime = nil;
LogLine_RollbackTracking.HasQueriedConnectionInv = false;

function LogLine_RollbackTracking.getNextSaveTime()
    return getTimestamp() + ZombRandBetween(120, 300);
end

function LogLine_RollbackTracking.LogInventory(event)
    local inventoryMasterTable = LogLineUtils.JavaArrayToTable(getPlayer():getInventory():getItems());
    local invString = LogLineUtils.ParseAmountDict(LogLineUtils.ItemListToAmountDict(inventoryMasterTable));
    local posStr = string.format("[%0d,%0d,%0d]", getPlayer():getX(), getPlayer():getY(), getPlayer():getZ());

    sendClientCommand(getPlayer(), "LogLine", "RollbackInventoryLog", { username = getPlayer():getUsername(), event = event, inventory = invString, pos = posStr });
end

function LogLine_RollbackTracking.EveryOneMinute()

    -- Do save check.
    if not LogLine_RollbackTracking.NextSaveTime then
        local saveTime = LogLine_RollbackTracking.getNextSaveTime();
        print("No save time set - next save time is " .. tostring(saveTime));
        LogLine_RollbackTracking.NextSaveTime = saveTime;
    end

    if getTimestamp() > LogLine_RollbackTracking.NextSaveTime then
        getPlayer():save();
        sendAddedRemovedItems(true);

        local saveTime = LogLine_RollbackTracking.getNextSaveTime();
        print("Next save time is" .. tostring(saveTime));
        LogLine_RollbackTracking.NextSaveTime = saveTime;
        LogLine_RollbackTracking.LogInventory("SAVE");
    end

    if LogLine_RollbackTracking.HasQueriedConnectionInv then return end;
    LogLine_RollbackTracking.LogInventory("CONNECT");
    LogLine_RollbackTracking.HasQueriedConnectionInv = true;
end

function LogLine_RollbackTracking.OnDisconnect()
    -- Send a log of all existing inventory items.

    LogLine_RollbackTracking.LogInventory("DISCONNECT");
end

Events.EveryOneMinute.Add(LogLine_RollbackTracking.EveryOneMinute);
Events.OnDisconnect.Add(LogLine_RollbackTracking.OnDisconnect);

return LogLine_RollbackTracking;