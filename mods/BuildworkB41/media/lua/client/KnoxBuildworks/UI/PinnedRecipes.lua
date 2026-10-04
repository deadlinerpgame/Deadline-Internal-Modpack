require "ISUI/ISPanel"
require "ISUI/ISCollapsableWindow"
require "ISUI/ISButton"
require "ISUI/ISComboBox"

local Registry = require("KnoxBuildworks/Definitions/Registry")
local Groups = require("KnoxBuildworks/Definitions/Groups")
local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local TableUtil = require("KnoxBuildworks/Util/Table")
local Theme = require("KnoxBuildworks/UI/Theme")
local Options = require("KnoxBuildworks/Options")
local IconResolver = require("KnoxBuildworks/UI/IconResolver")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
local I18n = require("KnoxBuildworks/I18n")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local PinnedRecipes = {}

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local ALIGN_VALUES = { "auto", "left", "right", "center" }
local MODE_VALUES = { "auto", "manual" }
local BAR_VALUES = { "left", "right", "top", "none" }
local CONTENT_VALUES = { "icons", "text" }
local PINNED_MAX_TEXT_WIDTH = 360
local PINNED_MIN_WIDTH = 260
local PINNED_ACTION_WIDTH = 28
local PINNED_OPACITY_STEP = 0.05
local GEAR_TEXTURE = getTexture("media/ui/inventoryPanes/Button_Gear.png")
    or getTexture("media/ui/inventoryPanes/Button_Settings.png")
local CLOSE_TEXTURE = getTexture("media/ui/inventoryPanes/Button_Close.png")
local BOOK_TEXTURE = getTexture("media/ui/craftingMenus/BuildProperty_Book_16.png")
local HUD_REFRESH_MS = 2000
local AREA_RESCAN_MS = 15000
local AREA_SCAN_BUDGET = 32
local hudGeneration = 0
local areaContainerCache = {}
local blueprintTotalsCache = {}

local SKILL_ICON_IDS = {
    Woodwork = "carpentry",
    Carpentry = "carpentry",
    MetalWelding = "metalworking",
    Mechanics = "mechanics",
    Electricity = "electricity",
    Farming = "farming",
    Cooking = "cooking",
    Fishing = "fishing",
    Trapping = "trapping",
    PlantScavenging = "plant_scavenging",
    Maintenance = "maintenance",
    Doctor = "first_aid",
    FirstAid = "first_aid",
    Fitness = "fitness",
    Strength = "strength",
    Nimble = "nimble",
    Sneak = "sneaking",
    Sneaking = "sneaking",
    Lightfoot = "lightfooted",
    Lightfooted = "lightfooted",
    Sprinting = "sprinting",
    Aiming = "aiming",
    Reloading = "reloading",
    Axe = "axe",
    Blunt = "blunt",
    SmallBlunt = "small_blunt",
    LongBlade = "long_blade",
    SmallBlade = "small_blade",
    Spear = "spear"
}

local function displayName(definition)
    return I18n.definitionName(definition)
end

local function uiData(player)
    local root = player:getModData()
    root.KBW_UI = root.KBW_UI or {}
    root.KBW_UI.pinnedRecipes = root.KBW_UI.pinnedRecipes or {}
    root.KBW_UI.pinnedRecipeOrder = root.KBW_UI.pinnedRecipeOrder or {}
    root.KBW_UI.pinnedBlueprints = root.KBW_UI.pinnedBlueprints or {}
    root.KBW_UI.pinnedBlueprintOrder = root.KBW_UI.pinnedBlueprintOrder or {}
    root.KBW_UI.pinnedCollapsed = root.KBW_UI.pinnedCollapsed or {}
    return root.KBW_UI
end

local function persistUiData(player)
    if isClient() and player and player.transmitModData then player:transmitModData() end
end

local function isCollapsed(data, key)
    return key ~= nil and data.pinnedCollapsed and data.pinnedCollapsed[key] == true
end

function PinnedRecipes.toggleCollapsed(player, key)
    if not player or not key then return end
    local data = uiData(player)
    data.pinnedCollapsed[key] = not data.pinnedCollapsed[key] or nil
    persistUiData(player)
    hudGeneration = hudGeneration + 1
end

local function cleanInlineText(text)
    text = tostring(text or "")
    return string.gsub(text, "[\r\n]+", " ")
end

local function measure(font, text)
    return getTextManager():MeasureStringX(font, text)
end

local function wrapLongWord(font, lines, word, width)
    local chunk = ""
    for charIndex = 1, #word do
        local char = string.sub(word, charIndex, charIndex)
        local candidate = chunk .. char
        if chunk ~= "" and measure(font, candidate) > width then
            lines[#lines + 1] = chunk
            chunk = char
        else
            chunk = candidate
        end
    end
    if chunk ~= "" then lines[#lines + 1] = chunk end
end

local function wrapText(font, text, width)
    text = cleanInlineText(text)
    local lines = {}
    if text == "" then return lines end
    if width < 24 then
        lines[#lines + 1] = text
        return lines
    end
    local current = ""
    for word in string.gmatch(text, "%S+") do
        local candidate = current == "" and word or current .. " " .. word
        if measure(font, candidate) <= width then
            current = candidate
        else
            if current ~= "" then
                lines[#lines + 1] = current
                current = ""
            end
            if measure(font, word) <= width then
                current = word
            else
                wrapLongWord(font, lines, word, width)
            end
        end
    end
    if current ~= "" then lines[#lines + 1] = current end
    return lines
end

local function optionValue(id, values, fallback)
    local option = Options and Options.getOption and Options:getOption(id)
    local index = option and option:getValue() or 1
    return values[index] or fallback
end

local function setOptionIndex(id, index)
    local option = Options and Options.getOption and Options:getOption(id)
    if option and option.setValue then option:setValue(index) end
    if Options and Options.apply then Options:apply() end
    if PZAPI and PZAPI.ModOptions and PZAPI.ModOptions.save then PZAPI.ModOptions:save() end
end

local function roundedOpacity(value)
    value = tonumber(value) or .85
    if value > 1 then value = value / 100 end
    value = math.floor((value / PINNED_OPACITY_STEP) + 0.5) * PINNED_OPACITY_STEP
    if value < .15 then value = .15 end
    if value > 1 then value = 1 end
    return tonumber(string.format("%.2f", value)) or value
end

local function setOptionNumber(id, value)
    local option = Options and Options.getOption and Options:getOption(id)
    if id == "PinnedOpacity" then value = math.floor(roundedOpacity(value) * 100 + 0.5) end
    if option and option.setValue then option:setValue(value) end
    if Options and Options.apply then Options:apply() end
    if PZAPI and PZAPI.ModOptions and PZAPI.ModOptions.save then PZAPI.ModOptions:save() end
end

local function optionNumber(id, fallback)
    local option = Options and Options.getOption and Options:getOption(id)
    local value = option and option:getValue() or fallback
    value = tonumber(value) or fallback
    if id == "PinnedOpacity" then return roundedOpacity(value) end
    return value
end

local function finishIdentity(finish)
    if type(finish) ~= "table" or finish.none == true then return "" end
    if finish.wallpaperType then return "wallpaper:" .. tostring(finish.wallpaperType) end
    if finish.paintType then return "paint:" .. tostring(finish.paintType) end
    if finish.plaster == true then return "plaster" end
    return tostring(finish.actionType or finish.id or finish.sign or "")
end

local function recipeKey(definition, stage, variantId, materialId, finish)
    if not definition or not stage then return nil end
    local key = tostring(definition.id) .. "|"
        .. tostring(Groups.resolveStageId(stage) or stage.id) .. "|"
        .. tostring(variantId or "") .. "|"
        .. tostring(materialId or "")
    local finishKey = finishIdentity(finish)
    if finishKey ~= "" then key = key .. "|" .. finishKey end
    return key
end

local function copyChoices(choices)
    local out = {}
    choices = choices or {}
    for key, value in pairs(choices) do
        out[key] = value
    end
    return out
end

local function finishChoices(stage, finish, choices)
    local out = copyChoices(choices)
    if type(finish) ~= "table" then return out end
    local inputs = ((stage or {}).requirements or {}).inputs or {}
    for inputIndex = 1, #inputs do
        local input = inputs[inputIndex]
        local tags = input.tags or {}
        for tagIndex = 1, #tags do
            local tag = string.lower(tostring(tags[tagIndex]))
            local selected = nil
            if tag == "base:paint" then selected = finish.paintType end
            if tag == "base:wallpaper" then selected = finish.wallpaperType end
            if selected then
                selected = tostring(selected)
                if not string.find(selected, ".", 1, true) then selected = "Base." .. selected end
                out[input.id or ("input-" .. inputIndex)] = selected
            end
        end
    end
    return out
end

local function removeOrderedKey(order, key)
    for index = 1, #order do
        if order[index] == key then
            table.remove(order, index)
            return
        end
    end
end

local function findOption(options, id)
    options = options or {}
    for optionIndex = 1, #options do
        local option = options[optionIndex]
        if tostring(option.id or "") == tostring(id or "") then return option end
    end
    return nil
end

local function effectiveDefinition(entry)
    local definition = Registry:get(entry.id)
    if not definition then return nil end
    local effective = definition
    local variant = findOption(definition.variants, entry.variantId)
    if variant then effective = TableUtil.merge(effective, variant) end
    local material = findOption(definition.materialOptions, entry.materialId)
    if material then effective = TableUtil.merge(effective, material) end
    effective.id = definition.id
    return effective
end

local function entryMatchesDefinition(entry, definition)
    if not entry or not definition then return false end
    if Groups.isGroup(definition) then
        local ids = Groups.memberIds(definition)
        for idIndex = 1, #ids do
            if entry.id == ids[idIndex] then return true end
        end
        return false
    end
    return entry.id == definition.id
end

local function itemDisplayName(fullType)
    if type(fullType) == "string" and string.find(fullType, ".", 1, true) then
        return getItemNameFromFullType(fullType)
    end
    return tostring(fullType or "?")
end

local function normalizeTagName(name)
    if not name then return nil end
    local value = tostring(name)
    if not string.find(value, ":", 1, true) then
        local dotIndex = string.find(value, ".", 1, true)
        if dotIndex then
            local namespace = string.sub(value, 1, dotIndex - 1)
            local path = string.sub(value, dotIndex + 1)
            if namespace ~= "" and path ~= "" and not string.find(path, ".", 1, true) then
                value = namespace .. ":" .. path
            end
        end
    end
    return value
end

local function tagDisplayName(name)
    local normalized = normalizeTagName(name) or tostring(name or "?")
    return IconResolver.displayNameForTag(normalized)
end

local function tagValue(name)
    local normalized = normalizeTagName(name)
    if normalized and KBWB41 then return KBWB41.tagName(normalized) end
    return nil
end

local function scriptFor(fullType)
    if not fullType then return nil end
    if getItem then
        local script = KBWB41.scriptItem(fullType)
        if script then return script end
    end
    return ScriptManager and ScriptManager.instance and ScriptManager.instance:FindItem(fullType) or nil
end

local function textureForItem(fullType)
    local script = scriptFor(fullType)
    return script and script.getNormalTexture and script:getNormalTexture() or nil
end

local function textureForTotalRow(row)
    local key = tostring(row and row.key or "")
    if string.sub(key, 1, 1) == "#" then return IconResolver.textureForTag(string.sub(key, 2)) end
    return textureForItem(key)
end

local function totalRowDisplayType(player, row, snapshot)
    local key = tostring(row and row.key or "")
    if string.sub(key, 1, 1) ~= "#" then
        return string.find(key, ".", 1, true) and key or nil
    end
    if snapshot and snapshot.displayType[row] then return snapshot.displayType[row] end
    local tag = tagValue(string.sub(key, 2))
    if not tag then return nil end
    local inventory = not snapshot and player and player.getInventory and player:getInventory() or nil
    local carried = inventory and inventory:getFirstTagRecurse(tag) or nil
    if carried and carried.getFullType then return carried:getFullType() end
    local manager = getScriptManager and getScriptManager() or nil
    local scripts = manager and manager.getItemsTag and manager:getItemsTag(tag) or nil
    if scripts and scripts:size() > 0 then
        local script = scripts:get(0)
        if script and script.getFullName then return script:getFullName() end
    end
    return nil
end

local function cachedBlueprintTotals(player, blueprint)
    local id = tostring(blueprint.id)
    local placements = blueprint.placements or {}
    local cached = blueprintTotalsCache[id]
    if cached and cached.blueprint == blueprint and cached.updated == blueprint.updated
        and cached.count == #placements then
        return cached.totals
    end
    local totals = Blueprints.totals(player, blueprint)
    blueprintTotalsCache[id] = {
        blueprint = blueprint,
        updated = blueprint.updated,
        count = #placements,
        totals = totals
    }
    return totals
end

local function skillTexture(skillName)
    local suffix = SKILL_ICON_IDS[tostring(skillName or "")]
    if not suffix then return nil end
    return getTexture("media/ui/ElyonLib/ui_skill_spiffo_" .. suffix .. ".png")
end

local function addContainer(containers, seen, container)
    if not container then return end
    local key = tostring(container)
    if seen[key] then return end
    seen[key] = true
    containers[#containers + 1] = container
end

local function areaSignature(area)
    if not area then return "" end
    return tostring(area.x1) .. "|" .. tostring(area.y1) .. "|" .. tostring(area.x2) .. "|"
        .. tostring(area.y2) .. "|" .. tostring(area.z)
end

local function newAreaScan(blueprint)
    local area = blueprint and blueprint.gatherArea or nil
    if not area then return nil end
    local x1 = math.floor(math.min(tonumber(area.x1) or 0, tonumber(area.x2) or 0))
    local x2 = math.floor(math.max(tonumber(area.x1) or 0, tonumber(area.x2) or 0))
    local y1 = math.floor(math.min(tonumber(area.y1) or 0, tonumber(area.y2) or 0))
    local y2 = math.floor(math.max(tonumber(area.y1) or 0, tonumber(area.y2) or 0))
    return {
        id = tostring(blueprint.id),
        signature = areaSignature(area),
        x1 = x1,
        x2 = x2,
        y1 = y1,
        y2 = y2,
        x = x1,
        y = y1,
        z = math.floor(tonumber(area.z) or 0),
        containers = {},
        worldItems = {},
        seen = {},
        seenWorldItems = {},
        seenVehicles = {},
        complete = false,
        nextRescan = 0,
        lastUsed = getTimestampMs and getTimestampMs() or 0
    }
end

local function ensureAreaScan(blueprint)
    local area = blueprint and blueprint.gatherArea or nil
    if not area then return nil end
    local id = tostring(blueprint.id)
    local signature = areaSignature(area)
    local state = areaContainerCache[id]
    local now = getTimestampMs and getTimestampMs() or 0
    if not state or state.signature ~= signature or (state.complete and now >= (state.nextRescan or 0)) then
        local previousContainers = state and state.signature == signature and state.containers or nil
        local previousWorldItems = state and state.signature == signature and state.worldItems or nil
        state = newAreaScan(blueprint)
        state.previousContainers = previousContainers
        state.previousWorldItems = previousWorldItems
        areaContainerCache[id] = state
    end
    if state then state.lastUsed = now end
    return state
end

local function scanAreaSquare(state)
    local square = getCell():getGridSquare(state.x, state.y, state.z)
    if square then
        local objects = square:getObjects()
        for objectIndex = 0, objects:size() - 1 do
            local object = objects:get(objectIndex)
            if object and object.getContainer and object:getContainer() then
                addContainer(state.containers, state.seen, object:getContainer())
            end
        end
        local worldObjects = square:getWorldObjects()
        for objectIndex = 0, worldObjects:size() - 1 do
            local worldItem = worldObjects:get(objectIndex)
            local item = worldItem and worldItem.getItem and worldItem:getItem() or nil
            local key = worldItem and tostring(worldItem) or nil
            if item and key and not state.seenWorldItems[key] then
                state.seenWorldItems[key] = true
                state.worldItems[#state.worldItems + 1] = worldItem
            end
        end
        local vehicle = square:getVehicleContainer()
        local vehicleKey = vehicle and tostring(vehicle) or nil
        if vehicle and vehicle.getPartCount and not state.seenVehicles[vehicleKey] then
            state.seenVehicles[vehicleKey] = true
            for partIndex = 0, vehicle:getPartCount() - 1 do
                local part = vehicle:getPartByIndex(partIndex)
                if part and part:getItemContainer() then addContainer(state.containers, state.seen, part:getItemContainer()) end
            end
        elseif vehicle and vehicle.getItems then
            addContainer(state.containers, state.seen, vehicle)
        end
    end
    state.y = state.y + 1
    if state.y > state.y2 then
        state.y = state.y1
        state.x = state.x + 1
    end
    if state.x > state.x2 then
        state.complete = true
        state.previousContainers = nil
        state.previousWorldItems = nil
        state.nextRescan = (getTimestampMs and getTimestampMs() or 0) + AREA_RESCAN_MS
    end
end

function PinnedRecipes.updateAreaScans()
    local remaining = AREA_SCAN_BUDGET
    local now = getTimestampMs and getTimestampMs() or 0
    for id, state in pairs(areaContainerCache) do
        if remaining <= 0 then break end
        if now - (state.lastUsed or now) > 60000 then
            areaContainerCache[id] = nil
        else
            while not state.complete and remaining > 0 do
                scanAreaSquare(state)
                remaining = remaining - 1
            end
        end
    end
end

local function gatherContainersForBlueprint(player, blueprint)
    local containers = {}
    local seen = {}
    if player and player.getInventory then addContainer(containers, seen, player:getInventory()) end
    local state = ensureAreaScan(blueprint)
    local previous = state and state.previousContainers or {}
    for containerIndex = 1, #previous do
        addContainer(containers, seen, previous[containerIndex])
    end
    local gathered = state and state.containers or {}
    for containerIndex = 1, #gathered do
        addContainer(containers, seen, gathered[containerIndex])
    end
    return containers
end

local function gatherWorldItemsForBlueprint(blueprint)
    local result = {}
    local seen = {}
    local state = ensureAreaScan(blueprint)
    local function append(items)
        for itemIndex = 1, #(items or {}) do
            local worldItem = items[itemIndex]
            local key = worldItem and tostring(worldItem) or nil
            if key and not seen[key] and worldItem:getSquare() then
                seen[key] = true
                result[#result + 1] = worldItem
            end
        end
    end
    append(state and state.previousWorldItems)
    append(state and state.worldItems)
    return result
end

local function amountForItem(item, row)
    local input = row and row.row or {}
    if (input.mode == "drain" or input.uses ~= nil) and instanceof(item, "DrainableComboItem") then
        return math.max(0, KBWB41.usesLeft(item))
    end
    return 1
end

local function itemMatchesTotalRow(item, row)
    if not item or not row then return false end
    local input = row.row or {}
    local selectedFullType = row.selectedFullType or input.selectedFullType
    if selectedFullType then
        return item.getFullType and item:getFullType() == tostring(selectedFullType)
    end
    local key = tostring(row.key or "")
    if string.sub(key, 1, 1) == "#" then
        local tag = tagValue(string.sub(key, 2))
        return tag and item.hasTag and item:hasTag(tag)
    end
    if item.getFullType and item:getFullType() == key then return true end
    local items = input.items or {}
    for itemIndex = 1, #items do
        if item.getFullType and item:getFullType() == items[itemIndex] then return true end
    end
    local tags = input.tags or {}
    for tagIndex = 1, #tags do
        local tag = tagValue(tags[tagIndex])
        if tag and item.hasTag and item:hasTag(tag) then return true end
    end
    return false
end

local scanContainerForRows

local function scanItemForRows(item, rows, snapshot)
    local itemKey = item and tostring(item) or nil
    if not itemKey or snapshot.seenItems[itemKey] then return end
    snapshot.seenItems[itemKey] = true
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if itemMatchesTotalRow(item, row) then
            snapshot.available[row] = (snapshot.available[row] or 0) + amountForItem(item, row)
            if not snapshot.displayType[row] and item.getFullType then snapshot.displayType[row] = item:getFullType() end
        end
    end
    if instanceof(item, "InventoryContainer") and item.getInventory and item:getInventory() then
        scanContainerForRows(item:getInventory(), rows, snapshot)
    end
end

scanContainerForRows = function(container, rows, snapshot)
    if not container or not container.getItems then return end
    local items = container:getItems()
    for itemIndex = 0, items:size() - 1 do
        scanItemForRows(items:get(itemIndex), rows, snapshot)
    end
end

local function resourceSnapshot(player, blueprint, rows)
    local containers = gatherContainersForBlueprint(player, blueprint)
    local snapshot = { available = {}, displayType = {}, seenItems = {} }
    for containerIndex = 1, #containers do
        scanContainerForRows(containers[containerIndex], rows, snapshot)
    end
    local worldItems = gatherWorldItemsForBlueprint(blueprint)
    for worldIndex = 1, #worldItems do
        scanItemForRows(worldItems[worldIndex]:getItem(), rows, snapshot)
    end
    return snapshot
end

local function blueprintDisplayName(blueprint)
    return tostring((blueprint and (blueprint.name or blueprint.id)) or "?")
end

local function firstAvailable(row)
    local availableItems = row.availableItems or {}
    for itemIndex = 1, #availableItems do
        local entry = availableItems[itemIndex]
        if (entry.available or 0) > 0 then return entry.fullType end
    end
    return nil
end

local function displayedAvailableType(row)
    local availableItems = row.availableItems or {}
    if row.selectedFullType then
        for itemIndex = 1, #availableItems do
            local entry = availableItems[itemIndex]
            if entry.fullType == row.selectedFullType and (entry.available or 0) > 0 then
                return entry.fullType
            end
        end
    end
    return firstAvailable(row)
end

local function rowDisplayType(row)
    if row.selectedFullType then return row.selectedFullType end
    local available = displayedAvailableType(row)
    if available then return available end
    return row.possibleItems and row.possibleItems[1] or nil
end

local function rowTitle(row)
    if row.kind == "skill" then return getText("IGUI_perks_" .. tostring(row.name)) end
    if row.kind == "knowledge" then
        local name = tostring(row.name or "?")
        if row.alternativeLabel and row.alternativeLabel ~= "" then
            return getText("IGUI_KBW_RecipeOrSkill", name, row.alternativeLabel)
        end
        return name
    end
    local displayType = rowDisplayType(row)
    if displayType then return itemDisplayName(displayType) end
    if row.possibleTags and row.possibleTags[1] then return tagDisplayName(row.possibleTags[1]) end
    return tostring(row.id or "?")
end

local function rowTexture(row)
    if row.kind == "skill" then return skillTexture(row.name) end
    if row.kind == "knowledge" then return BOOK_TEXTURE end
    local displayType = rowDisplayType(row)
    if displayType then return textureForItem(displayType) end
    if row.possibleTags and row.possibleTags[1] then return IconResolver.textureForTag(row.possibleTags[1]) end
    return nil
end

local function rowStatus(row)
    if row.kind == "knowledge" then
        if row.alternativeMet then return getText("IGUI_KBW_SkillUnlocked") end
        return row.ok and getText("IGUI_KBW_Known") or getText("IGUI_KBW_NotKnown")
    end
    return tostring(row.available or 0) .. "/" .. tostring(row.needed or 0)
end

function PinnedRecipes.isPinned(player, definition, stage, variantId, materialId, finish)
    if not player then return false end
    local key = recipeKey(definition, stage, variantId, materialId, finish)
    if not key then return false end
    local data = uiData(player)
    if data.pinnedRecipes[key] ~= nil then return true end
    if finishIdentity(finish) ~= "" then
        local legacyKey = recipeKey(definition, stage, variantId, materialId, nil)
        local legacy = data.pinnedRecipes[legacyKey]
        local label = finish and (finish.label or finish.id) or nil
        if legacy and legacy.finish == nil
            and legacy.finishLabel ~= nil and tostring(legacy.finishLabel) == tostring(label) then
            data.pinnedRecipes[legacyKey] = nil
            legacy.key = key
            legacy.finish = TableUtil.copy(finish)
            data.pinnedRecipes[key] = legacy
            local order = data.pinnedRecipeOrder or {}
            for orderIndex = 1, #order do
                if order[orderIndex] == legacyKey then order[orderIndex] = key end
            end
            return true
        end
    end
    return false
end

local pinnedIdsCache = nil

function PinnedRecipes.pinnedBuildableIds(player)
    if not player then return {}, 0 end
    local playerKey = player.getPlayerNum and player:getPlayerNum() or 0
    local cached = pinnedIdsCache
    if cached and cached.generation == hudGeneration and cached.playerKey == playerKey then
        return cached.set, cached.count
    end
    local data = uiData(player)
    local set = {}
    local count = 0
    local order = data.pinnedRecipeOrder or {}
    for orderIndex = 1, #order do
        local entry = data.pinnedRecipes[order[orderIndex]]
        if entry and entry.id and not set[entry.id] then
            set[entry.id] = true
            count = count + 1
        end
    end
    pinnedIdsCache = { generation = hudGeneration, playerKey = playerKey, set = set, count = count }
    return set, count
end

function PinnedRecipes.invalidate()
    hudGeneration = hudGeneration + 1
    pinnedIdsCache = nil
end

function PinnedRecipes.hasPinnedDefinition(player, definition)
    if not player or not definition then return false end
    return Groups.anyMemberIn(definition, PinnedRecipes.pinnedBuildableIds(player))
end

function PinnedRecipes.removeDefinition(player, definition)
    if not player or not definition then return end
    local data = uiData(player)
    local order = data.pinnedRecipeOrder or {}
    local removed = false
    local index = #order
    while index >= 1 do
        local key = order[index]
        local entry = data.pinnedRecipes[key]
        if entryMatchesDefinition(entry, definition) then
            data.pinnedRecipes[key] = nil
            table.remove(order, index)
            removed = true
        end
        index = index - 1
    end
    if removed then persistUiData(player) end
    hudGeneration = hudGeneration + 1
end

function PinnedRecipes.toggleDefault(player, definition)
    if not player or not definition then return false end
    if PinnedRecipes.hasPinnedDefinition(player, definition) then
        PinnedRecipes.removeDefinition(player, definition)
        return false
    end
    if Groups.isGroup(definition) then
        local stages = definition.stages or {}
        local stage = stages[1]
        local memberDefinition = Groups.resolveDefinition(definition, stage)
        if not memberDefinition or not stage then return false end
        return PinnedRecipes.toggle(player, memberDefinition, stage, "", "", nil, {})
    end
    local stages = definition.stages or {}
    local stage = stages[1]
    if not stage then return false end
    return PinnedRecipes.toggle(player, definition, stage, "", "", nil, {})
end

function PinnedRecipes.toggle(player, definition, stage, variantId, materialId, finish, choices)
    if not player then return false end
    definition = Groups.resolveDefinition(definition, stage)
    local key = recipeKey(definition, stage, variantId, materialId, finish)
    if not key then return false end
    local data = uiData(player)
    if data.pinnedRecipes[key] then
        PinnedRecipes.removeRecipe(player, key)
        return false
    end
    data.pinnedRecipes[key] = {
        key = key,
        id = definition.id,
        stageId = Groups.resolveStageId(stage) or stage.id,
        variantId = variantId or "",
        materialId = materialId or "",
        finish = finish and TableUtil.copy(finish) or nil,
        finishLabel = finish and (finish.label or finish.id) or nil,
        choices = finishChoices(stage, finish, choices)
    }
    data.pinnedRecipeOrder[#data.pinnedRecipeOrder + 1] = key
    persistUiData(player)
    hudGeneration = hudGeneration + 1
    return true
end

function PinnedRecipes.removeRecipe(player, key)
    if not player or not key then return false end
    local data = uiData(player)
    key = tostring(key)
    if not data.pinnedRecipes[key] then return false end
    data.pinnedRecipes[key] = nil
    data.pinnedCollapsed["recipe:" .. key] = nil
    removeOrderedKey(data.pinnedRecipeOrder, key)
    persistUiData(player)
    hudGeneration = hudGeneration + 1
    return true
end

function PinnedRecipes.removeBlueprint(player, blueprintId)
    if not player or not blueprintId then return false end
    local data = uiData(player)
    local id = tostring(blueprintId)
    if not data.pinnedBlueprints[id] then return false end
    data.pinnedBlueprints[id] = nil
    data.pinnedCollapsed["bp:" .. id] = nil
    removeOrderedKey(data.pinnedBlueprintOrder, id)
    persistUiData(player)
    hudGeneration = hudGeneration + 1
    return true
end

function PinnedRecipes.isBlueprintPinned(player, blueprint)
    if not player or not blueprint then return false end
    return uiData(player).pinnedBlueprints[tostring(blueprint.id)] ~= nil
end

function PinnedRecipes.toggleBlueprint(player, blueprint)
    if not player or not blueprint then return false end
    local data = uiData(player)
    local id = tostring(blueprint.id)
    if data.pinnedBlueprints[id] then
        PinnedRecipes.removeBlueprint(player, id)
        return false
    end
    data.pinnedBlueprints[id] = { id = id, name = blueprintDisplayName(blueprint) }
    data.pinnedBlueprintOrder[#data.pinnedBlueprintOrder + 1] = id
    persistUiData(player)
    hudGeneration = hudGeneration + 1
    return true
end

local function addWrapped(lines, font, text, maxWidth, color, texture, kind, indent)
    indent = indent or 0
    local wrapped = wrapText(
        font, text, texture and math.max(24, maxWidth - 26 - indent) or math.max(24, maxWidth - indent)
    )
    for lineIndex = 1, #wrapped do
        lines[#lines + 1] = {
            font = font,
            text = wrapped[lineIndex],
            color = color,
            texture = lineIndex == 1 and texture or nil,
            kind = kind,
            indent = indent
        }
    end
end

local function addDivider(lines)
    lines[#lines + 1] = { kind = "divider", text = "", font = UIFont.Small, color = Theme.borderSoft }
end

local function splitRequirementRows(rows)
    local inputs = {}
    local gates = {}
    rows = rows or {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if row.kind == "skill" or row.kind == "knowledge" then
            gates[#gates + 1] = row
        else
            inputs[#inputs + 1] = row
        end
    end
    return inputs, gates
end

local function countMissing(rows)
    local missing = 0
    rows = rows or {}
    for rowIndex = 1, #rows do
        if not rows[rowIndex].ok then missing = missing + 1 end
    end
    return missing
end

local function buildLines(player, maxWidth, includeTitle)
    local lines = {}
    if includeTitle then
        addWrapped(lines, UIFont.Medium, getText("IGUI_KBW_PinnedRecipes"), maxWidth, Theme.accent)
    end
    local data = uiData(player)
    local content = optionValue("PinnedContent", CONTENT_VALUES, "icons")
    local useIcons = content == "icons"
    local blueprintOrder = data.pinnedBlueprintOrder or {}
    local removedStaleBlueprint = false
    for blueprintIndex = #blueprintOrder, 1, -1 do
        local blueprintId = blueprintOrder[blueprintIndex]
        if not Blueprints.get(player, blueprintId) then
            data.pinnedBlueprints[blueprintId] = nil
            data.pinnedCollapsed["bp:" .. tostring(blueprintId)] = nil
            table.remove(blueprintOrder, blueprintIndex)
            removedStaleBlueprint = true
        end
    end
    if removedStaleBlueprint then
        persistUiData(player)
        hudGeneration = hudGeneration + 1
    end
    local blueprintCount = 0
    for blueprintIndex = 1, #blueprintOrder do
        local blueprintId = blueprintOrder[blueprintIndex]
        local blueprint = Blueprints.get(player, blueprintId)
        if blueprint then
            if blueprintCount > 0 then addDivider(lines) end
            blueprintCount = blueprintCount + 1
            local collapseKey = "bp:" .. tostring(blueprintId)
            local collapsed = isCollapsed(data, collapseKey)
            local headerLineIndex = #lines + 1
            addWrapped(
                lines, UIFont.Medium, (collapsed and "[+] " or "[-] ") .. blueprintDisplayName(blueprint),
                maxWidth - PINNED_ACTION_WIDTH, Theme.text, BOOK_TEXTURE, "blueprint"
            )
            lines[headerLineIndex].collapseKey = collapseKey
            lines[headerLineIndex].unpinKind = "blueprint"
            lines[headerLineIndex].unpinKey = tostring(blueprintId)
            if not collapsed then
                local totals = cachedBlueprintTotals(player, blueprint)
                local rooms = blueprint.rooms or {}
                addWrapped(
                    lines, UIFont.Small,
                    getText("IGUI_KBW_BlueprintTotalsShort", tostring(totals.placements or 0), tostring(#rooms)
                    ), maxWidth, Theme.textMuted, nil, "stage", 4
                )
                addWrapped(
                    lines, UIFont.Small, getText("IGUI_KBW_MaterialsTools"), maxWidth, Theme.text, nil, "group", 4
                )
                local materialRows = {}
                for key, row in pairs(totals.materials or {}) do
                    materialRows[#materialRows + 1] = row
                end
                for key, row in pairs(totals.tools or {}) do
                    materialRows[#materialRows + 1] = row
                end
                table.sort(
                    materialRows, function (a, b) return tostring(a.label or a.key) < tostring(b.label or b.key) end
                )
                local snapshot = resourceSnapshot(player, blueprint, materialRows)
                for rowIndex = 1, #materialRows do
                    local row = materialRows[rowIndex]
                    local needed = row.amount or row.needed or 0
                    local available = snapshot.available[row] or 0
                    local ok = available >= needed
                    local key = tostring(row.key or "")
                    local displayType = totalRowDisplayType(player, row, snapshot)
                    local label
                    local texture
                    if displayType then
                        label = itemDisplayName(displayType)
                        texture = textureForItem(displayType)
                    elseif string.sub(key, 1, 1) == "#" then
                        label = tagDisplayName(string.sub(key, 2))
                        texture = textureForTotalRow(row)
                    else
                        label = row.labelKey and I18n.text(row.labelKey, row.label) or tostring(row.label or key or "?")
                        texture = textureForTotalRow(row)
                    end
                    addWrapped(
                        lines, UIFont.Small, label .. " " .. tostring(available) .. "/" .. tostring(needed), maxWidth,
                        ok and Theme.textMuted or Theme.bad, useIcons and texture or nil, "requirement", 12
                    )
                end
                local skillRows = {}
                for key, row in pairs(totals.skills or {}) do
                    skillRows[#skillRows + 1] = row
                end
                if #skillRows > 0 then
                    addWrapped(
                        lines, UIFont.Small, getText("IGUI_KBW_SkillsKnowledge"), maxWidth, Theme.text, nil, "group", 4
                    )
                end
                table.sort(skillRows, function (a, b) return tostring(a.name) < tostring(b.name) end)
                for rowIndex = 1, #skillRows do
                    local row = skillRows[rowIndex]
                    local perk = Perks[row.name]
                    local available = perk and player:getPerkLevel(perk) or 0
                    local needed = row.needed or 0
                    addWrapped(
                        lines, UIFont.Small,
                        getText("IGUI_perks_" .. tostring(row.name)) .. " "
                            .. tostring(available) .. "/"
                            .. tostring(needed),
                        maxWidth, available >= needed and Theme.textMuted or Theme.bad,
                        useIcons and skillTexture(row.name) or nil, "requirement", 12
                    )
                end
            end
        end
    end
    local order = data.pinnedRecipeOrder or {}
    local recipeCount = 0
    for orderIndex = 1, #order do
        local entry = data.pinnedRecipes[order[orderIndex]]
        if entry then
            local definition = effectiveDefinition(entry)
            local stage = definition and Registry:getStage(definition, entry.stageId) or nil
            stage = stage and BuildableRules.effectiveStage(definition, stage) or nil
            if definition and stage then
                if recipeCount > 0 or blueprintCount > 0 then addDivider(lines) end
                recipeCount = recipeCount + 1
                local status = Requirements.evaluate(player, definition, stage, nil, entry.choices)
                local finishRows = WallFinishes.statusRows(player, entry.finish, definition, stage)
                for finishRowIndex = 1, #finishRows do
                    local finishRow = finishRows[finishRowIndex]
                    status.rows[#status.rows + 1] = finishRow
                    if not finishRow.ok then status.ok = false end
                end
                local stageLabel = stage.label or stage.id
                local rows = status.rows or {}
                local missing = countMissing(rows)
                local prefix = status.ok and getText("IGUI_KBW_ReadyToBuild")
                    or (getText("IGUI_KBW_CannotBuild") .. "  (" .. tostring(missing) .. "/" .. tostring(#rows) .. ")")
                local recipeTexture = nil
                if useIcons then
                    recipeTexture = IconResolver.textureForDefinition(definition, stage)
                end
                local collapseKey = "recipe:" .. tostring(order[orderIndex])
                local collapsed = isCollapsed(data, collapseKey)
                local headerLineIndex = #lines + 1
                addWrapped(
                    lines, UIFont.Medium, (collapsed and "[+] " or "[-] ") .. displayName(definition),
                    maxWidth - PINNED_ACTION_WIDTH, Theme.text, recipeTexture, "recipe"
                )
                lines[headerLineIndex].collapseKey = collapseKey
                lines[headerLineIndex].unpinKind = "recipe"
                lines[headerLineIndex].unpinKey = tostring(order[orderIndex])
                addWrapped(
                    lines, UIFont.Small, prefix, maxWidth, status.ok and Theme.textMuted or Theme.warn, nil, "status", 4
                )
                if not collapsed then
                    addWrapped(lines, UIFont.Small, tostring(stageLabel), maxWidth, Theme.textMuted, nil, "stage", 4)
                    if entry.finishLabel then
                        addWrapped(
                            lines, UIFont.Small, getText("IGUI_KBW_Finish") .. ": " .. tostring(entry.finishLabel),
                            maxWidth, Theme.textMuted, nil, "finish", 4
                        )
                    end
                    local inputs, gates = splitRequirementRows(rows)
                    if #inputs > 0 then
                        addWrapped(
                            lines, UIFont.Small, getText("IGUI_KBW_MaterialsTools"), maxWidth, Theme.text, nil, "group",
                            4
                        )
                    end
                    for rowIndex = 1, #inputs do
                        local row = inputs[rowIndex]
                        local color = row.ok and Theme.textMuted or Theme.bad
                        addWrapped(
                            lines, UIFont.Small, rowTitle(row) .. " " .. rowStatus(row), maxWidth, color,
                            useIcons and rowTexture(row) or nil, "requirement", 12
                        )
                    end
                    if #gates > 0 then
                        addWrapped(
                            lines, UIFont.Small, getText("IGUI_KBW_SkillsKnowledge"), maxWidth, Theme.text, nil, "group",
                            4
                        )
                    end
                    for rowIndex = 1, #gates do
                        local row = gates[rowIndex]
                        local color = row.ok and Theme.textMuted or Theme.bad
                        addWrapped(
                            lines, UIFont.Small, rowTitle(row) .. " " .. rowStatus(row), maxWidth, color,
                            useIcons and rowTexture(row) or nil, "requirement", 12
                        )
                    end
                end
            else
                addWrapped(lines, UIFont.Small, tostring(entry.id or "?"), maxWidth, Theme.warn)
            end
        end
    end
    return lines
end

local function clamp(value, minValue, maxValue)
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

local function currentOptionIndex(id, fallback)
    local option = Options and Options.getOption and Options:getOption(id)
    return option and option:getValue() or fallback
end

local function configureButton(button)
    button:initialise()
    Theme.applyButton(button, false)
    return button
end

KBWPinnedRecipesSettings = ISCollapsableWindow:derive("KBWPinnedRecipesSettings")

function KBWPinnedRecipesSettings:new(player)
    local o = ISCollapsableWindow:new(120, 120, 300, 252)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.minimumWidth = 280
    o.minimumHeight = 228
    o.resizable = false
    o.title = getText("IGUI_KBW_PinnedSettings")
    o.backgroundColor = Theme.backdrop
    o.borderColor = Theme.border
    o:setWantKeyEvents(true)
    return o
end

function KBWPinnedRecipesSettings:createChildren()
    ISCollapsableWindow.createChildren(self)
    local top = self:titleBarHeight() + 12
    self.modeCombo = ISComboBox:new(120, top, 156, 24, self, self.onModeChanged)
    self.modeCombo:initialise()
    self:addChild(self.modeCombo)
    self.modeCombo:addOption(getText("UI_optionscreen_KBW_PinnedPositionMode_Auto"))
    self.modeCombo:addOption(getText("UI_optionscreen_KBW_PinnedPositionMode_Manual"))

    self.alignCombo = ISComboBox:new(120, top + 34, 156, 24, self, self.onAlignChanged)
    self.alignCombo:initialise()
    self:addChild(self.alignCombo)
    self.alignCombo:addOption(getText("UI_optionscreen_KBW_PinnedAlignment_Auto"))
    self.alignCombo:addOption(getText("UI_optionscreen_KBW_PinnedAlignment_Left"))
    self.alignCombo:addOption(getText("UI_optionscreen_KBW_PinnedAlignment_Right"))
    self.alignCombo:addOption(getText("UI_optionscreen_KBW_PinnedAlignment_Center"))

    self.barCombo = ISComboBox:new(120, top + 68, 156, 24, self, self.onBarChanged)
    self.barCombo:initialise()
    self:addChild(self.barCombo)
    self.barCombo:addOption(getText("UI_optionscreen_KBW_PinnedBar_Left"))
    self.barCombo:addOption(getText("UI_optionscreen_KBW_PinnedBar_Right"))
    self.barCombo:addOption(getText("UI_optionscreen_KBW_PinnedBar_Top"))
    self.barCombo:addOption(getText("UI_optionscreen_KBW_PinnedBar_None"))

    self.contentCombo = ISComboBox:new(120, top + 102, 156, 24, self, self.onContentChanged)
    self.contentCombo:initialise()
    self:addChild(self.contentCombo)
    self.contentCombo:addOption(getText("UI_optionscreen_KBW_PinnedContent_Icons"))
    self.contentCombo:addOption(getText("UI_optionscreen_KBW_PinnedContent_Text"))

    self.opacityDown = configureButton(ISButton:new(120, top + 136, 36, 24, "-", self, self.onOpacityDown))
    self:addChild(self.opacityDown)
    self.opacityUp = configureButton(ISButton:new(240, top + 136, 36, 24, "+", self, self.onOpacityUp))
    self:addChild(self.opacityUp)
    self.resetButton = configureButton(
        ISButton:new(20, top + 174, 256, 28, getText("IGUI_KBW_ResetPinnedPosition"), self, self.onResetPosition)
    )
    self:addChild(self.resetButton)
    self:syncFromOptions()
end

function KBWPinnedRecipesSettings:syncFromOptions()
    if self.modeCombo then self.modeCombo.selected = currentOptionIndex("PinnedPositionMode", 1) end
    if self.alignCombo then self.alignCombo.selected = currentOptionIndex("PinnedAlignment", 1) end
    if self.barCombo then self.barCombo.selected = currentOptionIndex("PinnedBar", 1) end
    if self.contentCombo then self.contentCombo.selected = currentOptionIndex("PinnedContent", 1) end
end

function KBWPinnedRecipesSettings:onModeChanged()
    setOptionIndex("PinnedPositionMode", self.modeCombo.selected or 1)
end

function KBWPinnedRecipesSettings:onAlignChanged()
    setOptionIndex("PinnedAlignment", self.alignCombo.selected or 1)
end

function KBWPinnedRecipesSettings:onBarChanged()
    setOptionIndex("PinnedBar", self.barCombo.selected or 1)
end

function KBWPinnedRecipesSettings:onContentChanged()
    setOptionIndex("PinnedContent", self.contentCombo.selected or 1)
end

function KBWPinnedRecipesSettings:onOpacityDown()
    local opacity = optionNumber("PinnedOpacity", .85)
    setOptionNumber("PinnedOpacity", clamp(opacity - .05, .15, 1))
end

function KBWPinnedRecipesSettings:onOpacityUp()
    local opacity = optionNumber("PinnedOpacity", .85)
    setOptionNumber("PinnedOpacity", clamp(opacity + .05, .15, 1))
end

function KBWPinnedRecipesSettings:onResetPosition()
    local data = uiData(self.player)
    data.pinnedX = nil
    data.pinnedY = nil
    persistUiData(self.player)
end

function KBWPinnedRecipesSettings:render()
    ISCollapsableWindow.render(self)
    local top = self:titleBarHeight() + 16
    self:drawText(
        getText("IGUI_KBW_PinnedPositionMode"), 20, top, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_PinnedAlignment"), 20, top + 34, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_PinnedAccentBar"), 20, top + 68, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_PinnedContent"), 20, top + 104, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_PinnedOpacity"), 20, top + 138, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small
    )
    local opacity = optionNumber("PinnedOpacity", .85)
    self:drawTextCentre(
        string.format("%d%%", math.floor(opacity * 100 + .5)), 198, top + 138, Theme.accent.r, Theme.accent.g,
        Theme.accent.b, 1, UIFont.Small
    )
end

function KBWPinnedRecipesSettings:close()
    ISCollapsableWindow.close(self)
    PinnedRecipes.settingsPanel = nil
end

function KBWPinnedRecipesSettings:isKeyConsumed(key)
    return Keyboard and key == Keyboard.KEY_ESCAPE
end

function KBWPinnedRecipesSettings:onKeyRelease(key)
    if self:isVisible() and self:isKeyConsumed(key) then
        self:close()
        return
    end
end

function PinnedRecipes.openSettings(player)
    if PinnedRecipes.settingsPanel then
        PinnedRecipes.settingsPanel:syncFromOptions()
        PinnedRecipes.settingsPanel:setVisible(true)
        PinnedRecipes.settingsPanel:bringToTop()
        return
    end
    local panel = KBWPinnedRecipesSettings:new(player or getPlayer())
    panel:initialise()
    panel:addToUIManager()
    PinnedRecipes.settingsPanel = panel
end

KBWPinnedRecipesPanel = ISPanel:derive("KBWPinnedRecipesPanel")

function KBWPinnedRecipesPanel:new()
    local o = ISPanel:new(0, 0, 1, 1)
    setmetatable(o, self)
    self.__index = self
    o.background = false
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    o.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    o.cachedLines = nil
    o.cachedGeneration = -1
    o.nextLinesRefresh = 0
    return o
end

local function autoAlignment(screenLeft, screenWidth)
    local mid = screenLeft + screenWidth / 2
    local leftBusy = false
    local rightBusy = false
    local function classify(window)
        if not window or not window.getX or not window:isVisible() then return end
        local center = window:getX() + window:getWidth() / 2
        if center < mid then
            leftBusy = true
        else
            rightBusy = true
        end
    end
    if KBWCatalog then classify(KBWCatalog.instance) end
    if KBWPlanningMode then
        classify(KBWPlanningMode.instance)
        if KBWPlanningMode.instance then classify(KBWPlanningMode.instance.catalogPanel) end
    end
    if leftBusy and not rightBusy then return "right" end
    return "left"
end

function KBWPinnedRecipesPanel:screenRect(player, width, height)
    local playerNum = player:getPlayerNum()
    local screenLeft = getPlayerScreenLeft(playerNum)
    local screenTop = getPlayerScreenTop(playerNum)
    local screenWidth = getPlayerScreenWidth(playerNum)
    local screenHeight = getPlayerScreenHeight(playerNum)
    local alignment = optionValue("PinnedAlignment", ALIGN_VALUES, "auto")
    local mode = optionValue("PinnedPositionMode", MODE_VALUES, "auto")
    local data = uiData(player)
    if mode == "manual" and data.pinnedX and data.pinnedY then
        local x = clamp(tonumber(data.pinnedX) or screenLeft + 74, screenLeft + 4, screenLeft + screenWidth - width - 4)
        local y = clamp(tonumber(data.pinnedY) or screenTop + 116, screenTop + 4, screenTop + screenHeight - height - 4)
        return x, y, mode
    end

    if alignment == "auto" then alignment = autoAlignment(screenLeft, screenWidth) end
    local x = screenLeft + 74
    if alignment == "right" then
        x = math.max(screenLeft + 24, screenLeft + screenWidth - width - 96)
    elseif alignment == "center" then
        x = math.max(screenLeft + 24, screenLeft + math.floor((screenWidth - width) / 2))
    end
    local y = screenTop + 116
    return x, y, mode
end

function KBWPinnedRecipesPanel:onMouseDown(x, y)
    local rect = self.hudRect
    if not rect then return false end
    if x < rect.x or x > rect.x + rect.w or y < rect.y or y > rect.y + rect.h then return false end
    if self.gearRect and x >= self.gearRect.x and x <= self.gearRect.x + self.gearRect.w and y >= self.gearRect.y
        and y <= self.gearRect.y + self.gearRect.h then
        PinnedRecipes.openSettings(getPlayer())
        return true
    end
    local actionHits = self.headerActionHits or {}
    for hitIndex = 1, #actionHits do
        local hit = actionHits[hitIndex]
        if x >= hit.x0 and x <= hit.x1 and y >= hit.y0 and y <= hit.y1 then
            if hit.kind == "blueprint" then
                PinnedRecipes.removeBlueprint(getPlayer(), hit.key)
            else
                PinnedRecipes.removeRecipe(getPlayer(), hit.key)
            end
            return true
        end
    end
    local headerHits = self.headerHits or {}
    for hitIndex = 1, #headerHits do
        local hit = headerHits[hitIndex]
        if y >= hit.y0 and y <= hit.y1 then
            PinnedRecipes.toggleCollapsed(getPlayer(), hit.key)
            return true
        end
    end
    local mode = optionValue("PinnedPositionMode", MODE_VALUES, "auto")
    if mode == "manual" and y <= rect.y + 26 then
        self.draggingHud = true
        self.dragOffsetX = x - rect.x
        self.dragOffsetY = y - rect.y
        self:setCapture(true)
        return true
    end
    return false
end

function KBWPinnedRecipesPanel:onMouseMove(dx, dy)
    if not self.draggingHud then return false end
    local player = getPlayer()
    if not player or not self.hudRect then return false end
    local playerNum = player:getPlayerNum()
    local screenLeft = getPlayerScreenLeft(playerNum)
    local screenTop = getPlayerScreenTop(playerNum)
    local screenWidth = getPlayerScreenWidth(playerNum)
    local screenHeight = getPlayerScreenHeight(playerNum)
    local data = uiData(player)
    data.pinnedX = clamp(
        getMouseX() - (self.dragOffsetX or 0), screenLeft + 4, screenLeft + screenWidth - self.hudRect.w - 4
    )
    data.pinnedY = clamp(
        getMouseY() - (self.dragOffsetY or 0), screenTop + 4, screenTop + screenHeight - self.hudRect.h - 4
    )
    return true
end

function KBWPinnedRecipesPanel:onMouseMoveOutside(dx, dy)
    if self.draggingHud then return self:onMouseMove(dx, dy) end
    return false
end

function KBWPinnedRecipesPanel:onMouseUp(x, y)
    local moved = self.draggingHud == true
    self.draggingHud = false
    self:setCapture(false)
    if moved then persistUiData(getPlayer()) end
    return true
end

function KBWPinnedRecipesPanel:onMouseUpOutside(x, y)
    local moved = self.draggingHud == true
    self.draggingHud = false
    self:setCapture(false)
    if moved then persistUiData(getPlayer()) end
    return true
end

local function measurePinnedLines(lines, maxTextWidth)
    local width = 0
    local height = 36
    for lineIndex = 1, #lines do
        local line = lines[lineIndex]
        local lineWidth = line.kind == "divider" and width
            or (measure(line.font, line.text) + (line.texture and 26 or 0) + (line.indent or 0))
        if line.unpinKind then lineWidth = lineWidth + PINNED_ACTION_WIDTH end
        if lineWidth > width then width = lineWidth end
        local lineHeight = line.kind == "divider" and 9
            or (line.font == UIFont.Medium and FONT_HGT_MEDIUM or FONT_HGT_SMALL)
        if line.texture and lineHeight < 18 then lineHeight = 18 end
        height = height + lineHeight + 4
    end
    width = math.min(maxTextWidth, width) + 24
    local titleMinWidth = measure(UIFont.Small, getText("IGUI_KBW_PinnedRecipes")) + 42
    if width < titleMinWidth then width = titleMinWidth end
    if width < PINNED_MIN_WIDTH then width = PINNED_MIN_WIDTH end
    return width, height
end

function KBWPinnedRecipesPanel:render()
    local player = getPlayer()
    if not player then return end
    local data = uiData(player)
    local recipeOrder = data.pinnedRecipeOrder or {}
    local blueprintOrder = data.pinnedBlueprintOrder or {}
    if #recipeOrder == 0 and #blueprintOrder == 0 then
        self.hudRect = nil
        self:setWidth(1)
        self:setHeight(1)
        return
    end

    local maxTextWidth = PINNED_MAX_TEXT_WIDTH
    local now = getTimestampMs and getTimestampMs() or 0
    local inventoryRev = Requirements.inventoryRevision()
    local sinceBuild = now - (self.lastLinesBuildAt or 0)
    if not self.cachedLines or self.cachedGeneration ~= hudGeneration
        or (self.cachedInventoryRev ~= inventoryRev and sinceBuild > 1000)
        or now >= (self.nextLinesRefresh or 0) then
        self.cachedLines = buildLines(player, maxTextWidth, false)
        self.cachedGeneration = hudGeneration
        self.cachedInventoryRev = inventoryRev
        self.lastLinesBuildAt = now
        self.nextLinesRefresh = now + HUD_REFRESH_MS
        self.cachedWidth, self.cachedHeight = measurePinnedLines(self.cachedLines, maxTextWidth)
    end
    local lines = self.cachedLines
    if #lines == 0 then return end

    local headerHeight = 26
    local width = self.cachedWidth or 180
    local height = self.cachedHeight or 36

    local x, y, mode = self:screenRect(player, width, height)
    local bar = optionValue("PinnedBar", BAR_VALUES, "left")
    local opacity = optionNumber("PinnedOpacity", .85)
    self:setX(x)
    self:setY(y)
    self:setWidth(width)
    self:setHeight(height)
    x = 0
    y = 0
    self.hudRect = { x = 0, y = 0, w = width, h = height }
    self:drawRect(x, y, width, height, opacity * .70, Theme.backdrop.r, Theme.backdrop.g, Theme.backdrop.b)
    self:drawRectBorder(x, y, width, height, opacity * .78, Theme.border.r, Theme.border.g, Theme.border.b)
    self:drawRect(
        x, y, width, headerHeight, opacity * .82, Theme.surfaceRaised.r, Theme.surfaceRaised.g, Theme.surfaceRaised.b
    )
    if bar == "left" then
        self:drawRect(x, y, 4, height, opacity, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    elseif bar == "right" then
        self:drawRect(x + width - 4, y, 4, height, opacity, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    elseif bar == "top" then
        self:drawRect(x, y, width, 4, opacity, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    end
    self:drawText(
        getText("IGUI_KBW_PinnedRecipes"), x + 12, y + 6, Theme.accent.r, Theme.accent.g, Theme.accent.b, opacity,
        UIFont.Small
    )
    local gearX = x + width - 24
    local gearY = y + 4
    self.gearRect = { x = gearX, y = gearY, w = 20, h = 20 }
    if GEAR_TEXTURE then
        self:drawTextureScaledAspect(
            GEAR_TEXTURE, gearX, gearY, 18, 18, opacity, Theme.text.r, Theme.text.g, Theme.text.b
        )
    else
        self:drawText("o", gearX + 5, gearY + 2, Theme.text.r, Theme.text.g, Theme.text.b, opacity, UIFont.Small)
    end
    if mode == "manual" then
        self:drawRect(x + width - 52, y + 9, 18, 8, opacity * .35, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    end

    local textY = y + headerHeight + 7
    self.headerHits = {}
    self.headerActionHits = {}
    for lineIndex = 1, #lines do
        local line = lines[lineIndex]
        if line.kind == "divider" then
            self:drawRect(
                x + 10, textY + 4, width - 20, 1, opacity * .55, Theme.borderSoft.r, Theme.borderSoft.g,
                Theme.borderSoft.b
            )
            textY = textY + 12
        else
            local font = line.font
            local lineHeight = font == UIFont.Medium and FONT_HGT_MEDIUM or FONT_HGT_SMALL
            if line.texture and lineHeight < 18 then lineHeight = 18 end
            local color = line.color or Theme.text
            local textX = x + 12 + (line.indent or 0)
            if line.kind == "group" then
                self:drawRect(
                    x + 12, textY + lineHeight + 1, width - 24, 1, opacity * .32, Theme.borderSoft.r, Theme.borderSoft.g,
                    Theme.borderSoft.b
                )
            end
            if line.texture then
                self:drawTextureScaledAspect(line.texture, textX, textY, 18, 18, opacity, 1, 1, 1)
                textX = textX + 24
            end
            self:drawText(line.text, textX, textY, color.r, color.g, color.b, opacity, font)
            if line.collapseKey then
                self.headerHits[#self.headerHits + 1] = {
                    y0 = textY - 2,
                    y1 = textY + lineHeight + 2,
                    key = line.collapseKey
                }
            end
            if line.unpinKind then
                local actionX = width - PINNED_ACTION_WIDTH
                self:drawRect(
                    actionX, textY - 2, PINNED_ACTION_WIDTH - 5, lineHeight + 4, opacity * .35,
                    Theme.surfaceRaised.r, Theme.surfaceRaised.g, Theme.surfaceRaised.b
                )
                if CLOSE_TEXTURE then
                    self:drawTextureScaledAspect(
                        CLOSE_TEXTURE, actionX + 3, textY + math.floor((lineHeight - 16) / 2), 16, 16, opacity,
                        Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b
                    )
                else
                    self:drawText(
                        "x", actionX + 6, textY, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, opacity, font
                    )
                end
                self.headerActionHits[#self.headerActionHits + 1] = {
                    x0 = actionX,
                    x1 = width - 5,
                    y0 = textY - 2,
                    y1 = textY + lineHeight + 2,
                    kind = line.unpinKind,
                    key = line.unpinKey
                }
            end
            textY = textY + lineHeight + 4
        end
    end
end

function PinnedRecipes.ensurePanel()
    if PinnedRecipes.panel then return end
    local panel = KBWPinnedRecipesPanel:new()
    panel:initialise()
    panel:addToUIManager()
    PinnedRecipes.panel = panel
    if not PinnedRecipes.areaScanRegistered then
        PinnedRecipes.areaScanRegistered = true
        KBWB41.addEvent("OnTick", PinnedRecipes.updateAreaScans)
    end
end

return PinnedRecipes
