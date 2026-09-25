require("ISUI/ISCollapsableWindow")
require("ISUI/ISScrollingListBox")
require("ISUI/ISTextEntryBox")
require("ISUI/ISButton")
require("ISUI/ISComboBox")
require("ISUI/ISRichTextPanel")

local Registry = require("KnoxBuildworks/Definitions/Registry")
local CatalogIndex = require("KnoxBuildworks/UI/CatalogIndex")
local I18n = require("KnoxBuildworks/I18n")
local Theme = require("KnoxBuildworks/UI/Theme")
local VirtualListBox = require("KnoxBuildworks/UI/VirtualListBox")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

KBWDebugTileGrid = ISPanel:derive("KBWDebugTileGrid")

function KBWDebugTileGrid:setTileset(tileset)
    self.tileset = tileset
    self.tiles = {}
    self.selectedSprite = nil
    self.maxIndex = -1
    local names = tileset and getWorld():getAllTiles(tileset) or nil
    if names then
        for nameIndex = 0, names:size() - 1 do
            local spriteName = names:get(nameIndex)
            local index = tonumber(string.match(spriteName, "_(%d+)$"))
            if index then
                self.tiles[index] = spriteName
                self.maxIndex = math.max(self.maxIndex, index)
            end
        end
    end
    self:setYScroll(0)
    self:updateScrollHeight()
end

function KBWDebugTileGrid:updateScrollHeight()
    local rows = self.maxIndex >= 0 and math.floor(self.maxIndex / self.columns) + 1 or 1
    self:setScrollHeight(self.padding * 2 + rows * self:cellHeight())
end

function KBWDebugTileGrid:cellWidth()
    return math.max(32, math.floor(64 * self.zoom))
end

function KBWDebugTileGrid:cellHeight()
    return math.max(64, math.floor(128 * self.zoom))
end

function KBWDebugTileGrid:setZoom(zoom)
    local fitZoom = math.max(0.5, (self.width - self.padding * 2 - 18) / (self.columns * 64))
    self.zoom = math.max(0.5, math.min(1.5, fitZoom, zoom))
    self:updateScrollHeight()
end

function KBWDebugTileGrid:render()
    ISPanel.render(self)
    local scrollbarWidth = self.vscroll and self.vscroll.width or 0
    self:setStencilRect(0, 0, self.width - scrollbarWidth, self.height)
    local cellW = self:cellWidth()
    local cellH = self:cellHeight()
    local firstRow = math.max(0, math.floor((-self:getYScroll() - self.padding) / cellH) - 1)
    local lastRow = math.min(math.floor(math.max(0, self.maxIndex) / self.columns),
        firstRow + math.ceil(self.height / cellH) + 3)
    for row = firstRow, lastRow do
        for column = 0, self.columns - 1 do
            local index = row * self.columns + column
            local spriteName = self.tiles[index]
            if spriteName then
                local texture = getTexture(spriteName)
                if texture then
                    local x = self.padding + column * cellW
                    local y = self.padding + row * cellH
                    self:drawTextureScaledAspect(texture, x, y, cellW, cellH, 1, 1, 1, 1)
                    if self.selectedSprite == spriteName then
                        self:drawRectBorder(x, y, cellW, cellH, 1, Theme.accent.r, Theme.accent.g, Theme.accent.b)
                        self:drawRectBorder(x + 1, y + 1, cellW - 2, cellH - 2, 0.8, Theme.accent.r,
                            Theme.accent.g, Theme.accent.b)
                    end
                end
            end
        end
    end
    local mouseColumn = math.floor((self:getMouseX() - self.padding) / cellW)
    local mouseRow = math.floor((self:getMouseY() - self.padding) / cellH)
    if mouseColumn >= 0 and mouseColumn < self.columns and mouseRow >= 0 then
        local hoverIndex = mouseRow * self.columns + mouseColumn
        if self.tiles[hoverIndex] then
            self:drawRectBorder(self.padding + mouseColumn * cellW, self.padding + mouseRow * cellH,
                cellW, cellH, 0.7, 1, 1, 1)
        end
    end
    self:clearStencilRect()
    if self.vscroll then self.vscroll:setX(self.width - self.vscroll.width) end
end

function KBWDebugTileGrid:onMouseWheel(delta)
    if isCtrlKeyDown() then
        self:setZoom(self.zoom + (delta < 0 and 0.1 or -0.1))
        if self.owner then self.owner:updateZoomLabel() end
        return true
    end
    self:setYScroll(self:getYScroll() - delta * self:cellHeight())
    return true
end

function KBWDebugTileGrid:onMouseDown(x, y)
    local column = math.floor((x - self.padding) / self:cellWidth())
    local row = math.floor((y - self.padding) / self:cellHeight())
    if column < 0 or column >= self.columns or row < 0 then return true end
    local spriteName = self.tiles[row * self.columns + column]
    if spriteName then
        self.selectedSprite = spriteName
        if self.owner then self.owner:onSpriteSelected(spriteName) end
    end
    return true
end

function KBWDebugTileGrid:selectSprite(spriteName)
    local index = tonumber(string.match(tostring(spriteName or ""), "_(%d+)$"))
    if not index or not self.tiles[index] then return false end
    self.selectedSprite = self.tiles[index]
    local row = math.floor(index / self.columns)
    local target = math.max(0, self.padding + row * self:cellHeight() - math.floor(self.height / 2))
    self:setYScroll(-target)
    if self.owner then self.owner:onSpriteSelected(self.selectedSprite) end
    return true
end

function KBWDebugTileGrid:new(x, y, width, height, owner)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.owner = owner
    o.columns = 8
    o.padding = 8
    o.zoom = 0.75
    o.tiles = {}
    o.maxIndex = -1
    o.background = true
    o.backgroundColor = Theme.color(Theme.backdrop)
    o.borderColor = Theme.color(Theme.borderSoft)
    return o
end

KBWDebugTileBrowser = ISCollapsableWindow:derive("KBWDebugTileBrowser")
KBWDebugTileBrowser.instance = nil

local PADDING = 10
local GAP = 8
local CONTROL_H = 26
local BUTTON_H = 28

local function makeButton(parent, text, callback, primary)
    local button = ISButton:new(0, 0, 100, BUTTON_H, text, parent, callback)
    button:initialise()
    button:instantiate()
    Theme.applyActionButton(button, true, primary == true)
    parent:addChild(button)
    return button
end

local function wrappedText(value, width, font)
    local text = tostring(value or "")
    local lines = {}
    local line = ""
    for characterIndex = 1, #text do
        local character = string.sub(text, characterIndex, characterIndex)
        local candidate = line .. character
        if line ~= "" and getTextManager():MeasureStringX(font, candidate) > width then
            lines[#lines + 1] = line
            line = character
        else
            line = candidate
        end
    end
    if line ~= "" or #lines == 0 then lines[#lines + 1] = line end
    return lines
end

local function appendWrapped(lines, value, width, font, markup)
    local wrapped = wrappedText(value, width, font)
    for lineIndex = 1, #wrapped do
        lines[#lines + 1] = " <LINE> " .. (markup or "") .. wrapped[lineIndex]
    end
end

local function ownerParts(owner)
    local value = tostring(owner or "")
    local buildableId = string.match(value, "^([^:]+)") or value
    local stageId = string.match(value, "([^:]+)$") or ""
    local optionKind, optionId = string.match(value, "^[^:]+:(variant)%-([^:]+):")
    if not optionKind then optionKind, optionId = string.match(value, "^[^:]+:(material)%-([^:]+):") end
    return buildableId, stageId, optionKind, optionId
end

local function optionIndex(options, optionId, offset)
    options = options or {}
    for index = 1, #options do
        if tostring(options[index].id or "") == tostring(optionId or "") then return index + (offset or 0) end
    end
    return 1
end

local function catalogTarget(owner)
    local buildableId, stageId, optionKind, optionId = ownerParts(owner)
    local sourceDefinition = Registry:get(buildableId)
    if not sourceDefinition then return nil end
    local records = CatalogIndex.get().records or {}
    local record = nil
    for recordIndex = 1, #records do
        local candidate = records[recordIndex]
        if candidate.id == buildableId then
            record = candidate
            break
        end
        local members = candidate.definition and candidate.definition.__kbwMembers or {}
        for memberIndex = 1, #members do
            if members[memberIndex].id == buildableId then
                record = candidate
                break
            end
        end
        if record then break end
    end
    if not record then return nil end
    local stageIndex = 1
    local stages = record.definition.stages or {}
    for index = 1, #stages do
        local stage = stages[index]
        local candidateBuildableId = stage.__kbwBuildableId or record.definition.id
        local candidateStageId = stage.__kbwStageId or stage.id
        if candidateBuildableId == buildableId and tostring(candidateStageId or "") == stageId then
            stageIndex = index
            break
        end
    end
    local variantIndex = 1
    local materialIndex = 1
    if optionKind == "variant" then
        variantIndex = optionIndex(sourceDefinition.variants, optionId, 1)
    elseif optionKind == "material" then
        local offset = sourceDefinition.materialRequired == true and 0 or 1
        materialIndex = optionIndex(sourceDefinition.materialOptions, optionId, offset)
    end
    return {
        owner = tostring(owner),
        buildableId = buildableId,
        displayName = I18n.definitionName(sourceDefinition),
        catalogId = record.id,
        category = record.category,
        subcategory = record.subcategory,
        stageIndex = stageIndex,
        variantIndex = variantIndex,
        materialIndex = materialIndex
    }
end

local function tilesetName(imageName)
    local value = tostring(imageName or "")
    value = string.gsub(value, "\\", "/")
    value = string.match(value, "([^/]+)$") or value
    value = string.gsub(value, "%.[Pp][Nn][Gg]$", "")
    return value
end

function KBWDebugTileBrowser:createChildren()
    ISCollapsableWindow.createChildren(self)
    local top = self:titleBarHeight() + PADDING
    self.searchEntry = ISTextEntryBox:new("", PADDING, top, 280, CONTROL_H)
    self.searchEntry:initialise()
    self.searchEntry:instantiate()
    self.searchEntry:setClearButton(true)
    self.searchEntry.onTextChange = self.onSearchChanged
    self.searchEntry.target = self
    self:addChild(self.searchEntry)

    self.tilesetList = VirtualListBox:new(PADDING, top + CONTROL_H + GAP, 280, 500)
    self.tilesetList:initialise()
    self.tilesetList:instantiate()
    self.tilesetList.itemheight = 24
    self.tilesetList.font = UIFont.Small
    self.tilesetList.drawBorder = true
    self.tilesetList.doDrawItem = self.drawTileset
    self.tilesetList:setOnMouseDownFunction(self, self.onTilesetSelected)
    self:addChild(self.tilesetList)

    self.grid = KBWDebugTileGrid:new(0, top, 520, 500, self)
    self.grid:initialise()
    self.grid:instantiate()
    self.grid:addScrollBars()
    self:addChild(self.grid)

    self.details = ISRichTextPanel:new(0, top, 260, 430)
    self.details:initialise()
    self.details:instantiate()
    self.details.background = true
    self.details.backgroundColor = Theme.color(Theme.surface)
    self.details.borderColor = Theme.color(Theme.borderSoft)
    self.details.marginLeft = 10
    self.details.marginRight = 10
    self.details.marginTop = 10
    self.details.autosetheight = false
    self.details:addScrollBars()
    self:addChild(self.details)

    self.ownerCombo = ISComboBox:new(0, 0, 200, CONTROL_H, self, nil)
    self.ownerCombo:initialise()
    self:addChild(self.ownerCombo)

    self.openBuildworksButton = makeButton(
        self, getText("IGUI_KBW_DebugTilesOpenBuildworks"), self.onOpenBuildworks, true
    )
    self.copyButton = makeButton(self, getText("IGUI_KBW_DebugTilesCopy"), self.onCopy)
    self.copyJsonButton = makeButton(self, getText("IGUI_KBW_DebugTilesCopyJson"), self.onCopyJson)
    self.placeButton = makeButton(self, getText("IGUI_KBW_DebugTilesPlace"), self.onPlaceTile, true)
    self.zoomOutButton = makeButton(self, "-", self.onZoomOut)
    self.zoomInButton = makeButton(self, "+", self.onZoomIn)
    self.ownerTargets = {}
    self.zoomLabel = ""
    self.statusText = getText("IGUI_KBW_DebugTilesSelect")

    self:buildTilesetIndex()
    self:populateTilesets()
    self:updateZoomLabel()
    self:updateActions()
    self:layout()
end

function KBWDebugTileBrowser:buildTilesetIndex()
    self.tilesets = {}
    local seen = {}
    local debugTilesets = getWorld():getAllTilesName()
    for tilesetIndex = 0, debugTilesets:size() - 1 do
        local name = debugTilesets:get(tilesetIndex)
        if not seen[name] then
            seen[name] = true
            self.tilesets[#self.tilesets + 1] = name
        end
    end
    local images = getWorld():getTileImageNames()
    for imageIndex = 0, images:size() - 1 do
        local name = tilesetName(images:get(imageIndex))
        if name ~= "" and not seen[name] and getWorld():getAllTiles(name) then
            seen[name] = true
            self.tilesets[#self.tilesets + 1] = name
        end
    end
    table.sort(self.tilesets)
end

function KBWDebugTileBrowser:populateTilesets()
    local query = string.lower(self.searchEntry:getInternalText() or "")
    local exactSheet, exactIndex = string.match(query, "^(.-)_(%d+)$")
    local rows = {}
    local selectedIndex = 0
    for tilesetIndex = 1, #self.tilesets do
        local name = self.tilesets[tilesetIndex]
        if query == "" or string.find(string.lower(name), query, 1, true)
            or (exactSheet and string.lower(name) == exactSheet) then
            rows[#rows + 1] = { name = name, value = name }
            if self.grid.tileset == name then selectedIndex = #rows end
        end
    end
    self.tilesetList:replaceItems(rows, "name", "value")
    if selectedIndex == 0 and #self.tilesetList.items > 0 then selectedIndex = 1 end
    self.tilesetList.selected = selectedIndex
    if selectedIndex > 0 then
        local name = self.tilesetList.items[selectedIndex].item
        if self.grid.tileset ~= name then self:onTilesetSelected(name) end
        if exactIndex and string.lower(name) == exactSheet then self.grid:selectSprite(name .. "_" .. exactIndex) end
    else
        self.grid:setTileset(nil)
        self.selectedSprite = nil
        self:refreshOwnerControls(nil)
        self.details.text = " <LEFT> " .. getText("IGUI_KBW_DebugTilesSelect")
        self.details:paginate()
        self.statusText = getText("IGUI_KBW_DebugTilesSelect")
    end
end

function KBWDebugTileBrowser:onSearchChanged()
    self.target:populateTilesets()
end

function KBWDebugTileBrowser:updateActions()
    local hasSprite = self.selectedSprite ~= nil
    local hasOwner = #self.ownerTargets > 0
    Theme.applyActionButton(self.copyButton, hasSprite, false)
    Theme.applyActionButton(self.copyJsonButton, hasSprite, false)
    Theme.applyActionButton(self.placeButton, hasSprite, true)
    Theme.applyActionButton(self.openBuildworksButton, hasOwner, true)
    self.ownerCombo:setEnabled(hasOwner)
end

function KBWDebugTileBrowser:refreshOwnerControls(spriteName)
    self.ownerTargets = {}
    self.ownerCombo:clear()
    local owners = spriteName and Registry.sprites[spriteName] or {}
    for ownerIndex = 1, #owners do
        local target = catalogTarget(owners[ownerIndex])
        if target then
            self.ownerTargets[#self.ownerTargets + 1] = target
            local label = target.displayName .. "  |  " .. target.owner
            self.ownerCombo:addOptionWithData(label, target)
        end
    end
    if #self.ownerTargets == 0 then
        self.ownerCombo:addOption(getText("IGUI_KBW_DebugTilesNoBuildable"))
    end
    self.ownerCombo.selected = 1
    self:updateActions()
end

function KBWDebugTileBrowser:drawTileset(y, item, alt)
    if self.selected == item.index then
        self:drawRect(0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r,
            Theme.selected.g, Theme.selected.b)
    elseif alt then
        self:drawRect(0, y, self.width, self.itemheight - 1, 0.18, Theme.surfaceRaised.r,
            Theme.surfaceRaised.g, Theme.surfaceRaised.b)
    end
    self:drawText(item.text, 8, y + 4, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    return y + self.itemheight
end

function KBWDebugTileBrowser:onTilesetSelected(tileset)
    if not tileset or tileset == "" then return end
    self.grid:setTileset(tileset)
    self.selectedSprite = nil
    self:refreshOwnerControls(nil)
    self.details.text = " <LEFT> <H2> " .. tostring(tileset)
        .. " <LINE> <LINE> " .. getText("IGUI_KBW_DebugTilesSelect")
    self.details:paginate()
    self.statusText = tostring(tileset)
end

local function propertyLines(spriteName)
    local lines = {}
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    if not properties then return lines end
    local names = properties:getPropertyNames()
    for propertyIndex = 0, names:size() - 1 do
        local name = names:get(propertyIndex)
        lines[#lines + 1] = tostring(name) .. " = " .. tostring(KBWB41.propVal(properties, name))
    end
    local flags = properties:getFlagsList()
    for flagIndex = 0, flags:size() - 1 do
        lines[#lines + 1] = "flag: " .. tostring(flags:get(flagIndex))
    end
    return lines
end

function KBWDebugTileBrowser:onSpriteSelected(spriteName)
    self.selectedSprite = spriteName
    self:refreshOwnerControls(spriteName)
    local index = tonumber(string.match(spriteName, "_(%d+)$")) or 0
    local contentWidth = math.max(80, self.details.width - self.details.marginLeft - self.details.marginRight - 18)
    local lines = { " <LEFT> " }
    appendWrapped(lines, spriteName, contentWidth, UIFont.Medium, "<H2>")
    lines[#lines + 1] = " <LINE> <RGB:0.72,0.70,0.64> " .. getText("IGUI_KBW_DebugTilesCoordinates", math.floor(index / 8), index % 8, index
    )
    lines[#lines + 1] = " <LINE> <LINE> <H2> " .. getText("IGUI_KBW_DebugTilesProperties")
    local properties = propertyLines(spriteName)
    if #properties == 0 then lines[#lines + 1] = " <LINE> " .. getText("IGUI_KBW_DebugTilesNoProperties") end
    for propertyIndex = 1, #properties do
        appendWrapped(lines, properties[propertyIndex], contentWidth, UIFont.Small, "")
    end
    lines[#lines + 1] = " <LINE> <LINE> <H2> " .. getText("IGUI_KBW_DebugTilesUsedBy")
    local owners = Registry.sprites[spriteName] or {}
    if #owners == 0 then lines[#lines + 1] = "<LINE>" .. getText("IGUI_KBW_DebugTilesUnused") end
    for ownerIndex = 1, #owners do
        local target = catalogTarget(owners[ownerIndex])
        if target then
            appendWrapped(lines, target.displayName, contentWidth, UIFont.Small, " <RGB:0.93,0.86,0.56> ")
        end
        appendWrapped(lines, owners[ownerIndex], contentWidth, UIFont.Small, " <RGB:0.72,0.70,0.64> ")
    end
    self.details.text = table.concat(lines, "")
    self.details:paginate()
    self.statusText = spriteName
end

function KBWDebugTileBrowser:onCopy()
    if not self.selectedSprite then return end
    Clipboard.setClipboard(self.selectedSprite)
    self.statusText = getText("IGUI_KBW_DebugTilesCopied", self.selectedSprite)
end

function KBWDebugTileBrowser:onCopyJson()
    if not self.selectedSprite then return end
    Clipboard.setClipboard('"' .. self.selectedSprite .. '"')
    self.statusText = getText("IGUI_KBW_DebugTilesCopied", self.selectedSprite)
end

function KBWDebugTileBrowser:onPlaceTile()
    if not self.selectedSprite then return end
    if not ISBrushToolTileCursor then require "BuildingObjects/ISBrushToolTileCursor" end
    if not ISBrushToolTileCursor then return end
    local cursor = ISBrushToolTileCursor:new(self.selectedSprite, self.selectedSprite, self.player)
    getCell():setDrag(cursor, self.player:getPlayerNum())
end

function KBWDebugTileBrowser:onOpenBuildworks()
    local target = self.ownerCombo:getOptionData(self.ownerCombo.selected)
    if not target then return end
    local CatalogVisibility = require("KnoxBuildworks/UI/CatalogVisibility")
    local Catalog = require("KnoxBuildworks/UI/Catalog")
    CatalogVisibility.setShowAll(self.player, true)
    local player = self.player
    Catalog.open(player, {
        scope = "All",
        category = target.category,
        subcategory = target.subcategory,
        selectedId = target.catalogId,
        stageIndex = target.stageIndex,
        variantIndex = target.variantIndex,
        materialIndex = target.materialIndex,
        search = ""
    })
end

function KBWDebugTileBrowser:onZoomOut()
    self.grid:setZoom(self.grid.zoom - 0.1)
    self:updateZoomLabel()
end

function KBWDebugTileBrowser:onZoomIn()
    self.grid:setZoom(self.grid.zoom + 0.1)
    self:updateZoomLabel()
end

function KBWDebugTileBrowser:updateZoomLabel()
    self.zoomLabel = tostring(math.floor(self.grid.zoom * 100 + 0.5)) .. "%"
end

function KBWDebugTileBrowser:layout()
    local titleHeight = self:titleBarHeight()
    local resizeHeight = self:resizeWidgetHeight()
    local top = titleHeight + PADDING
    local bottomY = self.height - resizeHeight - PADDING - BUTTON_H
    local leftWidth = math.max(190, math.min(250, math.floor(self.width * 0.23)))
    local rightWidth = math.max(220, math.min(280, math.floor(self.width * 0.25)))
    self.searchEntry:setX(PADDING)
    self.searchEntry:setY(top)
    self.searchEntry:setWidth(leftWidth)
    self.tilesetList:setX(PADDING)
    self.tilesetList:setY(top + CONTROL_H + GAP)
    self.tilesetList:setWidth(leftWidth)
    self.tilesetList:setHeight(bottomY - GAP - self.tilesetList:getY())
    self.grid:setX(self.tilesetList:getRight() + GAP)
    self.grid:setY(top)
    self.grid:setWidth(self.width - PADDING * 2 - GAP * 2 - leftWidth - rightWidth)
    self.grid:setHeight(bottomY - GAP - top)
    self.grid:setZoom(self.grid.zoom)
    self.grid:updateScrollHeight()
    local ownerButtonY = bottomY - GAP - BUTTON_H
    local ownerComboY = ownerButtonY - GAP - CONTROL_H
    local previousDetailWidth = self.details.width
    self.details:setX(self.grid:getRight() + GAP)
    self.details:setY(top)
    self.details:setWidth(rightWidth)
    self.details:setHeight(math.max(120, ownerComboY - GAP - top))
    self.ownerCombo:setX(self.details:getX())
    self.ownerCombo:setY(ownerComboY)
    self.ownerCombo:setWidth(rightWidth)
    self.ownerCombo:setHeight(CONTROL_H)
    self.openBuildworksButton:setX(self.details:getX())
    self.openBuildworksButton:setY(ownerButtonY)
    self.openBuildworksButton:setWidth(rightWidth)

    if self.selectedSprite and previousDetailWidth ~= rightWidth then
        self:onSpriteSelected(self.selectedSprite)
    else
        self.details:paginate()
    end

    local zoomBlockWidth = 110
    local actionRight = self.grid:getRight() - zoomBlockWidth - GAP
    local actionButtons = { self.copyButton, self.copyJsonButton, self.placeButton }
    local actionWidth = math.floor((actionRight - PADDING - GAP * (#actionButtons - 1)) / #actionButtons)
    local actionX = PADDING
    for actionIndex = 1, #actionButtons do
        local button = actionButtons[actionIndex]
        button:setX(actionX)
        button:setY(bottomY)
        button:setWidth(actionIndex == #actionButtons and actionRight - actionX or actionWidth)
        actionX = button:getRight() + GAP
    end
    self.zoomOutButton:setX(self.grid:getRight() - zoomBlockWidth)
    self.zoomOutButton:setY(bottomY)
    self.zoomOutButton:setWidth(34)
    self.zoomInButton:setX(self.grid:getRight() - 34)
    self.zoomInButton:setY(bottomY)
    self.zoomInButton:setWidth(34)
    self.lastLayoutWidth = self.width
    self.lastLayoutHeight = self.height
end

function KBWDebugTileBrowser:prerender()
    if self.width ~= self.lastLayoutWidth or self.height ~= self.lastLayoutHeight then self:layout() end
    ISCollapsableWindow.prerender(self)
    local y = self.copyButton:getY() + 6
    self:drawText(self.zoomLabel, self.zoomOutButton:getRight() + 8, y,
        Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
end

function KBWDebugTileBrowser:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if KBWDebugTileBrowser.instance == self then KBWDebugTileBrowser.instance = nil end
end

function KBWDebugTileBrowser:isKeyConsumed(key)
    return Keyboard and key == Keyboard.KEY_ESCAPE
end

function KBWDebugTileBrowser:onKeyRelease(key)
    if self:isVisible() and self:isKeyConsumed(key) then
        self:close()
        return
    end
end

function KBWDebugTileBrowser:new(player)
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local width = math.min(1000, screenWidth - 60)
    local height = math.min(650, screenHeight - 60)
    local o = ISCollapsableWindow:new(math.floor((screenWidth - width) / 2), math.floor((screenHeight - height) / 2),
        width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.title = getText("IGUI_KBW_DebugTilesTitle")
    o.resizable = true
    o.minimumWidth = math.min(820, width)
    o.minimumHeight = math.min(500, height)
    o:setWantKeyEvents(true)
    return o
end

function KBWDebugTileBrowser.open(player)
    if not isDebugEnabled() or not player then return end
    if KBWDebugTileBrowser.instance then
        KBWDebugTileBrowser.instance:close()
        return
    end
    local window = KBWDebugTileBrowser:new(player)
    window:initialise()
    window:addToUIManager()
    window:setVisible(true)
    window:bringToTop()
    KBWDebugTileBrowser.instance = window
end

return KBWDebugTileBrowser
