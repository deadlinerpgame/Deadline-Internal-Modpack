LogLineUtils = {};

function LogLineUtils.JavaArrayToTable(javaTable)
    if not javaTable then return {} end;

    local returnTable = {};

    for i = 0, javaTable:size() - 1 do
        table.insert(returnTable, javaTable:get(i));
    end

    return returnTable;
end

function LogLineUtils.PlayerCoordsStr(player)
    if not player then return end;

    local coordsStr = string.format("[%0d,%0d,%0d]", player:getX(), player:getY(), player:getZ());
    return coordsStr;
end

function LogLineUtils.ItemToDictKey(item)
    if not item then return nil end;

    return string.format("%s|%s", item:getFullType(), item:getName());
end

function LogLineUtils.ItemListToAmountDict(itemList)
    if not itemList then return nil end;

    local returnList = {};

    for i, v in ipairs(itemList) do
        local item = itemList[i];
        if item then
            local itemType = LogLineUtils.ItemToDictKey(item);

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
                local newStr = string.format("%s [%0dx%s]", returnStr, count, k);
                returnStr = newStr;
            end
        else
            local tableHeader = string.format(" ([%s]: %s) |", k, LogLineUtils.ParseAmountDict(v, ""));
            returnStr = returnStr .. tableHeader;
        end
    end

    return returnStr;
end

function LogLineUtils.LogSingleItem(item)
    if not item then return nil end;

    return string.format("%s [%s]", item:getFullType(), item:getName());
end

function LogLineUtils.ContainerToLogStr(container)
    if not container then return "" end;

    local returnStr = "";

    if instanceof(container, "ItemContainer") then
        if container:getType() == "floor" then

            local square = getPlayer():getCurrentSquare();
            return string.format("floor (%0d,%0d,%0d)", square:getX(), square:getY(), square:getZ());
        end

        if container:getParent() then
            local parent = container:getParent();

            if instanceof(parent, "IsoPlayer") then
                if parent:getSteamID() then
                    local steamIDString = parent:getSteamID();
                    return string.format("%s (SID: %s)", parent:getUsername(), steamIDString);
                end

                return string.format("%s (NO STEAM)", parent:getUsername());
            end

            if instanceof(parent, "IsoObject") then
                local x = parent:getX();
                local y = parent:getY();
                local z = parent:getZ();

                local objName = "[cannot find obj name]";
                if container:getVehiclePart() then
                    if container:getVehiclePart():getVehicle() then
                        objName = container:getVehiclePart():getVehicle():getScript():getName();
                    end
                else
                    objName = parent:getSprite():getName() or parent:getSprite():getParentObjectName();
                end

                if not x or not y or not z then
                    return string.format("%s (invalid pos ContainerToLogStr)", objName);
                end

                if instanceof(parent, "IsoDeadBody") then
                    objName = "corpse (";

                    if parent:isZombie() then
                        objName = objName .. "zombie";
                    end

                    if parent:isPlayer() then
                        objName = objName .. "player";
                    end

                    objName = objName .. ")";
                end
 
                return string.format("%s (%0d,%0d,%0d)", objName or "INVALID_OBJ_NAME", x, y, z);
            end
        else
            if container:isInCharacterInventory(getPlayer()) then
                return string.format("%s [inv, %0d,%0d,%0d]", container:getType(), getPlayer():getX(), getPlayer():getY(), getPlayer():getZ());
            else
                if container:getSourceGrid() then
                    local srcGrid = container:getSourceGrid();
                    return string.format("%s (%0d,%0d,%0d)", container:getType(), srcGrid:getX(), srcGrid:getY(), srcGrid:getZ());
                else
                    return string.format("%s", container:getType());
                end
            end
        end
    end

    return container:getType();
end


function LogLineUtils.LogFromClient(prefix, string)
    sendClientCommand("LogLine", "LogClient", { prefix = prefix, message = string });
end

return LogLineUtils;