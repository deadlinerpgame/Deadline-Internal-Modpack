require "ISRenameEverything";

ISRenameEverything = ISRenameEverything or {};
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};


local original_renameItem_func = ISRenameEverything.onRenameItemClick;
function ISRenameEverything:onRenameItemClick(button, player, item)
    local originalName = item and item:getName() or "";
    original_renameItem_func(self, button, player, item);
    local newName = item and item:getName() or "";

    if originalName == newName then return end; -- Name hasn't changed.

    local coordsStr = string.format("%0d,%0d,%0d", player:getX(), player:getY(), player:getZ());

    local logStr = string.format("[%s] Item %s renamed from %s -> %s (%s)", 
        player:getUsername(), item:getFullType(), originalName, newName, coordsStr);

    LogLineUtils.LogFromClient("ItemRename", logStr);
end


local original_renameStack_func = ISRenameEverything.onRenameStackClick;
function ISRenameEverything:onRenameStackClick(button, player, items)
    -- Get first item and compare the names, because stacks of items are items that share the same name not the same type.
    if not items or items:size() == 0 then return end;

    local firstItem = items:get(0);
    local originalName = firstItem and firstItem:getName() or "";

    original_renameStack_func(self, button, player, items);

    local newName = firstItem:getName();

    if originalName == newName or newName == "" then return end;

    local coordsStr = string.format("%0d,%0d,%0d", player:getX(), player:getY(), player:getZ());
    local logStr = string.format("[%s] Stack renamed from %s > %s (", player:getUsername(), originalName, newName);

    for i = 0, items:size() - 1 do
        local iteratedItem = items:get(i);
        logStr = logStr .. "," .. iteratedItem and iteratedItem:getFullType() or "INVALID_ITEM_IN_STACK";
    end

    logStr = logStr .. string.format(") (POS: %s)", coordsStr);
    LogLineUtils.LogFromClient("ItemRename", logStr);
end