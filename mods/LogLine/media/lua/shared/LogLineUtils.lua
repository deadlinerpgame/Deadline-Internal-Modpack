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
                local newStr = string.format("%s [%0dx%s] |", returnStr, count, k);
                returnStr = newStr;
            end
        else
            local tableHeader = string.format("%s [%s]: %s |", returnStr, k, LogLineUtils.ParseAmountDict(v, returnStr));
            returnStr = tableHeader; -- Update with the container name before recursively iterating through it.
        end
    end

    return returnStr;
end

function LogLineUtils.ContainerToLogStr(container)
    if not container then return "" end;

    local returnStr = "";

    -- Step 1, get the item name.


    -- Step 2, is the item on the floor?

    -- Step 2 i) If on floor, include grid coordinates.

    -- Step 2 ii) If not on floor, get parent object name and grid coordinates.

    if instanceof(container, "ItemContainer") then
        if container:getType() == "floor" then
            -- From ISInventoryTransferAction.lua:
                --[[
                    function ISInventoryTransferAction:getNotFullFloorSquare(item)
	                    local square = self.character:getCurrentSquare()
                        ...
                --]]

            local square = getPlayer():getCurrentSquare();
            -- No need to null check this, if the player DOESN'T have a square then something catastrophic has gone wrong which needs erroring.
            return string.format("floor (%0d,%0d,%0d)", square:getX(), square:getY(), square:getZ());
        end

        if container:getParent() then -- If it has a parent, it's in an object container such as a counter or a fridge, or the
            local parent = container:getParent();

            if instanceof(parent, "IsoPlayer") then
                return string.format("%s %s (U: %s, SID: %s)", parent:getForname(), parent:getSurname(), parent:getUsername(), parent:getSteamID());
            end

            

            if instanceof(parent, "IsoObject") then
                local x = parent:getX();
                local y = parent:getY();
                local z = parent:getZ();

                local objName = parent:getSprite():getName() or parent:getSprite():getParentObjectName() or "[cannot find obj name]";

                if not x or not y or not z then
                    return string.format("%s (invalid pos LogLineUtils.ContainerToLogStr)", objName);
                end

                return string.format("%s (%0d,%0d,%0d)", objName, x, y, z);
            end
        else
            if container:isInCharacterInventory(getPlayer()) then
                return string.format("%s [inv]", container:getType());
            end
        end
    end

    
    

end

function LogLineUtils.LogFromClient(prefix, string)
    sendClientCommand("LogLine", "LogClient", { prefix = prefix, message = string });
end

return LogLineUtils;