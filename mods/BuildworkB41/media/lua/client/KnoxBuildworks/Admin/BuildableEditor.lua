require("ISUI/ISCollapsableWindow")
require("ISUI/ISPanel")
require("ISUI/ISLabel")
require("ISUI/ISScrollingListBox")
require("ISUI/ISComboBox")
require("ISUI/ISButton")
require("ISUI/ISTextEntryBox")
require("ISUI/ISTickBox")
require("ISUI/ISRichTextPanel")

local Registry = require("KnoxBuildworks/Definitions/Registry")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
local RulePresets = require("KnoxBuildworks/Admin/BuildableRulePresets")
local TableUtil = require("KnoxBuildworks/Util/Table")
local I18n = require("KnoxBuildworks/I18n")
local Theme = require("KnoxBuildworks/UI/Theme")
local VirtualListBox = require("KnoxBuildworks/UI/VirtualListBox")
local Guide = require("KnoxBuildworks/UI/Guide")
local AccessLevelUtils = require("ElyonLib/PlayerUtils/AccessLevelUtils")
local KBWB41 = require("KnoxBuildworks/Compat/B41")
require("KnoxBuildworks/Compat/UIShims")

KBWBuildableEditor = ISCollapsableWindow:derive("KBWBuildableEditor")
KBWBuildableEditor.instance = nil

local PAD = 10
local GAP = 7
local TABS = { "availability", "requirements", "finishes", "skills", "knowledge" }
local TAB_TEXT_KEYS = {
    "IGUI_KBW_AdminEditorTabAvailability", "IGUI_KBW_AdminEditorTabRequirements", "IGUI_KBW_AdminEditorTabFinishes",
    "IGUI_KBW_AdminEditorTabSkillsXP", "IGUI_KBW_AdminEditorTabKnowledge"
}

local function comboData(combo)
    return combo and combo:getOptionData(combo.selected) or nil
end

local function selectComboData(combo, wanted)
    if not combo then return end
    for optionIndex = 1, combo:getOptionCount() do
        if combo:getOptionData(optionIndex) == wanted then
            combo.selected = optionIndex
            return
        end
    end
    combo.selected = 1
end

local function trim(value)
    return string.gsub(tostring(value or ""), "^%s*(.-)%s*$", "%1")
end

local function splitValues(value)
    local result, seen = {}, {}
    value = tostring(value or "")
    for part in string.gmatch(value, "[^,]+") do
        local clean = trim(part)
        if clean ~= "" and not seen[clean] then
            seen[clean] = true
            result[#result + 1] = clean
        end
    end
    return result
end

local function joinValues(values)
    return table.concat(values or {}, ", ")
end

local function appendUnique(target, values, seen)
    values = values or {}
    seen = seen or {}
    for valueIndex = 1, #values do
        local value = values[valueIndex]
        if value ~= nil and not seen[value] then
            seen[value] = true
            target[#target + 1] = value
        end
    end
    return seen
end

local function makeButton(parent, text, callback, primary, target)
    local button = ISButton:new(0, 0, 100, parent.actionH, text, target or parent, callback)
    button:initialise()
    button:instantiate()
    Theme.applyActionButton(button, true, primary == true)
    parent:addChild(button)
    return button
end

local function makeCombo(parent, callback)
    local combo = ISComboBox:new(0, 0, 100, parent.controlH, parent, callback)
    combo:initialise()
    parent:addChild(combo)
    return combo
end

local function makeEntry(parent, numbersOnly)
    local entry = ISTextEntryBox:new("", 0, 0, 100, parent.controlH)
    entry:initialise()
    entry:instantiate()
    entry:setClearButton(not numbersOnly)
    if numbersOnly then entry:setOnlyNumbers(true) end
    parent:addChild(entry)
    return entry
end

local function makeTick(parent, text, callback)
    local tick = ISTickBox:new(0, 0, 100, parent.controlH, "", parent, callback)
    tick:initialise()
    tick:instantiate()
    tick:addOption(text)
    parent:addChild(tick)
    return tick
end

local function makeList(parent, draw, callback)
    local list = VirtualListBox:new(0, 0, 100, 100)
    list:initialise()
    list:instantiate()
    list.itemheight = parent.rowH
    list.font = UIFont.Small
    list.drawBorder = true
    list.doDrawItem = draw
    if callback then list:setOnMouseDownFunction(parent, callback) end
    parent:addChild(list)
    return list
end

local function inheritedPolicyText(value)
    if value == true then return getText("IGUI_KBW_AdminEditorEnabled") end
    if value == false then return getText("IGUI_KBW_AdminEditorDisabled") end
    return getText("IGUI_KBW_AdminEditorInherit")
end

local function addPolicyOptions(combo)
    combo:addOptionWithData(getText("IGUI_KBW_AdminEditorInherit"), "inherit")
    combo:addOptionWithData(getText("IGUI_KBW_AdminEditorEnabled"), "enabled")
    combo:addOptionWithData(getText("IGUI_KBW_AdminEditorDisabled"), "disabled")
end

local function policyData(rule)
    if not rule or rule.enabled == nil then return "inherit" end
    return rule.enabled and "enabled" or "disabled"
end

local function policyValue(value)
    if value == "enabled" then return true end
    if value == "disabled" then return false end
    return nil
end

local function addFinishPolicyOptions(combo, allowInherit)
    if allowInherit then combo:addOptionWithData(getText("IGUI_KBW_AdminEditorInherit"), "inherit") end
    combo:addOptionWithData(getText("IGUI_KBW_AdminEditorFinishRequired"), "required")
    combo:addOptionWithData(getText("IGUI_KBW_AdminEditorFinishWaived"), "waived")
end

local function finishPolicyData(value, allowInherit)
    if value == nil then return allowInherit and "inherit" or "required" end
    return value == true and "required" or "waived"
end

local function finishPolicyValue(value)
    if value == "required" then return true end
    if value == "waived" then return false end
    return nil
end

local function allStages(definition)
    local result, seen = {}, {}
    local function add(stages)
        stages = stages or {}
        for stageIndex = 1, #stages do
            local stage = stages[stageIndex]
            local id = tostring(stage.id or "")
            if id ~= "" and not seen[id] then
                seen[id] = true
                result[#result + 1] = stage
            end
        end
    end
    add(definition and definition.stages)
    local variants = (definition and definition.variants) or {}
    for variantIndex = 1, #variants do
        add(variants[variantIndex].stages)
    end
    local materials = (definition and definition.materialOptions) or {}
    for materialIndex = 1, #materials do
        add(materials[materialIndex].stages)
    end
    table.sort(result, function (a, b) return tostring(a.id) < tostring(b.id) end)
    return result
end

local function buildableRule(document, definition, create)
    if not definition then return nil end
    local rules = document.buildables
    local rule = rules[definition.id]
    if not rule and create then
        rule = { stages = {} }
        rules[definition.id] = rule
    end
    return rule
end

local function stageRule(document, definition, stage, create)
    local parent = buildableRule(document, definition, create)
    if not parent then return nil end
    parent.stages = parent.stages or {}
    local id = tostring(stage and stage.id or "")
    local rule = parent.stages[id]
    if not rule and create then
        rule = {}
        parent.stages[id] = rule
    end
    return rule
end

local function cleanEmptyRules(document, definition, stage)
    local parent = buildableRule(document, definition, false)
    if not parent then return end
    local rule = stage and parent.stages and parent.stages[tostring(stage.id)] or nil
    if rule and rule.inputs == nil and rule.skills == nil and rule.xp == nil and rule.recipes == nil
        and rule.needToBeLearned == nil and rule.time == nil then
        parent.stages[tostring(stage.id)] = nil
    end
    if parent.finishRequirements and #TableUtil.sortedKeys(parent.finishRequirements) == 0 then
        parent.finishRequirements = nil
    end
    if parent.enabled == nil and parent.finishRequirements == nil and #TableUtil.sortedKeys(parent.stages or {}) == 0 then
        document.buildables[definition.id] = nil
    end
end

function KBWBuildableEditor:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.infoButton:setVisible(true)
    self.infoButton.tooltip = getText("IGUI_KBW_OpenGuide")

    self.presetPanel = ISPanel:new(0, 0, 100, 100)
    self.presetPanel:initialise()
    self.presetPanel:instantiate()
    self.presetPanel.background = true
    self.presetPanel.backgroundColor = Theme.color(Theme.surface)
    self.presetPanel.borderColor = Theme.color(Theme.border)
    self.presetPanel.controlH = self.controlH
    self.presetPanel.actionH = self.actionH
    self:addChild(self.presetPanel)

    self.presetTitle = ISLabel:new(
        0, 0, self.fontH, getText("IGUI_KBW_AdminEditorPresetPanelTitle"), Theme.accent.r, Theme.accent.g,
        Theme.accent.b, 1, UIFont.Small, true
    )
    self.presetTitle:initialise()
    self.presetTitle.tooltip = getText("IGUI_KBW_AdminEditorPresetPanelHint")
    self.presetPanel:addChild(self.presetTitle)
    self.presetHint = ISLabel:new(
        0, 0, self.fontH, getText("IGUI_KBW_AdminEditorPresetPanelHint"), Theme.textMuted.r, Theme.textMuted.g,
        Theme.textMuted.b, 1, UIFont.Small, true
    )
    self.presetHint:initialise()
    self.presetPanel:addChild(self.presetHint)

    self.presetCombo = makeCombo(self.presetPanel, nil)
    self.presetNameEntry = makeEntry(self.presetPanel, false)
    if self.presetNameEntry.setPlaceholderText then
        KBWB41.call(self.presetNameEntry, "setPlaceholderText", getText("IGUI_KBW_AdminEditorPresetNamePlaceholder"))
    end
    self.loadPresetButton = makeButton(
        self.presetPanel, getText("IGUI_KBW_AdminEditorPresetLoad"), self.onLoadPreset, false, self
    )
    self.refreshPresetsButton = makeButton(
        self.presetPanel, getText("IGUI_KBW_AdminEditorPresetRefresh"), self.onRefreshPresets, false, self
    )
    self.exportPresetButton = makeButton(
        self.presetPanel, getText("IGUI_KBW_AdminEditorPresetExport"), self.onExportPreset, true, self
    )
    self.loadPresetButton.tooltip = getText("IGUI_KBW_AdminEditorPresetLoadTooltip")
    self.refreshPresetsButton.tooltip = getText("IGUI_KBW_AdminEditorPresetRefreshTooltip")
    self.exportPresetButton.tooltip = getText("IGUI_KBW_AdminEditorPresetExportTooltip")

    self.searchEntry = makeEntry(self, false)
    if self.searchEntry.setPlaceholderText then
        KBWB41.call(self.searchEntry, "setPlaceholderText", getText("IGUI_KBW_SearchPlaceholder"))
    end
    self.searchEntry.onTextChange = function (box)
        box.target:queueSearchRefresh()
    end
    self.searchEntry.target = self
    self.categoryFilter = makeCombo(self, self.onFilterChanged)
    self.subcategoryFilter = makeCombo(self, self.onFilterChanged)
    self.buildableList = makeList(self, self.drawBuildable, self.onBuildableSelected)

    self.stageCombo = makeCombo(self, self.onStageChanged)
    self.tabButtons = {}
    for keyIndex = 1, #TAB_TEXT_KEYS do
        local key = TAB_TEXT_KEYS[keyIndex]
        local button = makeButton(self, getText(key), self.onTab, false)
        button.tabId = TABS[keyIndex]
        button.kbwPreferredWidth = math.max(76, getTextManager():MeasureStringX(UIFont.Small, getText(key)) + 24)
        self.tabButtons[#self.tabButtons + 1] = button
    end

    self.categoryPolicy = makeCombo(self, self.onPolicyChanged)
    self.subcategoryPolicy = makeCombo(self, self.onPolicyChanged)
    self.buildablePolicy = makeCombo(self, self.onPolicyChanged)
    addPolicyOptions(self.categoryPolicy)
    addPolicyOptions(self.subcategoryPolicy)
    addPolicyOptions(self.buildablePolicy)
    self.timeOverride = makeTick(self, getText("IGUI_KBW_AdminEditorOverrideBuildTime"), self.onTimeOverride)
    self.timeEntry = makeEntry(self, true)

    self.wallFinishDefaults = {}
    self.wallFinishOverrides = {}
    local finishRequirements = { "plaster", "paint", "wallpaper" }
    for requirementIndex = 1, #finishRequirements do
        local requirement = finishRequirements[requirementIndex]
        local defaultCombo = makeCombo(self, self.onFinishPolicyChanged)
        defaultCombo.kbwFinishRequirement = requirement
        defaultCombo.kbwFinishScope = "default"
        addFinishPolicyOptions(defaultCombo, false)
        defaultCombo.tooltip = getText("IGUI_KBW_AdminEditorWallFinishDefaultsHint")
        self.wallFinishDefaults[requirement] = defaultCombo
        local overrideCombo = makeCombo(self, self.onFinishPolicyChanged)
        overrideCombo.kbwFinishRequirement = requirement
        overrideCombo.kbwFinishScope = "buildable"
        addFinishPolicyOptions(overrideCombo, true)
        overrideCombo.tooltip = getText("IGUI_KBW_AdminEditorWallFinishOverridesHint")
        self.wallFinishOverrides[requirement] = overrideCombo
    end

    self.inputsOverride = makeTick(self, getText("IGUI_KBW_AdminEditorOverrideInputs"), self.onInputsOverride)
    self.inputList = makeList(self, self.drawInput, self.onInputSelected)
    self.inputId = makeEntry(self, false)
    self.inputRole = makeCombo(self, nil)
    self.inputRole:addOptionWithData(getText("IGUI_KBW_AdminEditorRoleMaterial"), "material")
    self.inputRole:addOptionWithData(getText("IGUI_KBW_AdminEditorRoleTool"), "tool")
    self.inputRole:addOptionWithData(getText("IGUI_KBW_AdminEditorRoleConsumable"), "consumable")
    self.inputRole:addOptionWithData(getText("IGUI_KBW_AdminEditorRoleComponent"), "component")
    self.inputRole:addOptionWithData(getText("IGUI_KBW_AdminEditorRoleResource"), "resource")
    self.inputMode = makeCombo(self, nil)
    self.inputMode:addOptionWithData(getText("IGUI_KBW_AdminEditorModeConsume"), "consume")
    self.inputMode:addOptionWithData(getText("IGUI_KBW_AdminEditorModeKeep"), "keep")
    self.inputMode:addOptionWithData(getText("IGUI_KBW_AdminEditorModeDrain"), "drain")
    self.inputMode:addOptionWithData(getText("IGUI_KBW_AdminEditorModeDestroy"), "destroy")
    self.inputSource = makeCombo(self, nil)
    self.inputSource:addOptionWithData(getText("IGUI_KBW_AdminEditorItemTypes"), "items")
    self.inputSource:addOptionWithData(getText("IGUI_KBW_AdminEditorItemTags"), "tags")
    self.inputValues = makeEntry(self, false)
    self.inputAmount = makeEntry(self, true)
    self.inputHand = makeCombo(self, nil)
    self.inputHand:addOptionWithData(getText("IGUI_KBW_AdminEditorNone"), "none")
    self.inputHand:addOptionWithData(getText("IGUI_KBW_AdminEditorPrimaryHand"), "Prop1")
    self.inputHand:addOptionWithData(getText("IGUI_KBW_AdminEditorSecondaryHand"), "Prop2")
    self.inputDegrade = makeCombo(self, nil)
    self.inputDegrade:addOptionWithData(getText("IGUI_KBW_AdminEditorNoDegrade"), "none")
    self.inputDegrade:addOptionWithData(getText("IGUI_KBW_AdminEditorDegradeVeryLight"), "MayDegradeVeryLight")
    self.inputDegrade:addOptionWithData(getText("IGUI_KBW_AdminEditorDegradeLight"), "MayDegradeLight")
    self.inputDegrade:addOptionWithData(getText("IGUI_KBW_AdminEditorDegradeNormal"), "MayDegrade")
    self.inputDegrade:addOptionWithData(getText("IGUI_KBW_AdminEditorDegradeHeavy"), "MayDegradeHeavy")
    self.inputAdd = makeButton(self, getText("IGUI_KBW_AdminEditorAdd"), self.onInputAdd, false)
    self.inputUpdate = makeButton(self, getText("IGUI_KBW_AdminEditorUpdate"), self.onInputUpdate, false)
    self.inputRemove = makeButton(self, getText("IGUI_KBW_AdminEditorRemove"), self.onInputRemove, false)

    self.skillsOverride = makeTick(self, getText("IGUI_KBW_AdminEditorOverrideSkills"), self.onSkillsOverride)
    self.skillList = makeList(self, self.drawPerkRule, self.onSkillSelected)
    self.skillPerk = makeCombo(self, nil)
    self.skillAmount = makeEntry(self, true)
    self.skillAdd = makeButton(self, getText("IGUI_KBW_AdminEditorSet"), self.onSkillSet, false)
    self.skillRemove = makeButton(self, getText("IGUI_KBW_AdminEditorRemove"), self.onSkillRemove, false)
    self.xpOverride = makeTick(self, getText("IGUI_KBW_AdminEditorOverrideXP"), self.onXPOverride)
    self.xpList = makeList(self, self.drawPerkRule, self.onXPSelected)
    self.xpPerk = makeCombo(self, nil)
    self.xpAmount = makeEntry(self, true)
    self.xpAdd = makeButton(self, getText("IGUI_KBW_AdminEditorSet"), self.onXPSet, false)
    self.xpRemove = makeButton(self, getText("IGUI_KBW_AdminEditorRemove"), self.onXPRemove, false)
    self:populatePerks(self.skillPerk)
    self:populatePerks(self.xpPerk)

    self.knowledgeOverride = makeTick(self, getText("IGUI_KBW_AdminEditorOverrideKnowledge"), self.onKnowledgeOverride)
    self.needKnown = makeTick(self, getText("IGUI_KBW_AdminEditorMustKnowRecipe"), self.onNeedKnown)
    self.recipeList = makeList(self, self.drawRecipe, self.onRecipeSelected)
    self.recipeCombo = makeCombo(self, nil)
    self.recipeAdd = makeButton(self, getText("IGUI_KBW_AdminEditorAdd"), self.onRecipeAdd, false)
    self.recipeRemove = makeButton(self, getText("IGUI_KBW_AdminEditorRemove"), self.onRecipeRemove, false)
    self.recipeOptionsPopulated = false

    self.statusPanel = ISRichTextPanel:new(0, 0, 300, self.statusH)
    self.statusPanel:initialise()
    self.statusPanel:instantiate()
    self.statusPanel.background = true
    self.statusPanel.backgroundColor = Theme.color(Theme.surface)
    self.statusPanel.borderColor = Theme.color(Theme.borderSoft)
    self.statusPanel.marginLeft = 8
    self.statusPanel.marginRight = 8
    self.statusPanel.autosetheight = false
    self:addChild(self.statusPanel)

    self.reloadButton = makeButton(self, getText("IGUI_KBW_AdminEditorReload"), self.onReload, false)
    self.resetButton = makeButton(self, getText("IGUI_KBW_AdminEditorResetBuildable"), self.onResetBuildable, false)
    self.validateButton = makeButton(self, getText("IGUI_KBW_AdminEditorValidate"), self.onValidate, false)
    self.saveButton = makeButton(self, getText("IGUI_KBW_AdminEditorSave"), self.onSave, true)

    self.draft = BuildableRules.getDocument()
    self.baseRevision = BuildableRules.revision
    self:refreshPresetOptions()
    self:rebuildBuildableIndex()
    self:populateFilters()
    self:refreshBuildables(true)
    self:setTab("availability")
    self:setStatus(getText("IGUI_KBW_AdminEditorReady"), "normal")
    self:layout()
    BuildableRules.request(self.player)
end

function KBWBuildableEditor:rebuildBuildableIndex()
    local records = {}
    local definitions = Registry:list()
    for definitionIndex = 1, #definitions do
        local definition = definitions[definitionIndex]
        local name = I18n.definitionName(definition)
        records[#records + 1] = {
            definition = definition,
            name = name,
            nameLower = string.lower(name),
            idLower = string.lower(tostring(definition.id)),
            category = tostring(definition.category or "General"),
            subcategory = tostring(definition.subcategory or "General")
        }
    end
    table.sort(records, function (a, b)
        if a.name ~= b.name then return a.name < b.name end
        return a.definition.id < b.definition.id
    end)
    self.buildableIndex = records
end

function KBWBuildableEditor:queueSearchRefresh()
    self.searchRefreshAt = getTimestampMs() + 120
end

function KBWBuildableEditor:update()
    ISCollapsableWindow.update(self)
    if self.searchRefreshAt and getTimestampMs() >= self.searchRefreshAt then
        self.searchRefreshAt = nil
        self:refreshBuildables(false)
    end
end

function KBWBuildableEditor:populatePerks(combo)
    local entries = {}
    for perkIndex = 0, Perks.getMaxIndex() - 1 do
        local perkType = Perks.fromIndex(perkIndex)
        local perk = PerkFactory.getPerk(perkType)
        if perk and perk:getParent() ~= Perks.None then
            entries[#entries + 1] = { id = tostring(perk:getType()), name = tostring(perk:getName()) }
        end
    end
    table.sort(entries, function (a, b) return a.name < b.name end)
    for entryIndex = 1, #entries do
        combo:addOptionWithData(entries[entryIndex].name, entries[entryIndex].id)
    end
end

function KBWBuildableEditor:populateRecipes()
    if self.recipeOptionsPopulated then return end
    local recipes = KBWB41.call(ScriptManager.instance, "getAllCraftRecipes")
    local entries = {}
    if recipes then
        for recipeIndex = 0, recipes:size() - 1 do
            local recipe = recipes:get(recipeIndex)
            entries[#entries + 1] = {
                id = tostring(recipe:getName()),
                name = tostring(KBWB41.displayName(recipe) or recipe:getName())
            }
        end
    end
    table.sort(entries, function (a, b)
        if a.name ~= b.name then return a.name < b.name end
        return a.id < b.id
    end)
    for entryIndex = 1, #entries do
        self.recipeCombo:addOptionWithData(entries[entryIndex].name, entries[entryIndex].id)
    end
    self.recipeOptionsPopulated = true
end

function KBWBuildableEditor:populateFilters()
    local categories, categorySeen = {}, {}
    local records = self.buildableIndex or {}
    for recordIndex = 1, #records do
        local category = records[recordIndex].category
        if not categorySeen[category] then
            categorySeen[category] = true
            categories[#categories + 1] = category
        end
    end
    table.sort(categories, function (a, b) return I18n.category(a) < I18n.category(b) end)
    self.categoryFilter:clear()
    self.categoryFilter:addOptionWithData(getText("IGUI_KBW_AllCategories"), "All")
    for categoryIndex = 1, #categories do
        local category = categories[categoryIndex]
        self.categoryFilter:addOptionWithData(I18n.category(category), category)
    end
    self.categoryFilter.selected = 1
    self:populateSubcategories()
end

function KBWBuildableEditor:populateSubcategories()
    local category = comboData(self.categoryFilter) or "All"
    local values, seen = {}, {}
    local records = self.buildableIndex or {}
    for recordIndex = 1, #records do
        local record = records[recordIndex]
        if category == "All" or record.category == category then
            local subcategory = record.subcategory
            if not seen[subcategory] then
                seen[subcategory] = true
                values[#values + 1] = subcategory
            end
        end
    end
    table.sort(values, function (a, b) return I18n.subcategory(a) < I18n.subcategory(b) end)
    self.subcategoryFilter:clear()
    self.subcategoryFilter:addOptionWithData(getText("IGUI_KBW_AdminEditorAllSubcategories"), "All")
    for valueIndex = 1, #values do
        self.subcategoryFilter:addOptionWithData(I18n.subcategory(values[valueIndex]), values[valueIndex])
    end
    self.subcategoryFilter.selected = 1
end

function KBWBuildableEditor:onFilterChanged(combo)
    if combo == self.categoryFilter then self:populateSubcategories() end
    self:refreshBuildables(false)
end

function KBWBuildableEditor:refreshBuildables(selectFirst)
    local selected = self:selectedDefinition()
    local selectedId = selected and selected.id or nil
    local category = comboData(self.categoryFilter) or "All"
    local subcategory = comboData(self.subcategoryFilter) or "All"
    local query = string.lower(trim(self.searchEntry:getInternalText()))
    local filtered = {}
    local records = self.buildableIndex or {}
    for recordIndex = 1, #records do
        local record = records[recordIndex]
        local definition = record.definition
        local include = category == "All" or record.category == category
        if include and subcategory ~= "All" then
            include = record.subcategory == subcategory
        end
        if include and query ~= "" then
            include = string.find(record.nameLower, query, 1, true) ~= nil
                or string.find(record.idLower, query, 1, true) ~= nil
        end
        if include then filtered[#filtered + 1] = record end
    end
    self.buildableList:replaceItems(filtered)
    local selectedIndex = 0
    for resultIndex = 1, #filtered do
        if filtered[resultIndex].definition.id == selectedId then selectedIndex = resultIndex end
    end
    if selectedIndex == 0 and (selectFirst or #filtered > 0) then selectedIndex = #filtered > 0 and 1 or 0 end
    self.buildableList.selected = selectedIndex
    self:onBuildableSelected()
end

function KBWBuildableEditor:selectedDefinition()
    local row = self.buildableList and self.buildableList.items[self.buildableList.selected] or nil
    return row and row.item or nil
end

function KBWBuildableEditor:selectedStage()
    return self.stageCombo and self.stageCombo:getOptionData(self.stageCombo.selected) or nil
end

function KBWBuildableEditor:drawBuildable(y, item, alt)
    local definition = item.item
    if self.selected == item.index then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r, Theme.selected.g,
            Theme.selected.b
        )
    elseif alt then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, 0.18, Theme.surfaceRaised.r, Theme.surfaceRaised.g,
            Theme.surfaceRaised.b
        )
    end
    self:drawRectBorder(
        0, y, self.width, self.itemheight - 1, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g,
        Theme.borderSoft.b
    )
    local enabled = BuildableRules.isEnabledIn(self.parent.draft, definition)
    local color = enabled and Theme.good or Theme.bad
    self:drawRect(7, y + 10, 6, 6, 1, color.r, color.g, color.b)
    self:drawText(item.text, 20, y + 4, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    local path = I18n.category(definition.category or "General") .. " / "
        .. I18n.subcategory(definition.subcategory or "General")
    self:drawText(
        path, 20, y + self.parent.fontH + 6, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
    return y + self.itemheight
end

function KBWBuildableEditor:onBuildableSelected()
    local definition = self:selectedDefinition()
    self.stageCombo:clear()
    local stages = allStages(definition)
    for stageIndex = 1, #stages do
        local stage = stages[stageIndex]
        self.stageCombo:addOptionWithData(I18n.optionName(stage, stage.id), stage)
    end
    self.stageCombo.selected = #stages > 0 and 1 or 0
    self:refreshEditor()
end

function KBWBuildableEditor:onStageChanged()
    self:refreshEditor()
end

function KBWBuildableEditor:setTab(tabId)
    if tabId == "knowledge" and not self.recipeOptionsPopulated then
        self:populateRecipes()
        self:onRecipeSelected()
    end
    self.activeTab = tabId
    for buttonIndex = 1, #self.tabButtons do
        local button = self.tabButtons[buttonIndex]
        Theme.applyButton(button, button.tabId == tabId)
    end
    self:applyTabVisibility()
end

function KBWBuildableEditor:onTab(button)
    self:setTab(button.tabId)
end

function KBWBuildableEditor:tabControls()
    return {
        availability = {
            self.categoryPolicy, self.subcategoryPolicy, self.buildablePolicy, self.timeOverride, self.timeEntry
        },
        requirements = {
            self.inputsOverride,
            self.inputList,
            self.inputId,
            self.inputRole,
            self.inputMode,
            self.inputSource,
            self.inputValues,
            self.inputAmount,
            self.inputHand,
            self.inputDegrade,
            self.inputAdd,
            self.inputUpdate,
            self.inputRemove
        },
        finishes = {
            self.wallFinishDefaults.plaster,
            self.wallFinishDefaults.paint,
            self.wallFinishDefaults.wallpaper,
            self.wallFinishOverrides.plaster,
            self.wallFinishOverrides.paint,
            self.wallFinishOverrides.wallpaper
        },
        skills = {
            self.skillsOverride,
            self.skillList,
            self.skillPerk,
            self.skillAmount,
            self.skillAdd,
            self.skillRemove,
            self.xpOverride,
            self.xpList,
            self.xpPerk,
            self.xpAmount,
            self.xpAdd,
            self.xpRemove
        },
        knowledge = {
            self.knowledgeOverride,
            self.needKnown,
            self.recipeList,
            self.recipeCombo,
            self.recipeAdd,
            self.recipeRemove
        }
    }
end

function KBWBuildableEditor:applyTabVisibility()
    local controls = self:tabControls()
    for tabIndex = 1, #TABS do
        local tabId = TABS[tabIndex]
        local visible = self.activeTab == tabId
        local list = controls[tabId]
        for controlIndex = 1, #list do
            list[controlIndex]:setVisible(visible)
        end
    end
end

function KBWBuildableEditor:refreshEditor()
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    local category = definition and tostring(definition.category or "General") or nil
    local subcategory = definition and tostring(definition.subcategory or "General") or nil
    local categoryRule = category and self.draft.categories[category] or nil
    local scoped = category and self.draft.subcategories[category] or nil
    local subcategoryRule = scoped and scoped[subcategory] or nil
    local parent = buildableRule(self.draft, definition, false)
    local rule = stageRule(self.draft, definition, stage, false)
    selectComboData(self.categoryPolicy, policyData(categoryRule))
    selectComboData(self.subcategoryPolicy, policyData(subcategoryRule))
    selectComboData(self.buildablePolicy, policyData(parent))
    self.timeOverride:setSelected(1, rule ~= nil and rule.time ~= nil)
    local defaultTime = stage and StageConfig.construction(definition, stage).time or 200
    self.timeEntry:setText(rule and rule.time and tostring(rule.time) or tostring(defaultTime or 200))
    local finishDefaults = self.draft.wallFinishRequirements or {}
    local finishOverrides = parent and parent.finishRequirements or {}
    local finishRequirements = { "plaster", "paint", "wallpaper" }
    for requirementIndex = 1, #finishRequirements do
        local requirement = finishRequirements[requirementIndex]
        selectComboData(self.wallFinishDefaults[requirement], finishPolicyData(finishDefaults[requirement], false))
        selectComboData(self.wallFinishOverrides[requirement], finishPolicyData(finishOverrides[requirement], true))
    end
    self:refreshInputs()
    self:refreshSkillsXP()
    self:refreshKnowledge()
    self:updateEnabledStates()
    self:applyTabVisibility()
end

function KBWBuildableEditor:markDirty()
    self.dirty = true
    self:setStatus(getText("IGUI_KBW_AdminEditorUnsaved"), "warning")
end

function KBWBuildableEditor:onPolicyChanged(combo)
    local definition = self:selectedDefinition()
    if not definition then return end
    local category = tostring(definition.category or "General")
    local subcategory = tostring(definition.subcategory or "General")
    local value = policyValue(comboData(combo))
    if combo == self.categoryPolicy then
        if value == nil then
            self.draft.categories[category] = nil
        else
            self.draft.categories[category] = { enabled = value }
        end
    elseif combo == self.subcategoryPolicy then
        self.draft.subcategories[category] = self.draft.subcategories[category] or {}
        if value == nil then
            self.draft.subcategories[category][subcategory] = nil
        else
            self.draft.subcategories[category][subcategory] = { enabled = value }
        end
        if #TableUtil.sortedKeys(self.draft.subcategories[category]) == 0 then
            self.draft.subcategories[category] = nil
        end
    else
        local rule = buildableRule(self.draft, definition, value ~= nil)
        if rule then rule.enabled = value end
        cleanEmptyRules(self.draft, definition, self:selectedStage())
    end
    self:markDirty()
    self:setStatus(getText("IGUI_KBW_AdminEditorUnsaved"), "warning")
end

function KBWBuildableEditor:onTimeOverride(_, selected)
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    if not definition or not stage then return end
    local rule = stageRule(self.draft, definition, stage, selected == true)
    if selected then
        rule.time = tonumber(self.timeEntry:getInternalText())
            or (StageConfig.construction(definition, stage).time or 200)
    elseif rule then
        rule.time = nil
        cleanEmptyRules(self.draft, definition, stage)
    end
    self:markDirty()
    self:updateEnabledStates()
end

function KBWBuildableEditor:onFinishPolicyChanged(combo)
    local requirement = combo and combo.kbwFinishRequirement or nil
    if not requirement then return end
    local value = finishPolicyValue(comboData(combo))
    if combo.kbwFinishScope == "default" then
        self.draft.wallFinishRequirements = self.draft.wallFinishRequirements or {}
        self.draft.wallFinishRequirements[requirement] = value
    else
        local definition, stage = self:selectedDefinition(), self:selectedStage()
        if not definition or not BuildableRules.isWallBuildable(definition, stage) then return end
        local parent = buildableRule(self.draft, definition, value ~= nil)
        if parent then
            parent.finishRequirements = parent.finishRequirements or {}
            parent.finishRequirements[requirement] = value
        end
        cleanEmptyRules(self.draft, definition, stage)
    end
    self:markDirty()
    self:updateEnabledStates()
end

function KBWBuildableEditor:refreshInputs()
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    local rule = stageRule(self.draft, definition, stage, false)
    local overridden = rule ~= nil and rule.inputs ~= nil
    self.inputsOverride:setSelected(1, overridden)
    self.inputList:clear()
    local inputs = overridden and rule.inputs
        or (definition and stage and Requirements.getInputs(definition, stage) or {})
    for inputIndex = 1, #inputs do
        self.inputList:addItem(tostring(inputs[inputIndex].id), inputs[inputIndex])
    end
    self.inputList.selected = #inputs > 0 and 1 or 0
    self:onInputSelected()
end

function KBWBuildableEditor:drawInput(y, item, alt)
    if self.selected == item.index then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r, Theme.selected.g,
            Theme.selected.b
        )
    elseif alt then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, 0.18, Theme.surfaceRaised.r, Theme.surfaceRaised.g,
            Theme.surfaceRaised.b
        )
    end
    local input = item.item
    local accepted = input.items and #input.items > 0 and joinValues(input.items) or joinValues(input.tags)
    local amount = input.uses or input.amount or 1
    self:drawText(tostring(input.id), 7, y + 3, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    self:drawText(tostring(input.role or "material") .. " / "
            .. tostring(input.mode or "consume") .. " / "
            .. tostring(amount) .. " - "
            .. accepted, 7, y + self.parent.fontH + 5, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1,
        UIFont.Small)
    return y + self.itemheight
end

function KBWBuildableEditor:onInputSelected()
    local row = self.inputList.items[self.inputList.selected]
    local input = row and row.item or nil
    self.inputId:setText(input and tostring(input.id) or "")
    selectComboData(self.inputRole, input and input.role or "material")
    selectComboData(self.inputMode, input and input.mode or "consume")
    local source = input and input.tags and #input.tags > 0 and "tags" or "items"
    selectComboData(self.inputSource, source)
    self.inputValues:setText(input and joinValues(input[source]) or "")
    self.inputAmount:setText(input and tostring(input.uses or input.amount or 1) or "1")
    local hand, degrade = "none", "none"
    local flags = (input and input.flags) or {}
    for flagIndex = 1, #flags do
        if flags[flagIndex] == "Prop1" or flags[flagIndex] == "Prop2" then hand = flags[flagIndex] end
        if string.sub(flags[flagIndex], 1, 10) == "MayDegrade" then degrade = flags[flagIndex] end
    end
    selectComboData(self.inputHand, hand)
    selectComboData(self.inputDegrade, degrade)
end

function KBWBuildableEditor:onInputsOverride(_, selected)
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    if not definition or not stage then return end
    if selected and not BuildableRules.canOverrideInputs(definition, stage) then
        self.inputsOverride:setSelected(1, false)
        self:setStatus(getText("IGUI_KBW_AdminEditorNativeRequirementsLocked"), "error")
        return
    end
    local rule = stageRule(self.draft, definition, stage, selected == true)
    if selected then
        rule.inputs = TableUtil.copy(Requirements.getInputs(definition, stage))
    elseif rule then
        rule.inputs = nil
        cleanEmptyRules(self.draft, definition, stage)
    end
    self:markDirty()
    self:refreshInputs()
    self:updateEnabledStates()
end

function KBWBuildableEditor:inputFromForm(existing)
    local source = comboData(self.inputSource) or "items"
    local flags = {}
    local hand = comboData(self.inputHand)
    local degrade = comboData(self.inputDegrade)
    if hand and hand ~= "none" then flags[#flags + 1] = hand end
    if degrade and degrade ~= "none" then flags[#flags + 1] = degrade end
    local input = TableUtil.copy(existing or {})
    input.id = trim(self.inputId:getInternalText())
    input.role = comboData(self.inputRole) or "material"
    input.mode = comboData(self.inputMode) or "consume"
    input.resourceType = "Item"
    input.amount = tonumber(self.inputAmount:getInternalText())
    input.uses = nil
    input.flags = flags
    input.items = {}
    input.tags = {}
    input[source] = splitValues(self.inputValues:getInternalText())
    if input.mode == "drain" then
        input.uses = input.amount
        input.amount = nil
    end
    return input
end

function KBWBuildableEditor:onInputAdd()
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    if not rule or rule.inputs == nil then return end
    rule.inputs[#rule.inputs + 1] = self:inputFromForm()
    self:markDirty()
    self:refreshInputs()
end

function KBWBuildableEditor:onInputUpdate()
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    local selected = self.inputList.selected
    if not rule or rule.inputs == nil or not rule.inputs[selected] then return end
    rule.inputs[selected] = self:inputFromForm(rule.inputs[selected])
    self:markDirty()
    self:refreshInputs()
    self.inputList.selected = math.min(selected, #self.inputList.items)
end

function KBWBuildableEditor:onInputRemove()
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    local selected = self.inputList.selected
    if not rule or rule.inputs == nil or not rule.inputs[selected] then return end
    table.remove(rule.inputs, selected)
    self:markDirty()
    self:refreshInputs()
end

local function refreshPerkList(list, values)
    list:clear()
    local keys = TableUtil.sortedKeys(values or {})
    for keyIndex = 1, #keys do
        list:addItem(keys[keyIndex], { perk = keys[keyIndex], amount = values[keys[keyIndex]] })
    end
    list.selected = #keys > 0 and 1 or 0
end

function KBWBuildableEditor:refreshSkillsXP()
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    local rule = stageRule(self.draft, definition, stage, false)
    local skillOverride = rule ~= nil and rule.skills ~= nil
    local xpOverride = rule ~= nil and rule.xp ~= nil
    self.skillsOverride:setSelected(1, skillOverride)
    self.xpOverride:setSelected(1, xpOverride)
    local defaultSkills = stage and ((stage.requirements or {}).skills or {}) or {}
    local defaultXP = stage and (StageConfig.recipe(definition, stage).xpAward or {}) or {}
    refreshPerkList(self.skillList, skillOverride and rule.skills or defaultSkills)
    refreshPerkList(self.xpList, xpOverride and rule.xp or defaultXP)
    self:onSkillSelected()
    self:onXPSelected()
end

function KBWBuildableEditor:drawPerkRule(y, item, alt)
    if self.selected == item.index then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r, Theme.selected.g,
            Theme.selected.b
        )
    elseif alt then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, 0.18, Theme.surfaceRaised.r, Theme.surfaceRaised.g,
            Theme.surfaceRaised.b
        )
    end
    self:drawText(tostring(item.item.perk), 7, y + 4, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    self:drawText(
        tostring(item.item.amount), self.width - 70, y + 4, Theme.accent.r, Theme.accent.g, Theme.accent.b, 1,
        UIFont.Small
    )
    return y + self.itemheight
end

function KBWBuildableEditor:onSkillsOverride(_, selected)
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    if not definition or not stage then return end
    if selected and not BuildableRules.canOverrideRequirements(definition, stage) then
        self.skillsOverride:setSelected(1, false)
        self:setStatus(getText("IGUI_KBW_AdminEditorNativeRequirementsLocked"), "error")
        return
    end
    local rule = stageRule(self.draft, definition, stage, selected == true)
    if selected then
        rule.skills = TableUtil.copy((stage.requirements or {}).skills or {})
    elseif rule then
        rule.skills = nil
        cleanEmptyRules(self.draft, definition, stage)
    end
    self:markDirty()
    self:refreshSkillsXP()
    self:updateEnabledStates()
end

function KBWBuildableEditor:onXPOverride(_, selected)
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    if not definition or not stage then return end
    local rule = stageRule(self.draft, definition, stage, selected == true)
    if selected then
        rule.xp = TableUtil.copy(StageConfig.recipe(definition, stage).xpAward or {})
    elseif rule then
        rule.xp = nil
        cleanEmptyRules(self.draft, definition, stage)
    end
    self:markDirty()
    self:refreshSkillsXP()
    self:updateEnabledStates()
end

function KBWBuildableEditor:onSkillSelected()
    local row = self.skillList.items[self.skillList.selected]
    if not row then return end
    selectComboData(self.skillPerk, row.item.perk)
    self.skillAmount:setText(tostring(row.item.amount))
end

function KBWBuildableEditor:onXPSelected()
    local row = self.xpList.items[self.xpList.selected]
    if not row then return end
    selectComboData(self.xpPerk, row.item.perk)
    self.xpAmount:setText(tostring(row.item.amount))
end

function KBWBuildableEditor:setPerkRule(field, combo, entry, maximum)
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    if not rule or rule[field] == nil then return end
    local perk = comboData(combo)
    local amount = tonumber(entry:getInternalText())
    if not perk or not amount or amount < 0 or amount > maximum then
        self:setStatus(getText("IGUI_KBW_AdminEditorInvalidNumber"), "error")
        return
    end
    rule[field][perk] = amount
    self:markDirty()
    self:refreshSkillsXP()
end

function KBWBuildableEditor:removePerkRule(field, list)
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    local row = list.items[list.selected]
    if not rule or rule[field] == nil or not row then return end
    rule[field][row.item.perk] = nil
    self:markDirty()
    self:refreshSkillsXP()
end

function KBWBuildableEditor:onSkillSet()
    self:setPerkRule("skills", self.skillPerk, self.skillAmount, 10)
end
function KBWBuildableEditor:onSkillRemove()
    self:removePerkRule("skills", self.skillList)
end
function KBWBuildableEditor:onXPSet()
    self:setPerkRule("xp", self.xpPerk, self.xpAmount, 1000000)
end
function KBWBuildableEditor:onXPRemove()
    self:removePerkRule("xp", self.xpList)
end

function KBWBuildableEditor:refreshKnowledge()
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    local rule = stageRule(self.draft, definition, stage, false)
    local overridden = rule ~= nil and (rule.recipes ~= nil or rule.needToBeLearned ~= nil)
    self.knowledgeOverride:setSelected(1, overridden)
    local requirements = (stage and stage.requirements) or {}
    local knowledge = requirements.knowledge or {}
    local recipes = {}
    if overridden then
        recipes = rule.recipes or {}
    else
        local seen = {}
        local direct = requirements.recipes or {}
        seen = appendUnique(recipes, direct, seen)
        local known = knowledge.recipes or {}
        appendUnique(recipes, known, seen)
    end
    local mustKnow = knowledge.needToBeLearned
    if overridden and rule.needToBeLearned ~= nil then mustKnow = rule.needToBeLearned end
    self.needKnown:setSelected(1, mustKnow ~= false)
    self.recipeList:clear()
    for recipeIndex = 1, #recipes do
        self.recipeList:addItem(tostring(recipes[recipeIndex]), tostring(recipes[recipeIndex]))
    end
    self.recipeList.selected = #recipes > 0 and 1 or 0
    self:onRecipeSelected()
end

function KBWBuildableEditor:drawRecipe(y, item, alt)
    if self.selected == item.index then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r, Theme.selected.g,
            Theme.selected.b
        )
    elseif alt then
        self:drawRect(
            0, y, self.width, self.itemheight - 1, 0.18, Theme.surfaceRaised.r, Theme.surfaceRaised.g,
            Theme.surfaceRaised.b
        )
    end
    self:drawText(tostring(item.item), 7, y + 4, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    return y + self.itemheight
end

function KBWBuildableEditor:onKnowledgeOverride(_, selected)
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    if not definition or not stage then return end
    if selected and not BuildableRules.canOverrideRequirements(definition, stage) then
        self.knowledgeOverride:setSelected(1, false)
        self:setStatus(getText("IGUI_KBW_AdminEditorNativeRequirementsLocked"), "error")
        return
    end
    local rule = stageRule(self.draft, definition, stage, selected == true)
    if selected then
        local requirements = stage.requirements or {}
        local knowledge = requirements.knowledge or {}
        rule.recipes = {}
        local seen = {}
        local direct = requirements.recipes or {}
        seen = appendUnique(rule.recipes, direct, seen)
        local known = knowledge.recipes or {}
        appendUnique(rule.recipes, known, seen)
        rule.needToBeLearned = knowledge.needToBeLearned ~= false
    elseif rule then
        rule.recipes = nil
        rule.needToBeLearned = nil
        cleanEmptyRules(self.draft, definition, stage)
    end
    self:markDirty()
    self:refreshKnowledge()
    self:updateEnabledStates()
end

function KBWBuildableEditor:onNeedKnown(_, selected)
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    if not rule or (rule.recipes == nil and rule.needToBeLearned == nil) then return end
    rule.needToBeLearned = selected == true
    self:markDirty()
end

function KBWBuildableEditor:onRecipeSelected()
    local row = self.recipeList.items[self.recipeList.selected]
    if row then selectComboData(self.recipeCombo, row.item) end
end

function KBWBuildableEditor:onRecipeAdd()
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    local recipe = comboData(self.recipeCombo)
    if not rule or rule.recipes == nil or not recipe then return end
    for recipeIndex = 1, #rule.recipes do
        if rule.recipes[recipeIndex] == recipe then return end
    end
    rule.recipes[#rule.recipes + 1] = recipe
    table.sort(rule.recipes)
    self:markDirty()
    self:refreshKnowledge()
end

function KBWBuildableEditor:onRecipeRemove()
    local rule = stageRule(self.draft, self:selectedDefinition(), self:selectedStage(), false)
    local selected = self.recipeList.selected
    if not rule or rule.recipes == nil or not rule.recipes[selected] then return end
    table.remove(rule.recipes, selected)
    self:markDirty()
    self:refreshKnowledge()
end

function KBWBuildableEditor:updateEnabledStates()
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    local hasSelection = definition ~= nil and stage ~= nil
    local rule = stageRule(self.draft, definition, stage, false)
    local inputs = hasSelection and rule ~= nil and rule.inputs ~= nil
    local skills = hasSelection and rule ~= nil and rule.skills ~= nil
    local xp = hasSelection and rule ~= nil and rule.xp ~= nil
    local knowledge = hasSelection and rule ~= nil and (rule.recipes ~= nil or rule.needToBeLearned ~= nil)
    local requirementsEditable = hasSelection and BuildableRules.canOverrideRequirements(definition, stage) == true
    local wallSelected = hasSelection and BuildableRules.isWallBuildable(definition, stage) == true
    local finishRequirements = { "plaster", "paint", "wallpaper" }
    for requirementIndex = 1, #finishRequirements do
        local requirement = finishRequirements[requirementIndex]
        self.wallFinishOverrides[requirement]:setEnabled(wallSelected)
    end
    self.inputsOverride:disableOption(getText("IGUI_KBW_AdminEditorOverrideInputs"), not requirementsEditable)
    self.skillsOverride:disableOption(getText("IGUI_KBW_AdminEditorOverrideSkills"), not requirementsEditable)
    self.knowledgeOverride:disableOption(getText("IGUI_KBW_AdminEditorOverrideKnowledge"), not requirementsEditable)
    self.timeEntry:setEditable(hasSelection and self.timeOverride:isSelected(1) == true)
    self.inputId:setEditable(inputs)
    self.inputValues:setEditable(inputs)
    self.inputAmount:setEditable(inputs)
    self.inputRole:setEnabled(inputs)
    self.inputMode:setEnabled(inputs)
    self.inputSource:setEnabled(inputs)
    self.inputHand:setEnabled(inputs)
    self.inputDegrade:setEnabled(inputs)
    Theme.setButtonEnabled(self.inputAdd, inputs)
    Theme.setButtonEnabled(self.inputUpdate, inputs)
    Theme.setButtonEnabled(self.inputRemove, inputs)
    self.skillPerk:setEnabled(skills)
    self.skillAmount:setEditable(skills)
    Theme.setButtonEnabled(self.skillAdd, skills)
    Theme.setButtonEnabled(self.skillRemove, skills)
    self.xpPerk:setEnabled(xp)
    self.xpAmount:setEditable(xp)
    Theme.setButtonEnabled(self.xpAdd, xp)
    Theme.setButtonEnabled(self.xpRemove, xp)
    self.needKnown:disableOption(getText("IGUI_KBW_AdminEditorMustKnowRecipe"), not knowledge)
    self.recipeCombo:setEnabled(knowledge)
    Theme.setButtonEnabled(self.recipeAdd, knowledge)
    Theme.setButtonEnabled(self.recipeRemove, knowledge)
    Theme.setButtonEnabled(self.resetButton, definition ~= nil)
end

function KBWBuildableEditor:commitTime()
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    if not definition or not stage or not self.timeOverride:isSelected(1) then return true end
    local value = tonumber(self.timeEntry:getInternalText())
    if not value or value < 1 or value > 1000000 then
        self.timeEntry:setValid(false)
        self:setStatus(getText("IGUI_KBW_AdminEditorInvalidBuildTime"), "error")
        return false
    end
    self.timeEntry:setValid(true)
    local rule = stageRule(self.draft, definition, stage, true)
    if rule.time ~= value then
        rule.time = value
        self:markDirty()
    end
    return true
end

function KBWBuildableEditor:refreshPresetOptions(wantedFileName)
    local previous = comboData(self.presetCombo)
    if wantedFileName == nil and previous and previous.kind == "file" then
        wantedFileName = previous.fileName
    end
    self.presetCombo:clear()
    self.presetCombo:addOptionWithData(getText("IGUI_KBW_AdminEditorPresetServerCurrent"), {
        kind = "builtin",
        id = "server"
    })
    self.presetCombo:addOptionWithData(getText("IGUI_KBW_AdminEditorPresetDefinitionDefaults"), {
        kind = "builtin",
        id = "defaults"
    })
    self.presetCombo:addOptionWithData(getText("IGUI_KBW_AdminEditorPresetDisableAll"), {
        kind = "builtin",
        id = "disable_all"
    })
    local files = RulePresets.list()
    local selected = 1
    for fileIndex = 1, #files do
        local record = files[fileIndex]
        local key = record.valid and "IGUI_KBW_AdminEditorPresetFile" or "IGUI_KBW_AdminEditorPresetFileInvalid"
        local label = getText(key, tostring(record.name or record.fileName))
        if record.registryMismatch then label = label .. " *" end
        self.presetCombo:addOptionWithData(label, record)
        if wantedFileName ~= nil and record.fileName == wantedFileName then
            selected = self.presetCombo:getOptionCount()
        end
    end
    self.presetCombo.selected = selected
end

local function presetErrorText(code)
    local keys = {
        invalid_name = "IGUI_KBW_AdminEditorPresetNameRequired",
        invalid_file_name = "IGUI_KBW_AdminEditorPresetInvalidFile",
        file_not_found = "IGUI_KBW_AdminEditorPresetFileNotFound",
        file_too_large = "IGUI_KBW_AdminEditorPresetFileTooLarge",
        invalid_json = "IGUI_KBW_AdminEditorPresetInvalidJSON",
        unsupported_schema = "IGUI_KBW_AdminEditorPresetUnsupported",
        invalid_preset = "IGUI_KBW_AdminEditorPresetInvalidFile",
        invalid_rules = "IGUI_KBW_AdminEditorPresetInvalidRules",
        write_failed = "IGUI_KBW_AdminEditorPresetWriteFailed"
    }
    return getText(keys[tostring(code or "")] or "IGUI_KBW_AdminEditorPresetInvalidFile")
end

function KBWBuildableEditor:onRefreshPresets()
    RulePresets.clearCache()
    self:refreshPresetOptions()
    self:setStatus(
        getText("IGUI_KBW_AdminEditorPresetFilesRefreshed", "Zomboid/Lua/" .. RulePresets.FOLDER),
        "normal"
    )
end

function KBWBuildableEditor:onInfo()
    Guide.open(self.player, "admin_rules")
end

function KBWBuildableEditor:onLoadPreset()
    local selection = comboData(self.presetCombo)
    if not selection then
        self:setStatus(getText("IGUI_KBW_AdminEditorPresetNoSelection"), "error")
        return
    end
    local document, metadata
    if selection.kind == "builtin" then
        if selection.id == "server" then
            document = BuildableRules.getDocument()
        elseif selection.id == "defaults" then
            document = RulePresets.definitionDefaults()
        elseif selection.id == "disable_all" then
            document = RulePresets.disableAll()
        end
        metadata = { name = self.presetCombo:getOptionText(self.presetCombo.selected) }
    else
        if selection.valid == false then
            self:setStatus(presetErrorText(selection.errorCode), "error")
            return
        end
        local metadataOrError
        document, metadataOrError = RulePresets.read(selection.fileName)
        if not document then
            local code = type(metadataOrError) == "table" and metadataOrError.code or metadataOrError
            self:refreshPresetOptions(selection.fileName)
            self:setStatus(presetErrorText(code), "error")
            return
        end
        metadata = metadataOrError
        self.presetNameEntry:setText(tostring(metadata.name or ""))
        self:refreshPresetOptions(selection.fileName)
    end
    if not document then
        self:setStatus(getText("IGUI_KBW_AdminEditorPresetNoSelection"), "error")
        return
    end

    self.baseRevision = BuildableRules.revision
    self.serverChanged = false
    self.pendingSave = false
    self.draft = RulePresets.copyForDraft(document, self.baseRevision)
    self.dirty = true
    self:refreshBuildables(false)
    if metadata and metadata.registryMismatch then
        self:setStatus(
            getText("IGUI_KBW_AdminEditorPresetLoadedMismatch", tostring(metadata.name or selection.fileName)
            ), "warning"
        )
    else
        self:setStatus(
            getText("IGUI_KBW_AdminEditorPresetLoaded", tostring(metadata and metadata.name or "")),
            "warning"
        )
    end
end

function KBWBuildableEditor:onExportPreset()
    local name = trim(self.presetNameEntry:getInternalText())
    if name == "" then
        self:setStatus(getText("IGUI_KBW_AdminEditorPresetNameRequired"), "error")
        return
    end
    local normalized = self:validatedDraft()
    if not normalized then return end
    local path, errorCode, fileName = RulePresets.exportValidated(name, normalized)
    if not path then
        self:setStatus(presetErrorText(errorCode), "error")
        return
    end
    self:refreshPresetOptions(fileName)
    self:setStatus(getText("IGUI_KBW_AdminEditorPresetExported", path), "success")
end

function KBWBuildableEditor:validatedDraft()
    if not self:commitTime() then return end
    local normalized, errors = BuildableRules.validateDocument(self.draft)
    if not normalized then
        local message = errors[1] or getText("IGUI_KBW_AdminEditorValidationFailed")
        if #errors > 1 then message = message .. "<LINE>" .. errors[2] end
        self:setStatus(message, "error")
        return
    end
    return normalized
end

function KBWBuildableEditor:onValidate()
    local normalized = self:validatedDraft()
    if not normalized then return end
    self:setStatus(getText("IGUI_KBW_AdminEditorValidationPassed"), "success")
end

function KBWBuildableEditor:onSave()
    local normalized = self:validatedDraft()
    if not normalized then return end
    normalized.revision = self.baseRevision
    self.pendingSave = true
    self:setStatus(getText("IGUI_KBW_AdminEditorSaving"), "normal")
    if not BuildableRules.submit(self.player, normalized, self.baseRevision) then
        self.pendingSave = false
        self:setStatus(getText("IGUI_KBW_AdminEditorWriteFailed"), "error")
    end
end

function KBWBuildableEditor:onReload()
    self.dirty = false
    self.pendingSave = false
    self.draft = BuildableRules.getDocument()
    self.baseRevision = BuildableRules.revision
    self:refreshEditor()
    BuildableRules.request(self.player)
    self:setStatus(getText("IGUI_KBW_AdminEditorReloaded"), "normal")
end

function KBWBuildableEditor:onResetBuildable()
    local definition = self:selectedDefinition()
    if not definition then return end
    self.draft.buildables[definition.id] = nil
    self:markDirty()
    self:refreshEditor()
    self:setStatus(getText("IGUI_KBW_AdminEditorBuildableReset"), "warning")
end

function KBWBuildableEditor:onRulesSync(document, revision)
    if self.dirty and not self.pendingSave then
        if tonumber(revision) ~= tonumber(self.baseRevision) then
            self.serverChanged = true
            self:setStatus(getText("IGUI_KBW_AdminEditorServerChanged"), "warning")
        end
        return
    end
    self.pendingSave = false
    self.serverChanged = false
    self.dirty = false
    self.draft = TableUtil.copy(document)
    self.baseRevision = tonumber(revision) or 0
    self:refreshEditor()
    self:refreshBuildables(false)
    self:setStatus(getText("IGUI_KBW_AdminEditorSavedRevision", self.baseRevision), "success")
end

function KBWBuildableEditor:onRulesError(code, errors, revision)
    self.pendingSave = false
    if code == "conflict" then
        self.serverChanged = true
        self:setStatus(getText("IGUI_KBW_AdminEditorConflict"), "error")
    elseif code == "permission" then
        self:setStatus(getText("IGUI_KBW_AdminEditorPermissionDenied"), "error")
    elseif code == "write" then
        self:setStatus(getText("IGUI_KBW_AdminEditorWriteFailed"), "error")
    else
        self:setStatus((errors and errors[1]) or getText("IGUI_KBW_AdminEditorValidationFailed"), "error")
    end
    if revision then self.serverRevision = revision end
end

function KBWBuildableEditor:setStatus(message, kind)
    local color = "<RGB:0.92,0.91,0.88>"
    if kind == "error" then
        color = "<RGB:0.92,0.42,0.26>"
    elseif kind == "warning" then
        color = "<RGB:0.90,0.65,0.28>"
    elseif kind == "success" then
        color = "<RGB:0.25,0.90,0.32>"
    end
    self.statusPanel.text = color .. tostring(message or "")
    self.statusPanel:paginate()
end

function KBWBuildableEditor:layout()
    local titleH = self:titleBarHeight()
    local resizeH = self:resizeWidgetHeight()
    local presetY = titleH + PAD
    local presetPanelH = PAD + self.fontH + GAP + self.controlH * 2 + GAP + PAD
    local top = presetY + presetPanelH + GAP
    local bottomButtonsY = self.height - resizeH - PAD - self.actionH
    local statusY = bottomButtonsY - GAP - self.statusH
    local bodyBottom = statusY - GAP
    local leftW = math.max(300, math.floor((self.width - PAD * 2 - GAP) * 0.34))
    leftW = math.min(leftW, self.width - PAD * 2 - GAP - 480)
    local rightX = PAD + leftW + GAP
    local rightW = self.width - PAD - rightX

    local presetW = self.width - PAD * 2
    self.presetPanel:setX(PAD)
    self.presetPanel:setY(presetY)
    self.presetPanel:setWidth(presetW)
    self.presetPanel:setHeight(presetPanelH)
    self.presetTitle:setX(PAD)
    self.presetTitle:setY(PAD)
    self.presetTitle:setHeight(self.fontH)
    self.presetHint:setX(self.presetTitle:getRight() + GAP * 2)
    self.presetHint:setY(PAD)
    self.presetHint:setHeight(self.fontH)
    self.presetHint:setVisible(self.presetHint:getRight() <= presetW - PAD)

    local presetRowOneY = PAD + self.fontH + GAP
    local presetButtonW = math.max(90, self.fontH * 4)
    local importW = math.max(
        presetButtonW, getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_KBW_AdminEditorPresetRefresh")) + 24
    )
    local loadW = math.max(
        presetButtonW, getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_KBW_AdminEditorPresetLoad")) + 24
    )
    self.refreshPresetsButton:setX(presetW - PAD - importW)
    self.refreshPresetsButton:setY(presetRowOneY)
    self.refreshPresetsButton:setWidth(importW)
    self.loadPresetButton:setX(self.refreshPresetsButton:getX() - GAP - loadW)
    self.loadPresetButton:setY(presetRowOneY)
    self.loadPresetButton:setWidth(loadW)
    self.presetCombo:setX(PAD)
    self.presetCombo:setY(presetRowOneY)
    self.presetCombo:setWidth(self.loadPresetButton:getX() - GAP - PAD)

    local presetRowTwoY = presetRowOneY + self.controlH + GAP
    local exportW = math.max(
        presetButtonW, getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_KBW_AdminEditorPresetExport")) + 24
    )
    self.exportPresetButton:setX(presetW - PAD - exportW)
    self.exportPresetButton:setY(presetRowTwoY)
    self.exportPresetButton:setWidth(exportW)
    self.presetNameEntry:setX(PAD)
    self.presetNameEntry:setY(presetRowTwoY)
    self.presetNameEntry:setWidth(self.exportPresetButton:getX() - GAP - PAD)

    self.searchEntry:setX(PAD)
    self.searchEntry:setY(top)
    self.searchEntry:setWidth(leftW)
    self.categoryFilter:setX(PAD)
    self.categoryFilter:setY(top + self.controlH + GAP)
    self.categoryFilter:setWidth(math.floor((leftW - GAP) / 2))
    self.subcategoryFilter:setX(self.categoryFilter:getRight() + GAP)
    self.subcategoryFilter:setY(self.categoryFilter:getY())
    self.subcategoryFilter:setWidth(leftW - self.categoryFilter:getWidth() - GAP)
    self.buildableList:setX(PAD)
    self.buildableList:setY(self.categoryFilter:getBottom() + GAP)
    self.buildableList:setWidth(leftW)
    self.buildableList:setHeight(bodyBottom - self.buildableList:getY())

    self.stageCombo:setX(rightX)
    self.stageCombo:setY(top)
    self.stageCombo:setWidth(rightW)
    local tabsY = top + self.controlH + GAP
    local preferredTabsW = GAP * (#self.tabButtons - 1)
    for tabIndex = 1, #self.tabButtons do
        preferredTabsW = preferredTabsW + self.tabButtons[tabIndex].kbwPreferredWidth
    end
    local tabExtra = math.max(0, math.floor((rightW - preferredTabsW) / #self.tabButtons))
    local tabX = rightX
    for tabIndex = 1, #self.tabButtons do
        local button = self.tabButtons[tabIndex]
        button:setX(tabX)
        button:setY(tabsY)
        button:setWidth(
            tabIndex == #self.tabButtons and rightX + rightW - button:getX() or button.kbwPreferredWidth + tabExtra
        )
        tabX = button:getRight() + GAP
    end
    local contentY = tabsY + self.actionH + GAP + self.fontH + 4
    local contentH = bodyBottom - contentY
    self.contentLabelY = tabsY + self.actionH + GAP
    self.rightX, self.rightW = rightX, rightW

    local labelW = math.max(180, math.floor(rightW * 0.34))
    local controlX = rightX + labelW
    local controlW = rightW - labelW
    self.categoryPolicy:setX(controlX)
    self.categoryPolicy:setY(contentY)
    self.categoryPolicy:setWidth(controlW)
    self.subcategoryPolicy:setX(controlX)
    self.subcategoryPolicy:setY(contentY + self.controlH + GAP)
    self.subcategoryPolicy:setWidth(controlW)
    self.buildablePolicy:setX(controlX)
    self.buildablePolicy:setY(contentY + (self.controlH + GAP) * 2)
    self.buildablePolicy:setWidth(controlW)
    self.timeOverride:setX(rightX)
    self.timeOverride:setY(contentY + (self.controlH + GAP) * 3 + GAP)
    self.timeOverride:setWidth(labelW)
    self.timeEntry:setX(controlX)
    self.timeEntry:setY(self.timeOverride:getY())
    self.timeEntry:setWidth(controlW)

    self.finishHeadersY = contentY
    self.finishHintY = self.finishHeadersY + self.fontH + 2
    local finishRowsY = self.finishHintY + self.fontH + GAP
    local finishLabelW = math.max(110, math.floor(rightW * 0.23))
    local finishComboW = math.floor((rightW - finishLabelW - GAP * 2) / 2)
    self.finishDefaultsX = rightX + finishLabelW
    self.finishOverridesX = self.finishDefaultsX + finishComboW + GAP
    local finishRequirements = { "plaster", "paint", "wallpaper" }
    for requirementIndex = 1, #finishRequirements do
        local requirement = finishRequirements[requirementIndex]
        local rowY = finishRowsY + (requirementIndex - 1) * (self.controlH + GAP)
        local defaultCombo = self.wallFinishDefaults[requirement]
        defaultCombo:setX(self.finishDefaultsX)
        defaultCombo:setY(rowY)
        defaultCombo:setWidth(finishComboW)
        local overrideCombo = self.wallFinishOverrides[requirement]
        overrideCombo:setX(self.finishOverridesX)
        overrideCombo:setY(rowY)
        overrideCombo:setWidth(rightX + rightW - self.finishOverridesX)
    end
    self.finishNoteY = self.wallFinishOverrides.wallpaper:getBottom() + GAP

    self.inputsOverride:setX(rightX)
    self.inputsOverride:setY(contentY)
    self.inputsOverride:setWidth(rightW)
    local inputFormH = (self.fontH + 3) * 4 + self.controlH * 4 + GAP * 5 + self.actionH
    local inputListH = math.max(self.rowH * 2, contentH - self.controlH - GAP - inputFormH)
    self.inputList:setX(rightX)
    self.inputList:setY(contentY + self.controlH + GAP)
    self.inputList:setWidth(rightW)
    self.inputList:setHeight(inputListH)
    local formY = self.inputList:getBottom() + GAP + self.fontH + 3
    local halfW = math.floor((rightW - GAP) / 2)
    self.inputId:setX(rightX)
    self.inputId:setY(formY)
    self.inputId:setWidth(halfW)
    self.inputRole:setX(rightX + halfW + GAP)
    self.inputRole:setY(formY)
    self.inputRole:setWidth(rightW - halfW - GAP)
    formY = formY + self.controlH + GAP + self.fontH + 3
    self.inputMode:setX(rightX)
    self.inputMode:setY(formY)
    self.inputMode:setWidth(halfW)
    self.inputSource:setX(rightX + halfW + GAP)
    self.inputSource:setY(formY)
    self.inputSource:setWidth(rightW - halfW
            - GAP)
    formY = formY + self.controlH + GAP + self.fontH + 3
    self.inputValues:setX(rightX)
    self.inputValues:setY(formY)
    self.inputValues:setWidth(rightW - 120 - GAP)
    self.inputAmount:setX(self.inputValues:getRight() + GAP)
    self.inputAmount:setY(formY)
    self.inputAmount:setWidth(120)
    formY = formY + self.controlH + GAP + self.fontH + 3
    self.inputHand:setX(rightX)
    self.inputHand:setY(formY)
    self.inputHand:setWidth(halfW)
    self.inputDegrade:setX(rightX + halfW + GAP)
    self.inputDegrade:setY(formY)
    self.inputDegrade:setWidth(rightW - halfW
            - GAP)
    local inputButtonY = math.min(bodyBottom - self.actionH, formY + self.controlH + GAP)
    local inputButtonW = math.floor((rightW - GAP * 2) / 3)
    local inputButtons = { self.inputAdd, self.inputUpdate, self.inputRemove }
    for buttonIndex = 1, #inputButtons do
        local button = inputButtons[buttonIndex]
        button:setX(rightX + (buttonIndex - 1) * (inputButtonW + GAP))
        button:setY(inputButtonY)
        button:setWidth(buttonIndex == #inputButtons and rightX + rightW - button:getX() or inputButtonW)
    end
    self.inputLabels = {
        idY = self.inputId:getY() - self.fontH - 1,
        modeY = self.inputMode:getY() - self.fontH - 1,
        sourceY = self.inputValues:getY() - self.fontH - 1,
        flagsY = self.inputHand:getY() - self.fontH - 1
    }

    local sectionH = math.floor((contentH - GAP) / 2)
    self.skillsOverride:setX(rightX)
    self.skillsOverride:setY(contentY)
    self.skillsOverride:setWidth(rightW)
    self.skillList:setX(rightX)
    self.skillList:setY(contentY + self.controlH + GAP)
    self.skillList:setWidth(math.floor(rightW * 0.55))
    self.skillList:setHeight(sectionH - self.controlH
            - GAP)
    local perkControlX = self.skillList:getRight() + GAP
    local perkControlW = rightX + rightW - perkControlX
    self.skillPerk:setX(perkControlX)
    self.skillPerk:setY(self.skillList:getY())
    self.skillPerk:setWidth(perkControlW)
    self.skillAmount:setX(perkControlX)
    self.skillAmount:setY(self.skillPerk:getBottom() + GAP)
    self.skillAmount:setWidth(perkControlW)
    self.skillAdd:setX(perkControlX)
    self.skillAdd:setY(self.skillAmount:getBottom() + GAP)
    self.skillAdd:setWidth(perkControlW)
    self.skillRemove:setX(perkControlX)
    self.skillRemove:setY(self.skillAdd:getBottom() + GAP)
    self.skillRemove:setWidth(perkControlW)
    local xpY = contentY + sectionH + GAP
    self.xpOverride:setX(rightX)
    self.xpOverride:setY(xpY)
    self.xpOverride:setWidth(rightW)
    self.xpList:setX(rightX)
    self.xpList:setY(xpY + self.controlH + GAP)
    self.xpList:setWidth(self.skillList:getWidth())
    self.xpList:setHeight(bodyBottom - self.xpList:getY())
    self.xpPerk:setX(perkControlX)
    self.xpPerk:setY(self.xpList:getY())
    self.xpPerk:setWidth(perkControlW)
    self.xpAmount:setX(perkControlX)
    self.xpAmount:setY(self.xpPerk:getBottom() + GAP)
    self.xpAmount:setWidth(perkControlW)
    self.xpAdd:setX(perkControlX)
    self.xpAdd:setY(self.xpAmount:getBottom() + GAP)
    self.xpAdd:setWidth(perkControlW)
    self.xpRemove:setX(perkControlX)
    self.xpRemove:setY(self.xpAdd:getBottom() + GAP)
    self.xpRemove:setWidth(perkControlW)

    self.knowledgeOverride:setX(rightX)
    self.knowledgeOverride:setY(contentY)
    self.knowledgeOverride:setWidth(rightW)
    self.needKnown:setX(rightX)
    self.needKnown:setY(contentY + self.controlH + GAP)
    self.needKnown:setWidth(rightW)
    self.recipeList:setX(rightX)
    self.recipeList:setY(self.needKnown:getBottom() + GAP)
    self.recipeList:setWidth(rightW)
    self.recipeList:setHeight(math.max(
            self.rowH * 4,
            contentH - self.controlH * 3
                - self.actionH - GAP * 5
        ))
    self.recipeCombo:setX(rightX)
    self.recipeCombo:setY(self.recipeList:getBottom() + GAP)
    self.recipeCombo:setWidth(rightW)
    local recipeButtonW = math.floor((rightW - GAP) / 2)
    self.recipeAdd:setX(rightX)
    self.recipeAdd:setY(self.recipeCombo:getBottom() + GAP)
    self.recipeAdd:setWidth(recipeButtonW)
    self.recipeRemove:setX(self.recipeAdd:getRight() + GAP)
    self.recipeRemove:setY(self.recipeAdd:getY())
    self.recipeRemove:setWidth(rightW - recipeButtonW
            - GAP)

    self.statusPanel:setX(PAD)
    self.statusPanel:setY(statusY)
    self.statusPanel:setWidth(self.width - PAD * 2)
    self.statusPanel:setHeight(self.statusH)
    local buttons = { self.reloadButton, self.resetButton, self.validateButton, self.saveButton }
    local buttonW = math.floor((self.width - PAD * 2 - GAP * 3) / 4)
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:setX(PAD + (buttonIndex - 1) * (buttonW + GAP))
        button:setY(bottomButtonsY)
        button:setWidth(buttonIndex == #buttons and self.width - PAD - button:getX() or buttonW)
    end
    self.lastLayoutWidth, self.lastLayoutHeight = self.width, self.height
end

function KBWBuildableEditor:prerender()
    if self.width ~= self.lastLayoutWidth or self.height ~= self.lastLayoutHeight then self:layout() end
    ISCollapsableWindow.prerender(self)
    local definition, stage = self:selectedDefinition(), self:selectedStage()
    local header = definition and I18n.definitionName(definition) or getText("IGUI_KBW_AdminEditorNoSelection")
    self:drawText(
        header, self.rightX, self.contentLabelY, Theme.accent.r, Theme.accent.g, Theme.accent.b, 1, UIFont.Small
    )
    if self.activeTab == "availability" and definition then
        local y = self.categoryPolicy:getY() + 3
        self:drawText(
            getText("IGUI_KBW_AdminEditorCategoryPolicy"), self.rightX, y, Theme.text.r, Theme.text.g, Theme.text.b, 1,
            UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorSubcategoryPolicy"), self.rightX, y + self.controlH + GAP, Theme.text.r,
            Theme.text.g, Theme.text.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorBuildablePolicy"), self.rightX, y + (self.controlH + GAP) * 2, Theme.text.r,
            Theme.text.g, Theme.text.b, 1, UIFont.Small
        )
        local effective = BuildableRules.isEnabledIn(self.draft, definition, stage)
        local effectiveText = getText("IGUI_KBW_AdminEditorEffectiveStatus", inheritedPolicyText(effective)
        )
        local color = effective and Theme.good or Theme.bad
        self:drawText(
            effectiveText, self.rightX, self.timeOverride:getBottom() + GAP, color.r, color.g, color.b, 1, UIFont.Small
        )
    elseif self.activeTab == "requirements" then
        local labels = self.inputLabels
        self:drawText(
            getText("IGUI_KBW_AdminEditorInputId"), self.inputId:getX(), labels.idY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorRole"), self.inputRole:getX(), labels.idY, Theme.textMuted.r, Theme.textMuted.g,
            Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorMode"), self.inputMode:getX(), labels.modeY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorSourceType"), self.inputSource:getX(), labels.modeY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorAcceptedValues"), self.inputValues:getX(), labels.sourceY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorAmountUses"), self.inputAmount:getX(), labels.sourceY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorHandModel"), self.inputHand:getX(), labels.flagsY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorToolWear"), self.inputDegrade:getX(), labels.flagsY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
    elseif self.activeTab == "finishes" then
        self:drawText(
            getText("IGUI_KBW_AdminEditorWallFinishDefaults"), self.finishDefaultsX, self.finishHeadersY, Theme.accent.r,
            Theme.accent.g, Theme.accent.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorWallFinishOverrides"), self.finishOverridesX, self.finishHeadersY,
            Theme.accent.r, Theme.accent.g, Theme.accent.b, 1, UIFont.Small
        )
        self:drawText(
            getText("IGUI_KBW_AdminEditorWallFinishDefaultsHint"), self.rightX, self.finishHintY, Theme.textMuted.r,
            Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
        )
        local labels = {
            plaster = "IGUI_KBW_AdminEditorFinishPlaster",
            paint = "IGUI_KBW_AdminEditorFinishPaint",
            wallpaper = "IGUI_KBW_AdminEditorFinishWallpaper"
        }
        local finishRequirements = { "plaster", "paint", "wallpaper" }
        for requirementIndex = 1, #finishRequirements do
            local requirement = finishRequirements[requirementIndex]
            local defaultCombo = self.wallFinishDefaults[requirement]
            self:drawText(
                getText(labels[requirement]), self.rightX, defaultCombo:getY() + 3, Theme.text.r, Theme.text.g,
                Theme.text.b, 1, UIFont.Small
            )
        end
        local overrideHint = BuildableRules.isWallBuildable(definition, stage)
            and getText("IGUI_KBW_AdminEditorWallFinishOverridesHint")
            or getText("IGUI_KBW_AdminEditorWallFinishNotWall")
        self:drawText(
            overrideHint, self.rightX, self.finishNoteY, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1,
            UIFont.Small
        )
        for requirementIndex = 1, #finishRequirements do
            local requirement = finishRequirements[requirementIndex]
            local overrideCombo = self.wallFinishOverrides[requirement]
            self:drawText(
                getText(labels[requirement]), self.rightX, overrideCombo:getY() + 3, Theme.text.r, Theme.text.g,
                Theme.text.b, 1, UIFont.Small
            )
        end
    end
end

function KBWBuildableEditor:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if KBWBuildableEditor.instance == self then KBWBuildableEditor.instance = nil end
end

function KBWBuildableEditor:isKeyConsumed(key)
    return Keyboard and key == Keyboard.KEY_ESCAPE
end

function KBWBuildableEditor:onKeyRelease(key)
    if self:isVisible() and self:isKeyConsumed(key) then
        self:close()
        return
    end
end

function KBWBuildableEditor:new(player)
    local screenW, screenH = getCore():getScreenWidth(), getCore():getScreenHeight()
    local fontH = getTextManager():getFontHeight(UIFont.Small)
    local tabAreaW = GAP * (#TAB_TEXT_KEYS - 1)
    for keyIndex = 1, #TAB_TEXT_KEYS do
        tabAreaW = tabAreaW
            + math.max(76, getTextManager():MeasureStringX(UIFont.Small, getText(TAB_TEXT_KEYS[keyIndex])) + 24)
    end
    local minimumW = math.min(math.max(1000, 300 + PAD * 2 + GAP + tabAreaW), screenW - 40)
    local minimumH = math.min(math.max(600, fontH * 8 + 440), screenH - 40)
    local width = math.min(screenW - 60, math.max(minimumW, math.floor(screenW * 0.58)))
    local height = math.min(screenH - 60, math.max(minimumH, math.floor(screenH * 0.64)))
    local o = ISCollapsableWindow:new(
        math.floor((screenW - width) / 2), math.floor((screenH - height) / 2), width, height
    )
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.title = getText("IGUI_KBW_AdminEditorTitle")
    o.resizable = true
    o.fontH = fontH
    o.controlH = math.max(28, fontH + 10)
    o.actionH = math.max(30, fontH + 10)
    o.rowH = math.max(48, fontH * 2 + 12)
    o.statusH = math.max(52, fontH * 2 + 12)
    o.minimumWidth = minimumW
    o.minimumHeight = minimumH
    o:setWantKeyEvents(true)
    return o
end

function KBWBuildableEditor.open(player)
    if not player or not AccessLevelUtils.hasAdminAccess(player) then return end
    if KBWBuildableEditor.instance then KBWBuildableEditor.instance:close() end
    local ui = KBWBuildableEditor:new(player)
    ui:initialise()
    ui:addToUIManager()
    ui:setAlwaysOnTop(true)
    KBWBuildableEditor.instance = ui
    return ui
end

return KBWBuildableEditor
