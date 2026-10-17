require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISScrollingListBox"

local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local Theme = require("KnoxBuildworks/UI/Theme")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

KBWBlueprintImportWindow = ISPanel:derive("KBWBlueprintImportWindow")
KBWBlueprintImportWindow.instance = nil

function KBWBlueprintImportWindow.open(player, onImported)
    if KBWBlueprintImportWindow.instance then
        KBWBlueprintImportWindow.instance:close()
    end
    local width, height = 360, 320
    local x = math.floor((getCore():getScreenWidth() - width) / 2)
    local y = math.floor((getCore():getScreenHeight() - height) / 2)
    local window = KBWBlueprintImportWindow:new(x, y, width, height, player, onImported)
    window:initialise()
    window:addToUIManager()
    window:bringToTop()
    KBWBlueprintImportWindow.instance = window
    return window
end

function KBWBlueprintImportWindow:new(x, y, width, height, player, onImported)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.onImported = onImported
    o.backgroundColor = { r = Theme.backdrop.r, g = Theme.backdrop.g, b = Theme.backdrop.b, a = 0.94 }
    o.borderColor = Theme.border
    o.moveWithMouse = true
    o:setWantKeyEvents(true)
    return o
end

function KBWBlueprintImportWindow:createChildren()
    local pad, gap = 12, 8
    local buttonH = math.max(26, FONT_HGT_SMALL + 10)
    local listTop = pad + FONT_HGT_SMALL + 6 + FONT_HGT_SMALL + 8
    local listHeight = self.height - listTop - pad * 2 - buttonH

    self.fileList = ISScrollingListBox:new(pad, listTop, self.width - pad * 2, listHeight)
    self.fileList:initialise()
    self.fileList:instantiate()
    self.fileList.itemheight = FONT_HGT_SMALL * 2 + 12
    self.fileList.font = UIFont.Small
    self.fileList.drawBorder = true
    self.fileList.backgroundColor = Theme.surface
    self.fileList.borderColor = Theme.borderSoft
    self.fileList.doDrawItem = KBWBlueprintImportWindow.drawFileItem
    local owner = self
    self.fileList:setOnMouseDoubleClick(self, function ()
        owner:onImport()
    end)
    self:addChild(self.fileList)

    local buttonY = self.height - pad - buttonH
    local buttonW = math.floor((self.width - pad * 2 - gap * 2) / 3)
    self.importButton = ISButton:new(
        pad, buttonY, buttonW, buttonH, getText("IGUI_KBW_Import"), self, self.onImport
    )
    self.importButton:initialise()
    Theme.applyButton(self.importButton)
    self:addChild(self.importButton)
    self.refreshButton = ISButton:new(
        pad + buttonW + gap, buttonY, buttonW, buttonH, getText("IGUI_KBW_Refresh"), self, self.refreshFiles
    )
    self.refreshButton:initialise()
    Theme.applyButton(self.refreshButton)
    self:addChild(self.refreshButton)
    self.closeButton = ISButton:new(
        pad + (buttonW + gap) * 2, buttonY, buttonW, buttonH, getText("IGUI_KBW_Close"), self, self.close
    )
    self.closeButton:initialise()
    Theme.applyButton(self.closeButton)
    self:addChild(self.closeButton)

    self:refreshFiles()
end

function KBWBlueprintImportWindow:drawFileItem(y, item, alt)
    local list = self
    local isMouseOver = list.mouseoverselected == item.index and not list:isMouseOverScrollBar()
    if list.selected == item.index then
        list:drawRect(0, y, list:getWidth(), item.height - 1, 0.26, Theme.accent.r, Theme.accent.g, Theme.accent.b)
    elseif isMouseOver then
        list:drawRect(1, y + 1, list:getWidth() - 2, item.height - 2, 0.16, Theme.text.r, Theme.text.g, Theme.text.b)
    end
    list:drawRectBorder(
        0, y, list:getWidth(), item.height, 0.42, Theme.borderSoft.r, Theme.borderSoft.g, Theme.borderSoft.b
    )
    local detail = item.item or {}
    list:drawText(
        tostring(detail.displayName or item.text or ""), 8, y + 4, Theme.text.r, Theme.text.g, Theme.text.b, 1,
        UIFont.Small
    )
    list:drawText(
        tostring(detail.fileName or ""), 8, y + FONT_HGT_SMALL + 6, Theme.textMuted.r, Theme.textMuted.g,
        Theme.textMuted.b, 1, UIFont.Small
    )
    return y + item.height
end

function KBWBlueprintImportWindow:refreshFiles()
    self.fileList:clear()
    local details = Blueprints.listImportFileDetails()
    for detailIndex = 1, #details do
        local detail = details[detailIndex]
        self.fileList:addItem(detail.displayName, detail)
    end
    Theme.setButtonEnabled(self.importButton, #details > 0)
end

function KBWBlueprintImportWindow:selectedFile()
    local item = self.fileList.items and self.fileList.items[self.fileList.selected]
    return item and item.item and item.item.fileName or nil
end

function KBWBlueprintImportWindow:say(text, bad)
    if bad and HaloTextHelper then
        KBWB41.halo(self.player, text, true)
    elseif HaloTextHelper then
        KBWB41.halo(self.player, text, false)
    end
end

function KBWBlueprintImportWindow:onImport()
    local fileName = self:selectedFile()
    if not fileName then return end
    local blueprint, err = Blueprints.importFromFile(self.player, fileName)
    if not blueprint then
        self:say(
            getText("IGUI_KBW_BlueprintImportFileFailed", Blueprints.importErrorText(err)
            ), true
        )
        return
    end
    self:say(getText("IGUI_KBW_PickBlueprintOrigin"), false)
    local onImported = self.onImported
    self:close()
    if onImported then onImported(blueprint) end
end

function KBWBlueprintImportWindow:prerender()
    ISPanel.prerender(self)
    local pad = 12
    self:drawText(
        getText("IGUI_KBW_ImportBlueprintFile"), pad, pad, Theme.accent.r, Theme.accent.g,
        Theme.accent.b, 1, UIFont.Small
    )
    self:drawText(
        getText("IGUI_KBW_ImportFolderHint") .. Blueprints.EXPORT_FOLDER, pad,
        pad + FONT_HGT_SMALL + 4, Theme.textMuted.r, Theme.textMuted.g, Theme.textMuted.b, 1, UIFont.Small
    )
end

function KBWBlueprintImportWindow:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if KBWBlueprintImportWindow.instance == self then KBWBlueprintImportWindow.instance = nil end
end

function KBWBlueprintImportWindow:isKeyConsumed(key)
    return Keyboard and key == Keyboard.KEY_ESCAPE
end

function KBWBlueprintImportWindow:onKeyRelease(key)
    if self:isVisible() and self:isKeyConsumed(key) then
        self:close()
        return
    end
end

return KBWBlueprintImportWindow
