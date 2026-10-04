require "ISUI/ISPanel"
require "ISUI/ISToolTip"
require "ISUI/ISToolTipInv"
require "ISUI/ISInventoryItem"

local Theme = require("KnoxBuildworks/UI/Theme")
local I18n = require("KnoxBuildworks/I18n")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

KBWIngredientDrawer = ISPanel:derive("KBWIngredientDrawer")

local modeIcons = {
    keep = getTexture("media/ui/Entity/Icon_Returned_48x48.png"),
    drain = getTexture("media/ui/Entity/Icon_ItemConsumed_48x48.png"),
    consume = getTexture("media/ui/Entity/BuildProperty_Consume.png"),
    tool = getTexture("media/ui/Entity/Icon_Tools_48x48.png")
}
local closeTexture = getTexture("media/ui/inventoryPanes/Button_Close.png")
local arrowClosed = getTexture("media/ui/Entity/Icon_ExpandArrow_Closed_48x48.png")
local arrowOpen = getTexture("media/ui/Entity/Icon_ExpandArrow_Open_48x48.png")

local function cleanText(text)
    text = tostring(text or "")
    return string.gsub(text, "[\r\n]+", " ")
end

local function measure(text)
    return getTextManager():MeasureStringX(UIFont.Small, text)
end

local function lineHeight()
    return getTextManager():getFontHeight(UIFont.Small) + 2
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

local function drawLines(panel, lines, x, y, color, alpha)
    local h = lineHeight()
    for lineIndex = 1, #lines do
        panel:drawText(lines[lineIndex], x, y, color.r, color.g, color.b, alpha or 1, UIFont.Small)
        y = y + h
    end
    return y
end

local function scriptFor(fullType)
    if not fullType then return nil end
    if getItem then
        local script = KBWB41.scriptItem(fullType)
        if script then return script end
    end
    return ScriptManager and ScriptManager.instance and ScriptManager.instance:FindItem(fullType) or nil
end

local function textureFor(fullType)
    local script = scriptFor(fullType)
    return script and script:getNormalTexture()
end

local function scriptTextureName(script)
    if script and script.getNormalTexture then
        local texture = script:getNormalTexture()
        if texture and texture.getName then return texture:getName() end
    end
    return ""
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
            if translated and translated ~= "" then return translated .. " (" .. normalized .. ")" end
        end
    end
    return normalized
end

local function rowName(row)
    if row.labelKey then return I18n.text(row.labelKey, row.label) end
    if row.label then return row.label end
    if row.kind == "skill" then return getText("IGUI_perks_" .. row.name) end
    if row.kind == "knowledge" then return row.name end
    if row.possibleItems and row.possibleItems[1] then return itemDisplayName(row.possibleItems[1]) end
    if row.possibleTags and row.possibleTags[1] then return row.possibleTags[1] end
    return row.id or "?"
end

local function flagLabel(flag)
    local key = "IGUI_CraftingWindow_" .. tostring(flag)
    local text = getText(key)
    if text ~= key then return text end
    return tostring(flag)
end

local function selectedKey(fullType, item)
    if item and item.getFullType then return tostring(item) end
    return tostring(fullType or "")
end

local function possibleDedupKey(fullType)
    local script = scriptFor(fullType)
    if script and script.getDisplayName then return script:getDisplayName() .. "|" .. scriptTextureName(script) end
    return itemDisplayName(fullType) .. "|" .. tostring(fullType or "")
end

function KBWIngredientDrawer:new(x, y, w, h, target, onClose, onChoice)
    local o = ISPanel:new(x, y, w, h)
    setmetatable(o, self)
    self.__index = self
    o.target, o.onClose, o.onChoice = target, onClose, onChoice
    o.row = nil
    o.clickRows = {}
    o.expanded = {}
    o.selectedFullType = nil
    o.selectedItemKey = nil
    o.availableExpanded = true
    o.possibleExpanded = true
    o.backgroundColor = Theme.backdrop
    o.borderColor = Theme.border
    return o
end

function KBWIngredientDrawer:createChildren()
    ISPanel.createChildren(self)
    self:addScrollBars()
    self:setScrollChildren(false)
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
end

function KBWIngredientDrawer:onResize()
    if ISPanel.onResize then ISPanel.onResize(self) end
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
    self.lastScrollHeight = nil
end

function KBWIngredientDrawer:drawWidth()
    return self.width - (self.vscroll and self.vscroll:getWidth() or 0)
end

function KBWIngredientDrawer:hideTooltips()
    if self.tooltipItem then
        self.tooltipItem:setVisible(false)
        self.tooltipItem:removeFromUIManager()
        self.tooltipItem = nil
    end
    if self.tooltipText then
        self.tooltipText:setVisible(false)
        self.tooltipText:removeFromUIManager()
        self.tooltipText = nil
    end
end

function KBWIngredientDrawer:setRow(row, selectedFullType, selectedItemKeyValue)
    self:hideTooltips()
    self.row = row
    self.selectedFullType = selectedFullType
    self.selectedItemKey = selectedItemKeyValue or selectedFullType
    self.lastScrollHeight = nil
    self.clickRows = {}
    self:setYScroll(0)
    self:setVisible(row ~= nil)
    if self.vscroll then self:updateScrollbars() end
end

function KBWIngredientDrawer:onMouseWheel(delta)
    local minimum = math.min(0, self.height - self:getScrollHeight())
    self:setYScroll(math.max(minimum, math.min(0, self:getYScroll() - delta * 34)))
    if self.vscroll then self:updateScrollbars() end
    return true
end

function KBWIngredientDrawer:onMouseDown(x, y)
    if self.vscroll and x >= self:drawWidth() then return false end
    local headerY = -self:getYScroll()
    if x > self:drawWidth() - 34 and y >= headerY + 6 and y < headerY + 30 then
        self:setRow(nil)
        if self.onClose then self.onClose(self.target) end
        return true
    end
    local rows = self.clickRows or {}
    for rowIndex = 1, #rows do
        local hit = rows[rowIndex]
        if y >= hit.y and y < hit.y + hit.h then
            if hit.action == "toggle" then
                self.expanded[hit.key] = not self.expanded[hit.key]
                self.lastScrollHeight = nil
                return true
            end
            if hit.action == "toggleAvailable" then
                self.availableExpanded = not self.availableExpanded
                self.lastScrollHeight = nil
                return true
            end
            if hit.action == "togglePossible" then
                self.possibleExpanded = not self.possibleExpanded
                self.lastScrollHeight = nil
                return true
            end
            if hit.fullType then
                self.selectedFullType = hit.fullType
                self.selectedItemKey = selectedKey(hit.fullType, hit.item)
                if self.onChoice then self.onChoice(self.target, self.row, hit.fullType, self.selectedItemKey) end
                return true
            end
        end
    end
    return true
end

function KBWIngredientDrawer:onMouseMove(dx, dy)
    local mx = self:getMouseX()
    if self.vscroll and mx >= self:drawWidth() then
        self:hideTooltips()
        return
    end
    local my = self:getMouseY()
    local rows = self.clickRows or {}
    for rowIndex = 1, #rows do
        local hit = rows[rowIndex]
        if my >= hit.y and my < hit.y + hit.h then
            if hit.item then
                if not self.tooltipItem then
                    self.tooltipItem = ISToolTipInv:new(hit.item)
                    self.tooltipItem:addToUIManager()
                    self.tooltipItem.owner = self
                end
                self.tooltipItem:setItem(hit.item)
                if self.target and self.target.player then self.tooltipItem:setCharacter(self.target.player) end
                self.tooltipItem:setVisible(true)
                self.tooltipItem:setAlwaysOnTop(true)
                if self.tooltipText then self.tooltipText:setVisible(false) end
                return
            end
            if hit.tooltipText then
                if not self.tooltipText then
                    self.tooltipText = ISToolTip:new()
                    self.tooltipText:addToUIManager()
                    self.tooltipText.owner = self
                end
                self.tooltipText:setName(hit.tooltipText)
                self.tooltipText:setVisible(true)
                self.tooltipText:setAlwaysOnTop(true)
                if self.tooltipItem then self.tooltipItem:setVisible(false) end
                return
            end
        end
    end
    self:hideTooltips()
end

function KBWIngredientDrawer:onMouseMoveOutside(dx, dy)
    self:hideTooltips()
end

function KBWIngredientDrawer:close()
    self:hideTooltips()
    if ISPanel.close then ISPanel.close(self) end
end

local function drawSection(panel, y, text, expanded, action)
    local width = panel:drawWidth()
    local lines = wrapText(text, math.max(60, width - 44))
    local rowHeight = math.max(28, 8 + #lines * lineHeight())
    panel:drawRect(
        8, y, width - 16, rowHeight, 0.42, Theme.surfaceRaised.r, Theme.surfaceRaised.g, Theme.surfaceRaised.b
    )
    panel:drawRectBorder(
        8, y, width - 16, rowHeight, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g, Theme.borderSoft.b
    )
    local arrow = expanded and arrowOpen or arrowClosed
    if arrow then
        panel:drawTextureScaledAspect(arrow, 14, y + 6, 16, 16, 1, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    end
    drawLines(panel, lines, 36, y + 6, Theme.accent, 1)
    panel.clickRows[#panel.clickRows + 1] = { y = y, h = rowHeight, action = action }
    return y + rowHeight + 6
end

local function drawMode(panel, row, y)
    local width = panel:drawWidth()
    local modeTexture = row.role == "tool" and modeIcons.tool or modeIcons[row.mode]
    local text = getText("IGUI_KBW_Mode") .. ": " .. tostring(row.mode or "consume")
    local lines = wrapText(text, math.max(60, width - 52))
    local rowHeight = math.max(34, 8 + #lines * lineHeight())
    if modeTexture then panel:drawTextureScaledAspect(modeTexture, 10, y + 4, 28, 28, 1, 1, 1, 1) end
    drawLines(panel, lines, 44, y + 7, Theme.textMuted, 1)
    return y + rowHeight
end

local function drawTextBlock(panel, y, text, color)
    local width = panel:drawWidth()
    local lines = wrapText(text, math.max(60, width - 24))
    drawLines(panel, lines, 12, y, color or Theme.textMuted, 1)
    return y + (#lines * lineHeight()) + 4
end

local function drawAvailableNode(panel, y, entry)
    local width = panel:drawWidth()
    local key = "available:" .. tostring(entry.fullType)
    local items = entry.items or {}
    if #items == 0 and entry.item then
        items = { entry.item }
    end
    local expanded = panel.expanded[key]
    if expanded == nil then expanded = true end
    local lines = wrapText(itemDisplayName(entry.fullType) .. " ("
            .. tostring(entry.available or entry.count or 0) .. ")", math.max(60, width - 76))
    local rowHeight = math.max(34, 8 + #lines * lineHeight())
    panel:drawRect(
        8, y, width - 16, rowHeight, 0.28, Theme.surfaceRaised.r, Theme.surfaceRaised.g, Theme.surfaceRaised.b
    )
    panel:drawRectBorder(
        8, y, width - 16, rowHeight, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g, Theme.borderSoft.b
    )
    local arrow = expanded and arrowOpen or arrowClosed
    if arrow then
        panel:drawTextureScaledAspect(arrow, 12, y + 8, 14, 14, 1, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    end
    local texture = textureFor(entry.fullType)
    if texture then panel:drawTextureScaledAspect(texture, 31, y + 5, 28, 28, 1, 1, 1, 1) end
    drawLines(panel, lines, 66, y + 7, Theme.text, 1)
    panel.clickRows[#panel.clickRows + 1] = {
        y = y,
        h = rowHeight,
        action = "toggle",
        key = key,
        tooltipText = itemDisplayName(entry.fullType)
    }
    y = y + rowHeight
    if expanded then
        for itemIndex = 1, #items do
            y = panel:drawChoiceRow(y + 3, entry.fullType, nil, true, items[itemIndex], true)
        end
    end
    return y + 4
end

function KBWIngredientDrawer:drawChoiceRow(y, fullType, count, available, item, child)
    local width = self:drawWidth()
    local rowKeyValue = selectedKey(fullType, item)
    local selected = self.selectedFullType == fullType and (self.selectedItemKey == rowKeyValue or not item)
    local fill = selected and Theme.selectedSoft or Theme.surface
    local border = selected and Theme.accent or Theme.borderSoft
    local x = child and 24 or 8
    local rowWidth = width - x - 8
    local iconSize = child and 28 or 34
    local textX = x + iconSize + 12
    local name = item and item.getName and item:getName() or itemDisplayName(fullType)
    local lines = wrapText(name, math.max(60, width - textX - 18))
    local countLines = count ~= nil and wrapText(tostring(count), math.max(40, width - textX - 18)) or {}
    local rowHeight = math.max(iconSize + 10, 10 + (#lines + #countLines) * lineHeight())
    self:drawRect(x, y, rowWidth, rowHeight, fill.a, fill.r, fill.g, fill.b)
    self:drawRectBorder(x, y, rowWidth, rowHeight, border.a, border.r, border.g, border.b)
    if item and ISInventoryItem and ISInventoryItem.renderItemIcon then
        ISInventoryItem.renderItemIcon(self, item, x + 5, y + 5, available and 1 or .45, iconSize, iconSize)
    else
        local texture = textureFor(fullType)
        if texture then
            self:drawTextureScaledAspect(texture, x + 5, y + 5, iconSize, iconSize, available and 1 or .45, 1, 1, 1)
        end
    end
    local color = available and Theme.good or Theme.textMuted
    local textY = drawLines(
        self, lines, textX, y + 6, available and Theme.text or Theme.textMuted, available and 1 or .7
    )
    if #countLines > 0 then drawLines(self, countLines, textX, textY, color, 1) end
    self.clickRows[#self.clickRows + 1] = { y = y, h = rowHeight, fullType = fullType, item = item, tooltipText = name }
    return y + rowHeight + 4
end

local function drawPossibleItems(panel, y, row, availableMap, availablePossibleKeys)
    local seen = {}
    local possibleItems = row.possibleItems or {}
    local hadPossible = false
    for itemIndex = 1, #possibleItems do
        local fullType = possibleItems[itemIndex]
        local key = possibleDedupKey(fullType)
        if not seen[key] and not availablePossibleKeys[key] then
            seen[key] = true
            local count = availableMap[fullType] or 0
            hadPossible = true
            y = panel:drawChoiceRow(y, fullType, count, count > 0, nil, false)
        end
    end
    local possibleTags = row.possibleTags or {}
    for tagIndex = 1, #possibleTags do
        hadPossible = true
        y = drawTextBlock(
            panel, y + 2, getText("IGUI_KBW_ItemTag") .. ": " .. tagDisplayName(possibleTags[tagIndex]), Theme.text
        )
    end
    if not hadPossible then
        y = drawTextBlock(panel, y, getText("IGUI_KBW_NoneAvailable"), Theme.textMuted)
    end
    return y
end

function KBWIngredientDrawer:prerender()
    ISPanel.prerender(self)
    local row = self.row
    if not row then return end
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
    local width = self:drawWidth()
    local headerY = -self:getYScroll()
    local titleLines = wrapText(getText("IGUI_KBW_IngredientBrowser"), math.max(80, width - 48))
    local nameLines = wrapText(rowName(row), math.max(80, width - 24))
    local headerHeight = math.max(72, 22 + (#titleLines + #nameLines) * lineHeight() + 18)
    self.clickRows = {}
    self:drawRect(
        6, headerY + 4, width - 12, headerHeight - 8, Theme.backdrop.a, Theme.backdrop.r, Theme.backdrop.g,
        Theme.backdrop.b
    )
    self:drawRectBorder(
        6, headerY + 4, width - 12, headerHeight - 8, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g,
        Theme.borderSoft.b
    )
    local yText = drawLines(self, titleLines, 14, headerY + 11, Theme.accent, 1)
    drawLines(self, nameLines, 14, yText + 7, Theme.text, 1)
    self:drawRect(width - 34, headerY + 9, 22, 22, Theme.surface.a, Theme.surface.r, Theme.surface.g, Theme.surface.b)
    if closeTexture then
        self:drawTextureScaledAspect(closeTexture, width - 32, headerY + 11, 18, 18, 1, 1, 1, 1)
    else
        self:drawText("X", width - 28, headerY + 12, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
    end

    local y = headerHeight + 8
    local stencilHeight = math.max(1, self.height - headerHeight - 2)
    local stencilX, stencilY, stencilW, stencilH = self:clampStencilRectToParent(
        6, headerHeight + 2, math.max(1, width - 12), stencilHeight
    )
    if row.kind == "skill" then
        y = drawSection(self, y, getText("IGUI_KBW_RequiredSkill"), true, nil)
        local color = row.ok and Theme.good or Theme.warn
        y = drawTextBlock(self, y, getText("IGUI_perks_" .. row.name), Theme.text)
        y = drawTextBlock(self, y, tostring(row.available or 0) .. "/" .. tostring(row.needed or 0), color)
    elseif row.kind == "knowledge" then
        y = drawSection(self, y, getText("IGUI_KBW_RequiredKnowledge"), true, nil)
        local color = row.ok and Theme.good or Theme.warn
        local knowledgeName = row.name
        if row.alternativeLabel and row.alternativeLabel ~= "" then
            knowledgeName = getText("IGUI_KBW_RecipeOrSkill", row.name, row.alternativeLabel)
        end
        y = drawTextBlock(self, y, knowledgeName, color)
        local sources = row.sources or {}
        for sourceIndex = 1, #sources do
            local source = sources[sourceIndex]
            y = drawTextBlock(
                self, y, (source.type or "source") .. ": " .. tostring(source.item or source.name or "?"), Theme.text
            )
        end
    else
        y = drawMode(self, row, y)
        if row.flags and #row.flags > 0 then
            y = drawSection(self, y + 4, getText("IGUI_KBW_InputRules"), true, nil)
            local flags = row.flags or {}
            for flagIndex = 1, #flags do
                y = drawTextBlock(self, y, flagLabel(flags[flagIndex]), Theme.textMuted)
            end
        end

        y = drawSection(self, y + 4, getText("IGUI_CraftUI_AvailableItems"), self.availableExpanded, "toggleAvailable")
        local availableMap = {}
        local availablePossibleKeys = {}
        if self.availableExpanded then
            local availableItems = row.availableItems or {}
            local hadAvailable = false
            for entryIndex = 1, #availableItems do
                local entry = availableItems[entryIndex]
                availableMap[entry.fullType] = entry.available
                if (entry.available or 0) > 0 then
                    availablePossibleKeys[possibleDedupKey(entry.fullType)] = true
                    hadAvailable = true
                    y = drawAvailableNode(self, y, entry)
                end
            end
            if not hadAvailable then
                y = drawTextBlock(self, y, getText("IGUI_KBW_NoneAvailable"), Theme.warn)
            end
        else
            local availableItems = row.availableItems or {}
            for entryIndex = 1, #availableItems do
                local entry = availableItems[entryIndex]
                availableMap[entry.fullType] = entry.available
                if (entry.available or 0) > 0 then availablePossibleKeys[possibleDedupKey(entry.fullType)] = true end
            end
        end

        y = drawSection(self, y + 6, getText("IGUI_CraftUI_PossibleItems"), self.possibleExpanded, "togglePossible")
        if self.possibleExpanded then y = drawPossibleItems(self, y, row, availableMap, availablePossibleKeys) end
    end

    local scrollHeight = math.max(self.height, y + 30)
    if self.lastScrollHeight ~= scrollHeight then
        self.lastScrollHeight = scrollHeight
        self:setScrollHeight(scrollHeight)
        if self.vscroll then self:updateScrollbars() end
    end
    self:clearStencilRect()
end

return KBWIngredientDrawer
