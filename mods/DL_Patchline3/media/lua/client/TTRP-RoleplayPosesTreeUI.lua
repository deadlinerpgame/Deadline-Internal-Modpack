-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  ________      ________       ___    ___  ________       _________    ________      ___           ________      ___  ___      ________      ___      ________     -- 
--|\   ____\    |\   __  \     |\  \  /  /||\   ____\     |\___   ___\ |\   __  \    |\  \         |\   ____\    |\  \|\  \    |\   __  \    |\  \    |\   ____\     --
--\ \  \___|    \ \  \|\  \    \ \  \/  / /\ \  \___|_    \|___ \  \_| \ \  \|\  \   \ \  \        \ \  \___|    \ \  \\\  \   \ \  \|\  \   \ \  \   \ \  \___|_    --
-- \ \  \        \ \   _  _\    \ \    / /  \ \_____  \        \ \  \   \ \   __  \   \ \  \        \ \  \        \ \   __  \   \ \   _  _\   \ \  \   \ \_____  \   --
--  \ \  \____    \ \  \\  \|    \/  /  /    \|____|\  \        \ \  \   \ \  \ \  \   \ \  \____    \ \  \____    \ \  \ \  \   \ \  \\  \|   \ \  \   \|____|\  \  --
--   \ \_______\   \ \__\\ _\  __/  / /        ____\_\  \        \ \__\   \ \__\ \__\   \ \_______\   \ \_______\   \ \__\ \__\   \ \__\\ _\    \ \__\    ____\_\  \ --
--    \|_______|    \|__|\|__||\___/ /        |\_________\        \|__|    \|__|\|__|    \|_______|    \|_______|    \|__|\|__|    \|__|\|__|    \|__|   |\_________\--
--                            \|___|/         \|_________|                                                                                               \|_________|--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"

local json = require "TTRPJson"
local unpackArgs = table.unpack or unpack
require "TTRPFavorites"

TTRPPosesTreeUI = TTRPPosesTreeUI or {}
TTRPPosesTreeUI.windowOpen = TTRPPosesTreeUI.windowOpen or false

local UI_DATA_KEY = "TTRP_UI_Data"
local ICON_TEXTURE_PATH = "media/ui/menus/main-menu.png"
local ICON_SIZE = 42
local ICON_DRAG_THRESHOLD = 6
-- .txt instead of .json for B41 file writing -Milo
local BINDS_FILE_PATH = "TTRP_PoseBinds.txt"
local LOADOUTS_FILE_PATH = "TTRP_PoseBindLoadouts.txt"
local DEFAULT_BIND_LOADOUT = "Default"
local SEARCH_POSES_LABEL = "Search (All Poses):"
local SEARCH_BINDS_LABEL = "Search Binds:"
local BIND_HELP_TEXT = "Select a pose, click Set Key, then press a key."
local CANCEL_EMOTE_ID = "BobRPS_Cancel"
local ICON_TOGGLE_KEYBIND = "TTRP_ToggleTreeIcon"
local STARTUP_ENSURE_TICKS = 300

TTRPPosesTreeUI.customBinds = TTRPPosesTreeUI.customBinds or {}
TTRPPosesTreeUI.bindLoadouts = TTRPPosesTreeUI.bindLoadouts or {}
TTRPPosesTreeUI.activeBindLoadout = TTRPPosesTreeUI.activeBindLoadout or DEFAULT_BIND_LOADOUT

-----------------------------------------------
-- Local helper fucntions for the UI draw    --
-----------------------------------------------
-- We need to get the local/specific player in order to write the UI state and provide ModData info about the UI's state and favorites. idk if there's a better way to do this.
local function getLocalPlayer()
    return getSpecificPlayer(0)
end

local function toLowerSafe(value)
    if not value then
        return ""
    end
    return string.lower(tostring(value))
end

local function containsIgnoreCase(searchableText, queryText)
    local queryLower = toLowerSafe(queryText)
    if queryLower == "" then
        return true
    end

    local searchableLower = toLowerSafe(searchableText)
    return string.find(searchableLower, queryLower, 1, true) ~= nil
end

local function normalizeSearchText(value)
    local text = tostring(value or "")
    text = string.gsub(text, "^%s+", "")
    text = string.gsub(text, "%s+$", "")
    return text
end

local function fitTextToWidth(text, font, maxWidth)
    text = tostring(text or "")
    if maxWidth <= 0 then
        return ""
    end

    local tm = getTextManager()
    if tm:MeasureStringX(font, text) <= maxWidth then
        return text
    end

    local ellipsis = "..."
    local ellipsisW = tm:MeasureStringX(font, ellipsis)
    if ellipsisW >= maxWidth then
        return ""
    end

    local trimmed = text
    while #trimmed > 0 and tm:MeasureStringX(font, trimmed) + ellipsisW > maxWidth do
        trimmed = string.sub(trimmed, 1, #trimmed - 1)
    end

    return trimmed .. ellipsis
end

local function drawChevronMarker(ui, x, y, h, r, g, b, a)
    local midY = y + math.floor(h / 2)
    local topY = midY - 4
    local bottomY = midY + 4
    for i = 0, 4 do
        ui:drawRect(x + i, topY + i, 1, 1, a, r, g, b)
        ui:drawRect(x + i, bottomY - i, 1, 1, a, r, g, b)
    end
end

local function clampToScreen(x, y, width, height)
    local core = getCore and getCore() or nil
    if not core then
        return x, y, false
    end

    local screenW = core:getScreenWidth() or 0
    local screenH = core:getScreenHeight() or 0
    if screenW <= 0 or screenH <= 0 then
        return x, y, false
    end

    local clampedX = math.max(0, math.min(tonumber(x) or 0, math.max(0, screenW - (width or ICON_SIZE))))
    local clampedY = math.max(0, math.min(tonumber(y) or 0, math.max(0, screenH - (height or ICON_SIZE))))
    return clampedX, clampedY, true
end

local function isLauncherVisible()
    local launcher = TTRPPosesTreeUI and TTRPPosesTreeUI.launcher or nil
    if not launcher then
        return false
    end

    if launcher.isReallyVisible then
        return launcher:isReallyVisible()
    end

    if launcher.isVisible then
        return launcher:isVisible()
    end

    return false
end

local function isLauncherInScreenBounds()
    local launcher = TTRPPosesTreeUI and TTRPPosesTreeUI.launcher or nil
    if not launcher then
        return false
    end

    local x = launcher.getX and launcher:getX() or launcher.x or 0
    local y = launcher.getY and launcher:getY() or launcher.y or 0
    local w = launcher.getWidth and launcher:getWidth() or launcher.width or ICON_SIZE
    local h = launcher.getHeight and launcher:getHeight() or launcher.height or ICON_SIZE

    local clampedX, clampedY, hasBounds = clampToScreen(x, y, w, h)
    if not hasBounds then
        return false
    end

    return x == clampedX and y == clampedY
end

local function getOrCreateState()
    local player = getLocalPlayer()
    if not player then
        return nil, nil
    end

    local modData = player:getModData()
    modData[UI_DATA_KEY] = modData[UI_DATA_KEY] or {}

    local state = modData[UI_DATA_KEY]
    local defaultIconY = 340
    if getCore and getCore() and getCore():getScreenHeight() then
        local screenH = getCore():getScreenHeight()
        defaultIconY = math.max(280, math.min(screenH - ICON_SIZE - 100, 380))
    end

    state.iconX = state.iconX or 16
    state.iconY = state.iconY or defaultIconY
    if type(state.iconHidden) ~= "boolean" then
        state.iconHidden = tostring(state.iconHidden) == "true"
    end
    if state.iconY == 200 then
        state.iconY = defaultIconY
    end
    -- Keep launcher coordinates inside the visible screen area.
    local clampedX, clampedY, hasBounds = clampToScreen(state.iconX, state.iconY, ICON_SIZE, ICON_SIZE)
    if hasBounds then
        state.iconX = clampedX
        state.iconY = clampedY
    end
    state.windowX = state.windowX or 72
    state.windowY = state.windowY or 96
    state.windowW = state.windowW or 700
    if state.windowW == 900 or state.windowW == 760 then
        state.windowW = 700
    end
    state.windowH = state.windowH or 620

    return state, player
end

local function textureToPath(texture)
    if texture and type(texture) == "userdata" and texture.getName then
        return texture:getName()
    end
    if type(texture) == "string" then
        return texture
    end
    return nil
end

local function getTextureSafe(texturePath)
    if not texturePath or texturePath == "" then
        return nil
    end
    return getTexture(texturePath)
end

local function keyCodeToName(keyCode)
    if Keyboard and Keyboard.getKeyName then
        local keyName = Keyboard.getKeyName(keyCode)
        if keyName and keyName ~= "" then
            return keyName
        end
    end
    return tostring(keyCode)
end

local function playBoundEmote(emoteId, player)
    if type(emoteId) ~= "string" or emoteId == "" or not player then
        return
    end

    -- Route cancel keybinds through the cancel handler so they keep its custom behavior.
    if emoteId == CANCEL_EMOTE_ID and type(TTRPcancelEmote) == "function" then
        TTRPcancelEmote(emoteId, player)
        return
    end

    if type(TTRPdoEmote) == "function" then
        TTRPdoEmote(emoteId, player)
    else
        player:playEmote(emoteId)
    end
end

local function setLabelText(label, value)
    if not label then
        return
    end
    if label.setName then
        label:setName(value)
    else
        label.name = value
    end
end

local function jsonEncode(value)
    if type(json) ~= "table" then
        return nil
    end

    if type(json.stringify) == "function" then
        return json.stringify(value)
    end

    if type(json.encode) == "function" then
        return json.encode(value)
    end

    if type(json.Encode) == "function" then
        return json.Encode(value)
    end

    return nil
end

local function jsonDecode(value)
    if type(json) ~= "table" then
        return nil
    end

    if type(json.parse) == "function" then
        return json.parse(value)
    end

    if type(json.decode) == "function" then
        return json.decode(value)
    end

    if type(json.Decode) == "function" then
        return json.Decode(value)
    end

    return nil
end

-----------------------------------------------
-- Keybinds Storage                             --
-----------------------------------------------

local function cloneBindsTable(source)
    local cloned = {}
    for keyCode, bindData in pairs(source or {}) do
        if type(bindData) == "table" then
            cloned[tostring(keyCode)] = {
                label = bindData.label,
                displayLabel = bindData.displayLabel,
                emote = bindData.emote,
                texturePath = bindData.texturePath,
            }
        end
    end
    return cloned
end

local function serializeBindsTable(source)
    local payload = {}
    for keyCode, bindData in pairs(source or {}) do
        if type(bindData) == "table" and type(bindData.emote) == "string" and bindData.emote ~= "" then
            payload[tostring(keyCode)] = {
                keyCode = tonumber(keyCode) or keyCode,
                label = bindData.label,
                displayLabel = bindData.displayLabel,
                emote = bindData.emote,
                texturePath = bindData.texturePath,
            }
        end
    end
    return payload
end

local function deserializeBindsTable(parsed)
    local loaded = {}
    if type(parsed) ~= "table" then
        return loaded
    end

    for keyCode, bindData in pairs(parsed) do
        local resolvedKey = tonumber(keyCode)
        if not resolvedKey and type(bindData) == "table" then
            resolvedKey = tonumber(bindData.keyCode)
        end

        if resolvedKey and type(bindData) == "table" and type(bindData.emote) == "string" and bindData.emote ~= "" then
            loaded[tostring(resolvedKey)] = {
                label = bindData.label or bindData.displayLabel or bindData.emote,
                displayLabel = bindData.displayLabel or bindData.label or bindData.emote,
                emote = bindData.emote,
                texturePath = bindData.texturePath,
            }
        end
    end

    return loaded
end

local function tableHasEntries(tbl)
    if type(tbl) ~= "table" then
        return false
    end
    for _ in pairs(tbl) do
        return true
    end
    return false
end

local function getActiveLoadoutName()
    local active = tostring(TTRPPosesTreeUI.activeBindLoadout or "")
    if active == "" then
        active = DEFAULT_BIND_LOADOUT
    end
    return active
end

local function ensureActiveLoadout()
    local active = getActiveLoadoutName()
    TTRPPosesTreeUI.bindLoadouts = TTRPPosesTreeUI.bindLoadouts or {}
    if not TTRPPosesTreeUI.bindLoadouts[active] then
        TTRPPosesTreeUI.bindLoadouts[active] = {
            label = active,
            binds = cloneBindsTable(TTRPPosesTreeUI.customBinds or {}),
        }
    end
    TTRPPosesTreeUI.activeBindLoadout = active
    return active
end

local function saveBindLoadouts()
    local active = ensureActiveLoadout()
    local payload = {
        active = active,
        loadouts = {},
    }

    for name, loadoutData in pairs(TTRPPosesTreeUI.bindLoadouts or {}) do
        if type(name) == "string" and type(loadoutData) == "table" then
            payload.loadouts[name] = {
                label = loadoutData.label or name,
                binds = serializeBindsTable(loadoutData.binds or {}),
            }
        end
    end

    local fileWriter = getFileWriter(LOADOUTS_FILE_PATH, true, false)
    if not fileWriter then
        print("TTRP Poses Tree UI: failed to open '" .. LOADOUTS_FILE_PATH .. "' for write")
        return
    end

    local jsonString = jsonEncode(payload)
    if type(jsonString) ~= "string" then
        print("TTRP Poses Tree UI: failed to encode pose bind loadouts JSON")
        fileWriter:close()
        return
    end

    fileWriter:write(jsonString)
    fileWriter:close()
end

local function saveCustomBinds()
    local payload = serializeBindsTable(TTRPPosesTreeUI.customBinds or {})
    local fileWriter = getFileWriter(BINDS_FILE_PATH, true, false)
    if not fileWriter then
        print("TTRP Poses Tree UI: failed to open '" .. BINDS_FILE_PATH .. "' for write")
        return
    end

    local jsonString = jsonEncode(payload)
    if type(jsonString) ~= "string" then
        print("TTRP Poses Tree UI: failed to encode pose binds JSON")
        fileWriter:close()
        return
    end

    fileWriter:write(jsonString)
    fileWriter:close()
    print("TTRP Poses Tree UI: saved pose binds to '" .. BINDS_FILE_PATH .. "'")

    local active = ensureActiveLoadout()
    TTRPPosesTreeUI.bindLoadouts[active].binds = cloneBindsTable(TTRPPosesTreeUI.customBinds or {})
    saveBindLoadouts()
end

local function loadCustomBinds()
    local fileReader = getFileReader(BINDS_FILE_PATH, false)

    if not fileReader then
        TTRPPosesTreeUI.customBinds = {}
        return
    end

    local fileLines = {}
    local nextLine = fileReader:readLine()
    while nextLine do
        table.insert(fileLines, nextLine)
        nextLine = fileReader:readLine()
    end
    fileReader:close()
    local jsonString = table.concat(fileLines, "\n")

    if not jsonString or jsonString == "" then
        TTRPPosesTreeUI.customBinds = {}
        return
    end

    local parsed = jsonDecode(jsonString)
    local loaded = deserializeBindsTable(parsed)
    TTRPPosesTreeUI.customBinds = loaded
    print("TTRP Poses Tree UI: loaded pose binds from '" .. BINDS_FILE_PATH .. "'")
end

local function loadBindLoadouts()
    local fileReader = getFileReader(LOADOUTS_FILE_PATH, false)

    if not fileReader then
        TTRPPosesTreeUI.bindLoadouts = {}
        local active = ensureActiveLoadout()
        TTRPPosesTreeUI.bindLoadouts[active].binds = cloneBindsTable(TTRPPosesTreeUI.customBinds or {})
        return
    end

    local fileLines = {}
    local nextLine = fileReader:readLine()
    while nextLine do
        table.insert(fileLines, nextLine)
        nextLine = fileReader:readLine()
    end
    fileReader:close()

    local jsonString = table.concat(fileLines, "\n")
    local parsed = jsonDecode(jsonString)

    local loadedLoadouts = {}
    local sourceLoadouts = nil

    if type(parsed) == "table" and type(parsed.loadouts) == "table" then
        sourceLoadouts = parsed.loadouts
    elseif type(parsed) == "table" then
        sourceLoadouts = parsed
    end

    if type(sourceLoadouts) == "table" then
        for name, loadoutData in pairs(sourceLoadouts) do
            if type(loadoutData) == "table" then
                local resolvedName = nil
                if type(name) == "string" and name ~= "active" and name ~= "loadouts" then
                    resolvedName = name
                elseif type(loadoutData.name) == "string" then
                    resolvedName = loadoutData.name
                elseif type(loadoutData.label) == "string" then
                    resolvedName = loadoutData.label
                end

                if resolvedName and resolvedName ~= "" then
                    loadedLoadouts[resolvedName] = {
                        label = loadoutData.label or resolvedName,
                        binds = deserializeBindsTable(loadoutData.binds),
                    }
                end
            end
        end
    end

    if not tableHasEntries(loadedLoadouts) then
        loadedLoadouts[DEFAULT_BIND_LOADOUT] = {
            label = DEFAULT_BIND_LOADOUT,
            binds = cloneBindsTable(TTRPPosesTreeUI.customBinds or {}),
        }
    end

    TTRPPosesTreeUI.bindLoadouts = loadedLoadouts
    TTRPPosesTreeUI.activeBindLoadout = (type(parsed) == "table" and type(parsed.active) == "string" and loadedLoadouts[parsed.active] and parsed.active) or DEFAULT_BIND_LOADOUT

    local active = ensureActiveLoadout()
    TTRPPosesTreeUI.customBinds = cloneBindsTable(TTRPPosesTreeUI.bindLoadouts[active].binds or {})
end

local function updateListScrollState(listbox)
    if not listbox or not listbox.items then
        return
    end

    local totalHeight = 0
    for i = 1, #listbox.items do
        local row = listbox.items[i]
        totalHeight = totalHeight + ((row and row.height) or listbox.itemheight or 0)
    end

    local viewportHeight = (listbox.getHeight and listbox:getHeight()) or listbox.height or 0
    viewportHeight = math.max(0, viewportHeight - 2)

    if listbox.setScrollHeight then
        listbox:setScrollHeight(math.max(totalHeight, viewportHeight))
    end

    if listbox.vscroll then
        local listW = (listbox.getWidth and listbox:getWidth()) or listbox.width or 0
        local listH = (listbox.getHeight and listbox:getHeight()) or listbox.height or 0
        local vscrollW = listbox.vscroll.getWidth and listbox.vscroll:getWidth() or 0
        if listbox.vscroll.setX then
            listbox.vscroll:setX(math.max(0, listW - vscrollW - 1))
        end
        if listbox.vscroll.setY then
            listbox.vscroll:setY(1)
        end
        if listbox.vscroll.setHeight then
            listbox.vscroll:setHeight(math.max(0, listH - 2))
        end
        if listbox.vscroll.setVisible then
            listbox.vscroll:setVisible(totalHeight > (viewportHeight + 1))
        end
    end
end

local function persistState()
    local _, player = getOrCreateState()
    if player and player.transmitModData then
        player:transmitModData()
    end
end

-----------------------------------------------
-- Radial Menu Tree Transplant               --
-----------------------------------------------

local function newCollector()
    local collector = { slices = {} }

    function collector:addSlice(text, texture, command, ...)
        table.insert(self.slices, {
            text = text,
            texture = texture,
            command = command,
            args = { ... }
        })
    end

    return collector
end

local function findSubmenuBuilder(slice)
    if not slice or slice.command ~= ISRadialMenu.createSubMenu or type(slice.args) ~= "table" then
        return nil
    end

    for i = 1, #slice.args do
        if type(slice.args[i]) == "function" then
            return slice.args[i]
        end
    end

    return nil
end

local function buildTreeFromBuilder(builderFn, player)
    local node = { entries = {} }

    if type(builderFn) ~= "function" then
        return node
    end

    local collector = newCollector()
    builderFn(collector, player)

    for i = 1, #collector.slices do
        local slice = collector.slices[i]
        local subBuilder = findSubmenuBuilder(slice)

        if subBuilder then
            local childNode = buildTreeFromBuilder(subBuilder, player)
            childNode.label = slice.text or ""
            childNode.texture = slice.texture

            table.insert(node.entries, {
                type = "category",
                label = slice.text or "",
                texture = slice.texture,
                node = childNode
            })
        else
            table.insert(node.entries, {
                type = "action",
                label = slice.text or "",
                texture = slice.texture,
                command = slice.command,
                args = slice.args
            })
        end
    end

    return node
end

local function buildRootTree(player)
    local root = {
        label = getText("IGUI_TTRP_Poses"),
        entries = {}
    }

    if type(TTRPSubmenu) ~= "function" then
        return root
    end

    local built = buildTreeFromBuilder(TTRPSubmenu, player)
    built.label = root.label
    return built
end

-----------------------------------------------
-- Favorites Helper Functions                --
-----------------------------------------------

local function getFavoriteEntryData(entry)
    if not entry or entry.type ~= "action" then
        return nil
    end

    if entry.command ~= TTRPdoEmote then
        return nil
    end

    if type(entry.args) ~= "table" or type(entry.args[1]) ~= "string" then
        return nil
    end

    return {
        text = entry.label,
        emote = entry.args[1],
        texture = entry.texture
    }
end

local function getBindData(entry)
    if not entry or entry.type ~= "action" then
        return nil
    end

    if type(entry.args) ~= "table" or type(entry.args[1]) ~= "string" then
        return nil
    end

    local emoteId = entry.args[1]
    if entry.command == TTRPdoEmote then
        return {
            text = entry.label,
            emote = emoteId,
            texture = entry.texture
        }
    end

    if entry.command == TTRPcancelEmote and emoteId == CANCEL_EMOTE_ID then
        return {
            text = entry.label,
            emote = emoteId,
            texture = entry.texture
        }
    end

    return nil
end

local function collectActionEntries(entry, output, prefix)
    if not entry then
        return
    end

    output = output or {}
    prefix = prefix or ""

    if entry.type == "action" then
        table.insert(output, {
            entry = entry,
            displayLabel = (prefix ~= "" and (prefix .. entry.label) or entry.label)
        })
        return output
    end

    if entry.type == "category" and entry.node and type(entry.node.entries) == "table" then
        for i = 1, #entry.node.entries do
            local child = entry.node.entries[i]
            if child.type == "action" then
                table.insert(output, {
                    entry = child,
                    displayLabel = (prefix ~= "" and (prefix .. child.label) or child.label)
                })
            elseif child.type == "category" then
                local nextPrefix = (prefix ~= "" and (prefix .. child.label .. " / ") or (child.label .. " / "))
                collectActionEntries(child, output, nextPrefix)
            end
        end
    end

    return output
end

local function collectImmediateRows(entry, output)
    output = output or {}
    if not entry then
        return output
    end

    if entry.type == "action" then
        table.insert(output, {
            entry = entry,
            displayLabel = entry.label or ""
        })
        return output
    end

    if entry.type == "category" and entry.node and type(entry.node.entries) == "table" then
        for i = 1, #entry.node.entries do
            local child = entry.node.entries[i]
            table.insert(output, {
                entry = child,
                displayLabel = child.label or ""
            })
        end
    end

    return output
end

-----------------------------------------------
-- Browser Window                            --
-----------------------------------------------

local function rowAt(listbox, x, y)
    local index = listbox:rowAt(x, y)
    if index and listbox.items[index] then
        return index
    end
    return nil
end

local function isFavoritesCategoryEntry(entry)
    if not entry or entry.type ~= "category" then
        return false
    end

    local entryLabel = toLowerSafe(entry.label)
    local favoritesLabel = toLowerSafe(getText("IGUI_TTRP_Favorites"))
    if (favoritesLabel ~= "" and entryLabel == favoritesLabel) or entryLabel == "favorites" then
        return true
    end

    local texturePath = textureToPath(entry.texture)
    if texturePath and containsIgnoreCase(texturePath, "favorites") then
        return true
    end

    return false
end

local TTRPPosesBrowserWindow = ISCollapsableWindow:derive("TTRPPosesBrowserWindow")

function TTRPPosesBrowserWindow:new(x, y, width, height, playerObj)
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.title = getText("IGUI_TTRP_Poses")
    o.player = playerObj
    o.resizable = true

    o.rootNode = nil
    o.lastSearchText = ""

    o.poseDrillEntry = nil
    o.activeTab = "poses"
    o.poseTabControls = {}
    o.bindsTabControls = {}
    o.bindablePoseRows = {}
    o.awaitingBindKey = false
    o.pendingBindPoseRow = nil
    o.selectedLoadoutName = nil

    return o
end

function TTRPPosesBrowserWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

function TTRPPosesBrowserWindow:registerTabControl(control, tabKey)
    if not control then
        return
    end

    if tabKey == "binds" then
        table.insert(self.bindsTabControls, control)
    else
        table.insert(self.poseTabControls, control)
    end
end

function TTRPPosesBrowserWindow:updateTabButtons()
    if self.posesTabButton then
        local title = (self.activeTab == "poses") and "[Poses]" or "Poses"
        if self.posesTabButton.setTitle then
            self.posesTabButton:setTitle(title)
        else
            self.posesTabButton.title = title
        end
    end

    if self.bindsTabButton then
        local title = (self.activeTab == "binds") and "[Binds]" or "Binds"
        if self.bindsTabButton.setTitle then
            self.bindsTabButton:setTitle(title)
        else
            self.bindsTabButton.title = title
        end
    end
end

function TTRPPosesBrowserWindow:setActiveTab(tabKey)
    self.activeTab = (tabKey == "binds") and "binds" or "poses"

    -- Only show controls that belong to the active tab.
    for i = 1, #self.poseTabControls do
        local control = self.poseTabControls[i]
        control:setVisible(self.activeTab == "poses")
    end

    for i = 1, #self.bindsTabControls do
        local control = self.bindsTabControls[i]
        control:setVisible(self.activeTab == "binds")
    end

    if self.activeTab == "poses" then
        setLabelText(self.searchLabel, SEARCH_POSES_LABEL)
        self.awaitingBindKey = false
        self.pendingBindPoseRow = nil
    else
        setLabelText(self.searchLabel, SEARCH_BINDS_LABEL)
    end

    if self.layoutUI then
        self:layoutUI()
    end

    if self.activeTab == "poses" then
        self:populatePosesList(nil)
    else
        loadBindLoadouts()
        self:populateBindPoseList(nil)
        self:populateBindList(nil)
        if self.refreshLoadoutControls then
            self:refreshLoadoutControls()
        end
    end

    self:updateTabButtons()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onTabButtonClick(button)
    if not button or not button.tabKey then
        return
    end
    self:setActiveTab(button.tabKey)
end

function TTRPPosesBrowserWindow:createChildren()
    ISCollapsableWindow.createChildren(self)

    self.posesTabButton = ISButton:new(0, 0, 110, 22, "Poses", self, self.onTabButtonClick)
    self.posesTabButton:initialise()
    self.posesTabButton:instantiate()
    self.posesTabButton.tabKey = "poses"
    self:addChild(self.posesTabButton)

    self.bindsTabButton = ISButton:new(0, 0, 110, 22, "Binds", self, self.onTabButtonClick)
    self.bindsTabButton:initialise()
    self.bindsTabButton:instantiate()
    self.bindsTabButton.tabKey = "binds"
    self:addChild(self.bindsTabButton)

    self.searchLabel = ISLabel:new(0, 0, 16, SEARCH_POSES_LABEL, 1, 1, 1, 1, UIFont.Small, true)
    self.searchLabel:initialise()
    self.searchLabel:instantiate()
    self:addChild(self.searchLabel)

    self.searchBox = ISTextEntryBox:new("", 0, 0, 300, 24)
    self.searchBox:initialise()
    self.searchBox:instantiate()
    if self.searchBox.setClearButton then
        self.searchBox:setClearButton(true)
    end
    self.searchBox.tooltip = "Search all poses by category, pose name, or emote ID"
    self:addChild(self.searchBox)

    self.categoriesLabel = ISLabel:new(0, 0, 16, "Categories", 1, 1, 1, 1, UIFont.Small, true)
    self.categoriesLabel:initialise()
    self.categoriesLabel:instantiate()
    self:addChild(self.categoriesLabel)
    self:registerTabControl(self.categoriesLabel, "poses")

    self.subCategoriesLabel = ISLabel:new(0, 0, 16, "Subcategories", 1, 1, 1, 1, UIFont.Small, true)
    self.subCategoriesLabel:initialise()
    self.subCategoriesLabel:instantiate()
    self:addChild(self.subCategoriesLabel)
    self:registerTabControl(self.subCategoriesLabel, "poses")

    self.posesLabel = ISLabel:new(0, 0, 16, "Poses", 1, 1, 1, 1, UIFont.Small, true)
    self.posesLabel:initialise()
    self.posesLabel:instantiate()
    self:addChild(self.posesLabel)
    self:registerTabControl(self.posesLabel, "poses")

    self.categoriesList = ISScrollingListBox:new(0, 0, 200, 200)
    self.categoriesList:initialise()
    self.categoriesList:instantiate()
    self.categoriesList.itemheight = 54
    self.categoriesList.font = UIFont.Medium
    self.categoriesList.drawBorder = true
    self.categoriesList.parentWindow = self
    self.categoriesList.doDrawItem = function(list, y, item, alt)
        return list.parentWindow:drawListItem(list, y, item, alt, "category")
    end
    self.categoriesList.onMouseDown = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end

        listbox.selected = index
        listbox.parentWindow:onCategorySelected()
        return true
    end
    self:addChild(self.categoriesList)
    self:registerTabControl(self.categoriesList, "poses")

    self.subCategoriesList = ISScrollingListBox:new(0, 0, 200, 200)
    self.subCategoriesList:initialise()
    self.subCategoriesList:instantiate()
    self.subCategoriesList.itemheight = 54
    self.subCategoriesList.font = UIFont.Medium
    self.subCategoriesList.drawBorder = true
    self.subCategoriesList.parentWindow = self
    self.subCategoriesList.doDrawItem = function(list, y, item, alt)
        return list.parentWindow:drawListItem(list, y, item, alt, "subcategory")
    end
    self.subCategoriesList.onMouseDown = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end

        listbox.selected = index
        listbox.parentWindow:onSubCategorySelected()
        return true
    end
    self.subCategoriesList.onMouseDoubleClick = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end

        listbox.selected = index
        listbox.parentWindow:onSubCategorySelected()

        local subEntry = listbox.parentWindow:getSelectedSubCategoryEntry()
        if subEntry and subEntry.type == "action" then
            listbox.parentWindow:onPlaySelected()
        end

        return true
    end
    self:addChild(self.subCategoriesList)
    self:registerTabControl(self.subCategoriesList, "poses")

    self.posesList = ISScrollingListBox:new(0, 0, 200, 200)
    self.posesList:initialise()
    self.posesList:instantiate()
    self.posesList.itemheight = 46
    self.posesList.font = UIFont.Small
    self.posesList.drawBorder = true
    self.posesList.parentWindow = self
    self.posesList.doDrawItem = function(list, y, item, alt)
        return list.parentWindow:drawListItem(list, y, item, alt, "pose")
    end
    self.posesList.onMouseDown = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end

        listbox.selected = index
        listbox.parentWindow:onPoseSelected()
        return true
    end
    self.posesList.onMouseDoubleClick = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end

        listbox.selected = index
        local row = listbox.items[index]
        local entry = row and row.item and row.item.entry or nil
        listbox.parentWindow:onPoseSelected()
        if entry and entry.type == "action" then
            listbox.parentWindow:onPlaySelected()
        end
        return true
    end
    self:addChild(self.posesList)
    self:registerTabControl(self.posesList, "poses")

    self.playButton = ISButton:new(0, 0, 80, 24, "Play", self, self.onPlaySelected)
    self.playButton:initialise()
    self.playButton:instantiate()
    self:addChild(self.playButton)
    self:registerTabControl(self.playButton, "poses")

    self.favoriteButton = ISButton:new(0, 0, 90, 24, "Favorite", self, self.onToggleFavorite)
    self.favoriteButton:initialise()
    self.favoriteButton:instantiate()
    self:addChild(self.favoriteButton)
    self:registerTabControl(self.favoriteButton, "poses")

    self.refreshButton = ISButton:new(0, 0, 90, 24, "Refresh", self, self.onRefreshTree)
    self.refreshButton:initialise()
    self.refreshButton:instantiate()
    self:addChild(self.refreshButton)
    self:registerTabControl(self.refreshButton, "poses")

    self.cancelButton = ISButton:new(0, 0, 95, 24, "Cancel Pose", self, self.onCancelPose)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self:addChild(self.cancelButton)
    self:registerTabControl(self.cancelButton, "poses")

    self.bindsPosesLabel = ISLabel:new(0, 0, 16, "Bindable Poses", 1, 1, 1, 1, UIFont.Small, true)
    self.bindsPosesLabel:initialise()
    self.bindsPosesLabel:instantiate()
    self:addChild(self.bindsPosesLabel)
    self:registerTabControl(self.bindsPosesLabel, "binds")

    self.bindsMapLabel = ISLabel:new(0, 0, 16, "Bound Keys", 1, 1, 1, 1, UIFont.Small, true)
    self.bindsMapLabel:initialise()
    self.bindsMapLabel:instantiate()
    self:addChild(self.bindsMapLabel)
    self:registerTabControl(self.bindsMapLabel, "binds")

    self.bindPoseList = ISScrollingListBox:new(0, 0, 200, 200)
    self.bindPoseList:initialise()
    self.bindPoseList:instantiate()
    self.bindPoseList.itemheight = 46
    self.bindPoseList.font = UIFont.Small
    self.bindPoseList.drawBorder = true
    self.bindPoseList.parentWindow = self
    self.bindPoseList.doDrawItem = function(list, y, item, alt)
        return list.parentWindow:drawListItem(list, y, item, alt, "bindpose")
    end
    self.bindPoseList.onMouseDown = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end
        listbox.selected = index
        listbox.parentWindow:onBindPoseSelected()
        return true
    end
    self.bindPoseList.onMouseDoubleClick = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end
        listbox.selected = index
        listbox.parentWindow:onBindPoseSelected()
        listbox.parentWindow:onBeginCaptureBind()
        return true
    end
    self:addChild(self.bindPoseList)
    self:registerTabControl(self.bindPoseList, "binds")

    self.bindList = ISScrollingListBox:new(0, 0, 200, 200)
    self.bindList:initialise()
    self.bindList:instantiate()
    self.bindList.itemheight = 46
    self.bindList.font = UIFont.Small
    self.bindList.drawBorder = true
    self.bindList.parentWindow = self
    self.bindList.doDrawItem = function(list, y, item, alt)
        return list.parentWindow:drawListItem(list, y, item, alt, "bindlist")
    end
    self.bindList.onMouseDown = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end
        listbox.selected = index
        listbox.parentWindow:onBindListSelected()
        return true
    end
    self.bindList.onMouseDoubleClick = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end
        listbox.selected = index
        listbox.parentWindow:onBindListSelected()
        listbox.parentWindow:onUseSelectedBind()
        return true
    end
    self:addChild(self.bindList)
    self:registerTabControl(self.bindList, "binds")

    self.bindHelpLabel = ISLabel:new(0, 0, 16, BIND_HELP_TEXT, 1, 1, 1, 1, UIFont.Small, true)
    self.bindHelpLabel:initialise()
    self.bindHelpLabel:instantiate()
    self:addChild(self.bindHelpLabel)
    self:registerTabControl(self.bindHelpLabel, "binds")

    self.bindSetButton = ISButton:new(0, 0, 110, 24, "Set Key", self, self.onBeginCaptureBind)
    self.bindSetButton:initialise()
    self.bindSetButton:instantiate()
    self:addChild(self.bindSetButton)
    self:registerTabControl(self.bindSetButton, "binds")

    self.bindRemoveButton = ISButton:new(0, 0, 110, 24, "Remove Key", self, self.onRemoveSelectedBind)
    self.bindRemoveButton:initialise()
    self.bindRemoveButton:instantiate()
    self:addChild(self.bindRemoveButton)
    self:registerTabControl(self.bindRemoveButton, "binds")

    self.bindUseButton = ISButton:new(0, 0, 130, 24, "Use Bound Pose", self, self.onUseSelectedBind)
    self.bindUseButton:initialise()
    self.bindUseButton:instantiate()
    self:addChild(self.bindUseButton)
    self:registerTabControl(self.bindUseButton, "binds")

    self.loadoutActiveLabel = ISLabel:new(0, 0, 16, "Active Loadout: " .. getActiveLoadoutName(), 1, 1, 1, 1, UIFont.Small, false)
    self.loadoutActiveLabel:initialise()
    self.loadoutActiveLabel:instantiate()
    self:addChild(self.loadoutActiveLabel)
    self:registerTabControl(self.loadoutActiveLabel, "binds")

    self.loadoutList = ISScrollingListBox:new(0, 0, 200, 80)
    self.loadoutList:initialise()
    self.loadoutList:instantiate()
    self.loadoutList.itemheight = 22
    self.loadoutList.font = UIFont.Small
    self.loadoutList.drawBorder = true
    self.loadoutList.parentWindow = self
    self.loadoutList.doDrawItem = function(list, y, item, alt)
        return list.parentWindow:drawListItem(list, y, item, alt, "loadout")
    end
    self.loadoutList.onMouseDown = function(listbox, x, y)
        local index = rowAt(listbox, x, y)
        if not index then
            return false
        end
        listbox.selected = index
        listbox.parentWindow:onLoadoutSelected()
        return true
    end
    self:addChild(self.loadoutList)
    self:registerTabControl(self.loadoutList, "binds")

    self.loadoutNameEntry = ISTextEntryBox:new(getActiveLoadoutName(), 0, 0, 240, 22)
    self.loadoutNameEntry:initialise()
    self.loadoutNameEntry:instantiate()
    if self.loadoutNameEntry.setClearButton then
        self.loadoutNameEntry:setClearButton(true)
    end
    self.loadoutNameEntry.tooltip = "Type a loadout name, hit New Loadout."
    self:addChild(self.loadoutNameEntry)
    self:registerTabControl(self.loadoutNameEntry, "binds")

    self.loadoutSaveButton = ISButton:new(0, 0, 90, 24, "Save Loadout", self, self.onSaveLoadout)
    self.loadoutSaveButton:initialise()
    self.loadoutSaveButton:instantiate()
    self:addChild(self.loadoutSaveButton)
    self:registerTabControl(self.loadoutSaveButton, "binds")

    self.loadoutLoadButton = ISButton:new(0, 0, 90, 24, "Load Loadout", self, self.onLoadLoadout)
    self.loadoutLoadButton:initialise()
    self.loadoutLoadButton:instantiate()
    self:addChild(self.loadoutLoadButton)
    self:registerTabControl(self.loadoutLoadButton, "binds")

    self.loadoutDeleteButton = ISButton:new(0, 0, 100, 24, "Delete Loadout", self, self.onDeleteLoadout)
    self.loadoutDeleteButton:initialise()
    self.loadoutDeleteButton:instantiate()
    self:addChild(self.loadoutDeleteButton)
    self:registerTabControl(self.loadoutDeleteButton, "binds")

    self.loadoutNewButton = ISButton:new(0, 0, 120, 24, "New Loadout", self, self.onNewLoadout)
    self.loadoutNewButton:initialise()
    self.loadoutNewButton:instantiate()
    self:addChild(self.loadoutNewButton)
    self:registerTabControl(self.loadoutNewButton, "binds")

    self:layoutUI()
    self:rebuildTree(false)
    self:setActiveTab(self.activeTab)
end

function TTRPPosesBrowserWindow:layoutUI()
    local padding = 8
    local titleBarHeight = self:titleBarHeight()
    local tabHeight = 22
    local searchHeight = 24
    local footerHeight = (self.activeTab == "binds") and 220 or 36
    local tabGap = 6

    local tabY = titleBarHeight + padding
    self.posesTabButton:setX(padding)
    self.posesTabButton:setY(tabY)
    self.bindsTabButton:setX(self.posesTabButton:getRight() + 6)
    self.bindsTabButton:setY(tabY)

    local searchX = padding
    local searchLabelY = tabY + tabHeight + tabGap + 2
    local searchY = searchLabelY + 14
    local searchW = self.width - (padding * 2)

    -- Align with the search box text inset so label text starts on the same column.
    self.searchLabel:setX(self.searchBox:getX() + 6)
    self.searchLabel:setY(searchLabelY)

    self.searchBox:setX(searchX)
    self.searchBox:setY(searchY)
    self.searchBox:setWidth(searchW)
    self.searchBox:setHeight(searchHeight)

    local columnLabelY = searchY + searchHeight + 8
    local listY = columnLabelY + 16
    local listH = self.height - listY - padding - footerHeight - 6

    local categoryW = 170
    local subCategoryW = 240
    local listTotalW = self.width - (padding * 4)

    if listTotalW < (categoryW + subCategoryW + 250) then
        categoryW = 150
        subCategoryW = 180
    end

    local posesW = listTotalW - categoryW - subCategoryW
    if posesW < 220 then
        posesW = 220
        subCategoryW = listTotalW - categoryW - posesW
    end
    if posesW > 340 then
        local extra = posesW - 340
        posesW = 340
        subCategoryW = subCategoryW + math.floor(extra * 0.7)
        categoryW = listTotalW - subCategoryW - posesW
    end

    local categoryX = padding
    local subCategoryX = categoryX + categoryW + padding
    local posesX = subCategoryX + subCategoryW + padding

    self.categoriesList:setX(categoryX)
    self.categoriesList:setY(listY)
    self.categoriesList:setWidth(categoryW)
    self.categoriesList:setHeight(listH)

    self.categoriesLabel:setX(categoryX)
    self.categoriesLabel:setY(columnLabelY)

    self.subCategoriesList:setX(subCategoryX)
    self.subCategoriesList:setY(listY)
    self.subCategoriesList:setWidth(subCategoryW)
    self.subCategoriesList:setHeight(listH)

    self.subCategoriesLabel:setX(subCategoryX)
    self.subCategoriesLabel:setY(columnLabelY)

    self.posesList:setX(posesX)
    self.posesList:setY(listY)
    self.posesList:setWidth(posesW)
    self.posesList:setHeight(listH)

    self.posesLabel:setX(posesX)
    self.posesLabel:setY(columnLabelY)

    local controlsY = listY + listH + 6
    local spacing = 6

    self.playButton:setX(padding)
    self.playButton:setY(controlsY)

    self.favoriteButton:setX(self.playButton:getRight() + spacing)
    self.favoriteButton:setY(controlsY)

    self.refreshButton:setX(self.favoriteButton:getRight() + spacing)
    self.refreshButton:setY(controlsY)

    self.cancelButton:setX(self.width - padding - self.cancelButton:getWidth())
    self.cancelButton:setY(controlsY)

    local bindListX = padding
    local bindListY = listY
    local bindListW = math.floor((self.width - (padding * 3)) * 0.58)
    local bindMapX = bindListX + bindListW + padding
    local bindMapW = self.width - bindMapX - padding

    self.bindsPosesLabel:setX(bindListX)
    self.bindsPosesLabel:setY(columnLabelY)
    self.bindsMapLabel:setX(bindMapX)
    self.bindsMapLabel:setY(columnLabelY)

    self.bindPoseList:setX(bindListX)
    self.bindPoseList:setY(bindListY)
    self.bindPoseList:setWidth(bindListW)
    self.bindPoseList:setHeight(listH)

    self.bindList:setX(bindMapX)
    self.bindList:setY(bindListY)
    self.bindList:setWidth(bindMapW)
    self.bindList:setHeight(listH)

    self.bindSetButton:setX(bindListX)
    self.bindSetButton:setY(controlsY)
    self.bindRemoveButton:setX(self.bindSetButton:getRight() + spacing)
    self.bindRemoveButton:setY(controlsY)
    self.bindUseButton:setX(self.bindList:getRight() - self.bindUseButton:getWidth())
    self.bindUseButton:setY(controlsY)

    self.bindHelpLabel:setX(bindListX)
    self.bindHelpLabel:setY(controlsY + self.bindSetButton:getHeight() + 4)

    local loadoutY = self.bindHelpLabel:getY() + 16
    self.loadoutActiveLabel:setX(bindMapX)
    self.loadoutActiveLabel:setY(loadoutY)

    self.loadoutList:setX(bindMapX)
    self.loadoutList:setY(self.loadoutActiveLabel:getY() + 14)
    self.loadoutList:setWidth(bindMapW)
    self.loadoutList:setHeight(64)

    self.loadoutNameEntry:setX(bindMapX)
    self.loadoutNameEntry:setY(self.loadoutList:getY() + self.loadoutList:getHeight() + 4)
    self.loadoutNameEntry:setWidth(bindMapW)
    self.loadoutNameEntry:setHeight(22)

    local loadoutBtnY = self.loadoutNameEntry:getY() + self.loadoutNameEntry:getHeight() + 4
    local loadoutBtnW = math.floor((bindMapW - (spacing * 2)) / 3)
    self.loadoutSaveButton:setX(bindMapX)
    self.loadoutSaveButton:setY(loadoutBtnY)
    self.loadoutSaveButton:setWidth(loadoutBtnW)
    self.loadoutLoadButton:setX(self.loadoutSaveButton:getRight() + spacing)
    self.loadoutLoadButton:setY(loadoutBtnY)
    self.loadoutLoadButton:setWidth(loadoutBtnW)
    self.loadoutDeleteButton:setX(self.loadoutLoadButton:getRight() + spacing)
    self.loadoutDeleteButton:setY(loadoutBtnY)
    self.loadoutDeleteButton:setWidth(bindMapW - (loadoutBtnW * 2) - (spacing * 2))

    local newLoadoutBtnY = loadoutBtnY + self.loadoutSaveButton:getHeight() + 4
    self.loadoutNewButton:setX(bindMapX)
    self.loadoutNewButton:setY(newLoadoutBtnY)
    self.loadoutNewButton:setWidth(bindMapW)

    updateListScrollState(self.categoriesList)
    updateListScrollState(self.subCategoriesList)
    updateListScrollState(self.posesList)
    updateListScrollState(self.bindPoseList)
    updateListScrollState(self.bindList)
    updateListScrollState(self.loadoutList)
end

function TTRPPosesBrowserWindow:onResize()
    ISCollapsableWindow.onResize(self)

    if not self.categoriesList then
        return
    end

    self:layoutUI()
end

function TTRPPosesBrowserWindow:prerender()
    ISCollapsableWindow.prerender(self)

    local searchText = normalizeSearchText(self.searchBox and self.searchBox:getText() or "")
    if searchText ~= self.lastSearchText then
        self.lastSearchText = searchText
        if self.activeTab == "binds" then
            self:populateBindPoseList(nil)
        else
            self.poseDrillEntry = nil
            self:populatePosesList(nil)
        end
    end
end

function TTRPPosesBrowserWindow:drawListItem(list, y, item, alt, listType)
    local row = item.item
    local entry = row and row.entry or nil
    local displayText = row and row.displayLabel or item.text

    list:drawRectBorder(0, y, list:getWidth(), list.itemheight - 1, 0.9, 1, 1, 1)
    if list.selected == item.index then
        list:drawRect(0, y, list:getWidth(), list.itemheight - 1, 0.3, 0.52, 0.18, 0.58)
    end

    local textX = 6
    if entry and entry.texture then
        local iconPadding = 3
        local iconMaxSize = 40
        if listType == "category" or listType == "subcategory" then
            iconMaxSize = 48
        end
        local iconSize = math.max(20, math.min(iconMaxSize, list.itemheight - (iconPadding * 2)))
        local iconX = 5
        local iconY = y + math.floor((list.itemheight - iconSize) / 2)
        list:drawTextureScaledAspect(entry.texture, iconX, iconY, iconSize, iconSize, 1, 1, 1, 1)
        textX = iconX + iconSize + 6
    end

    local hasPoseChevron = (listType == "pose" and entry and entry.type == "category")
    local hasFavoriteMarker = (listType == "pose" and entry and self:isEntryFavorite(entry))
    local hasSubcategoryChevron = (listType == "subcategory")
    local hasRightMarker = hasSubcategoryChevron or hasPoseChevron or hasFavoriteMarker
    local markerReserve = hasFavoriteMarker and 8 or (hasRightMarker and 14 or 2)
    local textMaxWidth = math.max(0, list:getWidth() - textX - markerReserve)
    local clippedText = fitTextToWidth(displayText, list.font, textMaxWidth)
    list:drawText(clippedText, textX, y + (list.itemheight - getTextManager():getFontFromEnum(list.font):getLineHeight()) / 2, 1, 1, 1, 0.95, list.font)

    if hasSubcategoryChevron then
        local arrowR, arrowG, arrowB = 0.9, 0.9, 0.9
        if not entry or entry.type ~= "category" then
            arrowR, arrowG, arrowB = 0.65, 0.65, 0.65
        end
        drawChevronMarker(list, list:getWidth() - 11, y, list.itemheight, arrowR, arrowG, arrowB, 1)
    elseif hasPoseChevron then
        drawChevronMarker(list, list:getWidth() - 11, y, list.itemheight, 0.9, 0.9, 0.9, 1)
    elseif hasFavoriteMarker then
        local textW = getTextManager():MeasureStringX(list.font, clippedText or "")
        local starX = textX + textW + 4
        local maxStarX = list:getWidth() - 12
        if starX > maxStarX then
            starX = maxStarX
        end
        local starFont = UIFont.Medium
        local starY = y + (list.itemheight - getTextManager():getFontFromEnum(starFont):getLineHeight()) / 2
        list:drawText("*", starX, starY, 1.0, 0.85, 0.2, 1, starFont)
    end

    return y + list.itemheight
end

function TTRPPosesBrowserWindow:getSelectedCategoryEntry()
    if not self.categoriesList.selected or self.categoriesList.selected < 1 then
        return nil
    end

    local row = self.categoriesList.items[self.categoriesList.selected]
    return row and row.item and row.item.entry or nil
end

function TTRPPosesBrowserWindow:getSelectedSubCategoryEntry()
    if not self.subCategoriesList.selected or self.subCategoriesList.selected < 1 then
        return nil
    end

    local row = self.subCategoriesList.items[self.subCategoriesList.selected]
    return row and row.item and row.item.entry or nil
end

function TTRPPosesBrowserWindow:getSelectedPoseEntry()
    if not self.posesList.selected or self.posesList.selected < 1 then
        return nil
    end

    local row = self.posesList.items[self.posesList.selected]
    return row and row.item and row.item.entry or nil
end

function TTRPPosesBrowserWindow:getSelectedBindPoseRow()
    if not self.bindPoseList or not self.bindPoseList.selected or self.bindPoseList.selected < 1 then
        return nil
    end
    local row = self.bindPoseList.items[self.bindPoseList.selected]
    return row and row.item or nil
end

function TTRPPosesBrowserWindow:getSelectedBindRow()
    if not self.bindList or not self.bindList.selected or self.bindList.selected < 1 then
        return nil
    end
    local row = self.bindList.items[self.bindList.selected]
    return row and row.item or nil
end

function TTRPPosesBrowserWindow:buildBindablePoseRows()
    self.bindablePoseRows = {}
    if not self.rootNode or type(self.rootNode.entries) ~= "table" then
        return
    end

    for i = 1, #self.rootNode.entries do
        local category = self.rootNode.entries[i]
        if not isFavoritesCategoryEntry(category) then
            local prefix = (category and category.label and category.label ~= "") and (category.label .. " / ") or ""
            collectActionEntries(category, self.bindablePoseRows, prefix)
        end
    end
end

function TTRPPosesBrowserWindow:populateBindPoseList(preferredLabel)
    self:buildBindablePoseRows()
    self.bindPoseList:clear()

    local searchText = normalizeSearchText(self.searchBox and self.searchBox:getText() or "")
    for i = 1, #self.bindablePoseRows do
        local row = self.bindablePoseRows[i]
        local entry = row.entry
        local poseLabel = (entry and entry.label) or row.displayLabel or ""
        local emoteId = (entry and entry.args and entry.args[1]) or ""
        local searchable = poseLabel .. " " .. (row.displayLabel or "") .. " " .. tostring(emoteId)

        if containsIgnoreCase(searchable, searchText) then
            self.bindPoseList:addItem(poseLabel, {
                entry = row.entry,
                displayLabel = poseLabel,
                fullPathLabel = row.displayLabel or poseLabel,
            })
        end
    end

    if #self.bindPoseList.items > 0 then
        if not self:selectRowByLabel(self.bindPoseList, preferredLabel) then
            self.bindPoseList.selected = 1
        end
    else
        self.bindPoseList.selected = 0
    end

    updateListScrollState(self.bindPoseList)
end

function TTRPPosesBrowserWindow:populateBindList(preferredKeyCode)
    self.bindList:clear()

    local rows = {}
    for keyCode, bindData in pairs(TTRPPosesTreeUI.customBinds or {}) do
        local numericKey = tonumber(keyCode)
        if numericKey and type(bindData) == "table" and bindData.emote then
            table.insert(rows, {
                keyCode = numericKey,
                bindData = bindData,
                displayLabel = keyCodeToName(numericKey) .. " -> " .. (bindData.displayLabel or bindData.label or bindData.emote),
            })
        end
    end

    table.sort(rows, function(a, b)
        return tostring(a.displayLabel) < tostring(b.displayLabel)
    end)

    for i = 1, #rows do
        local row = rows[i]
        self.bindList:addItem(row.displayLabel, {
            entry = {
                type = "action",
                texture = getTextureSafe(row.bindData.texturePath),
            },
            keyCode = row.keyCode,
            bindData = row.bindData,
            displayLabel = row.displayLabel,
        })
    end

    if #self.bindList.items > 0 then
        local preferredFound = false
        if preferredKeyCode then
            for i = 1, #self.bindList.items do
                local row = self.bindList.items[i]
                if row and row.item and row.item.keyCode == preferredKeyCode then
                    self.bindList.selected = i
                    preferredFound = true
                    break
                end
            end
        end
        if not preferredFound then
            self.bindList.selected = 1
        end
    else
        self.bindList.selected = 0
    end

    updateListScrollState(self.bindList)
end

function TTRPPosesBrowserWindow:onBindPoseSelected()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onBindListSelected()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onBeginCaptureBind()
    local selectedPose = self:getSelectedBindPoseRow()
    if not selectedPose or not selectedPose.entry or selectedPose.entry.type ~= "action" then
        return
    end

    self.awaitingBindKey = true
    self.pendingBindPoseRow = selectedPose
    setLabelText(self.bindHelpLabel, "Press a key to bind: " .. (selectedPose.displayLabel or "pose"))
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onCaptureBindKey(keyCode)
    if not self.awaitingBindKey then
        return false
    end

    local selectedPose = self.pendingBindPoseRow
    self.awaitingBindKey = false
    self.pendingBindPoseRow = nil
    setLabelText(self.bindHelpLabel, BIND_HELP_TEXT)

    if not selectedPose or not selectedPose.entry then
        self:updateButtons()
        return true
    end

    local poseEntry = selectedPose.entry
    local bindableData = getBindData(poseEntry)
    if not bindableData then
        self:updateButtons()
        return true
    end

    local keyStr = tostring(keyCode)
    -- One bind per key: setting again overwrites the previous keybind.
    TTRPPosesTreeUI.customBinds[keyStr] = {
        label = bindableData.text,
        displayLabel = selectedPose.displayLabel or bindableData.text,
        emote = bindableData.emote,
        texturePath = textureToPath(bindableData.texture),
    }
    saveCustomBinds()

    self:populateBindList(keyCode)
    self:updateButtons()

    local player = getLocalPlayer()
    if player then
        player:setHaloNote("Bound " .. keyCodeToName(keyCode) .. " to " .. (selectedPose.displayLabel or bindableData.text), 120, 220, 120, 120)
    end
    return true
end

function TTRPPosesBrowserWindow:onRemoveSelectedBind()
    local selectedBind = self:getSelectedBindRow()
    if not selectedBind or not selectedBind.keyCode then
        return
    end

    TTRPPosesTreeUI.customBinds[tostring(selectedBind.keyCode)] = nil
    saveCustomBinds()
    self:populateBindList(nil)
    setLabelText(self.bindHelpLabel, BIND_HELP_TEXT)
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onUseSelectedBind()
    local selectedBind = self:getSelectedBindRow()
    if not selectedBind or not selectedBind.bindData or not selectedBind.bindData.emote then
        return
    end

    local player = getLocalPlayer()
    if not player then
        return
    end

    playBoundEmote(selectedBind.bindData.emote, player)
end

function TTRPPosesBrowserWindow:getRequestedLoadoutName()
    local rawName = self.loadoutNameEntry and self.loadoutNameEntry:getText() or ""
    local loadoutName = normalizeSearchText(rawName)
    if loadoutName == "" then
        return nil
    end
    return loadoutName
end

function TTRPPosesBrowserWindow:getSelectedLoadoutName()
    if not self.loadoutList or not self.loadoutList.selected or self.loadoutList.selected < 1 then
        return nil
    end
    local row = self.loadoutList.items[self.loadoutList.selected]
    local data = row and row.item or nil
    return data and data.name or nil
end

function TTRPPosesBrowserWindow:onLoadoutSelected()
    local selectedName = self:getSelectedLoadoutName()
    self.selectedLoadoutName = selectedName
    if selectedName and self.loadoutNameEntry then
        self.loadoutNameEntry:setText(selectedName)
    end
    self:updateButtons()
end

function TTRPPosesBrowserWindow:populateLoadoutList(preferredName)
    if not self.loadoutList then
        return
    end

    self.loadoutList:clear()

    local names = {}
    for name, loadoutData in pairs(TTRPPosesTreeUI.bindLoadouts or {}) do
        if type(name) == "string" and type(loadoutData) == "table" then
            table.insert(names, name)
        end
    end

    table.sort(names, function(a, b)
        if a == DEFAULT_BIND_LOADOUT then
            return true
        end
        if b == DEFAULT_BIND_LOADOUT then
            return false
        end
        return toLowerSafe(a) < toLowerSafe(b)
    end)

    local selectedIndex = nil
    for i = 1, #names do
        local name = names[i]
        self.loadoutList:addItem(name, { name = name, displayLabel = name })
        if preferredName and preferredName == name then
            selectedIndex = i
        end
    end

    if selectedIndex then
        self.loadoutList.selected = selectedIndex
    elseif #names > 0 then
        self.loadoutList.selected = 1
    else
        self.loadoutList.selected = 0
    end

    self.selectedLoadoutName = self:getSelectedLoadoutName()
    updateListScrollState(self.loadoutList)
end

function TTRPPosesBrowserWindow:refreshLoadoutControls()
    local active = getActiveLoadoutName()
    if self.loadoutActiveLabel then
        setLabelText(self.loadoutActiveLabel, "Active Loadout: " .. active)
        if self.loadoutList then
            self.loadoutActiveLabel:setX(self.loadoutList:getX())
            self.loadoutActiveLabel:setY(self.loadoutList:getY() - 14)
        end
    end
    if self.loadoutNameEntry and ((self.loadoutNameEntry:getText() or "") == "" or self:getSelectedLoadoutName() == nil) then
        self.loadoutNameEntry:setText(active)
    end
    self:populateLoadoutList(active)
end

function TTRPPosesBrowserWindow:onSaveLoadout()
    local loadoutName = self:getRequestedLoadoutName()
    if not loadoutName then
        return
    end

    TTRPPosesTreeUI.bindLoadouts[loadoutName] = {
        label = loadoutName,
        binds = cloneBindsTable(TTRPPosesTreeUI.customBinds or {}),
    }
    TTRPPosesTreeUI.activeBindLoadout = loadoutName
    saveBindLoadouts()
    self.selectedLoadoutName = loadoutName
    if self.loadoutNameEntry then
        self.loadoutNameEntry:setText(loadoutName)
    end
    self:refreshLoadoutControls()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onLoadLoadout()
    local loadoutName = self:getSelectedLoadoutName() or self:getRequestedLoadoutName()
    if not loadoutName then
        return
    end

    local loadoutData = TTRPPosesTreeUI.bindLoadouts and TTRPPosesTreeUI.bindLoadouts[loadoutName]
    if not loadoutData then
        return
    end

    TTRPPosesTreeUI.customBinds = cloneBindsTable(loadoutData.binds or {})
    TTRPPosesTreeUI.activeBindLoadout = loadoutName
    saveCustomBinds()
    self:populateBindList(nil)
    self.selectedLoadoutName = loadoutName
    if self.loadoutNameEntry then
        self.loadoutNameEntry:setText(loadoutName)
    end
    self:refreshLoadoutControls()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onDeleteLoadout()
    local loadoutName = self:getSelectedLoadoutName() or self:getRequestedLoadoutName()
    if not loadoutName or loadoutName == DEFAULT_BIND_LOADOUT then
        return
    end

    if not TTRPPosesTreeUI.bindLoadouts or not TTRPPosesTreeUI.bindLoadouts[loadoutName] then
        return
    end

    TTRPPosesTreeUI.bindLoadouts[loadoutName] = nil

    if TTRPPosesTreeUI.activeBindLoadout == loadoutName then
        TTRPPosesTreeUI.activeBindLoadout = DEFAULT_BIND_LOADOUT
        ensureActiveLoadout()
        TTRPPosesTreeUI.customBinds = cloneBindsTable(TTRPPosesTreeUI.bindLoadouts[DEFAULT_BIND_LOADOUT].binds or {})
        saveCustomBinds()
        self:populateBindList(nil)
    else
        saveBindLoadouts()
    end

    self.selectedLoadoutName = getActiveLoadoutName()
    if self.loadoutNameEntry then
        self.loadoutNameEntry:setText(self.selectedLoadoutName)
    end
    self:refreshLoadoutControls()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onNewLoadout()
    local loadoutName = self:getRequestedLoadoutName()
    if not loadoutName then
        return
    end

    TTRPPosesTreeUI.customBinds = {}
    TTRPPosesTreeUI.bindLoadouts[loadoutName] = {
        label = loadoutName,
        binds = {},
    }
    TTRPPosesTreeUI.activeBindLoadout = loadoutName
    saveCustomBinds()

    self:populateBindList(nil)
    self.selectedLoadoutName = loadoutName
    if self.loadoutNameEntry then
        self.loadoutNameEntry:setText(loadoutName)
    end
    self:refreshLoadoutControls()
    self:updateButtons()
end

function TTRPPosesBrowserWindow:isEntryFavorite(entry)
    if not entry then
        return false
    end

    local favoriteData = getFavoriteEntryData(entry)
    if not favoriteData then
        return false
    end

    if TTRPFavorites and TTRPFavorites.contains then
        return TTRPFavorites.contains(favoriteData.text)
    end

    return (Favorites or {})[favoriteData.text] ~= nil
end

function TTRPPosesBrowserWindow:updateButtons()
    if self.activeTab == "binds" then
        local selectedBindPose = self:getSelectedBindPoseRow()
        local selectedBind = self:getSelectedBindRow()
        local selectedLoadoutName = self:getSelectedLoadoutName()
        local requestedLoadoutName = self:getRequestedLoadoutName()
        local existingRequested = requestedLoadoutName and TTRPPosesTreeUI.bindLoadouts and TTRPPosesTreeUI.bindLoadouts[requestedLoadoutName] or nil

        self.bindSetButton:setEnable(selectedBindPose ~= nil)
        self.bindRemoveButton:setEnable(selectedBind ~= nil)
        self.bindUseButton:setEnable(selectedBind ~= nil)
        if self.loadoutSaveButton then
            self.loadoutSaveButton:setEnable(requestedLoadoutName ~= nil)
        end
        if self.loadoutLoadButton then
            self.loadoutLoadButton:setEnable(selectedLoadoutName ~= nil or existingRequested ~= nil)
        end
        if self.loadoutDeleteButton then
            local deleteCandidate = selectedLoadoutName or requestedLoadoutName
            local canDelete = deleteCandidate ~= nil and deleteCandidate ~= DEFAULT_BIND_LOADOUT and TTRPPosesTreeUI.bindLoadouts and TTRPPosesTreeUI.bindLoadouts[deleteCandidate] ~= nil
            self.loadoutDeleteButton:setEnable(canDelete)
        end
        if self.loadoutNewButton then
            self.loadoutNewButton:setEnable(requestedLoadoutName ~= nil)
        end

        local setTitle = self.awaitingBindKey and "Press Key..." or "Set Key"
        if self.bindSetButton.setTitle then
            self.bindSetButton:setTitle(setTitle)
        else
            self.bindSetButton.title = setTitle
        end

        return
    end

    local poseEntry = self:getSelectedPoseEntry()
    local hasPlayablePose = poseEntry and poseEntry.type == "action" and type(poseEntry.command) == "function"

    self.playButton:setEnable(hasPlayablePose)

    local canFavorite = getFavoriteEntryData(poseEntry) ~= nil
    self.favoriteButton:setEnable(canFavorite)

    local favoriteTitle = "Favorite"
    if canFavorite and self:isEntryFavorite(poseEntry) then
        favoriteTitle = "Unfavorite"
    end

    if self.favoriteButton.setTitle then
        self.favoriteButton:setTitle(favoriteTitle)
    else
        self.favoriteButton.title = favoriteTitle
    end
end

function TTRPPosesBrowserWindow:selectRowByLabel(listbox, label)
    if not label then
        return false
    end

    for i = 1, #listbox.items do
        local row = listbox.items[i]
        if row and row.item and row.item.entry and row.item.entry.label == label then
            listbox.selected = i
            return true
        end
    end

    return false
end

function TTRPPosesBrowserWindow:rebuildTree(keepSelection)
    local selectedCategoryLabel, selectedSubLabel, selectedPoseLabel

    if keepSelection then
        local selectedCategory = self:getSelectedCategoryEntry()
        local selectedSub = self:getSelectedSubCategoryEntry()
        local selectedPose = self:getSelectedPoseEntry()

        selectedCategoryLabel = selectedCategory and selectedCategory.label or nil
        selectedSubLabel = selectedSub and selectedSub.label or nil
        selectedPoseLabel = selectedPose and selectedPose.label or nil
    end

    self.player = getLocalPlayer()
    self.rootNode = buildRootTree(self.player)

    self:populateCategoriesList(selectedCategoryLabel)
    self:populateSubCategoriesList(selectedSubLabel)
    self:populatePosesList(selectedPoseLabel)
    self:populateBindPoseList(nil)
    self:populateBindList(nil)
end

function TTRPPosesBrowserWindow:populateCategoriesList(preferredLabel)
    self.categoriesList:clear()

    if not self.rootNode or type(self.rootNode.entries) ~= "table" then
        return
    end

    for i = 1, #self.rootNode.entries do
        local entry = self.rootNode.entries[i]
        if entry.type == "category" then
            self.categoriesList:addItem(entry.label or "", {
                entry = entry,
                displayLabel = entry.label or ""
            })
        end
    end

    if #self.categoriesList.items > 0 then
        if not self:selectRowByLabel(self.categoriesList, preferredLabel) then
            self.categoriesList.selected = 1
        end
    else
        self.categoriesList.selected = 0
    end

    updateListScrollState(self.categoriesList)
end

function TTRPPosesBrowserWindow:populateSubCategoriesList(preferredLabel)
    self.subCategoriesList:clear()

    local category = self:getSelectedCategoryEntry()
    if not category or category.type ~= "category" or not category.node then
        self:populatePosesList(nil)
        return
    end

    local entries = category.node.entries or {}

    for i = 1, #entries do
        local entry = entries[i]
        self.subCategoriesList:addItem(entry.label or "", {
            entry = entry,
            displayLabel = entry.label or ""
        })
    end

    if #self.subCategoriesList.items > 0 then
        if not self:selectRowByLabel(self.subCategoriesList, preferredLabel) then
            self.subCategoriesList.selected = 1
        end
    else
        self.subCategoriesList.selected = 0
    end

    updateListScrollState(self.subCategoriesList)
end

function TTRPPosesBrowserWindow:populatePosesList(preferredLabel)
    self.posesList:clear()

    local poseRows = {}
    local searchText = normalizeSearchText(self.searchBox and self.searchBox:getText() or "")
    local hasSearch = searchText ~= ""

    if hasSearch then
        if self.rootNode and type(self.rootNode.entries) == "table" then
            for i = 1, #self.rootNode.entries do
                local entry = self.rootNode.entries[i]
                local prefix = ""
                if entry and entry.label and entry.label ~= "" then
                    prefix = entry.label .. " / "
                end
                collectActionEntries(entry, poseRows, prefix)
            end
        end
    else
        local subEntry = self.poseDrillEntry or self:getSelectedSubCategoryEntry()
        if not subEntry then
            self:updateButtons()
            return
        end
        poseRows = collectImmediateRows(subEntry, {})
    end

    for i = 1, #poseRows do
        local row = poseRows[i]
        local entry = row.entry
        local emoteId = (entry and entry.args and entry.args[1]) or (entry and entry.label) or ""
        local searchableText = (row.displayLabel or "") .. " " .. tostring(emoteId)

        if (not hasSearch) or containsIgnoreCase(searchableText, searchText) then
            self.posesList:addItem(row.displayLabel or "", {
                entry = row.entry,
                displayLabel = row.displayLabel or ""
            })
        end
    end

    if #self.posesList.items > 0 then
        if not self:selectRowByLabel(self.posesList, preferredLabel) then
            self.posesList.selected = 1
        end
    else
        self.posesList.selected = 0
    end

    updateListScrollState(self.posesList)
    self:updateButtons()
end

function TTRPPosesBrowserWindow:onCategorySelected()
    self.poseDrillEntry = nil
    self:populateSubCategoriesList(nil)
    self:populatePosesList(nil)
end

function TTRPPosesBrowserWindow:onSubCategorySelected()
    self.poseDrillEntry = nil
    self:populatePosesList(nil)
end

function TTRPPosesBrowserWindow:onPoseSelected()
    local entry = self:getSelectedPoseEntry()
    if entry and entry.type == "category" then
        self.poseDrillEntry = entry
        self:populatePosesList(nil)
        return
    end

    self:updateButtons()
end

function TTRPPosesBrowserWindow:onPlaySelected()
    local entry = self:getSelectedPoseEntry()
    if not entry or entry.type ~= "action" or type(entry.command) ~= "function" then
        return
    end

    entry.command(unpackArgs(entry.args or {}))
end

function TTRPPosesBrowserWindow:onCancelPose()
    local player = getLocalPlayer()
    if not player then
        return
    end

    if type(TTRPcancelEmote) == "function" then
        TTRPcancelEmote("BobRPS_Cancel", player)
    else
        player:playEmote("BobRPS_Cancel")
    end
end

function TTRPPosesBrowserWindow:onToggleFavorite()
    local entry = self:getSelectedPoseEntry()
    local favoriteData = getFavoriteEntryData(entry)

    if not favoriteData then
        return
    end

    -- Persist favorites and rebuild so favorite labels/buttons update immediately like in the radial menu.
    if TTRPFavorites and TTRPFavorites.toggle then
        TTRPFavorites.toggle(favoriteData.text, favoriteData.texture, favoriteData.emote)
    end
    self:rebuildTree(true)
end

function TTRPPosesBrowserWindow:onRefreshTree()
    self.poseDrillEntry = nil
    self:rebuildTree(true)
end

-----------------------------------------------
-- Floating Launcher icon                    --
-----------------------------------------------

local TTRPPosesLauncherIcon = ISPanel:derive("TTRPPosesLauncherIcon")

function TTRPPosesLauncherIcon:new(x, y)
    local o = ISPanel.new(self, x, y, ICON_SIZE, ICON_SIZE)
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    o.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    o.iconTexture = getTexture(ICON_TEXTURE_PATH)
    o.dragging = false
    o.didDrag = false
    o.dragOriginX = 0
    o.dragOriginY = 0
    o.dragMouseX = 0
    o.dragMouseY = 0
    return o
end

function TTRPPosesLauncherIcon:initialise()
    ISPanel.initialise(self)
end

function TTRPPosesLauncherIcon:prerender()
    ISPanel.prerender(self)

    local alpha = self.mouseOver and 0.45 or 0.2
    self:drawRect(0, 0, self.width, self.height, alpha, 0.05, 0.05, 0.05)
    self:drawRectBorder(0, 0, self.width, self.height, 0.6, 0.7, 0.7, 0.7)
end

function TTRPPosesLauncherIcon:render()
    ISPanel.render(self)

    if self.iconTexture then
        self:drawTextureScaledAspect(self.iconTexture, 3, 3, self.width - 6, self.height - 6, 1, 1, 1, 1)
    else
        self:drawText("P", (self.width / 2) - 4, (self.height / 2) - 7, 1, 1, 1, 1, UIFont.Medium)
    end
end

function TTRPPosesLauncherIcon:onMouseDown(x, y)
    self.dragging = true
    self.didDrag = false
    self.dragOriginX = self:getX()
    self.dragOriginY = self:getY()
    self.dragMouseX = getMouseX()
    self.dragMouseY = getMouseY()
    return true
end

function TTRPPosesLauncherIcon:handleDrag()
    if not self.dragging then
        return
    end

    local mouseX = getMouseX()
    local mouseY = getMouseY()

    local dx = mouseX - self.dragMouseX
    local dy = mouseY - self.dragMouseY

    if not self.didDrag and (math.abs(dx) > ICON_DRAG_THRESHOLD or math.abs(dy) > ICON_DRAG_THRESHOLD) then
        self.didDrag = true
    end

    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()

    local targetX = self.dragOriginX + dx
    local targetY = self.dragOriginY + dy

    targetX = math.max(0, math.min(targetX, screenW - self.width))
    targetY = math.max(0, math.min(targetY, screenH - self.height))

    self:setX(targetX)
    self:setY(targetY)
end

function TTRPPosesLauncherIcon:onMouseMove(dx, dy)
    self:handleDrag()
    return true
end

function TTRPPosesLauncherIcon:onMouseMoveOutside(dx, dy)
    self:handleDrag()
    return true
end

function TTRPPosesLauncherIcon:finishMouseAction()
    if not self.dragging then
        return
    end

    self.dragging = false

    local state = getOrCreateState()
    if state then
        state.iconX = self:getX()
        state.iconY = self:getY()
        persistState()
    end

    -- Click toggles the window, drag only repositions the launcher icon.
    if not self.didDrag then
        TTRPPosesTreeUI.toggleWindow()
    end
end

function TTRPPosesLauncherIcon:onMouseUp(x, y)
    self:finishMouseAction()
    return true
end

function TTRPPosesLauncherIcon:onMouseUpOutside(x, y)
    self:finishMouseAction()
    return true
end

function TTRPPosesTreeUI.ensureUI()
    local state = getOrCreateState()
    if not state then
        return
    end

    local clampedX, clampedY, hasBounds = clampToScreen(state.iconX, state.iconY, ICON_SIZE, ICON_SIZE)
    if hasBounds then
        state.iconX = clampedX
        state.iconY = clampedY
    end

    if not TTRPPosesTreeUI.launcher then
        TTRPPosesTreeUI.launcher = TTRPPosesLauncherIcon:new(state.iconX, state.iconY)
        TTRPPosesTreeUI.launcher:initialise()
        TTRPPosesTreeUI.launcher:instantiate()
    else
        TTRPPosesTreeUI.launcher:setX(state.iconX)
        TTRPPosesTreeUI.launcher:setY(state.iconY)
    end

    if state.iconHidden then
        TTRPPosesTreeUI.launcher:setVisible(false)
        TTRPPosesTreeUI.launcher:removeFromUIManager()
    else
        TTRPPosesTreeUI.launcher:setVisible(true)
        TTRPPosesTreeUI.launcher:addToUIManager()
        TTRPPosesTreeUI.launcher:bringToTop()
    end

    if not TTRPPosesTreeUI.window then
        TTRPPosesTreeUI.window = TTRPPosesBrowserWindow:new(state.windowX, state.windowY, state.windowW, state.windowH, getLocalPlayer())
        TTRPPosesTreeUI.window:initialise()
        TTRPPosesTreeUI.window:instantiate()
    end
end

function TTRPPosesTreeUI.toggleLauncherVisibility()
    local state = getOrCreateState()
    if not state then
        return
    end

    if not TTRPPosesTreeUI.launcher then
        TTRPPosesTreeUI.launcher = TTRPPosesLauncherIcon:new(state.iconX, state.iconY)
        TTRPPosesTreeUI.launcher:initialise()
        TTRPPosesTreeUI.launcher:instantiate()
    end

    local launcher = TTRPPosesTreeUI.launcher
    if isLauncherVisible() then
        state.iconHidden = true
        launcher:setVisible(false)
        launcher:removeFromUIManager()
    else
        local mouseX = getMouseX and getMouseX() or state.iconX
        local mouseY = getMouseY and getMouseY() or state.iconY
        local targetX = math.floor(mouseX - (launcher:getWidth() / 2))
        local targetY = math.floor(mouseY - (launcher:getHeight() / 2))
        targetX, targetY = clampToScreen(targetX, targetY, launcher:getWidth(), launcher:getHeight())

        launcher:setX(targetX)
        launcher:setY(targetY)
        launcher:setVisible(true)
        launcher:addToUIManager()
        launcher:bringToTop()

        state.iconX = targetX
        state.iconY = targetY
        state.iconHidden = false
    end

    persistState()
end

function TTRPPosesTreeUI.toggleWindow()
    TTRPPosesTreeUI.ensureUI()

    local window = TTRPPosesTreeUI.window
    if not window then
        return
    end

    if TTRPPosesTreeUI.windowOpen then
        local state = getOrCreateState()
        if state then
            state.windowX = window:getX()
            state.windowY = window:getY()
            state.windowW = window:getWidth()
            state.windowH = window:getHeight()
            persistState()
        end

        window:setVisible(false)
        window:removeFromUIManager()
        TTRPPosesTreeUI.windowOpen = false
    else
        local state = getOrCreateState()
        if state then
            window:setX(state.windowX)
            window:setY(state.windowY)
            window:setWidth(state.windowW)
            window:setHeight(state.windowH)
        end

        if window.layoutUI then
            window:layoutUI()
        end
        window.player = getLocalPlayer()
        window:rebuildTree(true)
        if window.refreshLoadoutControls then
            window:refreshLoadoutControls()
        end
        window:addToUIManager()
        window:setVisible(true)
        window:bringToTop()
        TTRPPosesTreeUI.windowOpen = true
    end
end

function TTRPPosesTreeUI.stopDeferredEnsure()
    if TTRPPosesTreeUI.deferredEnsureActive then
        Events.OnTick.Remove(TTRPPosesTreeUI.onDeferredEnsureTick)
        TTRPPosesTreeUI.deferredEnsureActive = false
    end
    TTRPPosesTreeUI.deferredEnsureTicks = 0
end

function TTRPPosesTreeUI.scheduleDeferredEnsure()
    TTRPPosesTreeUI.deferredEnsureTicks = STARTUP_ENSURE_TICKS
    if not TTRPPosesTreeUI.deferredEnsureActive then
        Events.OnTick.Add(TTRPPosesTreeUI.onDeferredEnsureTick)
        TTRPPosesTreeUI.deferredEnsureActive = true
    end
end

function TTRPPosesTreeUI.onDeferredEnsureTick()
    local state = getOrCreateState()
    if not state then
        return
    end

    TTRPPosesTreeUI.ensureUI()

    -- Stop retrying once the icon is intentionally hidden, or visible and on-screen.
    if state.iconHidden or (isLauncherVisible() and isLauncherInScreenBounds()) then
        TTRPPosesTreeUI.stopDeferredEnsure()
        return
    end

    TTRPPosesTreeUI.deferredEnsureTicks = (TTRPPosesTreeUI.deferredEnsureTicks or 0) - 1
    if TTRPPosesTreeUI.deferredEnsureTicks <= 0 then
        TTRPPosesTreeUI.stopDeferredEnsure()
    end
end

function TTRPPosesTreeUI.onResolutionChange(oldW, oldH, newW, newH)
    local state = getOrCreateState()
    if not state then
        return
    end

    if TTRPPosesTreeUI.launcher then
        local clampedX, clampedY, hasBounds = clampToScreen(
            TTRPPosesTreeUI.launcher:getX(),
            TTRPPosesTreeUI.launcher:getY(),
            TTRPPosesTreeUI.launcher:getWidth(),
            TTRPPosesTreeUI.launcher:getHeight()
        )
        if hasBounds then
            TTRPPosesTreeUI.launcher:setX(clampedX)
            TTRPPosesTreeUI.launcher:setY(clampedY)
            state.iconX = clampedX
            state.iconY = clampedY
        end
        persistState()
    end
end

function TTRPPosesTreeUI.onGameStart()
    TTRPPosesTreeUI.windowOpen = false
    if TTRPFavorites and TTRPFavorites.load then
        TTRPFavorites.load()
    end
    loadCustomBinds()
    loadBindLoadouts()
    local state = getOrCreateState()
    if state then
        state.iconHidden = false
    end
    TTRPPosesTreeUI.ensureUI()
    TTRPPosesTreeUI.scheduleDeferredEnsure()
end

function TTRPPosesTreeUI.onCreatePlayer(playerIndex, playerObj)
    if playerIndex ~= 0 then
        return
    end

    if TTRPFavorites and TTRPFavorites.load then
        TTRPFavorites.load()
    end
    loadCustomBinds()
    loadBindLoadouts()
    local state = getOrCreateState()
    if state then
        state.iconHidden = false
    end
    TTRPPosesTreeUI.ensureUI()
    TTRPPosesTreeUI.scheduleDeferredEnsure()
end

function TTRPPosesTreeUI.onKeyPressed(keyCode)
    local window = TTRPPosesTreeUI.window
    if window and window.awaitingBindKey and TTRPPosesTreeUI.windowOpen then
        if window:onCaptureBindKey(keyCode) then
            return
        end
    end

    local toggleIconKey = getCore() and getCore():getKey(ICON_TOGGLE_KEYBIND) or nil
    if toggleIconKey and toggleIconKey > 0 and keyCode == toggleIconKey then
        TTRPPosesTreeUI.toggleLauncherVisibility()
        return
    end

    if window and TTRPPosesTreeUI.windowOpen and window.searchBox and window.searchBox.isFocused and window.searchBox:isFocused() then
        return
    end

    local bindData = TTRPPosesTreeUI.customBinds and TTRPPosesTreeUI.customBinds[tostring(keyCode)]
    if not bindData or type(bindData.emote) ~= "string" or bindData.emote == "" then
        return
    end

    -- Fire bound poses from keyboard even when the UI window is closed.
    local player = getLocalPlayer()
    if not player then
        return
    end

    playBoundEmote(bindData.emote, player)
end

function TTRPPosesTreeUI.onPlayerDeath(playerObj)
    if playerObj and playerObj:isLocalPlayer() then
        if TTRPPosesTreeUI.window and TTRPPosesTreeUI.windowOpen then
            TTRPPosesTreeUI.window:setVisible(false)
            TTRPPosesTreeUI.window:removeFromUIManager()
            TTRPPosesTreeUI.windowOpen = false
        end
    end
end

Events.OnGameStart.Add(TTRPPosesTreeUI.onGameStart)
Events.OnCreatePlayer.Add(TTRPPosesTreeUI.onCreatePlayer)
Events.OnResolutionChange.Add(TTRPPosesTreeUI.onResolutionChange)
Events.OnPlayerDeath.Add(TTRPPosesTreeUI.onPlayerDeath)
Events.OnKeyPressed.Add(TTRPPosesTreeUI.onKeyPressed)

return TTRPPosesTreeUI
