if ISInventoryPaneContextMenu == nil then return end

DLRepair = DLRepair or {}
DLRepair.hideVanillaRepair = true

function DLRepair.vanillaRepairLabels(items)
    local labels = {}
    if items == nil then return labels end
    local prefix = getText("ContextMenu_Repair")
    for _, entry in ipairs(items) do
        local item = entry
        if not instanceof(entry, "InventoryItem") then
            item = nil
            if type(entry) == "table" and entry.items ~= nil then
                item = entry.items[1]
            end
        end
        if item ~= nil then
            labels[#labels + 1] = prefix .. getItemNameFromFullType(item:getFullType())
        end
    end
    return labels
end

function DLRepair.stripVanillaRepair(context, items)
    if context == nil or context.removeOptionByName == nil then return end
    for _, label in ipairs(DLRepair.vanillaRepairLabels(items)) do
        context:removeOptionByName(label)
    end
end

local vanillaCreateMenu = ISInventoryPaneContextMenu.createMenu
ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
    local context = vanillaCreateMenu(player, isInPlayerInventory, items, x, y, origin)
    if DLRepair.hideVanillaRepair then
        DLRepair.stripVanillaRepair(context, items)
    end
    return context
end
