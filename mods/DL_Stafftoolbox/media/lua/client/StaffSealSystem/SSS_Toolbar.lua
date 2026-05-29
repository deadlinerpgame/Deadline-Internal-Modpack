require "StaffSealSystem/SSS_Shared"
require "StaffSealSystem/SSS_ClientActions"
require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISScrollingListBox"

StaffSealToolbar = StaffSealToolbar or {}
-- Use numpad '*' for toolbar toggle.
StaffSealToolbar.ToggleKey = Keyboard.KEY_MULTIPLY
StaffSealToolbar.ChatCommand = "/toolbox"

-- Track live toolbar state and the current targeting mode.
StaffSealToolbar._panel = nil
StaffSealToolbar._modeSeal = nil
StaffSealToolbar._sceneEntry = nil
StaffSealToolbar._sceneList = nil
StaffSealToolbar._controls = nil
StaffSealToolbar._width = 580
StaffSealToolbar._height = 420
StaffSealToolbar._sceneScope = "shared"

local function _localPlayer()
    if getPlayer then
        return getPlayer()
    end

    return nil
end

-- Local access check used for toolbar visibility/toggle gating.
local function _isLocalStaff()
    return StaffSealSystem.isStaff(_localPlayer())
end

-- True when the pressed key matches the configured toolbar toggle key.
local function _isToggleKey(key)
    return key == StaffSealToolbar.ToggleKey
end

-- Guard against consuming world clicks while mouse is over any UI element.
local function _isMouseOverUI()
    local uis = UIManager.getUI()
    for i = 1, uis:size() do
        local ui = uis:get(i - 1)
        if ui and ui:isMouseOver() then
            return true
        end
    end

    return false
end

-- Resolve the square currently under the mouse cursor.
local function _getSquareUnderMouse(player)
    if not player then
        return nil
    end

    local z = math.floor(player:getZ())
    local playerNum = player:getPlayerNum()
    local wx = screenToIsoX(playerNum, getMouseX(), getMouseY(), z)
    local wy = screenToIsoY(playerNum, getMouseX(), getMouseY(), z)
    local square = getCell() and getCell():getGridSquare(math.floor(wx), math.floor(wy), z)

    -- If we are over non-solid tiles, walk down to first solid square.
    while z >= 0 and (not square or not square:TreatAsSolidFloor()) do
        z = z - 1
        if z < 0 then
            break
        end
        wx = screenToIsoX(playerNum, getMouseX(), getMouseY(), z)
        wy = screenToIsoY(playerNum, getMouseX(), getMouseY(), z)
        square = getCell() and getCell():getGridSquare(math.floor(wx), math.floor(wy), z)
    end

    return square
end

-- Pick the best target at cursor: container object first, then world item.
local function _pickTarget(square)
    local picked = UIManager.getLastPicked and UIManager.getLastPicked() or nil

    -- Prefer exact object picker result first (works better for mannequins/offset sprites).
    if picked then
        if StaffSealSystem.objectHasContainers(picked) then
            return { kind = "container", object = picked }
        end

        if instanceof and instanceof(picked, "IsoWorldInventoryObject") then
            local item = picked.getItem and picked:getItem() or nil
            if item then
                return { kind = "worldItem", worldObject = picked, item = item }
            end
        end
    end

    if not square then
        return nil
    end

    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)
        if StaffSealSystem.objectHasContainers(obj) then
            return { kind = "container", object = obj }
        end
    end

    local wobs = square:getWorldObjects()
    for i = 0, wobs:size() - 1 do
        local wob = wobs:get(i)
        local item = wob and wob.getItem and wob:getItem() or nil
        if item then
            return { kind = "worldItem", worldObject = wob, item = item }
        end
    end

    return nil
end

-- Check the cursor square, then nearby tiles, to reduce isometric edge misses.
local function _pickTargetNearSquare(square)
    if not square then
        return nil
    end

    local target = _pickTarget(square)
    if target then
        return target
    end

    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                local sq = getCell() and getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
                if sq then
                    target = _pickTarget(sq)
                    if target then
                        return target
                    end
                end
            end
        end
    end

    return nil
end

-- Send container seal state change through MP command or direct SP write.
local function _sendContainerSeal(object, shouldSeal)
    StaffSealSystem.sendContainerSealCommand(object, shouldSeal)
end

-- Send item seal state change through MP command or direct SP write.
local function _sendItemSeal(item, square, shouldSeal)
    StaffSealSystem.sendItemSealCommand(item, shouldSeal, square)
end

local function _setMode(shouldSeal)
    StaffSealToolbar._modeSeal = shouldSeal
    StaffSealSystem.log("Toolbar mode: " .. (shouldSeal and "seal" or "unseal"))
end

local function _cancelMode()
    if StaffSealToolbar._modeSeal ~= nil then
        StaffSealSystem.log("Toolbar mode: cancelled")
    end
    StaffSealToolbar._modeSeal = nil
end

-- Handle left-click targeting while toolbar mode is active.
local function _onMouseDown(_x, _y)
    if StaffSealToolbar._modeSeal == nil then
        return
    end

    if _isMouseOverUI() then
        return
    end

    local player = _localPlayer()
    if not StaffSealSystem.isStaff(player) then
        StaffSealSystem.log("Toolbar click blocked: player is not staff")
        _cancelMode()
        return
    end

    local picked = UIManager.getLastPicked and UIManager.getLastPicked() or nil
    local square = picked and picked.getSquare and picked:getSquare() or _getSquareUnderMouse(player)
    local target = _pickTargetNearSquare(square)
    if not target then
        -- Keep mode active for sticky multi-target sealing.
        return
    end

    if target.kind == "container" then
        _sendContainerSeal(target.object, StaffSealToolbar._modeSeal)
    elseif target.kind == "worldItem" then
        _sendItemSeal(target.item, square, StaffSealToolbar._modeSeal)
    end

    -- Sticky mode: keep targeting active until user cancels.
end

-- Right-click cancels sticky target mode.
local function _onRightMouseDown(_x, _y)
    _cancelMode()
end

local function _onSealClick()
    _setMode(true)
end

local function _onUnsealClick()
    _setMode(false)
end

local function _onCancelClick()
    _cancelMode()
end

local function _trimText(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function _formatSceneTimestamp(ts)
    local n = tonumber(ts or 0) or 0
    local sec = n
    if n > 2000000000 then
        sec = math.floor(n / 1000)
    end

    if sec <= 0 or not os or not os.date then
        return tostring(ts or "")
    end

    return os.date("%Y-%m-%d %H:%M:%S", sec)
end

local function _isPrivateScope()
    return StaffSealToolbar._sceneScope == "private"
end

local function _getActiveSceneList()
    if _isPrivateScope() then
        return StaffSealSystem._rpScenesPrivate or {}
    end
    return StaffSealSystem._rpScenesShared or StaffSealSystem._rpScenes or {}
end

local function _onUseSharedListClick()
    StaffSealToolbar._sceneScope = "shared"
    StaffSealToolbar.refreshRPSceneList()
end

local function _onUsePrivateListClick()
    StaffSealToolbar._sceneScope = "private"
    StaffSealToolbar.refreshRPSceneList()
end

function StaffSealToolbar.refreshRPSceneList()
    local list = StaffSealToolbar._sceneList
    if not list then
        return
    end

    local selectedId = nil
    if list.selected and list.items and list.items[list.selected] and list.items[list.selected].item then
        selectedId = list.items[list.selected].item.id
    end

    list:clear()

    local scenes = _getActiveSceneList()
    for i = 1, #scenes do
        local e = scenes[i]
        local line = string.format("%s | %s | %d,%d,%d", tostring(e.text or ""), _formatSceneTimestamp(e.timestamp), tonumber(e.x or 0) or 0, tonumber(e.y or 0) or 0, tonumber(e.z or 0) or 0)
        list:addItem(line, e)
    end

    if selectedId ~= nil then
        for i = 1, #list.items do
            local row = list.items[i]
            if row and row.item and tonumber(row.item.id) == tonumber(selectedId) then
                list.selected = i
                break
            end
        end
    end
end

local function _onPlaceRPSceneClick()
    local player = _localPlayer()
    if not StaffSealSystem.isStaff(player) then
        return
    end

    local text = _trimText(StaffSealToolbar._sceneEntry and StaffSealToolbar._sceneEntry.getText and StaffSealToolbar._sceneEntry:getText() or "")
    if text == "" then
        text = "RP Scene"
    end

    local x = player and math.floor(player:getX()) or 0
    local y = player and math.floor(player:getY()) or 0
    local z = player and math.floor(player:getZ()) or 0
    StaffSealSystem.sendRPScenePlaceCommand(text, x, y, z, _isPrivateScope())
end

local function _onRemoveRPSceneClick()
    local player = _localPlayer()
    if not StaffSealSystem.isStaff(player) then
        return
    end

    local list = StaffSealToolbar._sceneList
    local row = list and list.selected and list.items and list.items[list.selected] or nil
    local entry = row and row.item or nil
    if not entry or entry.id == nil then
        return
    end

    StaffSealSystem.sendRPSceneRemoveCommand(entry.id, _isPrivateScope())
end

local function _onRefreshRPSceneClick()
    -- Manual refresh button: request authoritative list then repaint current UI.
    if StaffSealSystem.requestRPSceneSync then
        StaffSealSystem.requestRPSceneSync()
    end
    StaffSealToolbar.refreshRPSceneList()
end

local function _buildRPSceneExportFileName()
    local stamp = os and os.date and os.date("%Y%m%d_%H%M%S") or tostring(math.floor(getTimestampMs and getTimestampMs() or os.time()))
    local scope = _isPrivateScope() and "Private" or "Shared"
    return "StaffToolbox_RPScenes_" .. scope .. "_" .. tostring(stamp) .. ".txt"
end

local function _onDownloadRPSceneClick()
    local player = _localPlayer()
    if not StaffSealSystem.isStaff(player) then
        return
    end

    local scenes = _getActiveSceneList()
    local fileName = _buildRPSceneExportFileName()
    local writer = getFileWriter and getFileWriter(fileName, true, false) or nil
    if not writer then
        StaffSealSystem.log("RP scene export failed: could not open " .. tostring(fileName))
        return
    end

    -- Export one stable line per entry so staff can archive/share out-of-game.
    writer:write("RP Scene Export\r\n")
    writer:write("Scope=" .. (_isPrivateScope() and "Private" or "Shared") .. "\r\n")
    writer:write("Generated=" .. (os and os.date and os.date("%Y-%m-%d %H:%M:%S") or "unknown") .. "\r\n")
    writer:write("Entries=" .. tostring(#scenes) .. "\r\n")
    writer:write("\r\n")

    for i = 1, #scenes do
        local e = scenes[i]
        local safeText = tostring(e.text or ""):gsub("\r", " "):gsub("\n", " ")
        local line = string.format(
            "[%s] id=%s by=%s pos=%d,%d,%d text=%s",
            _formatSceneTimestamp(e.timestamp),
            tostring(e.id or ""),
            tostring(e.by or ""),
            tonumber(e.x or 0) or 0,
            tonumber(e.y or 0) or 0,
            tonumber(e.z or 0) or 0,
            safeText
        )
        writer:write(line .. "\r\n")
    end

    writer:close()
    StaffSealSystem.log("RP scenes exported to " .. tostring(fileName) .. " (" .. tostring(#scenes) .. " entries)")
end

local function _resolveSafeTeleportTarget(x, y, z)
    local cell = getCell and getCell() or nil
    if not cell then
        return x, y, z, nil
    end

    local baseZ = math.max(0, math.floor(tonumber(z or 0) or 0))
    local scanTop = math.min(8, baseZ + 3)

    -- Prefer the target square, but fall back to nearby tiles if that square is unsafe.
    for radius = 0, 1 do
        for dy = -radius, radius do
            for dx = -radius, radius do
                local tx = x + dx
                local ty = y + dy
                for sz = scanTop, 0, -1 do
                    local sq = cell:getGridSquare(tx, ty, sz)
                    if sq and sq.TreatAsSolidFloor and sq:TreatAsSolidFloor() then
                        return tx, ty, sz, sq
                    end
                end
            end
        end
    end

    return x, y, baseZ, nil
end

local function _teleportToSceneEntry(entry)
    if not entry then
        return
    end

    local x = math.floor(tonumber(entry.x or 0) or 0)
    local y = math.floor(tonumber(entry.y or 0) or 0)
    local z = math.floor(tonumber(entry.z or 0) or 0)
    local tx, ty, tz = _resolveSafeTeleportTarget(x, y, z)

    -- Use admin command path for teleport; safe target resolver avoids bad floor/z picks.
    if SendCommandToServer then
        SendCommandToServer("/teleportto " .. tostring(tx) .. "," .. tostring(ty) .. "," .. tostring(tz))
    end
end

local function _onSceneListDoubleClick(_target, item)
    -- PZ list callback sends (target, item); resolve to the scene payload robustly.
    local row = item
    if type(row) == "number" and StaffSealToolbar._sceneList and StaffSealToolbar._sceneList.items then
        row = StaffSealToolbar._sceneList.items[row]
    end
    if not row or not row.item then
        local list = StaffSealToolbar._sceneList
        row = list and list.selected and list.items and list.items[list.selected] or nil
    end
    if row and row.item then
        row = row.item
    end
    _teleportToSceneEntry(row)
end

local function _clampToolbarSize(w, h)
    local minW, minH = 440, 300
    local maxW, maxH = 1100, 900

    local outW = math.max(minW, math.min(maxW, math.floor(tonumber(w or 500) or 500)))
    local outH = math.max(minH, math.min(maxH, math.floor(tonumber(h or 420) or 420)))
    return outW, outH
end

local function _setControlRect(ctrl, x, y, w, h)
    if not ctrl then
        return
    end

    if ctrl.setX then ctrl:setX(x) else ctrl.x = x end
    if ctrl.setY then ctrl:setY(y) else ctrl.y = y end
    if w ~= nil then
        if ctrl.setWidth then ctrl:setWidth(w) else ctrl.width = w end
    end
    if h ~= nil then
        if ctrl.setHeight then ctrl:setHeight(h) else ctrl.height = h end
    end
end

local function _applyToolbarLayout()
    local panel = StaffSealToolbar._panel
    local c = StaffSealToolbar._controls
    if not panel or not c then
        return
    end

    local panelW, panelH = _clampToolbarSize(StaffSealToolbar._width, StaffSealToolbar._height)
    StaffSealToolbar._width = panelW
    StaffSealToolbar._height = panelH

    panel:setWidth(panelW)
    panel:setHeight(panelH)

    local pad = 6
    local topY = 6
    local entryY = 40
    local listY = 70
    local bottomY = panelH - 32

    _setControlRect(c.sealBtn, 6, topY, 64, 26)
    _setControlRect(c.unsealBtn, 76, topY, 70, 26)
    _setControlRect(c.cancelBtn, 152, topY, 64, 26)

    local smallW = 32
    local smallGap = 4
    local groupW = (smallW * 4) + (smallGap * 3)
    local groupX = panelW - pad - groupW
    _setControlRect(c.widthDownBtn, groupX, topY, smallW, 26)
    _setControlRect(c.widthUpBtn, groupX + (smallW + smallGap), topY, smallW, 26)
    _setControlRect(c.heightDownBtn, groupX + (smallW + smallGap) * 2, topY, smallW, 26)
    _setControlRect(c.heightUpBtn, groupX + (smallW + smallGap) * 3, topY, smallW, 26)

    local placeW = 122
    local entryW = math.max(120, panelW - (pad + pad + placeW + pad))
    local placeX = pad + entryW + pad
    _setControlRect(c.entry, pad, entryY, entryW, 24)
    _setControlRect(c.placeBtn, placeX, entryY, placeW, 24)

    local listW = panelW - (pad * 2)
    local listH = math.max(120, panelH - 108)
    _setControlRect(c.list, pad, listY, listW, listH)

    _setControlRect(c.sharedListBtn, pad, bottomY, 84, 24)
    _setControlRect(c.privateListBtn, pad + 90, bottomY, 84, 24)

    local downloadW = 84
    local refreshW = 58
    local removeW = 58
    local downloadX = panelW - pad - downloadW
    local refreshX = downloadX - pad - refreshW
    local removeX = refreshX - pad - removeW
    _setControlRect(c.removeBtn, removeX, bottomY, removeW, 24)
    _setControlRect(c.refreshBtn, refreshX, bottomY, refreshW, 24)
    _setControlRect(c.downloadBtn, downloadX, bottomY, downloadW, 24)

    StaffSealToolbar._trackerTextY = bottomY
end

local function _resizeToolbar(dw, dh)
    local nextW = (StaffSealToolbar._width or 500) + (tonumber(dw or 0) or 0)
    local nextH = (StaffSealToolbar._height or 420) + (tonumber(dh or 0) or 0)
    StaffSealToolbar._width, StaffSealToolbar._height = _clampToolbarSize(nextW, nextH)
    _applyToolbarLayout()
end

local function _onWidthDownClick()
    _resizeToolbar(-40, 0)
end

local function _onWidthUpClick()
    _resizeToolbar(40, 0)
end

local function _onHeightDownClick()
    _resizeToolbar(0, -30)
end

local function _onHeightUpClick()
    _resizeToolbar(0, 30)
end

-- Render a lightweight mouse-following hint while target mode is active.
local function _renderModeHint()
    if StaffSealToolbar._modeSeal == nil then
        return
    end

    local text = StaffSealToolbar._modeSeal and "Staff Seal: CLICK TARGET" or "Staff Unseal: CLICK TARGET"
    getTextManager():DrawString(UIFont.Small, getMouseX() + 14, getMouseY() + 14, text, 1.0, 0.92, 0.3, 1.0)
end

-- Build a small always-available toolbar to avoid brittle context menus.
local function _createToolbar()
    if StaffSealToolbar._panel or not _isLocalStaff() then
        return
    end

    local panelW, panelH = _clampToolbarSize(StaffSealToolbar._width, StaffSealToolbar._height)
    local panel = ISPanel:new(20, 220, panelW, panelH)
    panel:initialise()
    panel:instantiate()
    panel.moveWithMouse = true
    panel.backgroundColor = { r = 0.08, g = 0.08, b = 0.08, a = 0.72 }
    panel.borderColor = { r = 0.75, g = 0.75, b = 0.75, a = 0.9 }

    local sealBtn = ISButton:new(6, 6, 64, 26, "Seal", nil, _onSealClick)
    sealBtn:initialise()
    panel:addChild(sealBtn)

    local unsealBtn = ISButton:new(76, 6, 70, 26, "Unseal", nil, _onUnsealClick)
    unsealBtn:initialise()
    panel:addChild(unsealBtn)

    local cancelBtn = ISButton:new(152, 6, 64, 26, "Cancel", nil, _onCancelClick)
    cancelBtn:initialise()
    panel:addChild(cancelBtn)

    local widthDownBtn = ISButton:new(0, 0, 32, 26, "W-", nil, _onWidthDownClick)
    widthDownBtn:initialise()
    panel:addChild(widthDownBtn)

    local widthUpBtn = ISButton:new(0, 0, 32, 26, "W+", nil, _onWidthUpClick)
    widthUpBtn:initialise()
    panel:addChild(widthUpBtn)

    local heightDownBtn = ISButton:new(0, 0, 32, 26, "H-", nil, _onHeightDownClick)
    heightDownBtn:initialise()
    panel:addChild(heightDownBtn)

    local heightUpBtn = ISButton:new(0, 0, 32, 26, "H+", nil, _onHeightUpClick)
    heightUpBtn:initialise()
    panel:addChild(heightUpBtn)

    local entry = ISTextEntryBox:new("", 6, 40, 360, 24)
    entry:initialise()
    entry:instantiate()
    panel:addChild(entry)
    StaffSealToolbar._sceneEntry = entry

    local placeBtn = ISButton:new(372, 40, 122, 24, "Place RP Scene", nil, _onPlaceRPSceneClick)
    placeBtn:initialise()
    panel:addChild(placeBtn)

    local list = ISScrollingListBox:new(6, 70, 488, 312)
    list:initialise()
    list:instantiate()
    list.itemheight = 22
    list.font = UIFont.Small
    -- QoL: double-click a scene row to teleport directly to its coordinates.
    list:setOnMouseDoubleClick(panel, _onSceneListDoubleClick)
    panel:addChild(list)
    StaffSealToolbar._sceneList = list

    local removeBtn = ISButton:new(372, 388, 58, 24, "Remove", nil, _onRemoveRPSceneClick)
    removeBtn:initialise()
    panel:addChild(removeBtn)

    local sharedListBtn = ISButton:new(6, 388, 84, 24, "Shared", nil, _onUseSharedListClick)
    sharedListBtn:initialise()
    panel:addChild(sharedListBtn)

    local privateListBtn = ISButton:new(96, 388, 84, 24, "Private", nil, _onUsePrivateListClick)
    privateListBtn:initialise()
    panel:addChild(privateListBtn)

    local refreshBtn = ISButton:new(436, 388, 58, 24, "Refresh", nil, _onRefreshRPSceneClick)
    refreshBtn:initialise()
    panel:addChild(refreshBtn)

    local downloadBtn = ISButton:new(346, 388, 84, 24, "Download", nil, _onDownloadRPSceneClick)
    downloadBtn:initialise()
    panel:addChild(downloadBtn)

    StaffSealToolbar._controls = {
        sealBtn = sealBtn,
        unsealBtn = unsealBtn,
        cancelBtn = cancelBtn,
        widthDownBtn = widthDownBtn,
        widthUpBtn = widthUpBtn,
        heightDownBtn = heightDownBtn,
        heightUpBtn = heightUpBtn,
        entry = entry,
        placeBtn = placeBtn,
        list = list,
        sharedListBtn = sharedListBtn,
        privateListBtn = privateListBtn,
        removeBtn = removeBtn,
        refreshBtn = refreshBtn,
        downloadBtn = downloadBtn,
    }

    panel.render = function(self)
        ISPanel.render(self)
        local y = StaffSealToolbar._trackerTextY or (self.height - 32)
        local scopeText = _isPrivateScope() and "Private" or "Shared"
        self:drawText("RP Scene Tracker (" .. scopeText .. ")", 186, y, 0.95, 0.95, 0.95, 1.0, UIFont.Small)
    end

    panel:addToUIManager()
    panel:setVisible(false)
    StaffSealToolbar._panel = panel
    _applyToolbarLayout()
    StaffSealToolbar.refreshRPSceneList()
    StaffSealSystem.log("Toolbar initialized (hidden)")
end

-- Open/close toolbar on demand via hotkey.
local function _toggleToolbar()
    if not _isLocalStaff() then
        if StaffSealToolbar._panel then
            StaffSealToolbar._panel:setVisible(false)
        end
        return
    end

    _createToolbar()
    if not StaffSealToolbar._panel then
        return
    end

    if StaffSealToolbar._panel:isVisible() then
        StaffSealToolbar._panel:setVisible(false)
        StaffSealSystem.log("Toolbar hidden")
    else
        StaffSealToolbar._panel:addToUIManager()
        StaffSealToolbar._panel:setVisible(true)
        StaffSealToolbar._panel:bringToTop()
        if StaffSealSystem.requestRPSceneSync then
            StaffSealSystem.requestRPSceneSync()
        end
        StaffSealToolbar.refreshRPSceneList()
        StaffSealSystem.log("Toolbar shown")
    end
end

local function _onKeyPressed(key)
    if key == Keyboard.KEY_ESCAPE and StaffSealToolbar._modeSeal ~= nil then
        _cancelMode()
        return
    end

    if _isToggleKey(key) then
        _toggleToolbar()
    end
end

local function _bindChatEntryHandler()
    local chat = ISChat and ISChat.instance or nil
    local textEntry = chat and chat.textEntry or nil
    if textEntry then
        textEntry.onCommandEntered = ISChat.onCommandEntered
    end
end

-- Install a local chat command hook that intercepts /toolbox before server send.
local function _installChatCommandHook()
    if StaffSealSystem._toolbarChatHookInstalled then
        return
    end

    if not ISChat or not ISChat.onCommandEntered then
        return
    end

    local vanillaOnCommandEntered = ISChat.onCommandEntered
    ISChat.onCommandEntered = function(...)
        local chat = ISChat.instance
        local textEntry = chat and chat.textEntry or nil
        local raw = textEntry and textEntry.getText and textEntry:getText() or nil
        local cmd = raw and string.lower(tostring(raw)) or ""
        cmd = cmd:gsub("^%s+", ""):gsub("%s+$", "")

        if cmd == StaffSealToolbar.ChatCommand then
            if chat and chat.unfocus then
                chat:unfocus()
            end
            if textEntry and textEntry.setText then
                textEntry:setText("")
            end
            _toggleToolbar()
            return
        end

        return vanillaOnCommandEntered(...)
    end

    _bindChatEntryHandler()

    StaffSealSystem._toolbarChatHookInstalled = true
end

if not StaffSealSystem._toolbarHooksInstalled then
    Events.OnCreatePlayer.Add(function(_playerIndex, _playerObj)
        if _playerIndex == 0 then
            _createToolbar()
        end
    end)

    Events.OnGameStart.Add(function()
        _createToolbar()
        if StaffSealToolbar._panel then
            StaffSealToolbar._panel:setVisible(false)
        end
        _installChatCommandHook()
        if StaffSealSystem.requestRPSceneSync then
            StaffSealSystem.requestRPSceneSync()
        end
    end)

    Events.OnChatWindowInit.Add(function()
        _installChatCommandHook()
        _bindChatEntryHandler()
    end)

    Events.OnMouseDown.Add(_onMouseDown)
    Events.OnRightMouseDown.Add(_onRightMouseDown)
    Events.OnPostUIDraw.Add(_renderModeHint)
    Events.OnKeyPressed.Add(_onKeyPressed)
    StaffSealSystem._toolbarHooksInstalled = true
end
