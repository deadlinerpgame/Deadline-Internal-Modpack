require "StaffSealSystem/SSS_Shared"
require "StaffSealSystem/SSS_ClientActions"
require "StaffSealSystem/SSS_Toolbar"
require "ISUI/ISPanel"
require "ISUI/ISInventoryPaneContextMenu"
require "ISUI/ISInventoryPane"
require "ISUI/ISInventoryPage"
require "TimedActions/ISInventoryTransferAction"
require "TimedActions/ISGrabItemAction"
require "TimedActions/ISCraftAction"

-- Convenience accessor for the local player object.
local function _localPlayer()
    if getPlayer then
        local p = getPlayer()
        if p then
            return p
        end
    end

    if getSpecificPlayer then
        local p0 = getSpecificPlayer(0)
        if p0 then
            return p0
        end
    end

    return nil
end

-- Read world object entries from either Lua arrays or Java-backed collections.
local function _getWorldObject(worldObjects, oneBasedIndex)
    if not worldObjects then
        return nil
    end

    local obj = worldObjects[oneBasedIndex]
    if not obj and worldObjects.get then
        obj = worldObjects:get(oneBasedIndex - 1)
    end

    return obj
end

-- Best-effort resolve of the clicked world object that owns a container.
local function _resolveContainerObject(worldObjects)
    if not worldObjects then
        return nil
    end

    -- Support both Lua tables and Java-backed collections.
    local count = #worldObjects
    if count == 0 and worldObjects.size then
        count = worldObjects:size()
    end

    if count == 0 then
        return nil
    end

    for i = 1, count do
        local obj = _getWorldObject(worldObjects, i)
        if StaffSealSystem.objectHasContainers(obj) then
            return obj
        end
    end

    -- Some context entries are proxy objects; fall back to square scan.
    local first = _getWorldObject(worldObjects, 1)
    local square = first and first.getSquare and first:getSquare() or nil
    if square then
        local objects = square:getObjects()
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if StaffSealSystem.objectHasContainers(obj) then
                return obj
            end
        end
    end

    return nil
end

-- Check if a transfer should be blocked because the source is sealed.
local function _isBlockedTransfer(item, srcContainer, destContainer, character)
    if StaffSealSystem.isStaff(character) then
        return false
    end

    if item and StaffSealSystem.itemIsSealed(item) then
        local who = StaffSealSystem.getPlayerName(character)
        local fullType = item.getFullType and item:getFullType() or "unknown"
        StaffSealSystem.log("Denied transfer for " .. who .. " item=" .. tostring(fullType) .. " because item is sealed")
        return true
    end

    local sourceParent = srcContainer and srcContainer.getParent and srcContainer:getParent() or nil
    if sourceParent and StaffSealSystem.objectIsSealed(sourceParent) then
        local who = StaffSealSystem.getPlayerName(character)
        local fullType = item and item.getFullType and item:getFullType() or "unknown"
        StaffSealSystem.log("Denied transfer for " .. who .. " item=" .. tostring(fullType) .. " from sealed container at " .. StaffSealSystem.getObjectPosition(sourceParent))
        return true
    end

    local destParent = destContainer and destContainer.getParent and destContainer:getParent() or nil
    if destParent and StaffSealSystem.objectIsSealed(destParent) then
        local who = StaffSealSystem.getPlayerName(character)
        local fullType = item and item.getFullType and item:getFullType() or "unknown"
        StaffSealSystem.log("Denied transfer for " .. who .. " item=" .. tostring(fullType) .. " into sealed container at " .. StaffSealSystem.getObjectPosition(destParent))
        return true
    end

    return false
end

local function _isMannequinMoveableItem(item)
    if not item then
        return false
    end

    local fullType = item.getFullType and string.lower(tostring(item:getFullType() or "")) or ""
    if fullType == "base.mov_mannequinmale" or fullType == "base.mov_mannequinfemale" then
        return true
    end

    local t = item.getType and string.lower(tostring(item:getType() or "")) or ""
    if t == "mov_mannequinmale" or t == "mov_mannequinfemale" then
        return true
    end

    local ws = item.getWorldSprite and string.lower(tostring(item:getWorldSprite() or "")) or ""
    if ws ~= "" and string.find(ws, "mannequin", 1, true) ~= nil then
        return true
    end

    return false
end

local function _isMannequinMovableRecipe(recipe, item)
    if not recipe or not (instanceof and instanceof(recipe, "MovableRecipe")) then
        return false
    end

    if _isMannequinMoveableItem(item) then
        return true
    end

    local ws = recipe.getWorldSprite and string.lower(tostring(recipe:getWorldSprite() or "")) or ""
    if ws ~= "" and string.find(ws, "mannequin", 1, true) ~= nil then
        return true
    end

    local name = recipe.getName and string.lower(tostring(recipe:getName() or "")) or ""
    if name ~= "" and string.find(name, "mannequin", 1, true) ~= nil then
        return true
    end

    return false
end

local function _isItemFromSealedSource(item)
    if not item then
        return false
    end

    if StaffSealSystem.itemIsSealed(item) then
        return true
    end

    local src = item.getContainer and item:getContainer() or nil
    local parent = src and src.getParent and src:getParent() or nil
    return parent and StaffSealSystem.objectIsSealed(parent) or false
end

local function _hasSealedContainerParent(containers)
    if not containers then
        return false
    end

    if type(containers) == "table" then
        for i = 1, #containers do
            local c = containers[i]
            local p = c and c.getParent and c:getParent() or nil
            if p and StaffSealSystem.objectIsSealed(p) then
                return true
            end
        end
        return false
    end

    if containers.size and containers.get then
        for i = 0, containers:size() - 1 do
            local c = containers:get(i)
            local p = c and c.getParent and c:getParent() or nil
            if p and StaffSealSystem.objectIsSealed(p) then
                return true
            end
        end
    end

    return false
end

local function _isBlockedCraftAction(action)
    local character = action and action.character or nil
    if StaffSealSystem.isStaff(character) then
        return false
    end

    if _isItemFromSealedSource(action and action.item or nil) then
        return true
    end

    local recipe = action and action.recipe or nil

    if _hasSealedContainerParent(action and action.containers or nil) then
        return true
    end

    if not recipe or not recipe.getSource or not RecipeManager or not RecipeManager.getSourceItemsNeeded then
        return false
    end

    local sources = recipe:getSource()
    if not sources or not sources.size then
        return false
    end

    for i = 0, sources:size() - 1 do
        local items = RecipeManager.getSourceItemsNeeded(recipe, i, character, action.containers, action.item, nil, nil)
        if items then
            if type(items) == "table" then
                for j = 1, #items do
                    if _isItemFromSealedSource(items[j]) then
                        return true
                    end
                end
            elseif items.size and items.get then
                for j = 0, items:size() - 1 do
                    if _isItemFromSealedSource(items:get(j)) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

-- Route item-seal changes through server command in MP, direct write in SP.
local function _sendItemSealCommand(item, shouldSeal)
    StaffSealSystem.sendItemSealCommand(item, shouldSeal)
end

-- Send seal/unseal for multiple selected items (deduped by item id).
local function _sendItemSealBatch(items, shouldSeal)
    if not items or #items == 0 then
        return
    end

    local seen = {}
    for i = 1, #items do
        local item = items[i]
        local id = item and item.getID and item:getID() or nil
        local key = id or item
        if item and not seen[key] then
            seen[key] = true
            _sendItemSealCommand(item, shouldSeal)
        end
    end
end

-- True if a loot container should not be viewable for this player.
local function _isBlockedContainerView(inventory, player)
    if not inventory or StaffSealSystem.isStaff(player) then
        return false
    end

    if inventory.getType and inventory:getType() == "floor" then
        return false
    end

    local parent = inventory.getParent and inventory:getParent() or nil
    return parent and StaffSealSystem.objectIsSealed(parent)
end

-- Apply visual/access lock state to the loot window.
local function _setLootViewBlockedState(page, blocked)
    if not page then
        return
    end

    local function _ensurePaneOverlay(pane)
        if not pane or pane.SSS_Overlay then
            return
        end

        local y = pane.headerHgt or 0
        local overlay = ISPanel:new(0, y, pane.width, math.max(1, pane.height - y))
        overlay:initialise()
        overlay:instantiate()
        overlay.anchorLeft = true
        overlay.anchorRight = true
        overlay.anchorTop = true
        overlay.anchorBottom = true
        overlay.background = false

        overlay.prerender = function(self)
            self:drawRect(0, 0, self.width, self.height, 0.78, 0.05, 0.05, 0.05)
            self:drawRectBorder(0, 0, self.width, self.height, 0.85, 0.92, 0.28, 0.28)
        end

        overlay.render = function(self)
            self:drawTextCentre("SEALED", self.width / 2, (self.height / 2) - 18, 0.98, 0.35, 0.35, 1.0, UIFont.Medium)
            self:drawTextCentre("Staff-only access", self.width / 2, (self.height / 2) + 8, 0.92, 0.92, 0.92, 1.0, UIFont.Small)
        end

        pane:addChild(overlay)
        overlay:setVisible(false)
        pane.SSS_Overlay = overlay
    end

    local wasBlocked = page.SSS_SealedView == true
    page.SSS_SealedView = blocked == true
    if page.lootAll then
        page.lootAll.enable = not page.SSS_SealedView
    end

    -- Keep the sealed indicator inside the inventory pane header area.
    local pane = page.inventoryPane
    if pane and pane.nameHeader and pane.typeHeader then
        _ensurePaneOverlay(pane)
        if page.SSS_SealedView then
            pane.nameHeader:setTitle("SEALED")
            pane.typeHeader:setTitle("Staff-only access")
            pane.nameHeader.enable = false
            pane.typeHeader.enable = false
            if pane.SSS_Overlay then
                pane.SSS_Overlay:setVisible(true)
                pane.SSS_Overlay:bringToTop()
            end
        else
            pane.nameHeader:setTitle(getText("IGUI_invpanel_Type"))
            pane.typeHeader:setTitle(getText("IGUI_invpanel_Category"))
            pane.nameHeader.enable = true
            pane.typeHeader.enable = true
            if pane.SSS_Overlay then
                pane.SSS_Overlay:setVisible(false)
            end
        end
    end

    if wasBlocked and not page.SSS_SealedView then
        page.SSS_SealedWarned = false
    end
end

-- Keep sealed-container loot pages blocked even when vanilla paths reselect containers.
local function _enforceSealedLootView(playerNum)
    local lootPage = getPlayerLoot and getPlayerLoot(playerNum) or nil
    if not lootPage then
        return
    end

    local player = getSpecificPlayer and getSpecificPlayer(playerNum) or _localPlayer()
    local inventory = lootPage.inventory
    if _isBlockedContainerView(inventory, player) then
        lootPage.title = "Sealed"
        _setLootViewBlockedState(lootPage, true)
    elseif lootPage.SSS_SealedView then
        _setLootViewBlockedState(lootPage, false)
    end
end

-- Refresh all active loot views using event-driven triggers instead of per-frame polling.
local function _refreshAllLootViews()
    local maxPlayers = (getNumActivePlayers and getNumActivePlayers() or 1) - 1
    if maxPlayers < 0 then
        maxPlayers = 0
    end

    for pNum = 0, maxPlayers do
        _enforceSealedLootView(pNum)
    end
end

local _containerHighlights = {}
local _containerHighlightState = {
    force = true,
    lastScanMs = 0,
    lastX = nil,
    lastY = nil,
    lastZ = nil,
    tick = 0,
}

local function _requestHighlightRefresh()
    _containerHighlightState.force = true
end

StaffSealSystem.requestHighlightRefresh = _requestHighlightRefresh

local function _setObjectHighlight(obj, enabled)
    if not obj then
        return
    end

    if enabled then
        if obj.setHighlightColor then
            pcall(function()
                obj:setHighlightColor(0.95, 0.20, 0.20, 0.92)
            end)
        end
        if obj.setOutlineHighlight then
            pcall(function()
                obj:setOutlineHighlight(true)
            end)
        end
        if obj.setOutlineHighlightCol then
            pcall(function()
                obj:setOutlineHighlightCol(0.95, 0.20, 0.20, 1.0)
            end)
        end
        if obj.setHighlighted then
            local ok = pcall(function()
                obj:setHighlighted(true, false)
            end)
            if not ok then
                pcall(function()
                    obj:setHighlighted(true)
                end)
            end
        end
    else
        if obj.setOutlineHighlight then
            pcall(function()
                obj:setOutlineHighlight(false)
            end)
        end
        if obj.setHighlighted then
            local ok = pcall(function()
                obj:setHighlighted(false, false)
            end)
            if not ok then
                pcall(function()
                    obj:setHighlighted(false)
                end)
            end
        end
    end
end

local function _refreshNearbySealedContainerHighlights(player)
    if not player or not StaffSealSystem.isStaff(player) then
        for obj, _ in pairs(_containerHighlights) do
            _setObjectHighlight(obj, false)
        end
        _containerHighlights = {}
        return
    end

    local cell = getCell and getCell() or nil
    if not cell then
        return
    end

    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())
    local radius = 12
    local radiusSq = radius * radius
    local keep = {}

    for dy = -radius, radius do
        for dx = -radius, radius do
            if (dx * dx + dy * dy) <= radiusSq then
                local sq = cell:getGridSquare(px + dx, py + dy, pz)
                if sq then
                    local objs = sq:getObjects()
                    for i = 0, objs:size() - 1 do
                        local obj = objs:get(i)
                        if StaffSealSystem.objectHasContainers(obj) and StaffSealSystem.objectIsSealed(obj) then
                            keep[obj] = true
                            _setObjectHighlight(obj, true)
                        end
                    end
                end
            end
        end
    end

    for obj, _ in pairs(_containerHighlights) do
        if not keep[obj] then
            _setObjectHighlight(obj, false)
        end
    end

    _containerHighlights = keep
end

-- Keep currently-selected sealed containers red even if other code reapplies default selection highlight.
local function _refreshSelectedContainerHighlights()
    local player = _localPlayer()
    if not player or not StaffSealSystem.isStaff(player) then
        return
    end

    local pNum = player.getPlayerNum and player:getPlayerNum() or 0
    local pages = {
        getPlayerInventory and getPlayerInventory(pNum) or nil,
        getPlayerLoot and getPlayerLoot(pNum) or nil,
    }

    for i = 1, #pages do
        local page = pages[i]
        local inv = page and page.inventory or nil
        local parent = inv and inv.getParent and inv:getParent() or nil
        if parent and StaffSealSystem.objectIsSealed(parent) then
            _setObjectHighlight(parent, true)
        end
    end
end

local function _entryHasSealedItem(entry)
    if not entry then
        return false
    end

    if StaffSealSystem.itemIsSealed(entry) then
        return true
    end

    local first = entry.item or (entry.getItem and entry:getItem() or nil)
    if first and StaffSealSystem.itemIsSealed(first) then
        return true
    end

    local list = entry.items
    if list then
        if type(list) == "table" then
            for i = 1, #list do
                if StaffSealSystem.itemIsSealed(list[i]) then
                    return true
                end
            end
        elseif list.size and list.get then
            for i = 0, list:size() - 1 do
                if StaffSealSystem.itemIsSealed(list:get(i)) then
                    return true
                end
            end
        end
    end

    return false
end

local function _canSeeSealedRowIndicators(pane, viewer)
    if StaffSealSystem.isStaff(viewer) then
        return true
    end

    local inv = pane and pane.inventory or nil
    if inv and inv.getType and inv:getType() == "floor" then
        return true
    end

    return false
end

-- SEALED indicator paths are intentionally redundant for heavy mod stacks:
-- 1) row-name prefix mutation in refreshContainer (stable data path)
-- 2) pane render overlay text (survives many pane render customizations)
-- 3) OnPostUIDraw screen-space stamp (fallback when pane render is replaced)
-- Keep all three unless a server proves one path is consistently unnecessary.

local function _applySealedRowPrefixes(pane)
    if not pane or not pane.items then
        return
    end

    local rows = pane.items

    local viewer = getSpecificPlayer and getSpecificPlayer(pane.player) or _localPlayer()
    if not _canSeeSealedRowIndicators(pane, viewer) then
        for row = 1, #rows do
            local entry = rows[row]
            if entry and entry.SSS_OriginalName ~= nil then
                entry.name = entry.SSS_OriginalName
            end
        end
        return
    end

    local containerParent = pane.inventory and pane.inventory.getParent and pane.inventory:getParent() or nil
    local containerSealed = containerParent and StaffSealSystem.objectIsSealed(containerParent) or false

    for row = 1, #rows do
        local entry = rows[row]
        local sealed = containerSealed or _entryHasSealedItem(entry)
        if entry and type(entry.name) == "string" then
            if entry.SSS_OriginalName == nil then
                entry.SSS_OriginalName = entry.name
            end

            local baseName = entry.SSS_OriginalName
            if sealed then
                entry.name = "[SEALED] " .. tostring(baseName)
            else
                entry.name = baseName
            end
        end
    end
end

local function _drawInventorySealedStamps(pane)
    if not pane or not pane.items then
        return
    end

    if pane.getIsVisible and not pane:getIsVisible() then
        return
    end

    if pane.mode ~= "details" then
        return
    end

    local viewer = getSpecificPlayer and getSpecificPlayer(pane.player) or _localPlayer()
    if not _canSeeSealedRowIndicators(pane, viewer) then
        return
    end

    local yScroll = pane.getYScroll and pane:getYScroll() or 0
    local rowH = pane.itemHgt or 20
    local paneH = pane.getHeight and pane:getHeight() or 0
    local rows = pane.items
    local containerParent = pane.inventory and pane.inventory.getParent and pane.inventory:getParent() or nil
    local containerSealed = containerParent and StaffSealSystem.objectIsSealed(containerParent) or false

    for row = 1, #rows do
        local entry = rows[row]
        if containerSealed or _entryHasSealedItem(entry) then
            local rowY = pane.headerHgt + ((row - 1) * rowH) + yScroll
            if rowY + rowH >= 0 and rowY <= paneH then
                local stampX = 72
                pane:drawText("[SEALED]", stampX + 1, rowY + 3, 0.0, 0.0, 0.0, 0.95, UIFont.Small)
                pane:drawText("[SEALED]", stampX, rowY + 2, 0.98, 0.24, 0.24, 1.0, UIFont.Small)
            end
        end
    end
end

local function _drawInventorySealedStampsOnScreen(pane)
    if not pane or not pane.items then
        return
    end

    if pane.getIsVisible and not pane:getIsVisible() then
        return
    end

    local viewer = getSpecificPlayer and getSpecificPlayer(pane.player) or _localPlayer()
    if not _canSeeSealedRowIndicators(pane, viewer) then
        return
    end

    local absX = pane.getAbsoluteX and pane:getAbsoluteX() or pane.x
    local absY = pane.getAbsoluteY and pane:getAbsoluteY() or pane.y
    local yScroll = pane.getYScroll and pane:getYScroll() or 0
    local rowH = pane.itemHgt or 20
    local paneH = pane.getHeight and pane:getHeight() or 0
    local rows = pane.items
    local containerParent = pane.inventory and pane.inventory.getParent and pane.inventory:getParent() or nil
    local containerSealed = containerParent and StaffSealSystem.objectIsSealed(containerParent) or false

    for row = 1, #rows do
        local entry = rows[row]
        if containerSealed or _entryHasSealedItem(entry) then
            local rowY = pane.headerHgt + ((row - 1) * rowH) + yScroll
            if rowY + rowH >= 0 and rowY <= paneH then
                local stampX = 72
                getTextManager():DrawString(UIFont.Small, absX + stampX + 1, absY + rowY + 3, "[SEALED]", 0.0, 0.0, 0.0, 0.95)
                getTextManager():DrawString(UIFont.Small, absX + stampX, absY + rowY + 2, "[SEALED]", 0.98, 0.24, 0.24, 1.0)
            end
        end
    end
end

local _drawVisibleInventorySealedStamps

local function _installPostUIDrawSealedStampEvent()
    if StaffSealSystem._sealedStampPostDrawInstalled then
        return
    end

    Events.OnPostUIDraw.Add(_drawVisibleInventorySealedStamps)
    StaffSealSystem._sealedStampPostDrawInstalled = true
end

_drawVisibleInventorySealedStamps = function()
    local player = _localPlayer()
    if not player then
        return
    end

    local pNum = player.getPlayerNum and player:getPlayerNum() or 0
    local invPage = getPlayerInventory and getPlayerInventory(pNum) or nil
    local lootPage = getPlayerLoot and getPlayerLoot(pNum) or nil
    local targets = {
        {
            page = invPage,
            pane = invPage and invPage.inventoryPane or nil,
        },
        {
            page = lootPage,
            pane = lootPage and lootPage.inventoryPane or nil,
        },
    }

    for i = 1, #targets do
        local target = targets[i]
        local page = target and target.page or nil
        local pane = target and target.pane or nil
        local pageVisible = true
        if page then
            if page.getIsVisible then
                pageVisible = page:getIsVisible() == true
            elseif page.isVisible ~= nil then
                pageVisible = page.isVisible == true
            end

            if page.isCollapsed ~= nil and page.isCollapsed == true then
                pageVisible = false
            end
        else
            pageVisible = false
        end

        if pageVisible and pane then
            _drawInventorySealedStampsOnScreen(pane)
        end
    end
end

local function _installInventorySealedStampHook()
    if StaffSealSystem._inventoryStampHookInstalled and ISInventoryPane.render == StaffSealSystem._inventoryStampHook then
        return
    end

    local vanillaRender = ISInventoryPane.render
    local stampedRender = function(self)
        vanillaRender(self)
        _drawInventorySealedStamps(self)
    end

    ISInventoryPane.render = stampedRender
    StaffSealSystem._inventoryStampHook = stampedRender
    StaffSealSystem._inventoryStampHookInstalled = true
end

-- Convert inventory context selection wrappers to raw InventoryItem instances.
local function _unwrapInventoryItems(items)
    local out = {}
    if not items then
        return out
    end

    for _, entry in pairs(items) do
        if instanceof and instanceof(entry, "InventoryItem") then
            table.insert(out, entry)
        elseif entry and entry.items and type(entry.items) == "table" then
            for _, sub in ipairs(entry.items) do
                if instanceof and instanceof(sub, "InventoryItem") then
                    table.insert(out, sub)
                end
            end
        end
    end

    return out
end

-- Staff item options shown in inventory context menu (loot panel + inventory panel).
local function _addInventoryContextOptions(playerNum, context, items)
    local player = getSpecificPlayer and getSpecificPlayer(playerNum) or _localPlayer()
    local isStaff = StaffSealSystem.isStaff(player)
    local selectedItems = _unwrapInventoryItems(items)
    local item = selectedItems[1]
    if not item then
        return
    end

    if not isStaff then
        return
    end

    local shouldSeal = not StaffSealSystem.itemIsSealed(item)
    local label = shouldSeal and "Staff Seal: Seal Item" or "Staff Seal: Unseal Item"
    context:addOption(label, selectedItems, function(targets)
        _sendItemSealBatch(targets, shouldSeal)
    end)
end

-- Player-facing feedback when a transfer is denied.
local function _sayBlocked(character)
    local player = character or _localPlayer()
    if not player or not player.setHaloNote then
        return
    end

    local now = getTimestampMs and getTimestampMs() or 0
    local last = StaffSealSystem._blockedHaloAt or 0
    if now > 0 and (now - last) < 1200 then
        return
    end

    StaffSealSystem._blockedHaloAt = now
    player:setHaloNote("Sealed by staff", 220, 80, 80, 160)
end

-- Dedicated feedback when mannequin dismantle is blocked.
local function _sayMannequinBlocked(character)
    local player = character or _localPlayer()
    if not player or not player.setHaloNote then
        return
    end

    local now = getTimestampMs and getTimestampMs() or 0
    local last = StaffSealSystem._mannequinBlockedHaloAt or 0
    if now > 0 and (now - last) < 1200 then
        return
    end

    StaffSealSystem._mannequinBlockedHaloAt = now
    player:setHaloNote("DO NOT TOUCH THE MANNEQUIN", 240, 80, 80, 180)
end

-- Route seal changes through server command in MP, direct write in SP.
local function _sendSealCommand(object, shouldSeal)
    StaffSealSystem.sendContainerSealCommand(object, shouldSeal)
end

-- Staff-only context options to seal/unseal the first container in target list.
local function _addContextOptions(playerNum, context, worldObjects)
    local player = getSpecificPlayer and getSpecificPlayer(playerNum) or _localPlayer()
    local isStaff = StaffSealSystem.isStaff(player)

    if not isStaff then
        return
    end

    local object = _resolveContainerObject(worldObjects)

    if object then
        local sealed = StaffSealSystem.objectIsSealed(object)
        if sealed then
            context:addOption("Staff Seal: Unseal Container", object, function(target)
                _sendSealCommand(target, false)
            end)
        else
            context:addOption("Staff Seal: Seal Container", object, function(target)
                _sendSealCommand(target, true)
            end)
        end
    end
end

if not StaffSealSystem._clientContextHooksInstalled then
    Events.OnFillWorldObjectContextMenu.Add(_addContextOptions)
    Events.OnFillInventoryObjectContextMenu.Add(_addInventoryContextOptions)
    StaffSealSystem._clientContextHooksInstalled = true
end

if not StaffSealSystem._clientMannequinRecipeHookInstalled then
    Events.OnDynamicMovableRecipe.Add(function(_sprite, recipe, item, _player)
        if recipe and _isMannequinMoveableItem(item) then
            recipe:setValid(false)
        end
    end)
    StaffSealSystem._clientMannequinRecipeHookInstalled = true
end

local function _installCraftSuppressionHooks()
    if ISCraftAction and ISCraftAction.isValid then
        if (not StaffSealSystem._craftIsValidPatched) or (ISCraftAction.isValid ~= StaffSealSystem._craftIsValidHook) then
            local vanillaCraftIsValid = ISCraftAction.isValid
            local wrappedCraftIsValid = function(self)
                if _isMannequinMovableRecipe(self and self.recipe or nil, self and self.item or nil) then
                    local who = StaffSealSystem.getPlayerName(self.character)
                    StaffSealSystem.log("Denied mannequin disassembly for " .. who)
                    _sayMannequinBlocked(self.character)
                    self:stop()
                    return false
                end

                if _isBlockedCraftAction(self) then
                    local who = StaffSealSystem.getPlayerName(self.character)
                    local recipeName = self.recipe and self.recipe.getName and self.recipe:getName() or "unknown"
                    StaffSealSystem.log("Denied crafting for " .. who .. " recipe=" .. tostring(recipeName) .. " because source is sealed")
                    _sayBlocked(self.character)
                    self:stop()
                    return false
                end

                return vanillaCraftIsValid(self)
            end

            ISCraftAction.isValid = wrappedCraftIsValid
            StaffSealSystem._craftIsValidHook = wrappedCraftIsValid
            StaffSealSystem._craftIsValidPatched = true
        end
    end

    if ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.OnCraft then
        if (not StaffSealSystem._onCraftPatched) or (ISInventoryPaneContextMenu.OnCraft ~= StaffSealSystem._onCraftHook) then
            local vanillaOnCraft = ISInventoryPaneContextMenu.OnCraft
            local wrappedOnCraft = function(selectedItem, recipe, player, all)
                if _isMannequinMovableRecipe(recipe, selectedItem) then
                    local playerObj = getSpecificPlayer and getSpecificPlayer(player) or _localPlayer()
                    _sayMannequinBlocked(playerObj)
                    return
                end

                return vanillaOnCraft(selectedItem, recipe, player, all)
            end

            ISInventoryPaneContextMenu.OnCraft = wrappedOnCraft
            StaffSealSystem._onCraftHook = wrappedOnCraft
            StaffSealSystem._onCraftPatched = true
        end
    end

    if ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.OnCraftComplete then
        if (not StaffSealSystem._onCraftCompletePatched) or (ISInventoryPaneContextMenu.OnCraftComplete ~= StaffSealSystem._onCraftCompleteHook) then
            local vanillaOnCraftComplete = ISInventoryPaneContextMenu.OnCraftComplete
            local wrappedOnCraftComplete = function(completedAction, recipe, playerObj, container, containers, selectedItemType, selectedItemContainer)
                if _isMannequinMovableRecipe(recipe, completedAction and completedAction.item or nil) then
                    return
                end

                return vanillaOnCraftComplete(completedAction, recipe, playerObj, container, containers, selectedItemType, selectedItemContainer)
            end

            ISInventoryPaneContextMenu.OnCraftComplete = wrappedOnCraftComplete
            StaffSealSystem._onCraftCompleteHook = wrappedOnCraftComplete
            StaffSealSystem._onCraftCompletePatched = true
        end
    end
end

-- Patch core transfer/grab validation so sealed containers cannot be looted.
if not StaffSealSystem._clientBootEventRegistered then
Events.OnGameBoot.Add(function()
    if StaffSealSystem._clientBootPatched then
        return
    end
    StaffSealSystem._clientBootPatched = true

    local vanillaTransferIsValid = ISInventoryTransferAction.isValid
    ISInventoryTransferAction.isValid = function(self)
        if _isBlockedTransfer(self.item, self.srcContainer, self.destContainer, self.character) then
            _sayBlocked(self.character)
            self:stop()
            return false
        end

        return vanillaTransferIsValid(self)
    end

    local vanillaGrabIsValid = ISGrabItemAction.isValid
    ISGrabItemAction.isValid = function(self)
        local item = self.item and self.item.getItem and self.item:getItem() or nil
        local src = item and item.getContainer and item:getContainer() or nil
        if _isBlockedTransfer(item, src, self.character:getInventory(), self.character) then
            _sayBlocked(self.character)
            self:stop()
            return false
        end

        return vanillaGrabIsValid(self)
    end

    _installCraftSuppressionHooks()

    local vanillaSetNewContainer = ISInventoryPage.setNewContainer
    ISInventoryPage.setNewContainer = function(self, inventory)
        local player = getSpecificPlayer and getSpecificPlayer(self.player) or _localPlayer()
        if _isBlockedContainerView(inventory, player) then
            vanillaSetNewContainer(self, inventory)
            self.title = "Sealed"
            _setLootViewBlockedState(self, true)
            _requestHighlightRefresh()
            return
        end

        _setLootViewBlockedState(self, false)
        _requestHighlightRefresh()
        return vanillaSetNewContainer(self, inventory)
    end

    local vanillaPaneRefreshContainer = ISInventoryPane.refreshContainer
    ISInventoryPane.refreshContainer = function(self)
        vanillaPaneRefreshContainer(self)
        _applySealedRowPrefixes(self)
    end

    _installInventorySealedStampHook()
    _installPostUIDrawSealedStampEvent()

    local vanillaInventoryPageUpdate = ISInventoryPage.update
    ISInventoryPage.update = function(self)
        vanillaInventoryPageUpdate(self)

        local viewer = getSpecificPlayer and getSpecificPlayer(self.player) or _localPlayer()
        if not StaffSealSystem.isStaff(viewer) then
            return
        end

        if self.isCollapsed or not self.inventory then
            return
        end

        local parent = self.inventory.getParent and self.inventory:getParent() or nil
        if not parent or not StaffSealSystem.objectIsSealed(parent) then
            return
        end

        -- Re-apply red tint after vanilla container-selection highlight updates.
        if parent.setHighlighted then
            local ok = pcall(function()
                parent:setHighlighted(true, false)
            end)
            if not ok then
                pcall(function()
                    parent:setHighlighted(true)
                end)
            end
        end
        if parent.setHighlightColor then
            pcall(function()
                parent:setHighlightColor(0.95, 0.20, 0.20, 0.92)
            end)
        end
        if parent.setOutlineHighlight then
            pcall(function()
                parent:setOutlineHighlight(true)
            end)
        end
        if parent.setOutlineHighlightCol then
            pcall(function()
                parent:setOutlineHighlightCol(0.95, 0.20, 0.20, 1.0)
            end)
        end
    end

    if not StaffSealSystem._clientContainerEventsInstalled then
        Events.OnContainerUpdate.Add(function()
            _refreshAllLootViews()
        end)
        Events.OnPlayerUpdate.Add(function(player)
            if not player then
                return
            end

            local localPlayer = _localPlayer()
            local playerNum = player.getPlayerNum and player:getPlayerNum() or -1
            local localNum = localPlayer and localPlayer.getPlayerNum and localPlayer:getPlayerNum() or -2
            if playerNum ~= localNum then
                return
            end

            local hookTick = (StaffSealSystem._inventoryStampHookTick or 0) + 1
            StaffSealSystem._inventoryStampHookTick = hookTick
            if (hookTick % 120) == 0 then
                _installInventorySealedStampHook()
            end
            if (hookTick % 240) == 0 then
                _installCraftSuppressionHooks()
            end

            -- Reapply selected-container tint every frame to beat competing highlight writers.
            _refreshSelectedContainerHighlights()

            local px = math.floor(player:getX())
            local py = math.floor(player:getY())
            local pz = math.floor(player:getZ())
            local moved = (_containerHighlightState.lastX ~= px) or (_containerHighlightState.lastY ~= py) or (_containerHighlightState.lastZ ~= pz)
            _containerHighlightState.lastX = px
            _containerHighlightState.lastY = py
            _containerHighlightState.lastZ = pz

            local now = getTimestampMs and getTimestampMs() or 0
            local elapsed = now > 0 and (now - (_containerHighlightState.lastScanMs or 0)) or 0
            local shouldScan = false

            if _containerHighlightState.force then
                shouldScan = true
            elseif now > 0 then
                if moved and elapsed >= 250 then
                    shouldScan = true
                elseif elapsed >= 900 then
                    shouldScan = true
                end
            else
                local tick = (_containerHighlightState.tick or 0) + 1
                _containerHighlightState.tick = tick
                if moved and (tick % 6) == 0 then
                    shouldScan = true
                elseif (tick % 20) == 0 then
                    shouldScan = true
                end
            end

            if shouldScan then
                _refreshNearbySealedContainerHighlights(player)
                _containerHighlightState.force = false
                if now > 0 then
                    _containerHighlightState.lastScanMs = now
                end
            end
        end)
        Events.OnRefreshInventoryWindowContainers.Add(function(page, _phase)
            local pNum = page and page.player
            if pNum ~= nil then
                _enforceSealedLootView(pNum)
            else
                _refreshAllLootViews()
            end
        end)
        StaffSealSystem._clientContainerEventsInstalled = true
    end

    _refreshAllLootViews()
    _refreshNearbySealedContainerHighlights(_localPlayer())
end)
StaffSealSystem._clientBootEventRegistered = true
end

if not StaffSealSystem._sealedStampPostDrawInstalled then
    _installPostUIDrawSealedStampEvent()
end
