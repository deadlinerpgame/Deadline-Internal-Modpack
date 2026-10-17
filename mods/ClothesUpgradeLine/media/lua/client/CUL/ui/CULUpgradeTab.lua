require "ISUI/ISPanel"
require "ISUI/ISScrollingListBox"
require "ISUI/ISButton"

local S = require("CUL/ui/CULStyle")

CULUpgradeTab = ISPanel:derive("CULUpgradeTab")

function CULUpgradeTab:new(x, y, width, height, playerNum, kind, window)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum or 0
    o.player = getSpecificPlayer(o.playerNum)
    o.kind = kind or "apparel"
    o.window = window
    o.background = false
    o.selectedItem = nil
    o.selectedTrackId = nil
    o.perkLevel = 0
    o.emptyMsg = (kind == "pack")
        and "Carry or wear a bag to upgrade it."
        or  "Carry or wear a garment to upgrade it."
    return o
end

function CULUpgradeTab:createChildren()
    local tab = self

    self.itemList = S.newList(self, S.ROW_H,
        function(t, item) t:onSelectItem(item) end,
        function(list, y, item, alt) return tab:drawItemRow(list, y, item, alt) end)
    self:addChild(self.itemList)

    self.trackList = S.newList(self, S.HS * 2 + 10,
        function(t, track) t:onSelectTrack(track) end,
        function(list, y, item, alt) return tab:drawTrackRow(list, y, item, alt) end)
    self.trackList:setOnMouseDoubleClick(self, CULUpgradeTab.onTrackDoubleClick)
    self:addChild(self.trackList)

    self.upgradeButton = S.newButton(self, "Upgrade", CULUpgradeTab.onUpgrade)
    self:addChild(self.upgradeButton)

    self:layout()
    self:refresh()
end

function CULUpgradeTab:layout()
    local pad, w, h = S.PAD, self:getWidth(), self:getHeight()
    local leftW = math.floor(w / 3)

    self.itemList:setX(pad)
    self.itemList:setY(pad)
    self.itemList:setWidth(leftW - pad)
    self.itemList:setHeight(h - pad * 2)

    local x = leftW + pad
    local rw = w - x - pad
    self.rightX, self.rightW = x, rw

    local y = pad
    self.headerY = y
    y = y + S.ICON + 10 + 6

    self.flawY = y
    if self.kind == "apparel" then y = y + S.HS + 6 end

    self.tracksHeadY = y
    y = y + S.HM + 2

    self.upgradeButton:setX(x)
    self.upgradeButton:setY(h - pad - S.BUTTON_H)
    local bottom = h - pad - S.BUTTON_H - 6

    local listW = math.floor(rw * 0.5)
    self.trackList:setX(x)
    self.trackList:setY(y)
    self.trackList:setWidth(listW)
    self.trackList:setHeight(math.max(self.trackList.itemheight, bottom - y))

    self.detailsX = x + listW + pad
    self.detailsY = y
    self.detailsW = rw - listW - pad
    self.detailsH = math.max(0, bottom - y)

    self.lastW, self.lastH = w, h
end

function CULUpgradeTab:refresh()
    if not self.player then self.player = getSpecificPlayer(self.playerNum) end
    if not self.player then return end
    self.perkLevel = self.player:getPerkLevel(ClothesUpgrade.perk())

    local keep = self.selectedItem
    self.itemList:clear()
    local items = ClothesUpgrade.collectItems(self.player, self.kind)
    local reselect = nil
    for i, it in ipairs(items) do
        ClothesUpgrade.reapply(it)
        self.itemList:addItem(it:getName(), it)
        if keep and it == keep then reselect = i end
    end

    if reselect then
        self.itemList.selected = reselect
        self.selectedItem = keep
    elseif #items > 0 then
        self.itemList.selected = 1
        self.selectedItem = items[1]
    else
        self.itemList.selected = 0
        self.selectedItem = nil
    end
    self:refreshTracks()
end

function CULUpgradeTab:onSelectItem(item)
    self.selectedItem = item
    self.selectedTrackId = nil
    self:refreshTracks()
end

function CULUpgradeTab:refreshTracks()
    self.perkLevel = self.player:getPerkLevel(ClothesUpgrade.perk())
    self.trackList:clear()
    if not self.selectedItem then
        self.trackList.selected = 0
        return
    end
    local tracks = ClothesUpgrade.getTracks(self.selectedItem)
    local reselect = nil
    for i, t in ipairs(tracks) do
        local label = ClothesUpgrade.Stats[t.stat or t.id]
        label = (label and label.label) or (t.stat or t.id)
        self.trackList:addItem(label, t)
        if self.selectedTrackId and ClothesUpgrade.trackId(t) == self.selectedTrackId then reselect = i end
    end
    if reselect then
        self.trackList.selected = reselect
    elseif #tracks > 0 then
        self.trackList.selected = 1
        self.selectedTrackId = ClothesUpgrade.trackId(tracks[1])
    else
        self.trackList.selected = 0
        self.selectedTrackId = nil
    end
end

function CULUpgradeTab:onSelectTrack(track)
    self.selectedTrackId = ClothesUpgrade.trackId(track)
end

function CULUpgradeTab:selectedTrack()
    if not (self.selectedItem and self.selectedTrackId) then return nil end
    for _, t in ipairs(ClothesUpgrade.getTracks(self.selectedItem)) do
        if ClothesUpgrade.trackId(t) == self.selectedTrackId then return t end
    end
    return nil
end

function CULUpgradeTab:status(track)
    return ClothesUpgrade.trackStatus(self.player:getInventory(), self.selectedItem, track, self.perkLevel)
end

function CULUpgradeTab:blockReason(st)
    if not self.selectedItem then return "Select an item." end
    if not st then return "Select an upgrade." end
    if st.atCap then return "This upgrade is at its maximum." end
    if not st.meetsSkill then return "Requires " .. S.perkName(ClothesUpgrade.perk()) .. " " .. st.skillMin .. "." end
    if not st.hasTools then return "A required tool is missing." end
    if not st.haveAll then return "Required items are missing." end
    return nil
end

function CULUpgradeTab:onUpgrade()
    local item = self.selectedItem
    local track = self:selectedTrack()
    if not (item and track) then return end
    local inv = self.player:getInventory()
    if not ClothesUpgrade.canUpgrade(inv, item, track, self.perkLevel) then return end
    local bench = self.window and self.window.bench or nil
    local time = ClothesUpgrade.computeTime(self.player, item)
    local tab = self
    ISTimedActionQueue.add(CULUpgradeAction:new(self.player, item, track, time, function()
        if tab.javaObject then tab:refresh() end
    end, bench))
end

function CULUpgradeTab:onTrackDoubleClick(track)
    self.selectedTrackId = ClothesUpgrade.trackId(track)
    if self:blockReason(self:status(track)) == nil then self:onUpgrade() end
end

function CULUpgradeTab:drawItemRow(list, y, item, alt)
    local it = item.item
    local sub
    if self.kind == "pack" then
        local cap = ClothesUpgrade.statGetLive(it, "capacity")
        if cap then sub = "Capacity: " .. ClothesUpgrade.formatStat("capacity", cap) end
    else
        if it.getBodyLocation then sub = it:getBodyLocation() end
    end
    local md = it:getModData()
    local flawed = md.CUL and md.CUL.flaws and #md.CUL.flaws > 0
    return S.drawRow(list, y, item, S.texture(it), item.text, sub, flawed and S.bad() or S.white, true)
end

function CULUpgradeTab:drawTrackRow(list, y, item, alt)
    local track = item.item
    local h = item.height or list.itemheight
    if not self.selectedItem then return y + h end
    local st = self:status(track)
    local usable = self:blockReason(st) == nil
    local a = (usable or st.atCap) and 0.9 or 0.3
    local w = list:getWidth()
    local bc = list.borderColor
    list:drawRectBorder(0, y, w, h - 1, a, bc.r, bc.g, bc.b)
    if list.selected == item.index then
        list:drawRect(0, y, w, h - 1, 0.3, 0.7, 0.35, 0.15)
    end

    local ty = y + (h - S.HS * 2) / 2
    list:drawText(item.text, 6, ty, 1, 1, 1, a, UIFont.Small)
    if st.maxLevel then
        local lvl = st.level .. " / " .. st.maxLevel
        list:drawText(lvl, w - 6 - S.textWidth(UIFont.Small, lvl), ty, 1, 1, 1, a, UIFont.Small)
    end

    local cur = st.current or st.base or 0
    local line, c
    if st.atCap then
        line, c = ClothesUpgrade.formatStat(st.statId, cur) .. "  (maximum)", S.good()
    else
        local nxt = cur + (st.effStep or st.perStep)
        line = ClothesUpgrade.formatStat(st.statId, cur) .. " -> " .. ClothesUpgrade.formatStat(st.statId, nxt)
        c = usable and S.chanceColor(st.chance) or S.grey
        if usable then line = line .. "   " .. S.percent(st.chance) end
    end
    list:drawText(line, 6, ty + S.HS, c.r, c.g, c.b, a, UIFont.Small)
    return y + h
end

function CULUpgradeTab:prerender()
    if self.lastW ~= self:getWidth() or self.lastH ~= self:getHeight() then self:layout() end
    ISPanel.prerender(self)
    local track = self:selectedTrack()
    local st = track and self:status(track) or nil
    local reason = self:blockReason(st)
    S.setButtonState(self.upgradeButton, reason == nil, reason)
end

function CULUpgradeTab:render()
    ISPanel.render(self)
    local x = self.rightX
    local it = self.selectedItem
    if not it then
        S.drawLine(self, self.emptyMsg, x, self.headerY, S.white, UIFont.Medium)
        return
    end

    local sub = S.perkName(ClothesUpgrade.perk()) .. " " .. self.perkLevel
    S.drawHeader(self, x, self.headerY, S.texture(it), it:getName(), sub)

    if self.kind == "apparel" then
        local md = it:getModData()
        local flaws = md.CUL and md.CUL.flaws
        if flaws and #flaws > 0 then
            local labels = {}
            for _, f in ipairs(flaws) do labels[#labels + 1] = f.label or "flaw" end
            S.drawLine(self, "Flaws: " .. table.concat(labels, ", "), x, self.flawY, S.bad())
        else
            S.drawLine(self, "No flaws.", x, self.flawY, S.grey)
        end
    end

    S.drawSection(self, "Upgrades:", x, self.tracksHeadY)
    if (self.trackList.count or 0) == 0 then
        S.drawLine(self, "Nothing to upgrade on this item.", x + 6, self.detailsY + 4, S.grey)
        return
    end
    self:drawTrackDetails()
end

function CULUpgradeTab:drawTrackDetails()
    local track = self:selectedTrack()
    if not track then return end
    local st = self:status(track)
    local inv = self.player:getInventory()
    local x, y = self.detailsX, self.detailsY
    local fmt = function(v) return ClothesUpgrade.formatStat(st.statId, v) end

    self:setStencilRect(x, y, self.detailsW, self.detailsH)

    local cur = st.current or st.base or 0
    y = S.drawLine(self, "Level: " .. st.level .. (st.maxLevel and (" / " .. st.maxLevel) or ""), x, y, S.white, UIFont.Medium)
    y = S.drawLine(self, " - Current: " .. fmt(cur), x + 15, y, S.white)
    if not st.atCap then
        y = S.drawLine(self, " - Next level: " .. fmt(cur + (st.effStep or st.perStep)), x + 15, y, S.white)
    end
    if st.maxValue then
        y = S.drawLine(self, " - Maximum: " .. fmt(st.maxValue), x + 15, y, S.white)
    end
    y = y + 4

    if st.atCap then
        S.drawLine(self, "This upgrade is at its maximum.", x, y, S.good())
        self:clearStencilRect()
        return
    end

    local recipe = st.recipe or {}
    if recipe.items and #recipe.items > 0 then
        y = S.drawSection(self, "Required Items:", x, y)
        for _, req in ipairs(recipe.items) do
            local need = req.count or 1
            local have = ClothesUpgrade.availableForReq(inv, req)
            y = S.drawReqLine(self, x, y, S.texture(req.item),
                S.displayName(req.item) .. ": " .. have .. " / " .. need, have >= need)
        end
        y = y + 4
    end
    local tools = st.tools or recipe.tools
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
        y = S.drawSkillLine(self, x, y, ClothesUpgrade.perk(), self.perkLevel, st.skillMin)
        y = y + 4
    end
    S.drawLine(self, "Success chance: " .. S.percent(st.chance), x, y, S.chanceColor(st.chance), UIFont.Medium)
    self:clearStencilRect()
end
