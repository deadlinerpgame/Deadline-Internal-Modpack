require "StaffSealSystem/SSS_Shared"
require "StaffSealSystem/SSS_ClientActions"
require "StaffSealSystem/SSS_Toolbar"
require "ISUI/ISPanel"
require "ISUI/ISInventoryPaneContextMenu"
require "ISUI/ISInventoryPage"
require "TimedActions/ISInventoryTransferAction"
require "TimedActions/ISGrabItemAction"

-- Convenience accessor for the local player object.
local function _localPlayer()
    if getPlayer then
        return getPlayer()
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

-- Route item-seal changes through server command in MP, direct write in SP.
local function _sendItemSealCommand(item, shouldSeal)
    StaffSealSystem.sendItemSealCommand(item, shouldSeal)
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

    local sealed = StaffSealSystem.itemIsSealed(item)
    if sealed then
        context:addOption("Staff Seal: Unseal Item", item, function(target)
            _sendItemSealCommand(target, false)
        end)
    else
        context:addOption("Staff Seal: Seal Item", item, function(target)
            _sendItemSealCommand(target, true)
        end)
    end
end

-- Player-facing feedback when a transfer is denied.
local function _sayBlocked()
    -- Intentionally silent: restriction feedback is shown through blocked action behavior and logs.
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
        StaffSealSystem.log("Context hook: found container target at " .. StaffSealSystem.getObjectPosition(object) .. " staff=" .. tostring(isStaff))
    else
        StaffSealSystem.log("Context hook: no container target found staff=" .. tostring(isStaff))
    end

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
            _sayBlocked()
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
            _sayBlocked()
            self:stop()
            return false
        end

        return vanillaGrabIsValid(self)
    end

    local vanillaSetNewContainer = ISInventoryPage.setNewContainer
    ISInventoryPage.setNewContainer = function(self, inventory)
        local player = getSpecificPlayer and getSpecificPlayer(self.player) or _localPlayer()
        if _isBlockedContainerView(inventory, player) then
            vanillaSetNewContainer(self, inventory)
            self.title = "Sealed"
            _setLootViewBlockedState(self, true)
            return
        end

        _setLootViewBlockedState(self, false)
        return vanillaSetNewContainer(self, inventory)
    end

    if not StaffSealSystem._clientContainerEventsInstalled then
        Events.OnContainerUpdate.Add(_refreshAllLootViews)
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
end)
StaffSealSystem._clientBootEventRegistered = true
end
