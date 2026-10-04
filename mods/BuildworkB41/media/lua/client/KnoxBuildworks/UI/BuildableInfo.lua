local Matrix = require("KnoxBuildworks/Geometry/Matrix")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local I18n = require("KnoxBuildworks/I18n")
local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local BuildableInfo = {}

local DEFAULT_CONTAINER_CAPACITY = 50
local DEFAULT_FREEZER_CAPACITY = 15

local function translatedContainerName(containerType)
    local fallback = tostring(containerType or getText("IGUI_KBW_Storage"))
    if getTextOrNull and containerType then
        return getTextOrNull("IGUI_ContainerTitle_" .. tostring(containerType)) or fallback
    end
    return fallback
end

local function addContainer(entries, containerType, capacity, containerKind)
    if not containerType then return end
    capacity = tonumber(capacity) or DEFAULT_CONTAINER_CAPACITY
    entries[#entries + 1] = {
        type = tostring(containerType),
        name = translatedContainerName(containerType),
        capacity = capacity,
        kind = containerKind or "container"
    }
end

local function spriteProperty(spriteName, name)
    local sprite = spriteName and getSprite(spriteName) or nil
    local properties = sprite and sprite:getProperties() or nil
    if not properties or not KBWB41.propIs(properties, name) then return nil end
    local value = KBWB41.propVal(properties, name)
    if value == "" then return true end
    return value
end

local function addSpriteContainers(entries, spriteName, configured)
    local containerType = spriteProperty(spriteName, "container")
    if containerType and containerType ~= true then
        addContainer(
            entries, containerType,
            spriteProperty(spriteName, "ContainerCapacity") or (configured and configured.capacity), "container"
        )
    elseif configured and configured.type then
        addContainer(entries, configured.type, configured.capacity, "container")
    end
    if spriteProperty(spriteName, "Freezer") then
        addContainer(
            entries, "freezer", spriteProperty(spriteName, "FreezerCapacity") or DEFAULT_FREEZER_CAPACITY, "freezer"
        )
    end
end

function BuildableInfo.availableFace(stage)
    if not stage then return {}, nil end
    local cells, face = Matrix.getFaceCells(stage, "S")
    return cells or {}, face
end

function BuildableInfo.containerTiles(stage)
    if not stage then return {} end
    local cells, face = BuildableInfo.availableFace(stage)
    local tiles = {}
    local configured = stage.container
    for cellIndex = 1, #cells do
        local cell = cells[cellIndex]
        local containers = {}
        if cell.sprite then addSpriteContainers(containers, cell.sprite, configured) end
        if #containers > 0 then
            tiles[#tiles + 1] = {
                tileIndex = cellIndex,
                face = face,
                sprite = cell.sprite,
                dx = cell.dx or 0,
                dy = cell.dy or 0,
                dz = cell.dz or 0,
                containers = containers
            }
        end
    end
    if #cells == 0 and configured and configured.type then
        local containers = {}
        addContainer(containers, configured.type, configured.capacity, "container")
        tiles[1] = {
            tileIndex = 1,
            face = face,
            dx = 0,
            dy = 0,
            dz = 0,
            containers = containers
        }
    end
    return tiles
end

function BuildableInfo.containers(stage)
    local entries = {}
    local tiles = BuildableInfo.containerTiles(stage)
    for tileIndex = 1, #tiles do
        local tile = tiles[tileIndex]
        for containerIndex = 1, #tile.containers do
            local entry = tile.containers[containerIndex]
            entry.tileIndex = tile.tileIndex
            entry.face = tile.face
            entry.sprite = tile.sprite
            entry.dx = tile.dx
            entry.dy = tile.dy
            entry.dz = tile.dz
            entries[#entries + 1] = entry
        end
    end
    return entries
end

local function tileCapacityText(tile)
    local parts = {}
    local containers = tile.containers or {}
    for containerIndex = 1, #containers do
        local container = containers[containerIndex]
        parts[#parts + 1] = container.name .. ": " .. tostring(container.capacity)
    end
    return getText("IGUI_KBW_Tile") .. " " .. tostring(tile.tileIndex) .. " - " .. table.concat(parts, " + ")
end

function BuildableInfo.capacityLines(stage)
    local lines = {}
    local tiles = BuildableInfo.containerTiles(stage)
    for tileIndex = 1, #tiles do
        lines[#lines + 1] = tileCapacityText(tiles[tileIndex])
    end
    return lines
end

function BuildableInfo.capacityChipTexts(stage)
    return BuildableInfo.capacityLines(stage)
end

function BuildableInfo.dimensionsText(stage)
    local cells = BuildableInfo.availableFace(stage)
    local bounds = Matrix.getBounds(cells)
    return string.format("%d x %d x %d", bounds.width, bounds.height, bounds.depth)
end

local function capacityText(stage)
    local lines = BuildableInfo.capacityLines(stage)
    if #lines == 0 then return nil end
    return BuildableInfo.capacityHeading(stage) .. "  " .. table.concat(lines, "  |  ")
end

function BuildableInfo.capacityHeading(stage)
    local _, faceName = BuildableInfo.availableFace(stage)
    local heading = getText("IGUI_KBW_StorageCapacity")
    if faceName then
        local translatedFace = getTextOrNull and getTextOrNull("IGUI_KBW_Face_" .. tostring(faceName)) or nil
        heading = heading .. " " .. (translatedFace or tostring(faceName))
    end
    return heading
end

function BuildableInfo.capacityText(stage)
    return capacityText(stage)
end

function BuildableInfo.capacityShortText(stage)
    local lines = BuildableInfo.capacityLines(stage)
    if #lines == 0 then return nil end
    if #lines == 1 then return lines[1] end
    local count = 0
    local tiles = BuildableInfo.containerTiles(stage)
    for tileIndex = 1, #tiles do
        count = count + #(tiles[tileIndex].containers or {})
    end
    return getText("IGUI_KBW_Storage") .. ": " .. tostring(#tiles) .. " "
        .. getText("IGUI_KBW_Tiles") .. ", " .. tostring(count) .. " "
        .. getText("IGUI_KBW_Containers")
end

local function itemDisplayName(fullType)
    if type(fullType) == "string" and string.find(fullType, ".", 1, true) then
        return getItemNameFromFullType(fullType)
    end
    return tostring(fullType or "?")
end

local function rowName(row)
    if row.labelKey then return I18n.text(row.labelKey, row.label) end
    if row.label then return tostring(row.label) end
    if row.selectedFullType then return itemDisplayName(row.selectedFullType) end
    local possibleItems = row.possibleItems or {}
    if possibleItems[1] then return itemDisplayName(possibleItems[1]) end
    local possibleTags = row.possibleTags or {}
    if possibleTags[1] then return "#" .. tostring(possibleTags[1]) end
    return tostring(row.id or row.name or "?")
end

local function itemScript(fullType)
    if not fullType then return nil end
    if getItem then
        local script = KBWB41.scriptItem(fullType)
        if script then return script end
    end
    return ScriptManager and ScriptManager.instance and ScriptManager.instance:FindItem(fullType) or nil
end

local function itemTextureName(row)
    local texture = row.item and row.item.getTexture and row.item:getTexture() or nil
    local availableItems = row.availableItems or {}
    if not texture then
        for itemIndex = 1, #availableItems do
            local available = availableItems[itemIndex]
            if available.item and available.item.getTexture then
                texture = available.item:getTexture()
                if texture then break end
            end
        end
    end
    if not texture then
        local fullType = row.selectedFullType
        if not fullType and availableItems[1] then fullType = availableItems[1].fullType end
        if not fullType and row.possibleItems then fullType = row.possibleItems[1] end
        local script = itemScript(fullType)
        if script and script.getNormalTexture then texture = script:getNormalTexture() end
    end
    return texture and texture.getName and texture:getName() or nil
end

local function tooltipRow(row)
    local color = row.ok and "<RGB:0.55,0.85,0.45>" or "<RGB:0.95,0.62,0.28>"
    if row.kind == "skill" then
        return color .. "- " .. getText("IGUI_perks_" .. tostring(row.name)) .. ": "
            .. tostring(row.available or 0) .. "/" .. tostring(row.needed or 0)
    end
    if row.kind == "knowledge" then
        local name = tostring(row.name or "?")
        if row.alternativeLabel and row.alternativeLabel ~= "" then
            name = getText("IGUI_KBW_RecipeOrSkill", name, row.alternativeLabel)
        end
        local state = row.alternativeMet and getText("IGUI_KBW_SkillUnlocked")
            or (row.ok and getText("IGUI_KBW_Known") or getText("IGUI_KBW_NotKnown"))
        return color .. "- " .. name .. ": " .. state
    end
    local textureName = itemTextureName(row)
    local icon = textureName and ("<IMAGE:" .. textureName .. ",18,18> ") or "- "
    return icon .. color .. rowName(row) .. ": " .. tostring(row.available or 0)
        .. "/" .. tostring(row.needed or 1)
end

function BuildableInfo.compactTooltip(player, definition, stage)
    if not definition or not stage then return "" end
    local lines = {}
    local description = I18n.definitionDescription(definition)
    if description and description ~= "" then lines[#lines + 1] = "<RGB:0.78,0.78,0.75>" .. description end
    if StageConfig.placement(definition, stage).requiresOutside == true then
        lines[#lines + 1] = "<RGB:0.95,0.62,0.28>" .. getText("IGUI_KBW_RequiresOutside")
    end
    local capacityLines = BuildableInfo.capacityLines(stage)
    if #capacityLines > 0 then
        lines[#lines + 1] = "<RGB:0.86,0.78,0.45>" .. getText("IGUI_KBW_StorageCapacity")
        for capacityIndex = 1, #capacityLines do
            lines[#lines + 1] = "<RGB:0.86,0.78,0.45>- " .. capacityLines[capacityIndex]
        end
    end

    local status = Requirements.evaluate(player, definition, stage)
    local materialRows = {}
    local gateRows = {}
    local rows = status.rows or {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if row.kind == "skill" or row.kind == "knowledge" then
            gateRows[#gateRows + 1] = row
        else
            materialRows[#materialRows + 1] = row
        end
    end
    if #materialRows > 0 then
        lines[#lines + 1] = "<RGB:0.86,0.78,0.45>" .. getText("IGUI_KBW_MaterialsTools")
        for rowIndex = 1, #materialRows do
            lines[#lines + 1] = tooltipRow(materialRows[rowIndex])
        end
    end
    if #gateRows > 0 then
        lines[#lines + 1] = "<RGB:0.86,0.78,0.45>" .. getText("IGUI_KBW_SkillsKnowledge")
        for rowIndex = 1, #gateRows do
            lines[#lines + 1] = tooltipRow(gateRows[rowIndex])
        end
    end
    return table.concat(lines, " <LINE> ")
end

return BuildableInfo
