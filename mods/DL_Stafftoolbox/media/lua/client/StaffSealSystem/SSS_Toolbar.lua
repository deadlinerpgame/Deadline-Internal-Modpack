require "StaffSealSystem/SSS_Shared"
require "StaffSealSystem/SSS_ClientActions"
require "ISUI/ISPanel"
require "ISUI/ISButton"

StaffSealToolbar = StaffSealToolbar or {}
-- Use numpad '*' for toolbar toggle.
StaffSealToolbar.ToggleKey = Keyboard.KEY_MULTIPLY
StaffSealToolbar.ChatCommand = "/toolbox"

-- Track live toolbar state and the current targeting mode.
StaffSealToolbar._panel = nil
StaffSealToolbar._modeSeal = nil

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

    local panel = ISPanel:new(20, 220, 180, 72)
    panel:initialise()
    panel:instantiate()
    panel.moveWithMouse = true
    panel.backgroundColor = { r = 0.08, g = 0.08, b = 0.08, a = 0.72 }
    panel.borderColor = { r = 0.75, g = 0.75, b = 0.75, a = 0.9 }

    local sealBtn = ISButton:new(6, 6, 52, 26, "Seal", nil, _onSealClick)
    sealBtn:initialise()
    panel:addChild(sealBtn)

    local unsealBtn = ISButton:new(64, 6, 56, 26, "Unseal", nil, _onUnsealClick)
    unsealBtn:initialise()
    panel:addChild(unsealBtn)

    local cancelBtn = ISButton:new(126, 6, 48, 26, "Cancel", nil, _onCancelClick)
    cancelBtn:initialise()
    panel:addChild(cancelBtn)

    panel:addToUIManager()
    panel:setVisible(false)
    StaffSealToolbar._panel = panel
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
