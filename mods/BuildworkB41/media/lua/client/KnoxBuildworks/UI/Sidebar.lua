require "ISUI/ISEquippedItem"
require "ISUI/ISPanel"
require "ISUI/ISButton"

local KBW = require("KnoxBuildworks/Core")
local Catalog = require("KnoxBuildworks/UI/Catalog")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local UI_BORDER_SPACING = 10
local POPUP_HOVER_GRACE = 8
local PLANNING_MODE_TEXTURE = getTexture("media/ui/KBW_Planning_Mode.png")

local Sidebar = {}

local function replaceBuildMenu()
    return KBW.sandboxValue("KnoxBuildworks.ReplaceBuildMenu", false) == true
end

local function planningEnabled()
    return KBW.sandboxValue("KnoxBuildworks.EnablePlanningMode", true) == true
end

local function toggleCatalog(player)
    if KBWPlanningMode and KBWPlanningMode.instance then KBWPlanningMode.instance:close() end
    if KBWCatalog and KBWCatalog.instance then
        KBWCatalog.instance:close()
    else
        Catalog.open(player)
    end
end

local function togglePlanning(player)
    if not planningEnabled() then
        if HaloTextHelper then
            KBWB41.halo(player, getText("IGUI_KBW_PlanningDisabled"), true)
        end
        return
    end
    local PlanningMode = require("KnoxBuildworks/UI/PlanningMode")
    if KBWCatalog and KBWCatalog.instance then KBWCatalog.instance:close() end
    if PlanningMode.instance then
        PlanningMode.instance:close()
    else
        PlanningMode.open(player)
    end
end

KBWSidebarPopup = ISPanel:derive("KBWSidebarPopup")

function KBWSidebarPopup:new(owner)
    local size = owner.buildBtn:getWidth()
    if size <= 0 then size = owner.buildBtn:getHeight() end
    if size <= 0 then size = 48 end
    local o = ISPanel:new(10 + owner.buildBtn:getX(), 10 + owner.buildBtn:getY(), size, size)
    setmetatable(o, self)
    self.__index = self
    o.owner = owner
    o.background = true
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.7 }
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.entries = {}
    o.entrySignature = ""
    return o
end

local function popupEntries(owner)
    local entries = {}
    if replaceBuildMenu() then
        entries[#entries + 1] = {
            icon = owner.moveableIconBuildOn,
            label = getText("IGUI_KBW_Title"),
            onClick = toggleCatalog,
            isActive = function () return KBWCatalog and KBWCatalog.instance ~= nil end
        }
    else
        entries[#entries + 1] = {
            icon = owner.moveableIconBuildOn,
            label = getText("IGUI_KBW_Title"),
            onClick = toggleCatalog,
            isActive = function () return KBWCatalog and KBWCatalog.instance ~= nil end
        }
    end
    if planningEnabled() then
        entries[#entries + 1] = {
            icon = PLANNING_MODE_TEXTURE or owner.moveableIconBuildOn,
            label = getText("IGUI_KBW_PlanningMode"),
            onClick = togglePlanning,
            isActive = function () return KBWPlanningMode and KBWPlanningMode.instance ~= nil end
        }
    end
    return entries
end

function KBWSidebarPopup:refreshEntries()
    local owner = self.owner
    local size = owner.buildBtn:getWidth()
    if size <= 0 then size = owner.buildBtn:getHeight() end
    if size <= 0 then size = 48 end
    local signature = tostring(replaceBuildMenu()) .. "|" .. tostring(planningEnabled()) .. "|" .. tostring(size)
    if signature ~= self.entrySignature then
        self.entries = popupEntries(owner)
        self.entrySignature = signature
    end
    self.iconSize = size
    local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
    local widestLabel = size
    for entryIndex = 1, #self.entries do
        local entry = self.entries[entryIndex]
        local label = tostring(entry.label or "")
        widestLabel = math.max(
            widestLabel, getTextManager():MeasureStringX(UIFont.Small, label) + UI_BORDER_SPACING * 2
        )
    end
    self.labelHeight = fontHgt + 6
    self:setWidth(math.max(#self.entries * size, widestLabel))
    self:setHeight(size + self.labelHeight)
end

function KBWSidebarPopup:prerender()
    self:setAlwaysOnTop(true)
    self:refreshEntries()
    self:bringToTop()
end

function KBWSidebarPopup:render()
    local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
    local size = self.iconSize or (self.height - fontHgt - 6)
    self:drawRect(0, 0, self.width, self.height, 0.80, 0, 0, 0)
    local index = math.floor(self:getMouseX() / size)
    if index >= 0 and index < #self.entries then
        self:drawRect(index * size, 0, size, self.height, 0.15, 1, 1, 1)
        local label = tostring(self.entries[index + 1].label or "")
        local labelW = getTextManager():MeasureStringX(UIFont.Small, label)
        local labelX = index * size + math.floor((size - labelW) / 2)
        labelX = math.max(UI_BORDER_SPACING, math.min(labelX, self.width - UI_BORDER_SPACING - labelW))
        self:drawText(label, labelX, size + 2, 1.0, 0.85, 0.05, 1.0, UIFont.Small)
    end
    for entryIndex = 1, #self.entries do
        local entry = self.entries[entryIndex]
        local x = (entryIndex - 1) * size
        if entry.icon then self:drawTextureScaledAspect(entry.icon, x, 0, size, size, 1, 1, 1, 1) end
        if entry.isActive and entry.isActive(self.owner.chr) then
            self:drawRectBorder(x, 0, size, size, 0.5, 1, 1, 1)
        end
    end
end

function KBWSidebarPopup:onMouseDown(x, y)
    return true
end

function KBWSidebarPopup:onMouseUp(x, y)
    local size = self.iconSize or self.height
    local index = math.floor(x / size) + 1
    local entry = self.entries and self.entries[index] or nil
    self:setVisible(false)
    if self.owner and self.owner.buildBtn then self.owner.buildBtn:setVisible(true) end
    if entry and entry.onClick and self.owner then entry.onClick(self.owner.chr) end
    return true
end

local original_createChildren = ISEquippedItem.createChildren

local warnedNoBuildButton = false

local function ensurePopup(owner)
    if owner and not owner.buildBtn and not warnedNoBuildButton then
        warnedNoBuildButton = true
        require("KnoxBuildworks/Log"):info(
            "Sidebar build button not present in this build; "
            .. "use the right-click menu, the Menu Dock or the catalog keybind"
        )
    end
    if not owner or not owner.buildBtn or owner.KBWPopup then return end
    if owner.KBWVanillaBuildTooltip and owner.mouseOverList then
        for index = #owner.mouseOverList, 1, -1 do
            local item = owner.mouseOverList[index]
            if item and item.object == owner.buildBtn then table.remove(owner.mouseOverList, index) end
        end
    end
    owner.KBWVanillaBuildTooltip = true
    owner:addMouseOverToolTipItem(owner.buildBtn, getText("Tooltip_KBW_BuildButton"))
    owner.KBWPopup = KBWSidebarPopup:new(owner)
    owner.KBWPopup:refreshEntries()
    owner.KBWPopup:addToUIManager()
    owner.KBWPopup:setVisible(false)
    owner.KBWPopupHoverGrace = 0
end

if original_createChildren then
    function ISEquippedItem:createChildren()
        original_createChildren(self)
        ensurePopup(self)
    end
end

local original_initialise = ISEquippedItem.initialise
function ISEquippedItem:initialise()
    original_initialise(self)
    ensurePopup(self)
end

local original_prerender = ISEquippedItem.prerender
function ISEquippedItem:prerender()
    original_prerender(self)
    local popup = self.KBWPopup
    if not popup or not self.buildBtn then return end
    local buttonOver = self.buildBtn:isVisible() and self.buildBtn:isMouseOver()
    local popupOver = popup:isVisible() and popup:isMouseOver()
    if buttonOver or popupOver then
        popup:refreshEntries()
        local popupX = self:getX() + self.buildBtn:getX()
        local maxX = getCore():getScreenWidth() - popup:getWidth()
        popup:setX(math.max(0, math.min(popupX, maxX)))
        popup:setY(self:getY() + self.buildBtn:getY())
        popup:setVisible(true)
        popup:bringToTop()
        self.buildBtn:setVisible(false)
        self.KBWPopupHoverGrace = POPUP_HOVER_GRACE
    elseif popup:isVisible() then
        self.KBWPopupHoverGrace = (self.KBWPopupHoverGrace or 0) - 1
        if self.KBWPopupHoverGrace > 0 then
            popup:bringToTop()
            self.buildBtn:setVisible(false)
        else
            popup:setVisible(false)
            self.buildBtn:setVisible(true)
        end
    end
end

local original_onOptionMouseDown = ISEquippedItem.onOptionMouseDown
function ISEquippedItem:onOptionMouseDown(button, x, y)
    if button.internal == "BUILD" and replaceBuildMenu() then
        toggleCatalog(self.chr)
        return
    end
    original_onOptionMouseDown(self, button, x, y)
end

KBWB41.addEvent("OnCreatePlayer", function ()
    ensurePopup(ISEquippedItem.instance)
end)

ensurePopup(ISEquippedItem.instance)

local original_removeFromUIManager = ISEquippedItem.removeFromUIManager
function ISEquippedItem:removeFromUIManager()
    if self.KBWPopup then
        self.KBWPopup:removeFromUIManager()
        self.KBWPopup = nil
    end
    original_removeFromUIManager(self)
end

return Sidebar
