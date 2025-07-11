LogLineUtils = {};

--[[
        Takes a Java ArrayList and returns a Lua table{}.
--]]
function LogLineUtils.JavaArrayToTable(javaTable)
    if not javaTable then return {} end;

    local returnTable = {};

    for i = 0, javaTable:size() - 1 do
        table.insert(returnTable, javaTable:get(i));
    end

    return returnTable;
end

--[[
        Takes a list of items, e.g. { Base.Log, Base.Log, Base.KitchenKnife }.
        Condenses it into a dictionary of items and their amount, e.g:
            - ["Base.Log"] = 2
            - ["Base.KitchenKnife"] = 1
            - ["Base.MilitaryBackpack"] = { "Base.Chocolate", "Base.38Special", ...}

        Run LogLineUtils.ParseAmountDict to turn this into a human readable string.
--]]
function LogLineUtils.ItemListToAmountDict(itemList)
    if not itemList then return nil end; -- Distinction needed in return values between nil and empty. Allows better error handling and debugging. 

    local returnList = {};

    for i, v in ipairs(itemList) do
        local item = itemList[i];
        if item then
            local itemType = item:getFullType(); -- Use GetFullType to differentiate similar items.

            if instanceof(item, "InventoryContainer") then
                local subItems = item:getItemContainer():getItems();
                subItems = LogLineUtils.JavaArrayToTable(subItems);
                returnList[itemType] = LogLineUtils.ItemListToAmountDict(subItems);
            else
                if not returnList[itemType] then
                    returnList[itemType] = 1;
                else
                    returnList[itemType] = returnList[itemType] + 1;
                end
            end
        end
    end

    return returnList;
end

function LogLineUtils.ParseAmountDict(dict, returnStr)
    if not dict then return nil end;

    if not returnStr then returnStr = "" end;

    for k, v in pairs(dict) do
        if type(v) ~= "table" then
            local count = dict[k];

            if count then
                local newStr = string.format("%s [%s: %0d] |", returnStr, k, count);
                returnStr = newStr;
            end
        else
            local tableHeader = string.format("%s [*] %s: %s |", returnStr, k, LogLineUtils.ParseAmountDict(v, returnStr));
            returnStr = tableHeader; -- Update with the container name before recursively iterating through it.
        end
    end

    return returnStr;
end


function LogLineUtils.PlayerCoordsStr(player)
    if not player then return "[POS - INVALID PLAYER]" end;

    return string.format("POS: %0d,%0d,%0d", player:getX(), player:getY(), player:getZ());
end

function LogLineUtils.LogFromClient(prefix, string)
    sendClientCommand("LogLine", "LogClient", { prefix = prefix, message = string });
end

return LogLineUtils;