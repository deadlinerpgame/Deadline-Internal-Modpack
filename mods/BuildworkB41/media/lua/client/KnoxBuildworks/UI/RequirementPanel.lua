require "ISUI/ISPanel"

local Requirements = require("KnoxBuildworks/Validation/Requirements")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local Theme = require("KnoxBuildworks/UI/Theme")
local I18n = require("KnoxBuildworks/I18n")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

KBWRequirementPanel = ISPanel:derive("KBWRequirementPanel")

local textures = {
    returned = getTexture("media/ui/Entity/Icon_Returned_48x48.png"),
    consumed = getTexture("media/ui/Entity/BuildProperty_Consume.png"),
    used = getTexture("media/ui/Entity/Icon_ItemConsumed_48x48.png"),
    tool = getTexture("media/ui/Entity/Icon_Tools_48x48.png"),
    swap = getTexture("media/ui/Entity/BTN_Swap_Icon_48x48.png"),
    missing = getTexture("media/ui/Entity/BTN_Missing_Icon_48x48.png"),
    fluid = getTexture("media/textures/Item_Waterdrop_Grey.png")
}

local flagText = {
    MayDegrade = "IGUI_CraftingWindow_MayDegrade",
    MayDegradeLight = "IGUI_CraftingWindow_MayDegradeLight",
    MayDegradeVeryLight = "IGUI_CraftingWindow_MayDegradeLight",
    MayDegradeHeavy = "IGUI_CraftingWindow_MayDegradeHeavy",
    SharpnessCheck = "IGUI_CraftingWindow_SharpnessCheck",
    IsSharpenable = "IGUI_CraftingWindow_IsSharpenable",
    IsNotDull = "IGUI_CraftingWindow_IsNotDull",
    IsWorn = "IGUI_CraftingWindow_IsWorn",
    IsNotWorn = "IGUI_CraftingWindow_IsNotWorn",
    IsFull = "IGUI_CraftingWindow_IsFull",
    IsEmpty = "IGUI_CraftingWindow_IsEmpty",
    NotFull = "IGUI_CraftingWindow_NotFull",
    NotEmpty = "IGUI_CraftingWindow_NotEmpty",
    IsDamaged = "IGUI_CraftingWindow_IsDamaged",
    IsUndamaged = "IGUI_CraftingWindow_IsUndamaged",
    AllowFrozenItem = "IGUI_CraftingWindow_AllowFrozenItem",
    AllowRottenItem = "IGUI_CraftingWindow_AllowRottenItem",
    AllowDestroyedItem = "IGUI_CraftingWindow_AllowDestroyedItem",
    IsEmptyContainer = "IGUI_CraftingWindow_IsEmptyContainer",
    IsWholeFoodItem = "IGUI_CraftingWindow_IsWholeFoodItem",
    IsUncookedFoodItem = "IGUI_CraftingWindow_IsUncookedFoodItem",
    IsCookedFoodItem = "IGUI_CraftingWindow_IsCookedFoodItem",
    IsHeadPart = "IGUI_CraftingWindow_IsHeadPart"
}

local function scriptFor(fullType)
    if not fullType then return nil end
    if getItem then
        local script = KBWB41.scriptItem(fullType)
        if script then return script end
    end
    return ScriptManager and ScriptManager.instance and ScriptManager.instance:FindItem(fullType) or nil
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
    if normalized ~= "" and KBWB41 then
        local tag = KBWB41.tagName(normalized)
        if tag and tag.getTranslationName then
            local translated = KBWB41.displayName(tag)
            if translated and translated ~= "" then return translated end
        end
    end
    return normalized
end

local function cleanText(text)
    text = tostring(text or "")
    return string.gsub(text, "[\r\n]+", " ")
end

local function measure(text)
    return getTextManager():MeasureStringX(UIFont.Small, text)
end

local function wrapLongWord(lines, word, width)
    local chunk = ""
    for charIndex = 1, #word do
        local char = string.sub(word, charIndex, charIndex)
        local candidate = chunk .. char
        if chunk ~= "" and measure(candidate) > width then
            lines[#lines + 1] = chunk
            chunk = char
        else
            chunk = candidate
        end
    end
    if chunk ~= "" then lines[#lines + 1] = chunk end
end

local function wrapText(text, width)
    text = cleanText(text)
    local lines = {}
    if text == "" then return lines end
    if width < 24 then
        lines[#lines + 1] = text
        return lines
    end
    local current = ""
    for word in string.gmatch(text, "%S+") do
        local candidate = current == "" and word or current .. " " .. word
        if measure(candidate) <= width then
            current = candidate
        else
            if current ~= "" then
                lines[#lines + 1] = current
                current = ""
            end
            if measure(word) <= width then
                current = word
            else
                wrapLongWord(lines, word, width)
            end
        end
    end
    if current ~= "" then lines[#lines + 1] = current end
    return lines
end

local function drawWrapped(panel, lines, x, y, color, alpha)
    local lineHeight = getTextManager():getFontHeight(UIFont.Small) + 2
    for lineIndex = 1, #lines do
        panel:drawText(lines[lineIndex], x, y, color.r, color.g, color.b, alpha or 1, UIFont.Small)
        y = y + lineHeight
    end
    return y
end

local function rowKey(row)
    if not row then return nil end
    return tostring(row.kind or "") .. "|" .. tostring(row.id or row.name or "")
end

local function firstAvailable(row)
    local availableItems = row.availableItems or {}
    for itemIndex = 1, #availableItems do
        local entry = availableItems[itemIndex]
        if (entry.available or 0) > 0 then return entry.fullType, entry.item end
    end
    return nil, nil
end

local function textureFor(row)
    if row.resourceType == "Fluid" then return textures.fluid, { r = .72, g = .78, b = 1, a = 1 } end
    if row.item and row.item.getTexture then return row.item:getTexture(), { r = 1, g = 1, b = 1, a = 1 } end
    if row.icon then return getTexture(row.icon), { r = 1, g = 1, b = 1, a = 1 } end
    local available, _ = firstAvailable(row)
    local fullType = available or (row.possibleItems and row.possibleItems[1])
    local script = scriptFor(fullType)
    if script and script.getNormalTexture then
        local color = { r = 1, g = 1, b = 1, a = 1 }
        if script.getR then
            color.r = script:getR()
            color.g = script:getG()
            color.b = script:getB()
        end
        return script:getNormalTexture(), color
    end
    return nil, { r = 1, g = 1, b = 1, a = 1 }
end

local function semanticTexture(row)
    if row.mode == "keep" and row.role == "tool" then
        return textures.tool, getText("IGUI_CraftingWindow_WillBeKept")
    end
    if row.mode == "keep" then return textures.returned, getText("IGUI_CraftingWindow_WillBeKept") end
    if row.mode == "drain" then
        return textures.used, getText("IGUI_CraftingWindow_WillBeConsume", tostring(row.needed or 1))
    end
    return textures.consumed, getText("IGUI_CraftingWindow_WillBeDestroyed")
end

local function rowTitle(row)
    if row.selectedFullType then return itemDisplayName(row.selectedFullType) end
    if row.labelKey then return I18n.text(row.labelKey, row.label) end
    if row.label then return row.label end
    local available = firstAvailable(row)
    if available then return itemDisplayName(available) end
    if row.possibleItems and row.possibleItems[1] then return itemDisplayName(row.possibleItems[1]) end
    if row.possibleTags and row.possibleTags[1] then return "#" .. tagDisplayName(row.possibleTags[1]) end
    return row.id or "?"
end

local function flagSummary(row)
    local parts = {}
    local flags = row.flags or {}
    for flagIndex = 1, #flags do
        local flag = flags[flagIndex]
        if flag ~= "DontRecordInput" and flag ~= "ToolLeft"
            and flag ~= "ToolRight" and flag ~= "Prop1"
            and flag ~= "Prop2" then
            local key = flagText[flag]
            parts[#parts + 1] = key and getText(key) or flag
        end
    end
    return table.concat(parts, "  |  ")
end

local function rowSubText(row)
    local parts = {}
    if row.role == "tool" then
        parts[#parts + 1] = getText("IGUI_KBW_Tool")
    elseif row.role == "resource" then
        parts[#parts + 1] = tostring(row.resourceType or "Resource")
    elseif row.role == "consumable" then
        parts[#parts + 1] = getText("IGUI_KBW_Consumable")
    else
        parts[#parts + 1] = getText("IGUI_KBW_Material")
    end
    if row.mode == "keep" then
        parts[#parts + 1] = getText("IGUI_KBW_Kept")
    elseif row.mode == "drain" then
        parts[#parts + 1] = getText("IGUI_KBW_Drained") .. ": " .. tostring(row.uses or row.needed or 1)
    else
        parts[#parts + 1] = getText("IGUI_KBW_Consumed")
    end
    if row.possibleItems and #row.possibleItems > 1 then
        parts[#parts + 1] = tostring(#row.possibleItems) .. " " .. getText("IGUI_KBW_Alternatives")
    end
    if row.possibleTags and #row.possibleTags > 0 then
        parts[#parts + 1] = "#" .. tagDisplayName(row.possibleTags[1])
    end
    local flags = flagSummary(row)
    if flags ~= "" then parts[#parts + 1] = flags end
    return table.concat(parts, "  |  ")
end

local function materialRows(rows)
    local out = {}
    rows = rows or {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if row.kind ~= "skill" and row.kind ~= "knowledge" then out[#out + 1] = row end
    end
    return out
end

local function rowLayout(row, width)
    local titleX = 88
    local titleWidth = math.max(72, width - titleX - 92)
    local bodyWidth = math.max(72, width - titleX - 12)
    local semantic, semanticTip = semanticTexture(row)
    local layout = {
        titleX = titleX,
        titleLines = wrapText(rowTitle(row), titleWidth),
        subLines = wrapText(rowSubText(row), bodyWidth),
        semantic = semantic,
        semanticTip = semanticTip,
        semanticLines = semanticTip and wrapText(semanticTip, bodyWidth) or {}
    }
    local lineHeight = getTextManager():getFontHeight(UIFont.Small) + 2
    local lineCount = #layout.titleLines + #layout.subLines + #layout.semanticLines
    layout.height = math.max(70, 12 + lineCount * lineHeight + 10)
    return layout
end

function KBWRequirementPanel:new(x, y, w, h, player, target, onSelect)
    local o = ISPanel:new(x, y, w, h)
    setmetatable(o, self)
    self.__index = self
    o.player, o.target, o.onSelect = player, target, onSelect
    o.rows = {}
    o.clickRows = {}
    o.rowHeight = 70
    o.headerHeight = 0
    o.background = false
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    return o
end

function KBWRequirementPanel:createChildren()
    ISPanel.createChildren(self)
    self:addScrollBars()
    self:setScrollChildren(false)
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
end

function KBWRequirementPanel:onResize()
    if ISPanel.onResize then ISPanel.onResize(self) end
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
    self:setScrollHeight(math.max(self.height, self:contentHeight()))
end

function KBWRequirementPanel:drawWidth()
    return self.width - (self.vscroll and self.vscroll:getWidth() or 0)
end

function KBWRequirementPanel:contentHeight()
    local width = self:drawWidth()
    local total = 8
    local rows = self.rows or {}
    for rowIndex = 1, #rows do
        total = total + rowLayout(rows[rowIndex], width).height
    end
    return total
end

function KBWRequirementPanel:setSelection(definition, stage, finish)
    self.definition, self.stage, self.finish = definition, stage, finish
    local choices = self.target and self.target.selectedInputChoices and self.target:selectedInputChoices() or nil
    local status = definition and stage and Requirements.evaluate(self.player, definition, stage, nil, choices) or { rows = {} }
    self.rows = materialRows(status.rows or {})
    local finishRows = WallFinishes.statusRows(self.player, finish, definition, stage)
    for rowIndex = 1, #finishRows do
        self.rows[#self.rows + 1] = finishRows[rowIndex]
    end
    self:applyChoices()
    self.clickRows = {}
    self:setScrollHeight(math.max(self.height, self:contentHeight()))
    if self.vscroll then self:updateScrollbars() end
end

function KBWRequirementPanel:applyChoices()
    local rows = self.rows or {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if self.target and self.target.getInputChoice then row.selectedFullType = self.target:getInputChoice(row) end
    end
end

function KBWRequirementPanel:setSelectedRow(row)
    local key = rowKey(row)
    self.selectedRowKey = nil
    local rows = self.rows or {}
    for rowIndex = 1, #rows do
        if rowKey(rows[rowIndex]) == key then
            self.selectedRowKey = key
            return
        end
    end
end

function KBWRequirementPanel:onMouseWheel(delta)
    local minimum = math.min(0, self.height - self:getScrollHeight())
    self:setYScroll(math.max(minimum, math.min(0, self:getYScroll() - delta * 36)))
    if self.vscroll then self:updateScrollbars() end
    return true
end

function KBWRequirementPanel:onMouseDown(x, y)
    if self.vscroll and x >= self:drawWidth() then return false end
    local clickRows = self.clickRows or {}
    for hitIndex = 1, #clickRows do
        local hit = clickRows[hitIndex]
        if y >= hit.y and y < hit.y + hit.h then
            self.selectedRowKey = rowKey(hit.row)
            if self.onSelect then self.onSelect(self.target, hit.row) end
            return true
        end
    end
    return true
end

function KBWRequirementPanel:drawBadge(text, x, y, ok)
    local color = ok and Theme.good or Theme.textMuted
    self:drawRect(x, y, 42, 42, 0.72, Theme.surfaceRaised.r, Theme.surfaceRaised.g, Theme.surfaceRaised.b)
    self:drawRectBorder(x, y, 42, 42, 0.85, color.r, color.g, color.b)
    self:drawTextCentre(text, x + 21, y + 13, color.r, color.g, color.b, 1, UIFont.Small)
end

function KBWRequirementPanel:drawRequirementRow(row, y, layout)
    local width = self.currentDrawWidth or self:drawWidth()
    local selected = rowKey(row) == self.selectedRowKey
    local border = selected and Theme.accent or (row.ok and Theme.good or Theme.borderSoft)
    local countColor = row.ok and Theme.good or Theme.warn
    local fill = selected and Theme.selectedSoft or Theme.surface
    local rowHeight = layout.height
    self:drawRect(0, y, width, rowHeight - 6, fill.a, fill.r, fill.g, fill.b)
    self:drawRectBorder(0, y, width, rowHeight - 6, .78, border.r, border.g, border.b)
    local texture, color = textureFor(row)
    self:drawRect(8, y + 8, 46, 46, 0.62, 0, 0, 0)
    self:drawRectBorder(8, y + 8, 46, 46, 0.75, Theme.borderSoft.r, Theme.borderSoft.g, Theme.borderSoft.b)
    if texture then
        self:drawTextureScaledAspect(texture, 12, y + 12, 38, 38, row.ok and 1 or .34, color.r, color.g, color.b)
    else
        self:drawBadge(row.role == "tool" and "TL" or "IT", 10, y + 10, row.ok)
    end
    if layout.semantic then self:drawTextureScaledAspect(layout.semantic, 62, y + 10, 18, 18, 1, 1, 1, 1) end
    local textY = y + 7
    textY = drawWrapped(self, layout.titleLines, layout.titleX, textY, Theme.text, 1)
    textY = drawWrapped(self, layout.subLines, layout.titleX, textY + 1, Theme.textMuted, 1)
    drawWrapped(self, layout.semanticLines, layout.titleX, textY + 1, Theme.textMuted, .82)
    local needed = tostring(row.needed or 1)
    if row.neededMax and row.neededMax ~= row.needed then
        needed = tostring(row.needed) .. "-"
            .. tostring(row.neededMax)
    end
    local count = tostring(row.available or 0) .. "/" .. needed
    local countW = getTextManager():MeasureStringX(UIFont.Small, count)
    self:drawText(count, width - countW - 34, y + 10, countColor.r, countColor.g, countColor.b, 1, UIFont.Small)
    local buttonTexture = row.ok and textures.swap or textures.missing
    local buttonColor = selected and Theme.accent or Theme.textMuted
    if buttonTexture then
        self:drawTextureScaledAspect(
            buttonTexture, width - 30, y + rowHeight - 32, 22, 22, 1, buttonColor.r, buttonColor.g, buttonColor.b
        )
    end
end

function KBWRequirementPanel:prerender()
    ISPanel.prerender(self)
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
    self.currentDrawWidth = self:drawWidth()
    local stencilX, stencilY, stencilW, stencilH = self:clampStencilRectToParent(
        0, 0, self.currentDrawWidth, self.height
    )
    self.clickRows = {}
    local scroll = self:getYScroll()
    local y = 4
    local viewY = y + scroll
    local rows = self.rows or {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        local layout = rowLayout(row, self.currentDrawWidth)
        self.clickRows[#self.clickRows + 1] = { y = y, h = layout.height, row = row }
        viewY = y + scroll
        if viewY + layout.height >= 0 and viewY < self.height then self:drawRequirementRow(row, y, layout) end
        y = y + layout.height
    end
    self.currentDrawWidth = nil
    self:clearStencilRect()
end

return KBWRequirementPanel
