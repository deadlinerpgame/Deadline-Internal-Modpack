DLNoZombieGuns = {}

function DLNoZombieGuns.isBanned(fullType)
    local script = getScriptManager():FindItem(fullType)
    if script == nil then return false end
    local itemType = script:getTypeString()
    return (itemType == "Weapon" and script:isRanged()) or itemType == "WeaponPart" or script:getDisplayCategory() == "Ammo"
end

function DLNoZombieGuns.collect(container, found)
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if DLNoZombieGuns.isBanned(item:getFullType()) then
            table.insert(found, { container = container, item = item })
        elseif instanceof(item, "InventoryContainer") then
            DLNoZombieGuns.collect(item:getInventory(), found)
        end
    end
    return found
end

local function keepWeapons(def)
    local kept = {}
    for _, name in ipairs(def.weapons) do
        if not DLNoZombieGuns.isBanned(name) then
            table.insert(kept, name)
        end
    end
    def.weapons = kept
    return #kept > 0
end

local function filterAttachedWeapons()
    for id, def in pairs(AttachedWeaponDefinitions) do
        if id ~= "attachedWeaponCustomOutfit" and type(def) == "table" and def.weapons ~= nil and not keepWeapons(def) then
            def.outfit = { "DLNoZombieGuns" }
            def.daySurvived = nil
            def.chance = 0
        end
    end

    local outfits = AttachedWeaponDefinitions.attachedWeaponCustomOutfit
    local emptyOutfits = {}
    for outfit, custom in pairs(outfits) do
        local kept = {}
        for _, def in ipairs(custom.weapons) do
            if keepWeapons(def) then
                table.insert(kept, def)
            end
        end
        custom.weapons = kept
        if #kept == 0 then
            table.insert(emptyOutfits, outfit)
        end
    end
    for _, outfit in ipairs(emptyOutfits) do
        outfits[outfit] = nil
    end
end

local function onZombieDead(zombie)
    local attached = zombie:getAttachedItems()
    for i = attached:size() - 1, 0, -1 do
        local item = attached:get(i):getItem()
        if DLNoZombieGuns.isBanned(item:getFullType()) then
            zombie:removeAttachedItem(item)
        end
    end
    for _, entry in ipairs(DLNoZombieGuns.collect(zombie:getInventory(), {})) do
        entry.container:DoRemoveItem(entry.item)
    end
end

Events.OnGameBoot.Add(filterAttachedWeapons)
Events.OnZombieDead.Add(onZombieDead)
