if not getActivatedMods():contains("WastelandSafezone_DL") then return end

local function onFillWorldObjectContextMenu(playerNum, context)
    local option = context:getOptionFromName(getText("ContextMenu_SafehouseClaim"))
    if not option or option.onSelect ~= WSZ_Menu.onClaimSafehouseFromDef then return end
    local def = option.param2
    if DLSafezoneBounds.allowed(getSpecificPlayer(playerNum), def:getX(), def:getY(), def:getX2(), def:getY2()) then return end
    local toolTip = ISWorldObjectContextMenu.addToolTip()
    toolTip:setVisible(false)
    toolTip.description = DLSafezoneBounds.message
    option.notAvailable = true
    option.toolTip = toolTip
    option.target = nil
    option.onSelect = nil
end

local function patchCreatePanel()
    local validateSelection = WSZ_CreateSafezonePanel.validateSelection
    function WSZ_CreateSafezonePanel:validateSelection()
        local ok, reason = validateSelection(self)
        if not ok then return ok, reason end
        local area = self.areaPicker.value
        if not DLSafezoneBounds.allowed(self.player, area.x1, area.y1, area.x2, area.y2) then
            return false, DLSafezoneBounds.message
        end
        return true, nil
    end
    Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
end

Events.OnGameBoot.Add(patchCreatePanel)
