require "ISUI/ISPanel"
require "ISUI/ISCollapsableWindow"
require "ISUI/ISButton"
require "ISUI/ISScrollingListBox"
require "ISUI/ISTextEntryBox"
require "ISUI/ISComboBox"

local KBW = require("KnoxBuildworks/Core")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local Registry = require("KnoxBuildworks/Definitions/Registry")
local Groups = require("KnoxBuildworks/Definitions/Groups")
local TableUtil = require("KnoxBuildworks/Util/Table")
local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local Planner = require("KnoxBuildworks/Planning/Planner")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local Theme = require("KnoxBuildworks/UI/Theme")
local BuildCardGrid = require("KnoxBuildworks/UI/BuildCardGrid")
local PinnedRecipes = require("KnoxBuildworks/UI/PinnedRecipes")
local IconResolver = require("KnoxBuildworks/UI/IconResolver")
local FinishOptions = require("KnoxBuildworks/UI/FinishOptions")
local I18n = require("KnoxBuildworks/I18n")
local CatalogVisibility = require("KnoxBuildworks/UI/CatalogVisibility")
local CatalogIndex = require("KnoxBuildworks/UI/CatalogIndex")
local Profiler = require("KnoxBuildworks/Util/Profiler")
local Options = require("KnoxBuildworks/Options")
require("KnoxBuildworks/UI/BlueprintAccessWindow")
require("KnoxBuildworks/UI/BlueprintImportWindow")
require "ISUI/ISTickBox"
local KBWB41 = require("KnoxBuildworks/Compat/B41")
require("KnoxBuildworks/Compat/UIShims")

KBWPlanningMode = ISPanel:derive("KBWPlanningMode")
KBWPlanningMode.instance = nil

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local ROOM_COLORS = {
    { r = 0.25, g = 0.65, b = 0.95, a = 0.12 }, { r = 0.35, g = 0.80, b = 0.45, a = 0.12 },
    { r = 0.95, g = 0.78, b = 0.22, a = 0.12 }, { r = 0.72, g = 0.46, b = 0.95, a = 0.12 },
    { r = 0.42, g = 0.85, b = 0.85, a = 0.12 }, { r = 0.95, g = 0.52, b = 0.22, a = 0.12 },
    { r = 0.95, g = 0.35, b = 0.42, a = 0.12 }, { r = 0.95, g = 0.58, b = 0.82, a = 0.12 },
    { r = 0.78, g = 0.78, b = 0.78, a = 0.11 }, { r = 1.00, g = 1.00, b = 1.00, a = 0.10 },
    { r = 0.45, g = 0.55, b = 1.00, a = 0.12 }, { r = 0.65, g = 1.00, b = 0.35, a = 0.12 },
    { r = 1.00, g = 0.70, b = 0.45, a = 0.12 }, { r = 0.85, g = 0.45, b = 0.65, a = 0.12 }
}

local OPACITY_VALUES = { 0.08, 0.14, 0.22, 0.34 }

local GRANT_LEVELS = {
    { id = "none", label = "IGUI_KBW_LevelNone" },
    { id = "view", label = "IGUI_KBW_LevelView" },
    { id = "build", label = "IGUI_KBW_LevelBuild" },
    { id = "contribute", label = "IGUI_KBW_LevelContribute" }
}

local function displayName(definition)
    return I18n.definitionName(definition)
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

local function itemDisplayName(fullType)
    if type(fullType) == "string" and string.find(fullType, ".", 1, true) and getItemNameFromFullType then
        return getItemNameFromFullType(fullType)
    end
    return tostring(fullType or "?")
end

local function totalDisplayLabel(key, value, kind)
    local label = value and (value.label or value.name) or nil
    if kind == "skill" then return I18n.skill(value and value.name or key) end
    key = tostring(key or label or "?")
    if string.sub(key, 1, 1) == "#" then return tagDisplayName(string.sub(key, 2)) end
    if label and label ~= key and label ~= "" then return tostring(label) end
    return itemDisplayName(key)
end

local function say(player, text, bad)
    if not HaloTextHelper then return end
    if bad and HaloTextHelper then
        KBWB41.halo(player, text, true)
    elseif HaloTextHelper then
        KBWB41.halo(player, text, false)
    end
end

local function makeButton(owner, x, y, w, h, title, callback, selected)
    local button = ISButton:new(x, y, w, h, title, owner, callback)
    button:initialise()
    Theme.applyButton(button, selected == true)
    button.borderColor = Theme.color(selected and Theme.accent or Theme.border)
    button.backgroundColorMouseOver = Theme.color(Theme.selectedSoft)
    Theme.lockButtonColors(button)
    owner:addChild(button)
    return button
end

local function setOptionalTooltip(control, text)
    if control and control.setTooltip then control:setTooltip(text) end
    if control and control.setMouseOverText then control:setMouseOverText(text) end
end

local function drawSection(panel, x, y, w, h)
    panel:drawRect(x, y, w, h, 0.16, Theme.surface.r, Theme.surface.g, Theme.surface.b)
    panel:drawRectBorder(x, y, w, h, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g, Theme.borderSoft.b)
end

local function wrapLines(text, maxWidth)
    text = tostring(text or "")
    local tm = getTextManager()
    if maxWidth < 20 or tm:MeasureStringX(UIFont.Small, text) <= maxWidth then return { text } end
    local lines, current = {}, ""
    for word in string.gmatch(text, "%S+") do
        local candidate = current == "" and word or (current .. " " .. word)
        if current ~= "" and tm:MeasureStringX(UIFont.Small, candidate) > maxWidth then
            lines[#lines + 1] = current
            current = word
        else
            current = candidate
        end
    end
    if current ~= "" then lines[#lines + 1] = current end
    if #lines == 0 then lines[1] = "" end
    return lines
end

local function setItemHeight(list, item, height)
    if not item then return end
    list:setScrollHeight(list:getScrollHeight() - (item.height or 0) + height)
    item.height = height
end

local function drawWrapped(list, lines, x, y, color, font)
    for lineIndex = 1, #lines do
        list:drawText(lines[lineIndex], x, y, color.r, color.g, color.b, 1, font or UIFont.Small)
        y = y + FONT_HGT_SMALL
    end
    return y
end

local function applyCombo(combo)
    combo.background = true
    combo.backgroundColor = { r = Theme.surface.r, g = Theme.surface.g, b = Theme.surface.b, a = 0.96 }
    combo.backgroundColorMouseOver = {
        r = Theme.surfaceRaised.r,
        g = Theme.surfaceRaised.g,
        b = Theme.surfaceRaised.b,
        a = 0.98
    }
    combo.borderColor = { r = Theme.borderSoft.r, g = Theme.borderSoft.g, b = Theme.borderSoft.b, a = 0.95 }
    combo.textColor = Theme.text
end

local function uiData(player)
    local root = player:getModData()
    root.KBW_UI = root.KBW_UI or { favorites = {}, recent = {}, compact = false }
    root.KBW_UI.favorites = root.KBW_UI.favorites or {}
    root.KBW_UI.recent = root.KBW_UI.recent or {}
    return root.KBW_UI
end

local function matchesInventoryBar(element, panel)
    if not element or not panel then return false end
    return element == panel or (panel.javaObject ~= nil and element == panel.javaObject)
end

local function isInventoryBar(element)
    for playerIndex = 0, 3 do
        if getPlayerInventory and matchesInventoryBar(element, getPlayerInventory(playerIndex)) then return true end
        if getPlayerLoot and matchesInventoryBar(element, getPlayerLoot(playerIndex)) then return true end
    end
    return false
end

local function captureInventoryBars()
    local states = {}
    local function capture(panel)
        if not panel then return end
        states[#states + 1] = {
            panel = panel,
            visible = panel:isVisible(),
            collapsed = panel.isCollapsed == true,
            pinned = panel.pin == true
        }
    end
    for playerIndex = 0, 3 do
        if getPlayerInventory then capture(getPlayerInventory(playerIndex)) end
        if getPlayerLoot then capture(getPlayerLoot(playerIndex)) end
    end
    return states
end

local function holdInventoryBars(states)
    states = states or {}
    for stateIndex = 1, #states do
        local state = states[stateIndex]
        local panel = state.panel
        if panel and state.visible then
            panel:setVisible(true)
            if not state.collapsed then
                if panel.setPinned then
                    panel:setPinned()
                else
                    panel.pin = true
                end
                panel.isCollapsed = false
                panel.collapseCounter = 0
                if panel.clearMaxDrawHeight then panel:clearMaxDrawHeight() end
            end
            panel:bringToTop()
        end
    end
end

local function restoreInventoryBars(states)
    states = states or {}
    for stateIndex = 1, #states do
        local state = states[stateIndex]
        local panel = state.panel
        if panel then
            panel:setVisible(state.visible == true)
            panel.isCollapsed = state.collapsed == true
            panel.collapseCounter = 0
            if state.pinned then
                if panel.setPinned then panel:setPinned() else panel.pin = true end
            else
                if panel.collapse then panel:collapse() else panel.pin = false end
                panel.pin = false
                if panel.collapseButton then panel.collapseButton:setVisible(false) end
                if panel.pinButton then
                    panel.pinButton:setVisible(true)
                    panel.pinButton:bringToTop()
                end
            end
            panel.isCollapsed = state.collapsed == true
            if state.collapsed then
                if panel.setMaxDrawHeight and panel.titleBarHeight then
                    panel:setMaxDrawHeight(panel:titleBarHeight())
                end
            elseif panel.clearMaxDrawHeight then
                panel:clearMaxDrawHeight()
            end
            if state.visible then panel:bringToTop() end
        end
    end
end

local function hideBaseUI(keepInventoryBars)
    local hidden = {}
    local ui = UIManager.getUI()
    for uiIndex = 0, ui:size() - 1 do
        local element = ui:get(uiIndex)
        if element and element:isVisible() and (keepInventoryBars ~= true or not isInventoryBar(element)) then
            hidden[#hidden + 1] = element:toString()
            element:setVisible(false)
        end
    end
    return hidden
end

local function restoreBaseUI(hidden)
    local ui = UIManager.getUI()
    hidden = hidden or {}
    for hiddenIndex = 1, #hidden do
        local key = hidden[hiddenIndex]
        for uiIndex = 0, ui:size() - 1 do
            local element = ui:get(uiIndex)
            if element and element:toString() == key then
                element:setVisible(true)
                break
            end
        end
    end
end

local function mapToSortedList(map, kind)
    local list = {}
    for key, value in pairs(map or {}) do
        local row = {
            kind = kind,
            key = key,
            label = totalDisplayLabel(key, value, kind),
            rawLabel = tostring((value and value.label) or (value and value.name) or key),
            source = value
        }
        if value and value.amount then row.amount = value.amount end
        if value and value.needed then row.amount = value.needed end
        list[#list + 1] = row
    end
    table.sort(list, function (a, b) return tostring(a.label) < tostring(b.label) end)
    return list
end

local function levelLabel(level)
    level = tostring(level or "none")
    for levelIndex = 1, #GRANT_LEVELS do
        if GRANT_LEVELS[levelIndex].id == level then
            return getText(GRANT_LEVELS[levelIndex].label)
        end
    end
    if level == "private" then return getText("IGUI_KBW_LevelNone") end
    return tostring(level)
end

local function scopeShortLabel(scope)
    if scope == "view" then return getText("IGUI_KBW_AllCanViewShort") end
    if scope == "build" then return getText("IGUI_KBW_AllCanBuildShort") end
    if scope == "contribute" then return getText("IGUI_KBW_AllCanContributeShort") end
    return getText("IGUI_KBW_PrivateShort")
end

local function currentFaction(player)
    if not player or not Faction or not Faction.getPlayerFaction then return nil end
    return Faction.getPlayerFaction(player)
end

local function factionName(faction)
    if faction and faction.getName then return tostring(faction:getName()) end
    return nil
end

local function currentFactionName(player)
    return factionName(currentFaction(player))
end

local function blueprintAccessSummary(player, blueprint)
    if not blueprint then return getText("IGUI_KBW_NoBlueprintSelected") end
    local access = blueprint.access or {}
    local playerCount = 0
    for _ in pairs(access.players or {}) do
        playerCount = playerCount + 1
    end
    local factionCount = 0
    for _ in pairs(access.factions or {}) do
        factionCount = factionCount + 1
    end
    local faction = currentFactionName(player)
    local factionAccess = faction and access.factions and access.factions[faction] or nil
    if factionAccess then
        return string.format(
            "%s - faction %s - %d players", scopeShortLabel(access.scope), levelLabel(factionAccess), playerCount
        )
    end
    return string.format("%s - %d players - %d factions", scopeShortLabel(access.scope), playerCount, factionCount)
end

KBWPlanningCatalogPanel = ISPanel:derive("KBWPlanningCatalogPanel")

function KBWPlanningCatalogPanel:layoutSelectors()
    local comboH = 26
    local labelGap = 3
    local rowGap = 8
    local buttonH = math.max(30, FONT_HGT_SMALL + 14)
    local headerBlock = FONT_HGT_SMALL + 4
    local nameBlock = FONT_HGT_SMALL + 8
    local rowBlock = FONT_HGT_SMALL + labelGap + comboH
    local contentH = 10 + headerBlock + nameBlock + rowBlock * 3 + rowGap * 2 + 12
    self.placePlanH = buttonH
    self.placePlanY = self.height - buttonH - 10
    self.selectorPanelH = contentH
    self.selectorPanelY = math.max(128, self.placePlanY - 6 - contentH)
    self.selectorHeaderY = self.selectorPanelY + 10
    self.selectedNameY = self.selectorHeaderY + headerBlock
    self.stageLabelY = self.selectedNameY + nameBlock
    self.stageComboY = self.stageLabelY + FONT_HGT_SMALL + labelGap
    self.variantLabelY = self.stageComboY + comboH + rowGap
    self.variantComboY = self.variantLabelY + FONT_HGT_SMALL + labelGap
    self.finishLabelY = self.variantComboY + comboH + rowGap
    self.finishComboY = self.finishLabelY + FONT_HGT_SMALL + labelGap
    self.selectorComboH = comboH
    self.topTitleY = 10
    self.categoryY = self.topTitleY + FONT_HGT_SMALL + 10
    self.searchY = self.categoryY + comboH + 8
    self.showAllY = self.searchY + 34
    self.gridY = self.showAllY + 28
end

function KBWPlanningCatalogPanel:new(owner, player, x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.owner = owner
    o.player = player
    o.background = true
    o.backgroundColor = Theme.backdrop
    o.borderColor = Theme.border
    return o
end

function KBWPlanningCatalogPanel:createChildren()
    ISPanel.createChildren(self)
    self:layoutSelectors()
    self.categoryFilter = ISComboBox:new(10, self.categoryY, self.width - 20, 26, self, self.onCategoryChanged)
    self.categoryFilter:initialise()
    applyCombo(self.categoryFilter)
    self:addChild(self.categoryFilter)

    self.search = ISTextEntryBox:new("", 10, self.searchY, self.width - 20, 28)
    self.search:initialise()
    self.search:instantiate()
    self.search.target = self
    if self.search.setClearButton then self.search:setClearButton(true) end
    if self.search.javaObject and self.search.javaObject.setCentreVertically then
        KBWB41.call(self.search.javaObject, "setCentreVertically", true)
    end
    if self.search.setPlaceholderText then
        KBWB41.call(self.search, "setPlaceholderText", getText("IGUI_KBW_SearchPlaceholder"))
    end
    self.search.onTextChange = function (box)
        if box and box.target then box.target.searchDirtyAt = getTimestampMs() end
    end
    self:addChild(self.search)

    local showAllLabel = getText("IGUI_CraftingUI_ShowAllVersion")
    local showAllWidth = 28 + getTextManager():MeasureStringX(UIFont.Small, showAllLabel)
    self.showAllTickBox = ISTickBox:new(
        10, self.showAllY, showAllWidth, 24, "", self, self.onShowAllVersionsChanged
    )
    self.showAllTickBox:initialise()
    self.showAllTickBox:addOption(showAllLabel)
    self.showAllTickBox.selected[1] = CatalogVisibility.shouldShowAll(self.player)
    self:addChild(self.showAllTickBox)
    setOptionalTooltip(self.showAllTickBox, getText("Tooltip_KBW_ShowAllVersions"))

    self.stageCombo = ISComboBox:new(
        18, self.stageComboY, self.width - 36, self.selectorComboH, self, self.onStageChanged
    )
    self.stageCombo:initialise()
    applyCombo(self.stageCombo)
    self:addChild(self.stageCombo)
    setOptionalTooltip(
        self.stageCombo, getText("Tooltip_KBW_PlanningStage")
    )

    self.variantCombo = ISComboBox:new(
        18, self.variantComboY, math.floor((self.width - 44) / 2), self.selectorComboH, self,
        self.onPlanVariantChanged
    )
    self.variantCombo:initialise()
    applyCombo(self.variantCombo)
    self:addChild(self.variantCombo)
    setOptionalTooltip(
        self.variantCombo, getText("Tooltip_KBW_PlanningVariant")
    )

    self.materialCombo = ISComboBox:new(
        26 + math.floor((self.width - 44) / 2), self.variantComboY, math.floor((self.width - 44) / 2),
        self.selectorComboH, self, self.onPlanVariantChanged
    )
    self.materialCombo:initialise()
    applyCombo(self.materialCombo)
    self:addChild(self.materialCombo)
    setOptionalTooltip(
        self.materialCombo,
        getText("Tooltip_KBW_PlanningMaterial")
    )

    self.finishCombo = ISComboBox:new(
        18, self.finishComboY, self.width - 36, self.selectorComboH, self, self.onVariantMaterialChanged
    )
    self.finishCombo:initialise()
    applyCombo(self.finishCombo)
    self:addChild(self.finishCombo)
    setOptionalTooltip(
        self.finishCombo, getText("Tooltip_KBW_PlanningFinish")
    )

    self.catalogGrid = BuildCardGrid:new(
        10, self.gridY, self.width - 20, math.max(80, self.selectorPanelY - self.gridY - 8), self.player, self.owner,
        self.owner.onCatalogSelected, self.owner.onCatalogActivated
    )
    self.catalogGrid:initialise()
    self.catalogGrid:setViewMode("list")
    self:addChild(self.catalogGrid)

    self.placePlanButton = makeButton(
        self, 10, self.placePlanY, self.width - 20, self.placePlanH,
        getText("IGUI_KBW_PlanSelectedBuildable"), self.onPlanSelected
    )

    self:refreshCategories()
    self:refreshCatalog()
    self:onResize()
end

function KBWPlanningCatalogPanel:onResize()
    if ISPanel.onResize then ISPanel.onResize(self) end
    self:layoutSelectors()
    local width = self.width - 20
    if self.categoryFilter then
        self.categoryFilter:setY(self.categoryY)
        self.categoryFilter:setWidth(width)
    end
    if self.search then
        self.search:setY(self.searchY)
        self.search:setWidth(width)
    end
    if self.showAllTickBox then
        self.showAllTickBox:setX(10)
        self.showAllTickBox:setY(self.showAllY)
    end
    local innerWidth = self.width - 36
    local halfWidth = math.floor((innerWidth - 8) / 2)
    if self.stageCombo then
        self.stageCombo:setX(18)
        self.stageCombo:setY(self.stageComboY)
        self.stageCombo:setWidth(innerWidth)
    end
    if self.variantCombo then
        self.variantCombo:setX(18)
        self.variantCombo:setY(self.variantComboY)
        self.variantCombo:setWidth(halfWidth)
    end
    if self.materialCombo then
        self.materialCombo:setX(26 + halfWidth)
        self.materialCombo:setY(self.variantComboY)
        self.materialCombo:setWidth(halfWidth)
    end
    if self.finishCombo then
        self.finishCombo:setX(18)
        self.finishCombo:setY(self.finishComboY)
        self.finishCombo:setWidth(innerWidth)
    end
    if self.catalogGrid then
        self.catalogGrid:setY(self.gridY)
        self.catalogGrid:setWidth(width)
        self.catalogGrid:setHeight(math.max(80, self.selectorPanelY - self.gridY - 8))
        self.catalogGrid:onResize()
    end
    if self.placePlanButton then
        self.placePlanButton:setY(self.placePlanY)
        self.placePlanButton:setWidth(width)
    end
end

function KBWPlanningCatalogPanel:catalogSource()
    return self.owner:catalogSource()
end

function KBWPlanningCatalogPanel:update()
    if ISPanel.update then ISPanel.update(self) end
    CatalogIndex.pumpVisibility(6)
    if self.lastVisibilityGeneration == nil then
        self.lastVisibilityGeneration = CatalogIndex.visibilityGeneration
    elseif self.lastVisibilityGeneration ~= CatalogIndex.visibilityGeneration then
        self.lastVisibilityGeneration = CatalogIndex.visibilityGeneration
        self:refreshCatalog()
        return
    end
    if self.searchDirtyAt and getTimestampMs() - self.searchDirtyAt >= 220 then
        self.searchDirtyAt = nil
        self:refreshCatalog()
    end
end

function KBWPlanningCatalogPanel:refreshCategories()
    local selected = self.categoryFilter:getOptionData(self.categoryFilter.selected) or "All"
    self.categoryFilter:clear()
    self.categoryFilter:addOptionWithData(getText("IGUI_KBW_AllCategories"), "All")
    local categories = CatalogIndex.get().categories
    for categoryIndex = 1, #categories do
        local category = categories[categoryIndex]
        self.categoryFilter:addOptionWithData(I18n.category(category), category)
    end
    self.categoryFilter.selected = 1
    for optionIndex = 1, self.categoryFilter:getOptionCount() do
        if self.categoryFilter:getOptionData(optionIndex) == selected then
            self.categoryFilter.selected = optionIndex
        end
    end
end

function KBWPlanningCatalogPanel:refreshCatalog()
    local refreshStart = Profiler.now()
    local query = string.lower(self.search and self.search:getInternalText() or "")
    local category = self.categoryFilter:getOptionData(self.categoryFilter.selected) or "All"
    local index = CatalogIndex.get()
    local shouldShowAll = CatalogVisibility.shouldShowAll(self.player)
    local allCategories = category == "All"
    local hasQuery = query ~= ""
    local source = index.orderByName
    local pinnedIds, pinnedCount = PinnedRecipes.pinnedBuildableIds(self.player)
    local checkPins = pinnedCount > 0
    local pinnedFavorites, pinned, favorites, rest = {}, {}, {}, {}
    for sourceIndex = 1, #source do
        local record = source[sourceIndex]
        local include = allCategories or record.category == category
        if include and not CatalogVisibility.definitionEnabled(record.definition) then include = false end
        if include and not record.alwaysVisible then
            include = CatalogIndex.recordVisible(self.player, record, shouldShowAll)
        end
        if include and hasQuery then
            include = string.find(record.searchTextExtended, query, 1, true) ~= nil
        end
        if include then
            local definition = record.definition
            local isPinned = checkPins and Groups.anyMemberIn(definition, pinnedIds)
            local isFavorite = self.owner:isFavorite(definition) == true
            local bucket = rest
            if isPinned and isFavorite then
                bucket = pinnedFavorites
            elseif isPinned then
                bucket = pinned
            elseif isFavorite then
                bucket = favorites
            end
            bucket[#bucket + 1] = definition
        end
    end
    local filtered = pinnedFavorites
    for entryIndex = 1, #pinned do
        filtered[#filtered + 1] = pinned[entryIndex]
    end
    for entryIndex = 1, #favorites do
        filtered[#filtered + 1] = favorites[entryIndex]
    end
    for entryIndex = 1, #rest do
        filtered[#filtered + 1] = rest[entryIndex]
    end
    self.catalogGrid:setItems(filtered, self.owner.selectedBuildable and self.owner.selectedBuildable.id or nil)
    if self.catalogGrid.selectedIndex > 0 and filtered[self.catalogGrid.selectedIndex] then
        self.owner:onCatalogSelected(filtered[self.catalogGrid.selectedIndex])
    end
    Profiler.add("planning.refreshCatalog", refreshStart)
    Profiler.count("planning.refreshCatalogRuns")
end

function KBWPlanningCatalogPanel:refreshStageChoices(definition)
    if not self.stageCombo then return end
    local previous = self.stageCombo:getOptionData(self.stageCombo.selected)
    self.stageCombo:clear()
    local stages = CatalogVisibility.filteredStages(
        self.player, definition, CatalogVisibility.shouldShowAll(self.player)
    )
    self.visibleStages = stages
    if #stages == 0 then
        self.stageCombo:addOptionWithData(getText("IGUI_KBW_NoStages"), 1)
        self.stageCombo.selected = 1
        self:refreshVariantMaterialChoices(definition, nil)
        return
    end
    for stageIndex = 1, #stages do
        local stage = stages[stageIndex]
        self.stageCombo:addOptionWithData(I18n.optionName(stage, stageIndex), stageIndex)
    end
    self.stageCombo.selected = 1
    if previous then
        for optionIndex = 1, self.stageCombo:getOptionCount() do
            if self.stageCombo:getOptionData(optionIndex) == previous then self.stageCombo.selected = optionIndex end
        end
    end
    self:refreshVariantMaterialChoices(definition, self:selectedStage())
end

function KBWPlanningCatalogPanel:selectedStage()
    local stages = self.visibleStages or {}
    if #stages == 0 then return nil end
    local index = self.stageCombo and self.stageCombo:getOptionData(self.stageCombo.selected) or 1
    index = tonumber(index) or 1
    if index < 1 then index = 1 end
    if index > #stages then index = #stages end
    return stages[index]
end

local function addDefaultOption(combo, label)
    combo:addOptionWithData(label, "")
    combo.selected = 1
end

function KBWPlanningCatalogPanel:refreshOptionCombo(combo, options, defaultLabel, skipDefault)
    if not combo then return end
    local previous = combo:getOptionData(combo.selected)
    combo:clear()
    options = options or {}
    if not skipDefault or #options == 0 then
        addDefaultOption(combo, defaultLabel)
    end
    for optionIndex = 1, #options do
        local option = options[optionIndex]
        combo:addOptionWithData(I18n.optionName(option, optionIndex), option.id or "")
    end
    combo.selected = 1
    if previous then
        for optionIndex = 1, combo:getOptionCount() do
            if combo:getOptionData(optionIndex) == previous then combo.selected = optionIndex end
        end
    end
end

function KBWPlanningCatalogPanel:refreshVariantMaterialChoices(definition, stage)
    local baseDefinition = Groups.resolveDefinition(definition, stage)
    self:refreshOptionCombo(
        self.variantCombo, baseDefinition and baseDefinition.variants or {},
        getText("IGUI_KBW_DefaultVariant")
    )
    self:refreshOptionCombo(
        self.materialCombo, baseDefinition and baseDefinition.materialOptions or {},
        getText("IGUI_KBW_DefaultMaterial"),
        baseDefinition ~= nil and baseDefinition.materialRequired == true
    )
    self:refreshFinishChoices(self:effectiveDefinition(definition, stage), stage)
end

function KBWPlanningCatalogPanel:refreshFinishChoices(baseDefinition, stage)
    if not self.finishCombo then return end
    self.finishCombo:clear()
    self.finishEntries = FinishOptions.entriesFor(baseDefinition, stage)
    if #self.finishEntries == 0 then
        self.finishCombo:addOptionWithData(getText("IGUI_KBW_NoFinish"), 0)
        self.finishCombo.selected = 1
        self.finishCombo:setEnabled(false)
        return
    end
    for entryIndex = 1, #self.finishEntries do
        self.finishCombo:addOptionWithData(I18n.optionName(self.finishEntries[entryIndex], entryIndex), entryIndex)
    end
    self.finishCombo.selected = 1
    self.finishCombo:setEnabled(true)
end

function KBWPlanningCatalogPanel:selectedFinish()
    if not self.finishCombo or not self.finishEntries then return nil end
    local index = tonumber(self.finishCombo:getOptionData(self.finishCombo.selected)) or 0
    local entry = self.finishEntries[index]
    if entry and entry.none then return nil end
    return entry
end

function KBWPlanningCatalogPanel:selectedVariant()
    if not self.variantCombo then return "" end
    return self.variantCombo:getOptionData(self.variantCombo.selected) or ""
end

function KBWPlanningCatalogPanel:selectedMaterial()
    if not self.materialCombo then return "" end
    return self.materialCombo:getOptionData(self.materialCombo.selected) or ""
end

function KBWPlanningCatalogPanel:onStageChanged()
    self:refreshVariantMaterialChoices(self.owner and self.owner.selectedBuildable, self:selectedStage())
end

function KBWPlanningCatalogPanel:effectiveDefinition(definition, stage)
    local baseDefinition = Groups.resolveDefinition(definition, stage)
    if not baseDefinition then return nil end
    local optionSets = { self:selectedVariant(), self:selectedMaterial() }
    local sources = { baseDefinition.variants or {}, baseDefinition.materialOptions or {} }
    local effective = baseDefinition
    for setIndex = 1, #optionSets do
        local wantedId = optionSets[setIndex]
        if wantedId and wantedId ~= "" then
            local options = sources[setIndex]
            for optionIndex = 1, #options do
                if options[optionIndex].id == wantedId then
                    effective = TableUtil.merge(effective, options[optionIndex])
                    break
                end
            end
        end
    end
    return effective
end

function KBWPlanningCatalogPanel:onVariantMaterialChanged()
end

function KBWPlanningCatalogPanel:onPlanVariantChanged()
    local definition = self.owner and self.owner.selectedBuildable
    if not definition then return end
    local stage = self:selectedStage()
    self:refreshFinishChoices(self:effectiveDefinition(definition, stage), stage)
end

function KBWPlanningCatalogPanel:onCategoryChanged()
    self:refreshCatalog()
end

function KBWPlanningCatalogPanel:onShowAllVersionsChanged(clickedOption, enabled)
    CatalogVisibility.setShowAll(self.player, enabled == true)
    self.visibleStages = nil
    self:refreshCatalog()
    if self.owner and self.owner.selectedBuildable then
        self:refreshStageChoices(self.owner.selectedBuildable)
    end
end

function KBWPlanningCatalogPanel:onPlanSelected()
    self.owner:onPlanSelected()
end

function KBWPlanningCatalogPanel:prerender()
    ISPanel.prerender(self)
    if not self.selectorPanelY then self:layoutSelectors() end
    self:drawText(
        getText("IGUI_KBW_PlanningCatalog"), 10, self.topTitleY, Theme.accent.r, Theme.accent.g,
        Theme.accent.b, 1, UIFont.Small
    )
    self:drawRect(
        10, self.selectorPanelY, self.width - 20, self.selectorPanelH, Theme.surface.a, Theme.surface.r, Theme.surface.g,
        Theme.surface.b
    )
    self:drawRectBorder(
        10, self.selectorPanelY, self.width - 20, self.selectorPanelH, Theme.border.a, Theme.border.r, Theme.border.g,
        Theme.border.b
    )
    self:drawText(
        getText("IGUI_KBW_PlanningSelection"), 18, self.selectorHeaderY, Theme.accent.r,
        Theme.accent.g, Theme.accent.b, 1, UIFont.Small
    )
    local name = getText("IGUI_KBW_NoBuildableSelected")
    if self.owner and self.owner.selectedBuildable then name = displayName(self.owner.selectedBuildable) end
    self:drawText(name, 18, self.selectedNameY, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    self:drawText(
        getText("IGUI_KBW_Stage"), 18, self.stageLabelY, Theme.textMuted.r, Theme.textMuted.g,
        Theme.textMuted.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_Variant"), 18, self.variantLabelY, Theme.textMuted.r, Theme.textMuted.g,
        Theme.textMuted.b, 1, UIFont.Small
    )
    local materialX = self.materialCombo and self.materialCombo.x or (26 + math.floor((self.width - 44) / 2))
    self:drawText(
        getText("IGUI_KBW_MaterialSet"), materialX, self.variantLabelY, Theme.textMuted.r,
        Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_Finish"), 18, self.finishLabelY, Theme.textMuted.r, Theme.textMuted.g,
        Theme.textMuted.b, 1, UIFont.Small
    )
end

function KBWPlanningMode:new(player, hiddenUI, inventoryBars)
    local playerNum = player:getPlayerNum()
    local screenLeft = getPlayerScreenLeft(playerNum)
    local screenTop = getPlayerScreenTop(playerNum)
    local screenW = getPlayerScreenWidth(playerNum)
    local screenH = getPlayerScreenHeight(playerNum)
    local catalogW = math.min(410, math.max(360, math.floor(screenW * 0.28)))
    local maxEditorW = math.max(460, screenW - catalogW - 48)
    local preferredEditorW = math.max(500, 56 + getTextManager():getFontHeight(UIFont.Small) * 24)
    local width = math.min(preferredEditorW, maxEditorW)
    local height = math.min(screenH - 48, math.max(760, screenH - 72))
    local x = screenLeft + 12
    local y = screenTop + 36
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.hiddenUI = hiddenUI or {}
    o.inventoryBars = inventoryBars or {}
    o.screenLeft = screenLeft
    o.screenTop = screenTop
    o.screenW = screenW
    o.screenH = screenH
    o.background = true
    o.backgroundColor = Theme.backdrop
    o.borderColor = Theme.border
    o.roomColorIndex = 1
    o.selectedBuildable = nil
    o.opacityIndex = 2
    o.catalogWidth = catalogW
    return o
end

function KBWPlanningMode:createChildren()
    ISPanel.createChildren(self)
    self:setWantKeyEvents(true)
    local pad = 14
    local gap = 8
    local buttonH = math.max(28, FONT_HGT_SMALL + 12)
    local headerH = FONT_HGT_SMALL + 10
    local bottomButtonH = math.max(30, FONT_HGT_SMALL + 14)
    local owner = self
    local bottomY = self.height - pad - bottomButtonH - gap
    self.headerH = headerH
    self.titleY = 10
    self.subHeaderY = self.titleY + FONT_HGT_SMALL + 6
    self.contentY = self.subHeaderY + FONT_HGT_SMALL + 8
    local leftW = math.floor((self.width - pad * 3) * 0.46)
    if leftW < 232 then leftW = 232 end
    local maximumLeftWidth = math.max(252, FONT_HGT_SMALL * 11 + 24)
    if leftW > maximumLeftWidth then leftW = maximumLeftWidth end
    local rightX = pad + leftW + pad
    local rightW = self.width - rightX - pad
    self.leftX = pad
    self.leftW = leftW
    self.rightX = rightX
    self.rightW = rightW
    local yLeft = self.contentY
    local yRight = self.contentY

    self.blueprintList = ISScrollingListBox:new(pad, yLeft, leftW, 120)
    self.blueprintList:initialise()
    self.blueprintList:instantiate()
    self.blueprintList.itemheight = 48
    self.blueprintList.backgroundColor = Theme.surface
    self.blueprintList.borderColor = Theme.borderSoft
    self.blueprintList.doDrawItem = function (list, rowY, item, alt)
        return owner:drawBlueprintRow(list, rowY, item, alt)
    end
    self.blueprintList:setOnMouseDownFunction(
        self,
        function (target)
            target:onBlueprintSelected()
        end
    )
    self:addChild(self.blueprintList)

    yLeft = yLeft + self.blueprintList.height + gap
    local renameLabel = getText("IGUI_KBW_Rename")
    local renameW = math.max(64, getTextManager():MeasureStringX(UIFont.Small, renameLabel) + 20)
    self.blueprintName = ISTextEntryBox:new("", pad, yLeft, leftW - renameW - gap, buttonH)
    self.blueprintName:initialise()
    self.blueprintName:instantiate()
    self:addChild(self.blueprintName)
    self.renameButton = makeButton(
        self, pad + leftW - renameW, yLeft, renameW, buttonH, renameLabel, self.onRenameBlueprint
    )
    setOptionalTooltip(
        self.renameButton,
        getText("Tooltip_KBW_RenameBlueprint")
    )
    yLeft = yLeft + buttonH + gap

    local thirdLeft = math.floor((leftW - gap * 2) / 3)
    local halfLeft = math.floor((leftW - gap) / 2)
    self.newButton = makeButton(
        self, pad, yLeft, thirdLeft, buttonH, getText("IGUI_KBW_NewShort"), self.onNewBlueprint
    )
    self.duplicateButton = makeButton(
        self, pad + thirdLeft + gap, yLeft, thirdLeft, buttonH, getText("IGUI_KBW_Duplicate"),
        self.onDuplicateBlueprint
    )
    self.deleteButton = makeButton(
        self, pad + (thirdLeft + gap) * 2, yLeft, thirdLeft, buttonH, getText("IGUI_KBW_Delete"),
        self.onDeleteBlueprint
    )
    setOptionalTooltip(
        self.newButton, getText("Tooltip_KBW_NewBlueprint")
    )
    setOptionalTooltip(
        self.duplicateButton, getText("Tooltip_KBW_DuplicateBlueprint")
    )
    setOptionalTooltip(self.deleteButton, getText("Tooltip_KBW_DeleteBlueprint"))
    yLeft = yLeft + buttonH + gap
    self.activateButton = makeButton(
        self, pad, yLeft, halfLeft, buttonH, getText("IGUI_KBW_ActivateBlueprint"),
        self.onActivateBlueprint
    )
    self.pinBlueprintButton = makeButton(
        self, pad + halfLeft + gap, yLeft, halfLeft, buttonH, getText("IGUI_KBW_PinBlueprint"),
        self.onPinBlueprint
    )
    setOptionalTooltip(
        self.activateButton,
        getText("Tooltip_KBW_ActivateBlueprint")
    )
    setOptionalTooltip(
        self.pinBlueprintButton,
        getText("Tooltip_KBW_PinBlueprint")
    )
    yLeft = yLeft + buttonH + gap
    local exportLabel = getText("IGUI_KBW_ExportJSON")
    local importLabel = getText("IGUI_KBW_Import")
    local copyJsonLabel = getText("IGUI_KBW_CopyBlueprintJSON")
    local exportRowMinimum = getTextManager():MeasureStringX(UIFont.Small, exportLabel) + 20
        + getTextManager():MeasureStringX(UIFont.Small, importLabel) + 20
        + getTextManager():MeasureStringX(UIFont.Small, copyJsonLabel) + 20
        + gap * 2
    if exportRowMinimum <= leftW then
        self.exportButton = makeButton(
            self, pad, yLeft, thirdLeft, buttonH, exportLabel, self.onExportBlueprint
        )
        self.importButton = makeButton(
            self, pad + thirdLeft + gap, yLeft, thirdLeft, buttonH, importLabel, self.onImportBlueprint
        )
        self.copyJsonButton = makeButton(
            self, pad + (thirdLeft + gap) * 2, yLeft, thirdLeft, buttonH, copyJsonLabel,
            self.onCopyBlueprintJSON
        )
        yLeft = yLeft + buttonH + gap
    else
        self.exportButton = makeButton(
            self, pad, yLeft, halfLeft, buttonH, exportLabel, self.onExportBlueprint
        )
        self.importButton = makeButton(
            self, pad + halfLeft + gap, yLeft, halfLeft, buttonH, importLabel, self.onImportBlueprint
        )
        self.copyJsonButton = makeButton(
            self, pad, yLeft + buttonH + gap, leftW, buttonH, copyJsonLabel, self.onCopyBlueprintJSON
        )
        yLeft = yLeft + (buttonH + gap) * 2
    end
    setOptionalTooltip(
        self.exportButton,
        getText("Tooltip_KBW_ExportBlueprint")
    )
    setOptionalTooltip(
        self.importButton,
        getText("Tooltip_KBW_ImportBlueprint")
    )
    self.levelDownButton = makeButton(self, pad, yLeft, 40, buttonH, "-Z", self.onLevelDown)
    self.levelUpButton = makeButton(self, pad + 46, yLeft, 40, buttonH, "+Z", self.onLevelUp)
    setOptionalTooltip(self.levelDownButton, getText("Tooltip_KBW_LevelDown"))
    setOptionalTooltip(self.levelUpButton, getText("Tooltip_KBW_LevelUp"))
    self.levelLabelX = pad + 96
    local levelLabelW = getTextManager():MeasureStringX(UIFont.Small, "Z -88") + 12
    local useLevelX = self.levelLabelX + levelLabelW
    self.usePlayerLevelButton = makeButton(
        self, useLevelX, yLeft, leftW - (useLevelX - pad), buttonH, getText("IGUI_KBW_UsePlayerLevel"),
        self.onUsePlayerLevel
    )
    yLeft = yLeft + buttonH + gap

    self.accessHeaderY = yLeft
    yLeft = yLeft + headerH
    self.manageAccessButton = makeButton(
        self, pad, yLeft, leftW, buttonH, getText("IGUI_KBW_ManageAccess"), self.onManageAccess
    )
    setOptionalTooltip(
        self.manageAccessButton,
        getText("Tooltip_KBW_ManageAccess")
    )
    yLeft = yLeft + buttonH + gap + headerH

    self.totalList = ISScrollingListBox:new(pad, yLeft, leftW, math.max(96, bottomY - yLeft))
    self.totalList:initialise()
    self.totalList:instantiate()
    self.totalList.itemheight = 28
    self.totalList.backgroundColor = Theme.surface
    self.totalList.borderColor = Theme.borderSoft
    self.totalList.doDrawItem = function (list, rowY, item, alt) return owner:drawTotalRow(list, rowY, item, alt) end
    self:addChild(self.totalList)

    local hintSize = buttonH - 4
    self.roomName = ISTextEntryBox:new("", rightX, yRight, rightW - hintSize - gap, buttonH)
    self.roomName:initialise()
    self.roomName:instantiate()
    self:addChild(self.roomName)
    self.colorHintX = rightX + rightW - hintSize
    self.colorHintY = yRight + math.floor((buttonH - hintSize) / 2)
    self.colorHintSize = hintSize
    yRight = yRight + buttonH + gap
    self.colorButtons = {}
    local colorStep = 30
    local perRow = math.max(1, math.floor((rightW + gap) / colorStep))
    for colorIndex = 1, #ROOM_COLORS do
        local color = ROOM_COLORS[colorIndex]
        local row = math.floor((colorIndex - 1) / perRow)
        local col = (colorIndex - 1) - row * perRow
        local button = makeButton(
            self, rightX + col * colorStep, yRight + row * colorStep, 24, 24, "",
            function (target)
                target:onPickColor(colorIndex)
            end
        )
        button.backgroundColor = { r = color.r, g = color.g, b = color.b, a = 0.88 }
        button.backgroundColorMouseOver = { r = color.r, g = color.g, b = color.b, a = 1 }
        self.colorButtons[#self.colorButtons + 1] = button
    end
    yRight = yRight + (math.floor((#ROOM_COLORS - 1) / perRow) + 1) * colorStep + gap
    local actionHalf = math.floor((rightW - gap) / 2)
    self.drawRoomButton = makeButton(
        self, rightX, yRight, actionHalf, buttonH, getText("IGUI_KBW_DrawRoom"), self.onDrawRoom
    )
    self.eraseRoomButton = makeButton(
        self, rightX + actionHalf + gap, yRight, actionHalf, buttonH, getText("IGUI_KBW_EraseRoomTool"),
        self.onEraseRoomTool
    )
    setOptionalTooltip(self.drawRoomButton, getText("Tooltip_KBW_DrawRoom"))
    setOptionalTooltip(
        self.eraseRoomButton, getText("Tooltip_KBW_EraseRoom")
    )
    yRight = yRight + buttonH + gap
    self.eraseButton = makeButton(
        self, rightX, yRight, actionHalf, buttonH, getText("IGUI_KBW_EraseTool"), self.onEraseTool
    )
    self.buildToolButton = makeButton(
        self, rightX + actionHalf + gap, yRight, actionHalf, buttonH, getText("IGUI_KBW_BuildTool"),
        self.onBuildTool
    )
    setOptionalTooltip(self.eraseButton, getText("Tooltip_KBW_ErasePlan"))
    setOptionalTooltip(
        self.buildToolButton, getText("Tooltip_KBW_BuildTool")
    )
    yRight = yRight + buttonH + gap
    self.gatherAreaButton = makeButton(
        self, rightX, yRight, actionHalf, buttonH, getText("IGUI_KBW_GatherArea"), self.onGatherArea
    )
    self.buildAllButton = makeButton(
        self, rightX + actionHalf + gap, yRight, actionHalf, buttonH, getText("IGUI_KBW_BuildAll"),
        self.onBuildAll
    )
    setOptionalTooltip(
        self.gatherAreaButton,
        getText("Tooltip_KBW_GatherArea")
    )
    setOptionalTooltip(
        self.buildAllButton,
        getText("Tooltip_KBW_BuildAll")
    )
    yRight = yRight + buttonH + gap
    self.stopToolButton = makeButton(
        self, rightX, yRight, actionHalf, buttonH, getText("IGUI_KBW_StopTool"), self.onStopTool
    )
    self.stopQueueButton = makeButton(
        self, rightX + actionHalf + gap, yRight, actionHalf, buttonH, getText("IGUI_KBW_StopQueue"),
        self.onStopQueue
    )
    setOptionalTooltip(self.stopToolButton, getText("Tooltip_KBW_StopTool"))
    setOptionalTooltip(
        self.stopQueueButton, getText("Tooltip_KBW_StopQueue")
    )
    yRight = yRight + buttonH + gap
    self.moveBlueprintButton = makeButton(
        self, rightX, yRight, rightW, buttonH, getText("IGUI_KBW_MoveBlueprintTool"),
        self.onMoveBlueprint
    )
    setOptionalTooltip(
        self.moveBlueprintButton,
        getText("Tooltip_KBW_MoveBlueprint")
    )
    yRight = yRight + buttonH + gap

    yRight = yRight + headerH
    self.opacityButtons = {}
    local opacityH = math.max(24, FONT_HGT_SMALL + 8)
    local opacityW = math.floor((rightW - gap * (#OPACITY_VALUES - 1)) / #OPACITY_VALUES)
    for opacityIndex = 1, #OPACITY_VALUES do
        local label = tostring(math.floor(OPACITY_VALUES[opacityIndex] * 100)) .. "%"
        local button = makeButton(
            self, rightX + (opacityIndex - 1) * (opacityW + gap), yRight, opacityW, opacityH, label,
            function (target)
                target:onOpacity(opacityIndex)
            end,
            opacityIndex == self.opacityIndex
        )
        self.opacityButtons[#self.opacityButtons + 1] = button
    end
    yRight = yRight + opacityH + gap + headerH

    self.roomList = ISScrollingListBox:new(rightX, yRight, rightW, 110)
    self.roomList:initialise()
    self.roomList:instantiate()
    self.roomList.itemheight = 36
    self.roomList.backgroundColor = Theme.surface
    self.roomList.borderColor = Theme.borderSoft
    self.roomList.doDrawItem = function (list, rowY, item, alt) return owner:drawRoomRow(list, rowY, item, alt) end
    self.roomList:setOnMouseDownFunction(
        self,
        function (target)
            target:onRoomSelected()
        end
    )
    self:addChild(self.roomList)
    yRight = yRight + self.roomList.height + gap
    local halfRight = math.floor((rightW - gap) / 2)
    local updateRoomLabel = getText("IGUI_KBW_UpdateRoom")
    local deleteRoomLabel = getText("IGUI_KBW_DeleteRoom")
    local roomLabelWidth = math.max(
        getTextManager():MeasureStringX(UIFont.Small, updateRoomLabel),
        getTextManager():MeasureStringX(UIFont.Small, deleteRoomLabel)
    )
    if roomLabelWidth + 12 <= halfRight then
        self.updateRoomButton = makeButton(self, rightX, yRight, halfRight, buttonH, updateRoomLabel, self.onUpdateRoom)
        self.deleteRoomButton = makeButton(
            self, rightX + halfRight + gap, yRight, halfRight, buttonH, deleteRoomLabel, self.onDeleteRoom
        )
        yRight = yRight + buttonH + gap + headerH
    else
        self.updateRoomButton = makeButton(self, rightX, yRight, rightW, buttonH, updateRoomLabel, self.onUpdateRoom)
        self.deleteRoomButton = makeButton(
            self, rightX, yRight + buttonH + gap, rightW, buttonH, deleteRoomLabel, self.onDeleteRoom
        )
        yRight = yRight + (buttonH + gap) * 2 + headerH
    end
    setOptionalTooltip(
        self.updateRoomButton,
        getText("Tooltip_KBW_UpdateRoom")
    )

    self.placementList = ISScrollingListBox:new(rightX, yRight, rightW, math.max(96, bottomY - yRight))
    self.placementList:initialise()
    self.placementList:instantiate()
    self.placementList.itemheight = 42
    self.placementList.backgroundColor = Theme.surface
    self.placementList.borderColor = Theme.borderSoft
    self.placementList.doDrawItem = function (list, rowY, item, alt)
        return owner:drawPlacementRow(list, rowY, item, alt)
    end
    self.placementList:setOnMouseDownFunction(
        self,
        function (target)
            target:onPlacementSelected()
        end
    )
    self:addChild(self.placementList)

    local bottomHalf = math.floor((self.width - pad * 2 - gap) / 2)
    self.buildSelectedButton = makeButton(
        self, pad, self.height - pad - bottomButtonH, bottomHalf, bottomButtonH,
        getText("IGUI_KBW_BuildPlacement"), self.onBuildSelected
    )
    self.exitButton = makeButton(
        self, pad + bottomHalf + gap, self.height - pad - bottomButtonH, bottomHalf, bottomButtonH,
        getText("IGUI_KBW_ExitPlanningMode"), self.onExit
    )

    local catalogW = self.catalogWidth or 390
    local catalogX = self.screenLeft + self.screenW - catalogW - 12
    local minCatalogX = self.x + self.width + 10
    if catalogX < minCatalogX and minCatalogX + catalogW <= self.screenLeft + self.screenW - 12 then
        catalogX = minCatalogX
    end
    self.catalogPanel = KBWPlanningCatalogPanel:new(self, self.player, catalogX, self.y, catalogW, self.height)
    self.catalogPanel:initialise()
    self.catalogPanel:addToUIManager()
    self.catalogPanel:bringToTop()

    self:refreshBlueprints()
    self:onPickColor(1)
    self:onOpacity(self.opacityIndex)
end

function KBWPlanningMode:catalogSource()
    return CatalogIndex.get().list
end

function KBWPlanningMode:isKeyConsumed(key)
    if Keyboard and key == Keyboard.KEY_ESCAPE then return true end
    return false
end

function KBWPlanningMode:onKeyRelease(key)
    if Keyboard and key == Keyboard.KEY_ESCAPE then self:close() end
end

function KBWPlanningMode:selectedBlueprint()
    local item = self.blueprintList.items[self.blueprintList.selected]
    return item and item.item or nil
end

function KBWPlanningMode:selectedPlacement()
    local item = self.placementList.items[self.placementList.selected]
    return item and item.item or nil
end

function KBWPlanningMode:selectedRoom()
    local item = self.roomList and self.roomList.items[self.roomList.selected]
    return item and item.item or nil
end

function KBWPlanningMode:selectedOrActiveBlueprint()
    local blueprint = self:selectedBlueprint() or Blueprints.active(self.player)
    if not blueprint then
        blueprint = Blueprints.create(self.player, nil, math.floor(self.player:getZ()))
        self:refreshBlueprints()
    end
    return blueprint
end

function KBWPlanningMode:drawBlueprintRow(list, y, item, alt)
    local blueprint = item.item
    local selected = list.selected == item.index
    local fill = selected and Theme.selected or (alt and Theme.surfaceRaised or Theme.surface)
    list:drawRect(0, y, list.width, item.height - 2, fill.a, fill.r, fill.g, fill.b)
    list:drawRectBorder(
        0, y, list.width, item.height - 2, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g,
        Theme.borderSoft.b
    )
    local nameLines = item.nameLines or { tostring(blueprint.name or blueprint.id) }
    local textY = drawWrapped(list, nameLines, 10, y + 5, Theme.text)
    local rooms = blueprint.rooms or {}
    local placements = blueprint.placements or {}
    list:drawText(
        getText("IGUI_KBW_BlueprintSummary", tostring(blueprint.level or 0),
            tostring(#rooms), tostring(#placements)
        ), 10, textY + 2, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
    return y + item.height
end

function KBWPlanningMode:drawPlacementRow(list, y, item, alt)
    local placement = item.item
    local selected = list.selected == item.index
    local fill = selected and Theme.selected or (alt and Theme.surfaceRaised or Theme.surface)
    list:drawRect(0, y, list.width, item.height - 2, fill.a, fill.r, fill.g, fill.b)
    local nameLines = item.nameLines or { displayName(Registry:get(placement.buildableId)) }
    local textY = drawWrapped(list, nameLines, 10, y + 4, Theme.text)
    local details = string.format(
        "%s  %d,%d z%d", tostring(placement.stageId or ""), placement.x or 0, placement.y or 0, placement.z or 0
    )
    list:drawText(details, 10, textY + 2, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small)
    return y + item.height
end

function KBWPlanningMode:drawRoomRow(list, y, item, alt)
    local room = item.item
    local selected = list.selected == item.index
    local fill = selected and Theme.selected or (alt and Theme.surfaceRaised or Theme.surface)
    local color = room.color or ROOM_COLORS[1]
    list:drawRect(0, y, list.width, item.height - 2, fill.a, fill.r, fill.g, fill.b)
    list:drawRect(8, y + 8, 14, 14, color.a or 0.8, color.r or 0.25, color.g or 0.65, color.b or 0.95)
    list:drawRectBorder(8, y + 8, 14, 14, Theme.border.a, Theme.border.r, Theme.border.g, Theme.border.b)
    local nameLines = item.nameLines or { tostring(room.name or room.type or "Room") }
    local textY = drawWrapped(list, nameLines, 30, y + 3, Theme.text)
    local details = string.format(
        "%dx%d  %d,%d z%d", room.w or room.width or 1, room.h or room.height or 1, room.x or 0, room.y or 0, room.z or 0
    )
    list:drawText(details, 30, textY + 2, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small)
    return y + item.height
end

function KBWPlanningMode:drawTotalRow(list, y, item, alt)
    local row = item.item
    if row.kind == "header" then
        list:drawRect(
            0, y, list.width, item.height - 1, Theme.surfaceRaised.a, Theme.surfaceRaised.r, Theme.surfaceRaised.g,
            Theme.surfaceRaised.b
        )
        drawWrapped(list, item.nameLines or { row.label }, 8, y + 3, Theme.accent)
    else
        local fill = alt and Theme.surfaceRaised or Theme.surface
        list:drawRect(0, y, list.width, item.height - 1, fill.a, fill.r, fill.g, fill.b)
        local suffix = row.amount and ("  x" .. tostring(row.amount)) or ""
        local icon = nil
        local iconColor = { r = 1, g = 1, b = 1, a = 1 }
        local key = tostring(row.key or "")
        if string.sub(key, 1, 1) == "#" then
            icon, iconColor = IconResolver.textureForTag(string.sub(key, 2))
        elseif row.kind == "material" or row.kind == "tool" then
            icon, iconColor = IconResolver.textureForItem(key)
        end
        iconColor = iconColor or { r = 1, g = 1, b = 1, a = 1 }
        local textX = 12
        if icon then
            list:drawTextureScaledAspect(
                icon, 8, y + 3, 20, 20, iconColor.a or 1, iconColor.r or 1, iconColor.g or 1, iconColor.b or 1
            )
            textX = 34
        end
        drawWrapped(list, item.nameLines or { tostring(row.label) .. suffix }, textX, y + 5, Theme.text)
    end
    return y + item.height
end

function KBWPlanningMode:refreshBlueprints()
    local active = Blueprints.active(self.player)
    self.blueprintList:clear()
    local values = Blueprints.list(self.player)
    local selectedIndex = 1
    for blueprintIndex = 1, #values do
        local blueprint = values[blueprintIndex]
        local item = self.blueprintList:addItem(blueprint.name or blueprint.id, blueprint)
        if item then
            item.nameLines = wrapLines(blueprint.name or blueprint.id, self.blueprintList.width - 20)
            setItemHeight(self.blueprintList, item, #item.nameLines * FONT_HGT_SMALL + FONT_HGT_SMALL + 16)
        end
        if active and active.id == blueprint.id then selectedIndex = blueprintIndex end
    end
    if #values > 0 then self.blueprintList.selected = selectedIndex end
    local selected = self:selectedBlueprint()
    if self.blueprintName then
        self.blueprintName:setText(selected and tostring(selected.name or selected.id) or "")
    end
    self:refreshRooms()
    self:refreshPlacements()
    self:refreshTotals()
    self:updateBlueprintPinButton()
    self:updateActivateButton()
    self:updateAccessControls()
    if self.accessWindow and selected then
        self.accessWindow.blueprintId = selected.id
        self.accessWindow:syncFromBlueprint()
    end
end

function KBWPlanningMode:updateAccessControls()
    local blueprint = self:selectedBlueprint()
    local isOwner = blueprint ~= nil and Blueprints.isOwner(self.player, blueprint)
    local canContribute = blueprint ~= nil and Blueprints.canContribute(self.player, blueprint)
    Theme.setButtonEnabled(self.manageAccessButton, blueprint ~= nil)
    local ownerButtons = { self.renameButton, self.deleteButton }
    for buttonIndex = 1, #ownerButtons do
        Theme.setButtonEnabled(ownerButtons[buttonIndex], isOwner == true)
    end
    local editButtons = {
        self.levelDownButton, self.levelUpButton, self.usePlayerLevelButton, self.drawRoomButton, self.eraseRoomButton,
        self.eraseButton, self.gatherAreaButton, self.moveBlueprintButton, self.updateRoomButton, self.deleteRoomButton
    }
    for buttonIndex = 1, #editButtons do
        Theme.setButtonEnabled(editButtons[buttonIndex], canContribute == true)
    end
    local canBuild = blueprint ~= nil and Blueprints.canBuild(self.player, blueprint)
    local buildButtons = { self.buildToolButton, self.buildAllButton, self.buildSelectedButton }
    for buttonIndex = 1, #buildButtons do
        Theme.setButtonEnabled(buildButtons[buttonIndex], canBuild == true)
    end
end

function KBWPlanningMode:onManageAccess()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    if self.accessWindow then
        self.accessWindow.blueprintId = blueprint.id
        self.accessWindow:syncFromBlueprint()
        self.accessWindow:setVisible(true)
        self.accessWindow:bringToTop()
        return
    end
    self.accessWindow = KBWBlueprintAccessWindow:new(self, self.player, blueprint)
    self.accessWindow:initialise()
    self.accessWindow:addToUIManager()
    self.accessWindow:bringToTop()
end

function KBWPlanningMode:refreshRooms()
    if not self.roomList then return end
    self.roomList:clear()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local rooms = blueprint.rooms or {}
    for roomIndex = 1, #rooms do
        local room = rooms[roomIndex]
        local item = self.roomList:addItem(tostring(room.name or room.id), room)
        if item then
            item.nameLines = wrapLines(room.name or room.type or "Room", self.roomList.width - 40)
            setItemHeight(self.roomList, item, #item.nameLines * FONT_HGT_SMALL + FONT_HGT_SMALL + 14)
        end
    end
    if #rooms > 0 then self.roomList.selected = 1 end
end

function KBWPlanningMode:refreshPlacements()
    self.placementList:clear()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local placements = blueprint.placements or {}
    for placementIndex = 1, #placements do
        local placement = placements[placementIndex]
        local item = self.placementList:addItem(tostring(placement.id), placement)
        if item then
            item.nameLines = wrapLines(displayName(Registry:get(placement.buildableId)), self.placementList.width - 20)
            setItemHeight(self.placementList, item, #item.nameLines * FONT_HGT_SMALL + FONT_HGT_SMALL + 14)
        end
    end
end

function KBWPlanningMode:refreshTotals()
    self.totalList:clear()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local totals = Blueprints.totals(self.player, blueprint)
    local listWidth = self.totalList.width
    local function addHeader(label)
        local item = self.totalList:addItem(label, { kind = "header", label = label })
        if item then
            item.nameLines = wrapLines(label, listWidth - 16)
            setItemHeight(self.totalList, item, #item.nameLines * FONT_HGT_SMALL + 8)
        end
    end
    local function addRows(rows)
        for rowIndex = 1, #rows do
            local row = rows[rowIndex]
            local item = self.totalList:addItem(row.label, row)
            if item then
                local suffix = row.amount and ("  x" .. tostring(row.amount)) or ""
                item.nameLines = wrapLines(tostring(row.label) .. suffix, listWidth - 46)
                setItemHeight(self.totalList, item, math.max(26, #item.nameLines * FONT_HGT_SMALL + 10))
            end
        end
    end
    local rooms = blueprint.rooms or {}
    addHeader(
        getText("IGUI_KBW_BlueprintTotalsShort", tostring(totals.placements or 0),
            tostring(#rooms)
        )
    )
    addHeader(getText("IGUI_KBW_MaterialsTools"))
    addRows(mapToSortedList(totals.materials, "material"))
    addRows(mapToSortedList(totals.tools, "tool"))
    addHeader(getText("IGUI_KBW_SkillsKnowledge"))
    addRows(mapToSortedList(totals.skills, "skill"))
end

function KBWPlanningMode:onBlueprintSelected()
    local blueprint = self:selectedBlueprint()
    if self.blueprintName then
        self.blueprintName:setText(blueprint and tostring(blueprint.name or blueprint.id) or "")
    end
    self:refreshRooms()
    self:refreshPlacements()
    self:refreshTotals()
    self:updateBlueprintPinButton()
    self:updateActivateButton()
    self:updateAccessControls()
end

function KBWPlanningMode:onPlacementSelected()
    local placement = self:selectedPlacement()
    Planner.setHighlight(placement and placement.id or nil)
end

function KBWPlanningMode:onRoomSelected()
    local room = self:selectedRoom()
    if room and self.roomName then self.roomName:setText(tostring(room.name or room.type or "")) end
    if room and room.color then
        for colorIndex = 1, #ROOM_COLORS do
            local color = ROOM_COLORS[colorIndex]
            if math.abs(color.r - (room.color.r or -1)) < 0.01 and math.abs(color.g - (room.color.g or -1)) < 0.01
                and math.abs(color.b - (room.color.b or -1)) < 0.01 then
                self:onPickColor(colorIndex)
                break
            end
        end
    end
    Planner.setHighlightRoom(room and room.id or nil)
end

function KBWPlanningMode:onCatalogSelected(definition)
    self.selectedBuildable = definition
    if self.catalogPanel then self.catalogPanel:refreshStageChoices(definition) end
end

function KBWPlanningMode:onCatalogActivated(definition)
    self.selectedBuildable = definition
    if self.catalogPanel then self.catalogPanel:refreshStageChoices(definition) end
    self:onPlanSelected()
end

function KBWPlanningMode:isFavorite(definition)
    return definition and uiData(self.player).favorites[definition.id] == true
end

function KBWPlanningMode:isPinnedDefinition(definition)
    return PinnedRecipes.hasPinnedDefinition(self.player, definition)
end

function KBWPlanningMode:onGridFavorite(definition)
    if not definition then return end
    local favorites = uiData(self.player).favorites
    favorites[definition.id] = not favorites[definition.id]
    if self.catalogPanel then self.catalogPanel:refreshCatalog() end
end

function KBWPlanningMode:onGridPin(definition)
    if not definition then return end
    PinnedRecipes.toggleDefault(self.player, definition)
    if self.catalogPanel then self.catalogPanel:refreshCatalog() end
end

function KBWPlanningMode:updateBlueprintPinButton()
    if not self.pinBlueprintButton then return end
    local blueprint = self:selectedBlueprint()
    local pinned = blueprint and PinnedRecipes.isBlueprintPinned
        and PinnedRecipes.isBlueprintPinned(self.player, blueprint)
    Theme.applyButton(self.pinBlueprintButton, pinned == true)
    self.pinBlueprintButton:setTitle(
        pinned and getText("IGUI_KBW_UnpinBlueprint") or getText("IGUI_KBW_PinBlueprint")
    )
end

function KBWPlanningMode:onPinBlueprint()
    local blueprint = self:selectedBlueprint()
    if not blueprint or not PinnedRecipes.toggleBlueprint then return end
    PinnedRecipes.toggleBlueprint(self.player, blueprint)
    self:updateBlueprintPinButton()
end

function KBWPlanningMode:onNewBlueprint()
    Blueprints.create(self.player, nil, math.floor(self.player:getZ()))
    self:refreshBlueprints()
end

function KBWPlanningMode:onDuplicateBlueprint()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local copy = Blueprints.duplicate(self.player, blueprint.id)
    if copy then Blueprints.setActive(self.player, copy.id) end
    self:refreshBlueprints()
end

function KBWPlanningMode:onRenameBlueprint()
    local blueprint = self:selectedBlueprint()
    if not blueprint or not self.blueprintName then return end
    local name = self.blueprintName:getInternalText()
    if name and name ~= "" then
        Blueprints.rename(self.player, blueprint.id, name)
        self:refreshBlueprints()
    end
end

function KBWPlanningMode:onDeleteBlueprint()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    Blueprints.delete(self.player, blueprint.id)
    Planner.setHighlight(nil)
    Planner.setHighlightRoom(nil)
    self:refreshBlueprints()
end

function KBWPlanningMode:onActivateBlueprint()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    if Blueprints.isActive(self.player, blueprint.id) then
        Blueprints.setActive(self.player, nil)
    else
        Blueprints.setActive(self.player, blueprint.id)
        GhostRenderer.clearCache()
    end
    self:updateActivateButton()
end

function KBWPlanningMode:updateActivateButton()
    if not self.activateButton then return end
    local blueprint = self:selectedBlueprint()
    local active = blueprint ~= nil and Blueprints.isActive(self.player, blueprint.id)
    Theme.applyButton(self.activateButton, active == true)
    self.activateButton:setTitle(
        active and getText("IGUI_KBW_DeactivateBlueprint")
            or getText("IGUI_KBW_ActivateBlueprint")
    )
end

function KBWPlanningMode:onExportBlueprint()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local path = Blueprints.exportToFile(blueprint)
    say(
        self.player,
        path
            and getText("IGUI_KBW_Exported", tostring(blueprint.name or blueprint.id), path
            )
            or getText("IGUI_KBW_ExportFailed"), path == nil
    )
end

function KBWPlanningMode:onImportBlueprint()
    local owner = self
    KBWBlueprintImportWindow.open(self.player, function (blueprint)
        owner:refreshBlueprints()
        Planner.beginMoveBlueprint(owner.player, blueprint.id)
    end)
end

function KBWPlanningMode:onCopyBlueprintJSON()
    local blueprint = self:selectedBlueprint()
    if not blueprint or not Clipboard then return end
    Clipboard.setClipboard(Blueprints.exportJSON(blueprint))
    say(self.player, getText("IGUI_KBW_BlueprintCopiedJSON"), false)
end

function KBWPlanningMode:onLevelDown()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local level = (tonumber(blueprint.level) or 0) - 1
    Blueprints.setLevel(self.player, blueprint.id, level)
    self:refreshBlueprints()
end

function KBWPlanningMode:onLevelUp()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    local level = (tonumber(blueprint.level) or 0) + 1
    Blueprints.setLevel(self.player, blueprint.id, level)
    self:refreshBlueprints()
end

function KBWPlanningMode:onUsePlayerLevel()
    local blueprint = self:selectedBlueprint()
    if not blueprint then return end
    Blueprints.setLevel(self.player, blueprint.id, math.floor(self.player:getZ()))
    self:refreshBlueprints()
end

function KBWPlanningMode:onPickColor(colorIndex)
    self.roomColorIndex = colorIndex
    for buttonIndex = 1, #self.colorButtons do
        local button = self.colorButtons[buttonIndex]
        button.borderColor = buttonIndex == colorIndex and Theme.accent or Theme.borderSoft
    end
end

function KBWPlanningMode:onUpdateRoom()
    local blueprint = self:selectedBlueprint()
    local room = self:selectedRoom()
    if not blueprint or not room then return end
    local name = self.roomName and self.roomName:getInternalText() or nil
    if not name or name == "" then name = room.name or getText("IGUI_KBW_RoomTypeGeneric") end
    local color = ROOM_COLORS[self.roomColorIndex or 1] or ROOM_COLORS[1]
    Blueprints.updateRoom(self.player, blueprint.id, room.id, {
        name = name,
        color = { r = color.r, g = color.g, b = color.b, a = color.a }
    })
    self:refreshRooms()
    self:refreshTotals()
end

function KBWPlanningMode:onDeleteRoom()
    local blueprint = self:selectedBlueprint()
    local room = self:selectedRoom()
    if not blueprint or not room then return end
    Blueprints.removeRoom(self.player, blueprint.id, room.id)
    Planner.setHighlightRoom(nil)
    self:refreshRooms()
    self:refreshTotals()
end

function KBWPlanningMode:onOpacity(opacityIndex)
    self.opacityIndex = opacityIndex
    local value = OPACITY_VALUES[opacityIndex] or 0.5
    GhostRenderer.setOpacity(value)
    for buttonIndex = 1, #self.opacityButtons do
        Theme.applyButton(self.opacityButtons[buttonIndex], buttonIndex == opacityIndex)
    end
end

function KBWPlanningMode:roomTemplate()
    local color = ROOM_COLORS[self.roomColorIndex or 1] or ROOM_COLORS[1]
    local name = self.roomName:getInternalText()
    if name == nil or name == "" then name = getText("IGUI_KBW_RoomTypeGeneric") end
    return { name = name, type = "room", color = { r = color.r, g = color.g, b = color.b, a = color.a } }
end

function KBWPlanningMode:onDrawRoom()
    local blueprint = self:selectedOrActiveBlueprint()
    if not blueprint then return end
    Blueprints.setActive(self.player, blueprint.id)
    local owner = self
    Planner.beginRoom(self.player, blueprint.id, self:roomTemplate(), function ()
        owner:refreshBlueprints()
    end)
end

function KBWPlanningMode:beginEraseMode(mode)
    local blueprint = self:selectedOrActiveBlueprint()
    if not blueprint then return end
    Blueprints.setActive(self.player, blueprint.id)
    local owner = self
    Planner.beginErase(self.player, blueprint.id, function ()
        owner:refreshBlueprints()
    end, mode
    )
end

function KBWPlanningMode:onEraseTool()
    self:beginEraseMode("placements")
end

function KBWPlanningMode:onEraseRoomTool()
    self:beginEraseMode("rooms")
end

function KBWPlanningMode:onGatherArea()
    local blueprint = self:selectedOrActiveBlueprint()
    if not blueprint then return end
    Blueprints.setActive(self.player, blueprint.id)
    local owner = self
    Planner.beginGatherArea(self.player, blueprint.id, function ()
        Planner.cancelCursor(owner.player)
    end)
end

function KBWPlanningMode:onBuildAll()
    local blueprint = self:selectedOrActiveBlueprint()
    if not blueprint then return end
    Blueprints.setActive(self.player, blueprint.id)
    local BuildQueue = require("KnoxBuildworks/Planning/BuildQueue")
    local owner = self
    BuildQueue.start(self.player, blueprint.id, function ()
        owner:refreshBlueprints()
    end)
end

function KBWPlanningMode:onStopQueue()
    local BuildQueue = require("KnoxBuildworks/Planning/BuildQueue")
    BuildQueue.stop()
end

function KBWPlanningMode:onBuildTool()
    local blueprint = self:selectedOrActiveBlueprint()
    if not blueprint then return end
    Blueprints.setActive(self.player, blueprint.id)
    local owner = self
    Planner.beginBuildTool(self.player, blueprint.id, function ()
        owner:refreshBlueprints()
    end)
end

function KBWPlanningMode:onMoveBlueprint()
    local blueprint = self:selectedOrActiveBlueprint()
    if not blueprint then return end
    Blueprints.setActive(self.player, blueprint.id)
    local owner = self
    Planner.beginMoveBlueprint(self.player, blueprint.id, function ()
        owner:refreshBlueprints()
        owner:updateActivateButton()
    end)
end

function KBWPlanningMode:onStopTool()
    Planner.cancelCursor(self.player)
    Planner.setHighlightRoom(nil)
end

function KBWPlanningMode:onPlanSelected()
    local blueprint = self:selectedOrActiveBlueprint()
    local definition = self.selectedBuildable
    if (not definition) and self.catalogPanel and self.catalogPanel.catalogGrid then
        definition = self.catalogPanel.catalogGrid.items[self.catalogPanel.catalogGrid.selectedIndex]
    end
    if not blueprint or not definition then
        say(self.player, getText("IGUI_KBW_SelectBuildableFirst"), true)
        return
    end
    local stage = self.catalogPanel and self.catalogPanel:selectedStage()
        or (definition.stages and definition.stages[1])
    if not stage then return end
    local variantId = self.catalogPanel and self.catalogPanel:selectedVariant() or ""
    local materialId = self.catalogPanel and self.catalogPanel:selectedMaterial() or ""
    local finish = self.catalogPanel and self.catalogPanel:selectedFinish() or nil
    Blueprints.setActive(self.player, blueprint.id)
    Planner.begin(
        self.player, Groups.resolveBuildableId(definition, stage), Groups.resolveStageId(stage), variantId, materialId,
        1, finish
    )
end

function KBWPlanningMode:onBuildSelected()
    local blueprint = self:selectedBlueprint()
    local placement = self:selectedPlacement()
    if blueprint and placement then
        local owner = self
        local BuildQueue = require("KnoxBuildworks/Planning/BuildQueue")
        BuildQueue.startSelected(self.player, blueprint.id, placement, function ()
            owner:refreshBlueprints()
        end)
    end
end

function KBWPlanningMode:onExit()
    self:close()
end

function KBWPlanningMode:prerender()
    ISPanel.prerender(self)
    local leftX = self.leftX or 14
    local rightX = self.rightX or 320
    local headerH = self.headerH or 18
    local frameTop = (self.contentY or 46) - 2
    local function headerTextY(widget)
        return widget.y - headerH + 2
    end
    drawSection(self, leftX - 6, frameTop, (self.leftW or 290) + 12, self.totalList.y - headerH - 4 - frameTop)
    drawSection(
        self, leftX - 6, self.totalList.y - headerH, (self.leftW or 290) + 12, self.totalList.height + headerH + 6
    )
    drawSection(self, rightX - 6, frameTop, (self.rightW or 220) + 12, self.roomList.y - headerH - 4 - frameTop)
    local roomFrameBottom = self.deleteRoomButton.y + self.deleteRoomButton.height + 6
    drawSection(
        self, rightX - 6, self.roomList.y - headerH, (self.rightW or 220) + 12,
        roomFrameBottom - (self.roomList.y - headerH)
    )
    drawSection(
        self, rightX - 6, self.placementList.y - headerH, (self.rightW or 220) + 12,
        self.placementList.height + headerH + 6
    )
    self:drawText(
        getText("IGUI_KBW_PlanningMode"), leftX, self.titleY or 12, Theme.accent.r,
        Theme.accent.g, Theme.accent.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_Blueprints"), leftX, self.subHeaderY or 30, Theme.textMuted.r,
        Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
    local blueprint = self:selectedBlueprint()
    self:drawText(
        getText("IGUI_KBW_BlueprintLevel",
            tostring((blueprint and blueprint.level) or math.floor(self.player:getZ()))
        ), self.levelLabelX, self.levelDownButton.y + math.floor((self.levelDownButton.height - FONT_HGT_SMALL) / 2),
        Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_RoomTools"), rightX, self.subHeaderY or 30, Theme.textMuted.r,
        Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
    if self.colorHintX then
        local hint = ROOM_COLORS[self.roomColorIndex or 1] or ROOM_COLORS[1]
        self:drawRect(
            self.colorHintX, self.colorHintY, self.colorHintSize, self.colorHintSize, 0.95, hint.r, hint.g, hint.b
        )
        self:drawRectBorder(
            self.colorHintX, self.colorHintY, self.colorHintSize, self.colorHintSize, Theme.accent.a, Theme.accent.r,
            Theme.accent.g, Theme.accent.b
        )
    end
    self:drawText(
        getText("IGUI_KBW_GhostOpacity"), rightX, headerTextY(self.opacityButtons[1]),
        Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_Rooms"), rightX, headerTextY(self.roomList), Theme.accent.r, Theme.accent.g,
        Theme.accent.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_BlueprintTotals"), leftX, headerTextY(self.totalList), Theme.accent.r,
        Theme.accent.g, Theme.accent.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_Placements"), rightX, headerTextY(self.placementList), Theme.accent.r,
        Theme.accent.g, Theme.accent.b, 1, UIFont.Small
    )
    if self.accessHeaderY then
        local accessLabel = getText("IGUI_KBW_Access")
        self:drawText(
            accessLabel, leftX, self.accessHeaderY, Theme.accent.r, Theme.accent.g, Theme.accent.b, 1, UIFont.Small
        )
        if blueprint then
            local info = blueprintAccessSummary(self.player, blueprint)
            local infoX = leftX + getTextManager():MeasureStringX(UIFont.Small, accessLabel) + 10
            self:drawText(
                info, infoX, self.accessHeaderY, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1,
                UIFont.Small
            )
        end
    end
end

function KBWPlanningMode:close()
    Planner.cancelCursor(self.player)
    Planner.setHighlight(nil)
    Planner.setHighlightRoom(nil)
    if self.catalogPanel then
        self.catalogPanel:setVisible(false)
        self.catalogPanel:removeFromUIManager()
        self.catalogPanel = nil
    end
    if self.accessWindow then
        self.accessWindow:close()
        self.accessWindow = nil
    end
    self:setVisible(false)
    self:removeFromUIManager()
    restoreBaseUI(self.hiddenUI)
    restoreInventoryBars(self.inventoryBars)
    if KBWPlanningMode.instance == self then KBWPlanningMode.instance = nil end
end

function KBWPlanningMode.open(player)
    player = player or getPlayer()
    if not KBW.Runtime.loaded then
        if player and HaloTextHelper then
            KBWB41.halo(player, getText("IGUI_KBW_DefinitionsLoading"), false)
        end
        return nil
    end
    if KBW.sandboxValue("KnoxBuildworks.EnablePlanningMode", true) ~= true then
        if HaloTextHelper then
            KBWB41.halo(player, getText("IGUI_KBW_PlanningDisabled"), true)
        end
        return nil
    end
    if isClient() then
        sendClientCommand(player, KBW.NETWORK_MODULE, "BPRequest", { reason = "planning_open" })
    end
    if KBWPlanningMode.instance then KBWPlanningMode.instance:close() end
    local keepOption = Options and Options.getOption and Options:getOption("KeepInventoryVisibleInPlanning") or nil
    local keepInventoryBars = keepOption and keepOption.getValue and keepOption:getValue() == true
    local inventoryBars = keepInventoryBars and captureInventoryBars() or {}
    local hidden = hideBaseUI(keepInventoryBars)
    local ui = KBWPlanningMode:new(player, hidden, inventoryBars)
    ui:initialise()
    ui:addToUIManager()
    ui:bringToTop()
    if ui.catalogPanel then ui.catalogPanel:bringToTop() end
    if keepInventoryBars then holdInventoryBars(inventoryBars) end
    KBWPlanningMode.instance = ui
    return ui
end

return KBWPlanningMode
