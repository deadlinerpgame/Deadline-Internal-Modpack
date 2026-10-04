require "ISUI/ISPanel"
require "ISUI/ISScrollingListBox"
require "ISUI/ISButton"
require "ISUI/ISColorPicker"
require "ISUI/ISTextEntryBox"

local S = require("CUL/ui/CULStyle")

CULAppearanceTab = ISPanel:derive("CULAppearanceTab")

local function clamp255(v)
    if type(v) == "table" and v.getText then v = v:getText() end
    v = tonumber(v) or 0
    if v < 0 then v = 0 elseif v > 255 then v = 255 end
    return math.floor(v + 0.5)
end

function CULAppearanceTab:new(x, y, width, height, playerNum, window)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum or 0
    o.player = getSpecificPlayer(o.playerNum)
    o.window = window
    o.background = false
    o.selectedItem = nil
    o.appr = nil
    o.perkLevel = 0
    o.dirty = false
    o._syncingRGB = false
    o.origR, o.origG, o.origB = 1, 1, 1
    o.curR, o.curG, o.curB = 1, 1, 1
    o.origTex, o.curTex = 0, 0
    return o
end

function CULAppearanceTab:createChildren()
    local tab = self

    self.itemList = S.newList(self, S.ROW_H,
        function(t, item) t:onSelectItem(item) end,
        function(list, y, item, alt) return tab:drawItemRow(list, y, item, alt) end)
    self:addChild(self.itemList)

    self.chooseColorBtn = S.newButton(self, "Choose Colour", CULAppearanceTab.openColorPicker)
    self:addChild(self.chooseColorBtn)

    self.rBox = ISTextEntryBox:new("", 0, 0, 10, S.BUTTON_H)
    self.gBox = ISTextEntryBox:new("", 0, 0, 10, S.BUTTON_H)
    self.bBox = ISTextEntryBox:new("", 0, 0, 10, S.BUTTON_H)
    for _, e in ipairs({ self.rBox, self.gBox, self.bBox }) do
        e:initialise()
        e:instantiate()
        e:setOnlyNumbers(true)
        e:setMaxTextLength(3)
        e.onTextChange = function() tab:onRGBChanged() end
        self:addChild(e)
    end

    self.texPrevBtn = S.newButton(self, "<", function(s) s:onTexStep(-1) end)
    self:addChild(self.texPrevBtn)
    self.texNextBtn = S.newButton(self, ">", function(s) s:onTexStep(1) end)
    self:addChild(self.texNextBtn)

    self.applyBtn = S.newButton(self, "Apply", CULAppearanceTab.onApply)
    self:addChild(self.applyBtn)
    self.revertBtn = S.newButton(self, "Revert", CULAppearanceTab.onRevert)
    self:addChild(self.revertBtn)

    if ISColorPicker then
        self.colorPicker = ISColorPicker:new(0, 0)
        self.colorPicker:initialise()
        self.colorPicker.keepOnScreen = true
        self.colorPicker.pickedTarget = self
        self.colorPicker.resetFocusTo = self
    end

    self:layout()
    self:refresh()
end

function CULAppearanceTab:layout()
    local pad, w, h = S.PAD, self:getWidth(), self:getHeight()
    local leftW = math.floor(w / 3)

    self.itemList:setX(pad)
    self.itemList:setY(pad)
    self.itemList:setWidth(leftW - pad)
    self.itemList:setHeight(h - pad * 2)

    local x = leftW + pad
    local rw = w - x - pad
    self.rightX, self.rightW = x, rw
    local rowH = S.BUTTON_H

    local y = pad
    self.headerY = y
    y = y + S.ICON + 10 + 6

    self.colorHeadY = y
    y = y + S.HM + 2
    self.swatchY = y
    self.swatchW = rowH
    self.chooseColorBtn:setX(x + self.swatchW + 8)
    self.chooseColorBtn:setY(y)
    y = y + rowH + 4

    self.rgbRowY = y
    local boxW = S.textWidth(UIFont.Small, "000") + 16
    local letterW = S.textWidth(UIFont.Small, "G") + 6
    self.rgbLetterX = {}
    local bx = x
    for i, box in ipairs({ self.rBox, self.gBox, self.bBox }) do
        self.rgbLetterX[i] = bx
        box:setX(bx + letterW)
        box:setY(y)
        box:setWidth(boxW)
        box:setHeight(rowH)
        bx = bx + letterW + boxW + 12
    end
    y = y + rowH + 8

    self.texHeadY = y
    y = y + S.HM + 2
    self.texRowY = y
    self.texPrevBtn:setX(x)
    self.texPrevBtn:setY(y)
    self.texTextX = x + self.texPrevBtn:getWidth() + 8
    self.texNextBtn:setX(self.texTextX + S.textWidth(UIFont.Small, "Variant 00 / 00") + 8)
    self.texNextBtn:setY(y)
    y = y + rowH + 8

    self.costY = y
    self.applyBtn:setX(x)
    self.applyBtn:setY(h - pad - S.BUTTON_H)
    self.revertBtn:setX(x + self.applyBtn:getWidth() + 5)
    self.revertBtn:setY(h - pad - S.BUTTON_H)
    self.costH = math.max(0, (h - pad - S.BUTTON_H - 6) - y)

    self.lastW, self.lastH = w, h
end

function CULAppearanceTab:setControlsVisibility()
    local a = self.appr
    local canTint = (a and a.canTint) or false
    self.chooseColorBtn:setVisible(canTint)
    self.rBox:setVisible(canTint)
    self.gBox:setVisible(canTint)
    self.bBox:setVisible(canTint)
    local hasTex = (a and a.textureCount and a.textureCount > 1) or false
    self.texPrevBtn:setVisible(hasTex)
    self.texNextBtn:setVisible(hasTex)
end

function CULAppearanceTab:syncRGBBoxes()
    if not (self.rBox and self.gBox and self.bBox) then return end
    self._syncingRGB = true
    self.rBox:setText(tostring(clamp255((self.curR or 0) * 255)))
    self.gBox:setText(tostring(clamp255((self.curG or 0) * 255)))
    self.bBox:setText(tostring(clamp255((self.curB or 0) * 255)))
    self._syncingRGB = false
end

function CULAppearanceTab:onRGBChanged()
    if self._syncingRGB then return end
    if not (self.selectedItem and self.appr and self.appr.canTint) then return end
    local r = clamp255(self.rBox:getText()) / 255
    local g = clamp255(self.gBox:getText()) / 255
    local b = clamp255(self.bBox:getText()) / 255
    self:ensurePreviewMarked()
    self.curR, self.curG, self.curB = r, g, b
    self.dirty = true
    ClothesUpgrade.applyTint(self.player, self.selectedItem, r, g, b)
end

function CULAppearanceTab:onSelectItem(item)
    if item ~= self.selectedItem then self:revertPending() end
    self.selectedItem = item
    self.appr = item and ClothesUpgrade.getAppearance(item) or nil
    if item then
        self.origR, self.origG, self.origB = ClothesUpgrade.getTintRGB(item)
        self.origTex = ClothesUpgrade.getTextureIndex(item)
    else
        self.origR, self.origG, self.origB = 1, 1, 1
        self.origTex = 0
    end
    self.curR, self.curG, self.curB = self.origR, self.origG, self.origB
    self.curTex = self.origTex
    self.dirty = false
    self:setControlsVisibility()
    self:syncRGBBoxes()
    self:closeColorPicker()
end

function CULAppearanceTab:openColorPicker()
    if not (self.selectedItem and self.appr and self.appr.canTint) then return end
    local p = self.colorPicker
    if not p then return end
    local btn = self.chooseColorBtn
    local pw = p:getWidth()
    if not pw or pw <= 0 then pw = 264 end
    local ph = p:getHeight()
    if not ph or ph <= 0 then ph = 250 end

    local px = btn:getX() + btn:getWidth() - pw
    if px < 0 then px = 0 end
    local py = btn:getY() + btn:getHeight() + 2
    if py + ph > self:getHeight() then
        py = btn:getY() - ph - 2
        if py < 0 then py = 0 end
    end

    p:setX(px)
    p:setY(py)
    p:setInitialColor(ColorInfo.new(self.curR, self.curG, self.curB, 1))
    p:setPickedFunc(CULAppearanceTab.onColorPicked, nil)
    self:removeChild(p)
    self:addChild(p)
end

function CULAppearanceTab:closeColorPicker()
    if self.colorPicker then self:removeChild(self.colorPicker) end
end

function CULAppearanceTab:ensurePreviewMarked()
    local it = self.selectedItem
    if not it then return end
    local md = it:getModData()
    if md.CULpv then return end
    md.CULpv = { tint = { self.origR, self.origG, self.origB }, tex = self.origTex }
end

function CULAppearanceTab:clearPreviewFlag()
    if self.selectedItem then self.selectedItem:getModData().CULpv = nil end
end

function CULAppearanceTab:onColorPicked(color, mouseUp, arg)
    if not self.selectedItem then return end
    self:ensurePreviewMarked()
    self.curR, self.curG, self.curB = color.r, color.g, color.b
    self.dirty = true
    self:syncRGBBoxes()
    ClothesUpgrade.applyTint(self.player, self.selectedItem, color.r, color.g, color.b)
end

function CULAppearanceTab:onTexStep(delta)
    if not (self.selectedItem and self.appr and self.appr.textureCount > 1) then return end
    local n = self.appr.textureCount
    self:ensurePreviewMarked()
    self.curTex = ((self.curTex or 0) + delta) % n
    self.dirty = true
    ClothesUpgrade.applyTexture(self.player, self.selectedItem, self.curTex)
end

function CULAppearanceTab:revertPending()
    if not (self.selectedItem and self.player) then self.dirty = false; return end
    if self.dirty then
        ClothesUpgrade.applyTint(self.player, self.selectedItem, self.origR, self.origG, self.origB)
        if self.appr and self.appr.textureCount and self.appr.textureCount > 1 then
            ClothesUpgrade.applyTexture(self.player, self.selectedItem, self.origTex)
        end
        self.curR, self.curG, self.curB = self.origR, self.origG, self.origB
        self.curTex = self.origTex
        self:syncRGBBoxes()
    end
    self:clearPreviewFlag()
    self.dirty = false
end

function CULAppearanceTab:onApply()
    if not (self.dirty and self.selectedItem and self.player) then return end
    if not ClothesUpgrade.canDye(self.player:getInventory(), self.perkLevel) then return end
    ClothesUpgrade.consumeDye(self.player)
    self.origR, self.origG, self.origB = self.curR, self.curG, self.curB
    self.origTex = self.curTex
    self:clearPreviewFlag()
    self.dirty = false
    if HaloTextHelper and HaloTextHelper.addText then
        local c = HaloTextHelper.getColorGreen and HaloTextHelper.getColorGreen()
        if c then
            HaloTextHelper.addText(self.player, "Recoloured", c)
        else
            HaloTextHelper.addText(self.player, "Recoloured")
        end
    end
    self:refresh()
end

function CULAppearanceTab:onRevert()
    self:revertPending()
end

function CULAppearanceTab:onHide()
    self:revertPending()
    self:closeColorPicker()
end

function CULAppearanceTab:refresh()
    if not self.player then self.player = getSpecificPlayer(self.playerNum) end
    if not self.player then return end
    self.perkLevel = self.player:getPerkLevel(ClothesUpgrade.perk())
    self:revertPending()

    local keep = self.selectedItem
    self.itemList:clear()
    local items = ClothesUpgrade.collectAppearanceItems(self.player)
    local reselect = nil
    for i, it in ipairs(items) do
        self.itemList:addItem(it:getName(), it)
        if keep and it == keep then reselect = i end
    end
    if reselect then
        self.itemList.selected = reselect
        self:onSelectItem(keep)
    elseif #items > 0 then
        self.itemList.selected = 1
        self:onSelectItem(items[1])
    else
        self.itemList.selected = 0
        self:onSelectItem(nil)
    end
end

function CULAppearanceTab:blockReason(st)
    if not self.selectedItem then return "Select an item." end
    if not self.dirty then return "Change the colour or texture first." end
    if not st.meetsSkill then return "Requires " .. S.perkName(ClothesUpgrade.perk()) .. " " .. st.skillMin .. "." end
    if not st.hasTools then return "A required tool is missing." end
    if not st.haveAll then return "You need dye to apply this." end
    return nil
end

function CULAppearanceTab:drawItemRow(list, y, item, alt)
    local it = item.item
    local a = ClothesUpgrade.getAppearance(it)
    local parts = {}
    if a then
        if a.canTint then parts[#parts + 1] = "Dyeable" end
        if a.textureCount and a.textureCount > 1 then parts[#parts + 1] = a.textureCount .. " textures" end
    end
    return S.drawRow(list, y, item, S.texture(it), item.text, table.concat(parts, ", "), S.white, true)
end

function CULAppearanceTab:prerender()
    if self.lastW ~= self:getWidth() or self.lastH ~= self:getHeight() then self:layout() end
    ISPanel.prerender(self)
    local st = ClothesUpgrade.dyeStatus(self.player:getInventory(), self.perkLevel)
    local reason = self:blockReason(st)
    S.setButtonState(self.applyBtn, reason == nil, reason)
    S.setButtonState(self.revertBtn, self.dirty, "Nothing to revert.")
end

function CULAppearanceTab:render()
    ISPanel.render(self)
    local x, w = self.rightX, self.rightW
    local it = self.selectedItem
    if not it then
        S.drawLine(self, "Carry or wear an item that can be dyed or reskinned.", x, self.headerY, S.white, UIFont.Medium)
        return
    end

    S.drawHeader(self, x, self.headerY, S.texture(it), it:getName(),
        self.dirty and "Preview - not applied yet" or nil, S.bad())

    S.drawSection(self, "Colour:", x, self.colorHeadY)
    if self.appr and self.appr.canTint then
        local sw = self.swatchW
        self:drawRect(x, self.swatchY, sw, sw, 1, self.curR, self.curG, self.curB)
        self:drawRectBorder(x, self.swatchY, sw, sw, 1, 1, 1, 1)
        local letters = { "R", "G", "B" }
        local ly = self.rgbRowY + (S.BUTTON_H - S.HS) / 2
        for i = 1, 3 do
            self:drawText(letters[i], self.rgbLetterX[i], ly, 1, 1, 1, 1, UIFont.Small)
        end
    else
        S.drawLine(self, "This item can't be dyed.", x, self.swatchY + (S.BUTTON_H - S.HS) / 2, S.grey)
    end

    S.drawSection(self, "Texture:", x, self.texHeadY)
    local ty = self.texRowY + (S.BUTTON_H - S.HS) / 2
    if self.appr and self.appr.textureCount and self.appr.textureCount > 1 then
        local txt = string.format("Variant %d / %d", (self.curTex or 0) + 1, self.appr.textureCount)
        self:drawText(txt, self.texTextX, ty, 1, 1, 1, 1, UIFont.Small)
    else
        S.drawLine(self, "No other textures.", x, ty, S.grey)
    end

    local inv = self.player:getInventory()
    local st = ClothesUpgrade.dyeStatus(inv, self.perkLevel)
    local y = self.costY
    self:setStencilRect(x, y, w, self.costH)
    if st.free then
        S.drawLine(self, "Changing the look costs nothing.", x, y, S.grey)
    else
        if st.cost and #st.cost > 0 then
            y = S.drawSection(self, "Cost Per Application:", x, y)
            for _, req in ipairs(st.cost) do
                local need = req.count or 1
                local have = ClothesUpgrade.availableForReq(inv, req)
                y = S.drawReqLine(self, x, y, S.texture(req.item),
                    S.displayName(req.item) .. ": " .. have .. " / " .. need, have >= need)
            end
            y = y + 4
        end
        local tools = (ClothesUpgrade.Config.dye or {}).tools
        if tools and #tools > 0 then
            y = S.drawSection(self, "Required Tools:", x, y)
            for _, t in ipairs(tools) do
                local ft = ClothesUpgrade.toolType(t)
                y = S.drawReqLine(self, x, y, S.texture(ft), S.displayName(ft), ClothesUpgrade.hasTool(inv, t))
            end
            y = y + 4
        end
        if (st.skillMin or 0) > 0 then
            y = S.drawSection(self, "Required Skills:", x, y)
            S.drawSkillLine(self, x, y, ClothesUpgrade.perk(), self.perkLevel, st.skillMin)
        end
    end
    self:clearStencilRect()
end
