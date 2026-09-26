require("ISUI/ISCollapsableWindow")
require("ISUI/ISScrollingListBox")
require("ISUI/ISComboBox")
require("ISUI/ISButton")
require("ISUI/ISTextEntryBox")
require("ISUI/ISRichTextPanel")

local BuildTestRunner = require("KnoxBuildworks/Debug/BuildTestRunner")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local I18n = require("KnoxBuildworks/I18n")
local Theme = require("KnoxBuildworks/UI/Theme")
local VirtualListBox = require("KnoxBuildworks/UI/VirtualListBox")

KBWDebugBuildTestWindow = ISCollapsableWindow:derive("KBWDebugBuildTestWindow")
KBWDebugBuildTestWindow.instance = nil

local PADDING = 10
local GAP = 7
local CONTROL_H = 26
local ACTION_H = 30
local LIST_MIN_W = 310
local DETAIL_MIN_W = 330

local function comboData(combo)
    return combo and combo:getOptionData(combo.selected) or nil
end

local function addComboOption(combo, text, data)
    combo:addOptionWithData(text, data)
end

local function chooseComboData(combo, wanted)
    for optionIndex = 1, #combo.options do
        if combo:getOptionData(optionIndex) == wanted then
            combo.selected = optionIndex
            return
        end
    end
    combo.selected = 1
end

local function makeButton(parent, text, callback, primary)
    local button = ISButton:new(0, 0, 100, ACTION_H, text, parent, callback)
    button:initialise()
    button:instantiate()
    Theme.applyActionButton(button, true, primary == true)
    parent:addChild(button)
    return button
end

local function resultColor(status)
    if status == "passed" then return Theme.good end
    if status == "failed" then return Theme.bad end
    if status == "skipped" then return Theme.warn end
    return Theme.textMuted
end

local function statusLabel(status)
    if status == "passed" then return getText("IGUI_KBW_DebugTestPassed") end
    if status == "failed" then return getText("IGUI_KBW_DebugTestFailed") end
    if status == "skipped" then return getText("IGUI_KBW_DebugTestSkipped") end
    return getText("IGUI_KBW_DebugTestPending")
end

local function itemName(fullType)
    local scriptItem = ScriptManager.instance:getItem(fullType)
    return scriptItem and scriptItem:getDisplayName() or fullType
end

function KBWDebugBuildTestWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    local titleHeight = self:titleBarHeight()

    self.categoryCombo = ISComboBox:new(PADDING, titleHeight + PADDING, 230, CONTROL_H, self, self.onFilterChanged)
    self.categoryCombo:initialise()
    self:addChild(self.categoryCombo)

    self.subcategoryCombo = ISComboBox:new(0, titleHeight + PADDING, 230, CONTROL_H, self, self.onFilterChanged)
    self.subcategoryCombo:initialise()
    self:addChild(self.subcategoryCombo)

    self.resultCombo = ISComboBox:new(0, titleHeight + PADDING, 140, CONTROL_H, self, self.onFilterChanged)
    self.resultCombo:initialise()
    self:addChild(self.resultCombo)

    self.caseList = VirtualListBox:new(PADDING, 0, LIST_MIN_W, 400)
    self.caseList:initialise()
    self.caseList:instantiate()
    self.caseList.itemheight = 48
    self.caseList.font = UIFont.Small
    self.caseList.drawBorder = true
    self.caseList.doDrawItem = self.drawCase
    self.caseList:setOnMouseDownFunction(self, self.onCaseSelected)
    self:addChild(self.caseList)

    self.details = ISRichTextPanel:new(0, 0, DETAIL_MIN_W, 300)
    self.details:initialise()
    self.details:instantiate()
    self.details.background = true
    self.details.backgroundColor = Theme.color(Theme.surface)
    self.details.borderColor = Theme.color(Theme.borderSoft)
    self.details.marginLeft = 12
    self.details.marginRight = 12
    self.details.marginTop = 10
    self.details.marginBottom = 10
    self.details.autosetheight = false
    self.details:addScrollBars()
    self:addChild(self.details)

    self.noteEntry = ISTextEntryBox:new("", 0, 0, 300, CONTROL_H)
    self.noteEntry:initialise()
    self.noteEntry:instantiate()
    self.noteEntry:setClearButton(true)
    self:addChild(self.noteEntry)

    self.prepareButton = makeButton(self, getText("IGUI_KBW_DebugTestPrepare"), self.onPrepare, true)
    self.passButton = makeButton(self, getText("IGUI_KBW_DebugTestPass"), self.onPass, false)
    self.failButton = makeButton(self, getText("IGUI_KBW_DebugTestFail"), self.onFail, false)
    self.skipButton = makeButton(self, getText("IGUI_KBW_DebugTestSkip"), self.onSkip, false)
    self.continueButton = makeButton(self, getText("IGUI_KBW_DebugTestContinue"), self.onContinue, true)
    self.resetButton = makeButton(self, getText("IGUI_KBW_DebugTestResetScope"), self.onResetScope, false)

    self.cases = BuildTestRunner.cases()
    self:populateFilters()
    self:refreshCases(true)
    self:layout()
end

function KBWDebugBuildTestWindow:populateFilters()
    local state = BuildTestRunner.state(self.player)
    self.categoryCombo:clear()
    local categories = BuildTestRunner.categories(self.cases)
    for categoryIndex = 1, #categories do
        local category = categories[categoryIndex]
        addComboOption(self.categoryCombo,
            category == "All" and getText("IGUI_KBW_AllCategories") or I18n.category(category), category)
    end
    chooseComboData(self.categoryCombo, state.category)
    self:populateSubcategories()

    self.resultCombo:clear()
    addComboOption(self.resultCombo, getText("IGUI_KBW_DebugTestAllResults"), "All")
    addComboOption(self.resultCombo, getText("IGUI_KBW_DebugTestPending"), "Pending")
    addComboOption(self.resultCombo, getText("IGUI_KBW_DebugTestPassed"), "Passed")
    addComboOption(self.resultCombo, getText("IGUI_KBW_DebugTestFailed"), "Failed")
    addComboOption(self.resultCombo, getText("IGUI_KBW_DebugTestSkipped"), "Skipped")
    chooseComboData(self.resultCombo, state.resultFilter)
end

function KBWDebugBuildTestWindow:populateSubcategories()
    local state = BuildTestRunner.state(self.player)
    local category = comboData(self.categoryCombo) or state.category or "All"
    self.subcategoryCombo:clear()
    local subcategories = BuildTestRunner.subcategories(self.cases, category)
    for subcategoryIndex = 1, #subcategories do
        local subcategory = subcategories[subcategoryIndex]
        addComboOption(self.subcategoryCombo,
            subcategory == "All" and getText("IGUI_KBW_DebugTestAllSubcategories")
                or I18n.subcategory(subcategory), subcategory)
    end
    chooseComboData(self.subcategoryCombo, state.subcategory)
end

function KBWDebugBuildTestWindow:onFilterChanged(combo)
    local state = BuildTestRunner.state(self.player)
    if combo == self.categoryCombo then
        state.category = comboData(self.categoryCombo) or "All"
        state.subcategory = "All"
        self:populateSubcategories()
    else
        state.subcategory = comboData(self.subcategoryCombo) or "All"
        state.resultFilter = comboData(self.resultCombo) or "All"
    end
    if isClient() and self.player.transmitModData then self.player:transmitModData() end
    self:refreshCases(true)
end

function KBWDebugBuildTestWindow:refreshCases(selectCurrent)
    local state = BuildTestRunner.state(self.player)
    local selectedKey = selectCurrent and state.currentKey
        or (self:selectedCase() and self:selectedCase().key or state.currentKey)
    self.filteredCases = BuildTestRunner.filteredCases(self.player, self.cases)
    local rows = {}
    local selectedIndex = 0
    for caseIndex = 1, #self.filteredCases do
        local testCase = self.filteredCases[caseIndex]
        rows[caseIndex] = { name = BuildTestRunner.caseName(testCase), testCase = testCase }
        if testCase.key == selectedKey then selectedIndex = caseIndex end
    end
    self.caseList:replaceItems(rows, "name", "testCase")
    if selectedIndex == 0 and #self.filteredCases > 0 then selectedIndex = 1 end
    self.caseList.selected = selectedIndex
    self:refreshDetails()
end

function KBWDebugBuildTestWindow:selectedCase()
    local selected = self.caseList and self.caseList.items[self.caseList.selected] or nil
    return selected and selected.item or nil
end

function KBWDebugBuildTestWindow:drawCase(y, item, alt)
    local testCase = item.item
    local state = BuildTestRunner.state(self.parent.player)
    local result = state.results[testCase.key]
    local status = result and result.status or "pending"
    if self.selected == item.index then
        self:drawRect(0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r,
            Theme.selected.g, Theme.selected.b)
    elseif alt then
        self:drawRect(0, y, self.width, self.itemheight - 1, 0.22, Theme.surfaceRaised.r,
            Theme.surfaceRaised.g, Theme.surfaceRaised.b)
    end
    self:drawRectBorder(0, y, self.width, self.itemheight - 1, Theme.borderSoft.a, Theme.borderSoft.r,
        Theme.borderSoft.g, Theme.borderSoft.b)
    local color = resultColor(status)
    self:drawRect(8, y + 9, 6, 6, 1, color.r, color.g, color.b)
    self:drawText(item.text, 22, y + 5, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    local path = I18n.category(testCase.category) .. " / " .. I18n.subcategory(testCase.subcategory)
    self:drawText(path, 22, y + 25, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small)
    return y + self.itemheight
end

function KBWDebugBuildTestWindow:onCaseSelected()
    self:refreshDetails()
end

function KBWDebugBuildTestWindow:detailsText(testCase)
    if not testCase then return "<CENTRE>" .. getText("IGUI_KBW_DebugTestNoSelection") end
    local state = BuildTestRunner.state(self.player)
    local result = state.results[testCase.key]
    local status = result and result.status or "pending"
    local passed, failed, skipped, pending = 0, 0, 0, 0
    local scope = BuildTestRunner.scopeCases(self.player, self.cases)
    for caseIndex = 1, #scope do
        local caseResult = state.results[scope[caseIndex].key]
        local caseStatus = caseResult and caseResult.status or "pending"
        if caseStatus == "passed" then passed = passed + 1
        elseif caseStatus == "failed" then failed = failed + 1
        elseif caseStatus == "skipped" then skipped = skipped + 1
        else pending = pending + 1 end
    end
    local lines = {
        "<H1>" .. BuildTestRunner.caseName(testCase),
        "<RGB:0.72,0.70,0.64>" .. testCase.buildableId,
        "<LINE><RGB:0.92,0.91,0.88>" .. getText("IGUI_KBW_DebugTestStatus") .. ": " .. statusLabel(status),
        "<LINE>" .. getText("IGUI_KBW_DebugTestProgress", passed, failed, skipped, pending),
        "<LINE>" .. getText("IGUI_KBW_Category") .. ": " .. I18n.category(testCase.category),
        "<LINE>" .. getText("IGUI_KBW_Subcategory") .. ": " .. I18n.subcategory(testCase.subcategory),
        "<LINE>" .. getText("IGUI_KBW_DebugTestStage") .. ": " .. tostring(testCase.stageId)
    }
    if testCase.variantId ~= "" then
        lines[#lines + 1] = "<LINE>" .. getText("IGUI_KBW_Variant") .. ": " .. testCase.variantId
    end
    if testCase.materialId ~= "" then
        lines[#lines + 1] = "<LINE>" .. getText("IGUI_KBW_Material") .. ": " .. testCase.materialId
    end
    lines[#lines + 1] = " <LINE> <LINE> <H2>" .. getText("IGUI_KBW_DebugTestExpectedInputs")
    local inputs = Requirements.getInputs(testCase.definition, testCase.stage)
    if #inputs == 0 then lines[#lines + 1] = "<LINE>" .. getText("IGUI_KBW_DebugTestNoInputs") end
    for inputIndex = 1, #inputs do
        local input = inputs[inputIndex]
        local possible = Requirements.possibleItems(input)
        local fullType = (input.items or {})[1] or possible[1]
        local amount = tonumber(input.uses or input.amount) or 1
        local unit = input.uses and getText("IGUI_KBW_Uses") or getText("IGUI_KBW_Items")
        lines[#lines + 1] = "<LINE>" .. tostring(amount) .. " " .. unit .. " - "
            .. (fullType and itemName(fullType) or tostring(input.id)) .. " (" .. tostring(input.mode or "consume") .. ")"
    end
    if result and result.note and result.note ~= "" then
        lines[#lines + 1] = " <LINE> <LINE> <H2>" .. getText("IGUI_KBW_DebugTestNote")
        lines[#lines + 1] = "<LINE>" .. result.note
    end
    if state.currentKey == testCase.key and state.prepared then
        lines[#lines + 1] = " <LINE> <LINE> <RGB:0.58,0.85,0.55>" .. getText("IGUI_KBW_DebugTestPreparedHint")
        local totals = {}
        local order = {}
        local spawned = state.prepared.spawned or {}
        for spawnedIndex = 1, #spawned do
            local entry = spawned[spawnedIndex]
            local total = totals[entry.fullType]
            if not total then
                total = { count = 0, units = 0 }
                totals[entry.fullType] = total
                order[#order + 1] = entry.fullType
            end
            total.count = total.count + 1
            total.units = total.units + (tonumber(entry.supplied) or 0)
        end
        lines[#lines + 1] = " <LINE> <LINE> <H2>" .. getText("IGUI_KBW_DebugTestSpawned")
        for typeIndex = 1, #order do
            local fullType = order[typeIndex]
            local total = totals[fullType]
            lines[#lines + 1] = "<LINE>" .. tostring(total.count) .. "x " .. itemName(fullType)
                .. " (" .. tostring(total.units) .. " " .. getText("IGUI_KBW_DebugTestUnits") .. ")"
        end
    end
    return table.concat(lines, "")
end

function KBWDebugBuildTestWindow:refreshDetails(message)
    local testCase = self:selectedCase()
    self.details.text = self:detailsText(testCase)
    if message and message ~= "" then
        self.details.text = self.details.text .. " <LINE> <LINE> <RGB:0.95,0.55,0.32>" .. tostring(message)
    end
    self.details:paginate()
    local hasSelection = testCase ~= nil
    Theme.applyActionButton(self.prepareButton, hasSelection, true)
    Theme.applyActionButton(self.passButton, hasSelection, false)
    Theme.applyActionButton(self.failButton, hasSelection, false)
    Theme.applyActionButton(self.skipButton, hasSelection, false)
    Theme.applyActionButton(self.continueButton, #self.filteredCases > 0, true)
end

function KBWDebugBuildTestWindow:onPrepare()
    local testCase = self:selectedCase()
    local ok, reason = BuildTestRunner.prepare(self.player, testCase)
    self:refreshDetails(ok and getText("IGUI_KBW_DebugTestPlaceNow") or reason)
end

function KBWDebugBuildTestWindow:record(status)
    local testCase = self:selectedCase()
    if not testCase then return end
    BuildTestRunner.record(self.player, testCase, status, self.noteEntry:getInternalText())
    self.noteEntry:setText("")
    self:refreshCases(false)
end

function KBWDebugBuildTestWindow:onPass()
    self:record("passed")
end

function KBWDebugBuildTestWindow:onFail()
    self:record("failed")
end

function KBWDebugBuildTestWindow:onSkip()
    self:record("skipped")
end

function KBWDebugBuildTestWindow:onContinue()
    local state = BuildTestRunner.state(self.player)
    local nextCase = BuildTestRunner.firstPending(self.player, self.filteredCases, state.currentKey)
    if not nextCase then
        self:refreshDetails(getText("IGUI_KBW_DebugTestScopeComplete"))
        return
    end
    for caseIndex = 1, #self.caseList.items do
        if self.caseList.items[caseIndex].item.key == nextCase.key then
            self.caseList.selected = caseIndex
            break
        end
    end
    self:onPrepare()
end

function KBWDebugBuildTestWindow:onResetScope()
    BuildTestRunner.resetScope(self.player, BuildTestRunner.scopeCases(self.player, self.cases))
    self:refreshCases(true)
end

function KBWDebugBuildTestWindow:layout()
    local titleHeight = self:titleBarHeight()
    local resizeHeight = self:resizeWidgetHeight()
    local contentTop = titleHeight + PADDING
    local noteLabelHeight = getTextManager():getFontHeight(UIFont.Small) + 3
    local comboWidth = math.max(130, math.floor((self.width - PADDING * 2 - GAP * 2) / 3))
    self.categoryCombo:setX(PADDING)
    self.categoryCombo:setWidth(comboWidth)
    self.subcategoryCombo:setX(self.categoryCombo:getRight() + GAP)
    self.subcategoryCombo:setWidth(comboWidth)
    self.resultCombo:setX(self.subcategoryCombo:getRight() + GAP)
    self.resultCombo:setWidth(self.width - PADDING - self.resultCombo:getX())

    local bodyTop = contentTop + CONTROL_H + GAP
    local buttonY = self.height - resizeHeight - PADDING - ACTION_H
    local noteY = buttonY - GAP - CONTROL_H
    local noteLabelY = noteY - noteLabelHeight
    local bodyHeight = math.max(160, noteLabelY - GAP - bodyTop)
    local leftWidth = math.max(LIST_MIN_W, math.floor((self.width - PADDING * 2 - GAP) * 0.43))
    leftWidth = math.min(leftWidth, self.width - PADDING * 2 - GAP - DETAIL_MIN_W)
    self.caseList:setX(PADDING)
    self.caseList:setY(bodyTop)
    self.caseList:setWidth(leftWidth)
    self.caseList:setHeight(bodyHeight)
    self.details:setX(self.caseList:getRight() + GAP)
    self.details:setY(bodyTop)
    self.details:setWidth(self.width - PADDING - self.details:getX())
    self.details:setHeight(bodyHeight)
    self.details:paginate()

    self.noteEntry:setX(PADDING)
    self.noteEntry:setY(noteY)
    self.noteEntry:setWidth(self.width - PADDING * 2)
    self.noteEntry:setHeight(CONTROL_H)

    local buttons = { self.prepareButton, self.passButton, self.failButton, self.skipButton, self.continueButton,
        self.resetButton }
    local buttonWidth = math.floor((self.width - PADDING * 2 - GAP * (#buttons - 1)) / #buttons)
    local buttonX = PADDING
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:setX(buttonX)
        button:setY(buttonY)
        button:setWidth(buttonIndex == #buttons and self.width - PADDING - buttonX or buttonWidth)
        buttonX = button:getRight() + GAP
    end
    self.noteLabelY = noteLabelY
    self.lastLayoutWidth = self.width
    self.lastLayoutHeight = self.height
end

function KBWDebugBuildTestWindow:prerender()
    if self.width ~= self.lastLayoutWidth or self.height ~= self.lastLayoutHeight then self:layout() end
    ISCollapsableWindow.prerender(self)
    self:drawText(getText("IGUI_KBW_DebugTestNoteHint"), PADDING, self.noteLabelY,
        Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small)
end

function KBWDebugBuildTestWindow:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if KBWDebugBuildTestWindow.instance == self then KBWDebugBuildTestWindow.instance = nil end
end

function KBWDebugBuildTestWindow:isKeyConsumed(key)
    return Keyboard and key == Keyboard.KEY_ESCAPE
end

function KBWDebugBuildTestWindow:onKeyRelease(key)
    if self:isVisible() and self:isKeyConsumed(key) then
        self:close()
        return
    end
end

function KBWDebugBuildTestWindow:new(player)
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local width = math.min(940, screenWidth - 60)
    local height = math.min(610, screenHeight - 60)
    local o = ISCollapsableWindow:new(math.floor((screenWidth - width) / 2), math.floor((screenHeight - height) / 2),
        width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.title = getText("IGUI_KBW_DebugTestTitle")
    o.resizable = true
    o.minimumWidth = math.min(780, width)
    o.minimumHeight = math.min(490, height)
    o:setWantKeyEvents(true)
    return o
end

function KBWDebugBuildTestWindow.open(player)
    if not isDebugEnabled() or not player then return end
    if KBWDebugBuildTestWindow.instance then
        KBWDebugBuildTestWindow.instance:close()
        return
    end
    local window = KBWDebugBuildTestWindow:new(player)
    window:initialise()
    window:addToUIManager()
    window:setVisible(true)
    window:bringToTop()
    KBWDebugBuildTestWindow.instance = window
end

return KBWDebugBuildTestWindow
