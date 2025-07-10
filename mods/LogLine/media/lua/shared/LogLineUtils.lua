LogLineUtils = {};

--[[
        Iterates through each item in the given container, and, if it is a container, recursively calls this function again.
--]]
function LogLineUtils.RecursiveItemLog(parentContainer, outputTable)
    if not parentContainer then return end;

    -- Make sure that the type is in the array, e.g. ["Base.MilitaryBackpack"].
    local parentType = parentContainer:getFullType();
    if not outputTable[parentType] then
        outputTable[parentType] = {};
    end

    local inventory = parentContainer:getContainer() or parentContainer:getInventory();
    if not inventory then return end; -- Means it's not a container or a player inv.

    local items = inventory:getItems();
    if not items or #items == 0 then return outputTable end;

    for i, v in ipairs(items) do
        local item = items[i];
        local itemType = item:getFullType();
        
        if item:IsInventoryContainer() then
            LogLineUtils.RecursiveItemLog(item, outputTable[parentType]);
        else
            if not outputTable[parentType][itemType] then
                outputTable[parentType][itemType] = 1;
            else
                outputTable[parentType][itemType] = countTable[itemType] + 1;
            end
        end
    end
end

--[[
        Takes a list of items, e.g. { Base.Log, Base.Log, Base.KitchenKnife }.
        Condenses it into a dictionary of items and their amount, e.g:
            - ["Base.Log"] = 2
            - ["Base.KitchenKnife"] = 1

        Run LogLineUtils.ParseAmountDict to turn this into a human readable string.
--]]
function LogLineUtils.ItemListToAmountDict(itemList)
    if not itemList then return nil end; -- Distinction needed in return values between nil and empty. Allows better error handling and debugging. 

    local returnList = {};

    for i, v in ipairs(itemList) do
        local item = itemList[i];
        if item then
            local itemType = item:getFullType(); -- Use GetFullType to differentiate similar items.

            if not returnList[itemType] then
                returnList[itemType] = 1;
            else
                returnList[itemType] = returnList[itemType] + 1;
            end
        end
    end

    return returnList;
end

function LogLineUtils.ParseAmountDict(dict)
    if not dict then return nil end;

    local returnString = "";
    for k, v in pairs(dict) do
        local count = dict[k];

        if count then
            local newStr = string.format("%s | [%s: %0d]", returnString, k, count);
            returnString = newStr;
        end
    end

    return returnString;
end

function LogLineUtils.PlayerCoordsStr(player)
    if not player then return "[POS - INVALID PLAYER]" end;

    return string.format("X: %0d, Y: %0d, Z: %0d", player:getX(), player:getY(), player:getZ());
end

function LogLineUtils.LogFromClient(prefix, string)
    sendClientCommand("LogLine", "LogClient", { prefix = prefix, message = string });
end

return LogLineUtils;