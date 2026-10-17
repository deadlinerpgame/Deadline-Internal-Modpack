require "DL_NoZombieGuns"

local function stripCorpse(container)
    local body = container:getParent()
    if not instanceof(body, "IsoDeadBody") or not body:isZombie() then return false end
    local found = DLNoZombieGuns.collect(container, {})
    for _, entry in ipairs(found) do
        if body:getPrimaryHandItem() == entry.item then body:setPrimaryHandItem(nil) end
        if body:getSecondaryHandItem() == entry.item then body:setSecondaryHandItem(nil) end
        body:getAttachedItems():remove(entry.item)
        entry.container:removeItemOnServer(entry.item)
        entry.container:DoRemoveItem(entry.item)
    end
    return #found > 0
end

local function onRefreshInventoryWindowContainers(page, state)
    if state ~= "end" then return end
    for _, button in ipairs(page.backpacks) do
        if stripCorpse(button.inventory) then
            ISInventoryPage.renderDirty = true
        end
    end
end

Events.OnRefreshInventoryWindowContainers.Add(onRefreshInventoryWindowContainers)
