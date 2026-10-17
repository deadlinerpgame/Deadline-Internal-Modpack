require "ISUI/ISPanel"

local Requirements = require("KnoxBuildworks/Validation/Requirements")
local Theme = require("KnoxBuildworks/UI/Theme")

KBWAccessPanel = ISPanel:derive("KBWAccessPanel")

local icons = {
    skill = getTexture("media/ui/craftingMenus/BuildProperty_Clock_16.png"),
    book = getTexture("media/ui/craftingMenus/BuildProperty_Book_16.png")
}

local skillIcons = {
    Woodwork = getTexture("media/ui/ElyonLib/ui_skill_spiffo_carpentry.png"),
    Cooking = getTexture("media/ui/ElyonLib/ui_skill_spiffo_cooking.png"),
    Farming = getTexture("media/ui/ElyonLib/ui_skill_spiffo_farming.png"),
    Doctor = getTexture("media/ui/ElyonLib/ui_skill_spiffo_first_aid.png"),
    Electricity = getTexture("media/ui/ElyonLib/ui_skill_spiffo_electricity.png"),
    MetalWelding = getTexture("media/ui/ElyonLib/ui_skill_spiffo_metalworking.png"),
    Mechanics = getTexture("media/ui/ElyonLib/ui_skill_spiffo_mechanics.png"),
    Fishing = getTexture("media/ui/ElyonLib/ui_skill_spiffo_fishing.png"),
    Trapping = getTexture("media/ui/ElyonLib/ui_skill_spiffo_trapping.png"),
    PlantScavenging = getTexture("media/ui/ElyonLib/ui_skill_spiffo_plant_scavenging.png"),
    Fitness = getTexture("media/ui/ElyonLib/ui_skill_spiffo_fitness.png"),
    Strength = getTexture("media/ui/ElyonLib/ui_skill_spiffo_strength.png"),
    Sprinting = getTexture("media/ui/ElyonLib/ui_skill_spiffo_sprinting.png"),
    Lightfoot = getTexture("media/ui/ElyonLib/ui_skill_spiffo_lightfooted.png"),
    Lightfooted = getTexture("media/ui/ElyonLib/ui_skill_spiffo_lightfooted.png"),
    Nimble = getTexture("media/ui/ElyonLib/ui_skill_spiffo_nimble.png"),
    Sneak = getTexture("media/ui/ElyonLib/ui_skill_spiffo_sneaking.png"),
    Sneaking = getTexture("media/ui/ElyonLib/ui_skill_spiffo_sneaking.png"),
    Aiming = getTexture("media/ui/ElyonLib/ui_skill_spiffo_aiming.png"),
    Reloading = getTexture("media/ui/ElyonLib/ui_skill_spiffo_reloading.png"),
    Axe = getTexture("media/ui/ElyonLib/ui_skill_spiffo_axe.png"),
    LongBlade = getTexture("media/ui/ElyonLib/ui_skill_spiffo_long_blade.png"),
    SmallBlade = getTexture("media/ui/ElyonLib/ui_skill_spiffo_small_blade.png"),
    SmallBlunt = getTexture("media/ui/ElyonLib/ui_skill_spiffo_small_blunt.png"),
    LongBlunt = getTexture("media/ui/ElyonLib/ui_skill_spiffo_blunt.png"),
    Blunt = getTexture("media/ui/ElyonLib/ui_skill_spiffo_blunt.png"),
    Spear = getTexture("media/ui/ElyonLib/ui_skill_spiffo_spear.png"),
    Maintenance = getTexture("media/ui/ElyonLib/ui_skill_spiffo_maintenance.png")
}

local function gateRows(rows)
    local out = {}
    rows = rows or {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if row.kind == "skill" or row.kind == "knowledge" then out[#out + 1] = row end
    end
    return out
end

local function cleanText(text)
    text = tostring(text or "")
    return string.gsub(text, "[\r\n]+", " ")
end

local function measure(text)
    return getTextManager():MeasureStringX(UIFont.Small, text)
end

local function wrapText(text, width)
    text = cleanText(text)
    local lines = {}
    if text == "" then return lines end
    local current = ""
    for word in string.gmatch(text, "%S+") do
        local candidate = current == "" and word or current .. " " .. word
        if current == "" or measure(candidate) <= width then
            current = candidate
        else
            lines[#lines + 1] = current
            current = word
        end
    end
    if current ~= "" then lines[#lines + 1] = current end
    return lines
end

local rowTitle
local rowStatus

local function rowHeightFor(row, width)
    local status = rowStatus(row)
    local statusWidth = measure(status) + 30
    local lines = wrapText(rowTitle(row), math.max(50, width - statusWidth - 42))
    return math.max(44, 16 + (#lines * (getTextManager():getFontHeight(UIFont.Small) + 3)))
end

local function contentHeightFor(rows, width, panelHeight)
    local total = 8
    rows = rows or {}
    for rowIndex = 1, #rows do
        total = total + rowHeightFor(rows[rowIndex], width) + 6
    end
    return math.max(panelHeight or 0, total)
end

local function rowKey(row)
    if not row then return nil end
    return tostring(row.kind or "") .. "|" .. tostring(row.id or row.name or "")
end

rowTitle = function (row)
    if row.kind == "skill" then return getText("IGUI_perks_" .. row.name) end
    if row.kind == "knowledge" then
        if row.alternativeLabel and row.alternativeLabel ~= "" then
            return getText("IGUI_KBW_RecipeOrSkill", row.name, row.alternativeLabel)
        end
        return row.name
    end
    return row.id or "?"
end

rowStatus = function (row)
    if row.kind == "knowledge" then
        if row.alternativeMet then return getText("IGUI_KBW_SkillUnlocked") end
        return row.ok and getText("IGUI_KBW_Known") or getText("IGUI_KBW_NotKnown")
    end
    return tostring(row.available or 0) .. "/" .. tostring(row.needed or 0)
end

function KBWAccessPanel:new(x, y, w, h, player, target, onSelect)
    local o = ISPanel:new(x, y, w, h)
    setmetatable(o, self)
    self.__index = self
    o.player, o.target, o.onSelect = player, target, onSelect
    o.rows = {}
    o.clickRows = {}
    o.rowHeight = 42
    o.headerHeight = 0
    o.background = false
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    return o
end

function KBWAccessPanel:createChildren()
    ISPanel.createChildren(self)
    self:addScrollBars()
    self:setScrollChildren(false)
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
end

function KBWAccessPanel:onResize()
    if ISPanel.onResize then ISPanel.onResize(self) end
    if self.vscroll then
        self.vscroll:setX(self.width - self.vscroll:getWidth())
        self.vscroll:setHeight(self.height)
    end
    self:setScrollHeight(contentHeightFor(self.rows, self:drawWidth(), self.height))
end

function KBWAccessPanel:drawWidth()
    return self.width - (self.vscroll and self.vscroll:getWidth() or 0)
end

function KBWAccessPanel:hasRows()
    return self.rows ~= nil and #self.rows > 0
end

function KBWAccessPanel:setSelection(definition, stage)
    self.definition, self.stage = definition, stage
    local status = definition and stage and Requirements.evaluate(self.player, definition, stage) or { rows = {} }
    self.rows = gateRows(status.rows or {})
    self.clickRows = {}
    self:setYScroll(0)
    self:setScrollHeight(contentHeightFor(self.rows, self:drawWidth(), self.height))
    if self.vscroll then self:updateScrollbars() end
end

function KBWAccessPanel:setSelectedRow(row)
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

function KBWAccessPanel:onMouseWheel(delta)
    local minimum = math.min(0, self.height - self:getScrollHeight())
    self:setYScroll(math.max(minimum, math.min(0, self:getYScroll() - delta * 30)))
    if self.vscroll then self:updateScrollbars() end
    return true
end

function KBWAccessPanel:onMouseDown(x, y)
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

function KBWAccessPanel:drawRow(row, y)
    local color = row.ok and Theme.good or Theme.warn
    local width = self.currentDrawWidth or self:drawWidth()
    local selected = rowKey(row) == self.selectedRowKey
    local fill = selected and Theme.selectedSoft or Theme.surface
    local border = selected and Theme.accent or color
    local rowHeight = rowHeightFor(row, width)
    self:drawRect(0, y, width, rowHeight, fill.a, fill.r, fill.g, fill.b)
    self:drawRectBorder(0, y, width, rowHeight, 0.65, border.r, border.g, border.b)
    local icon = row.kind == "skill" and (skillIcons[row.name] or icons.skill) or icons.book
    if icon then
        self:drawTextureScaledAspect(icon, 8, y + 10, 18, 18, 1, color.r, color.g, color.b)
    else
        self:drawText(row.kind == "skill" and "SK" or "BK", 8, y + 11, color.r, color.g, color.b, 1, UIFont.Small)
    end
    local status = rowStatus(row)
    local w = getTextManager():MeasureStringX(UIFont.Small, status)
    local lines = wrapText(rowTitle(row), math.max(50, width - w - 62))
    local textY = y + 9
    local lineHeight = getTextManager():getFontHeight(UIFont.Small) + 3
    for lineIndex = 1, #lines do
        self:drawText(lines[lineIndex], 34, textY, Theme.text.r, Theme.text.g, Theme.text.b, 1, UIFont.Small)
        textY = textY + lineHeight
    end
    self:drawText(status, width - w - 18, y + 9, color.r, color.g, color.b, 1, UIFont.Small)
    self:drawText(">", width - 10, y + 9, border.r, border.g, border.b, 1, UIFont.Small)
    return rowHeight
end

function KBWAccessPanel:prerender()
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
    if #self.rows == 0 then
        self:drawText(
            getText("IGUI_KBW_NoSkillKnowledge"), 4, 4, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1,
            UIFont.Small
        )
        self.currentDrawWidth = nil
        self:clearStencilRect()
        return
    end
    local y = 4
    for rowIndex = 1, #self.rows do
        local row = self.rows[rowIndex]
        local rowHeight = rowHeightFor(row, self.currentDrawWidth)
        self.clickRows[#self.clickRows + 1] = { y = y, h = rowHeight, row = row }
        local viewY = y + scroll
        if viewY + rowHeight >= 0 and viewY <= self.height then
            self:drawRow(row, y)
        end
        y = y + rowHeight + 6
    end
    self.currentDrawWidth = nil
    self:clearStencilRect()
end

return KBWAccessPanel
