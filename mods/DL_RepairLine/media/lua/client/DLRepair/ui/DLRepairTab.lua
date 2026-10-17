require "ISUI/ISPanel"
require "ISUI/ISScrollingListBox"
require "ISUI/ISButton"

local S = require("DLRepair/ui/DLRepairStyle")

DLRepairTab = ISPanel:derive("DLRepairTab")

local function optionLabel(option)
    local parts = {}
    for _, req in ipairs(option.items or {}) do
        local n = S.displayName(req.item)
        local cnt = req.count or 1
        parts[#parts + 1] = (cnt > 1) and (n .. " x" .. cnt) or n
    end
    return (#parts > 0) and table.concat(parts, " + ") or "Repair"
end

function DLRepairTab:new(x, y, width, height, playerNum, window)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum or 0
    o.player = getSpecificPlayer(o.playerNum)
    o.window = window
    o.background = false
    o.selectedWeapon = nil
    o.selectedOption = nil
    o.perkLevel = 0
    return o
end

function DLRepairTab:createChildren()
    local tab = self

    self.weaponList = S.newList(self, S.ROW_H,
        function(t, weapon) t:onSelectWeapon(weapon) end,
        function(list, y, item, alt) return tab:drawWeaponRow(list, y, item, alt) end)
    self:addChild(self.weaponList)

    if DLRepair.Config.showWeaponModel then
        self.modelPanel = DLWeaponModelPanel:new(0, 0, 10, 10)
        self:addChild(self.modelPanel)
    end

    self.optionList = S.newList(self, S.HS * 2 + 10,
        function(t, option) t:onSelectOption(option) end,
        function(list, y, item, alt) return tab:drawOptionRow(list, y, item, alt) end)
    self.optionList:setOnMouseDoubleClick(self, DLRepairTab.onOptionDoubleClick)
    self:addChild(self.optionList)

    self.repairButton = S.newButton(self, "Repair", DLRepairTab.onRepair)
    self:addChild(self.repairButton)

    self:layout()
    self:refresh()
end

function DLRepairTab:layout()
    local pad, w, h = S.PAD, self:getWidth(), self:getHeight()
    local leftW = math.floor(w / 3)

    self.weaponList:setX(pad)
    self.weaponList:setY(pad)
    self.weaponList:setWidth(leftW - pad)
    self.weaponList:setHeight(h - pad * 2)

    local x = leftW + pad
    local rw = w - x - pad
    self.rightX, self.rightW = x, rw

    local y = pad
    self.headerY = y
    y = y + S.ICON + 10 + 6

    if self.modelPanel then
        local modelH = math.max(80, math.min(180, math.floor(h * 0.26)))
        self.modelPanel:setX(x)
        self.modelPanel:setY(y)
        self.modelPanel:setWidth(rw)
        self.modelPanel:setHeight(modelH)
        y = y + modelH + 6
    end

    self.conditionY = y
    y = y + S.HM + 2 + 10 + 4 + S.HS + 6

    self.optionsHeadY = y
    y = y + S.HM + 2

    self.repairButton:setX(x)
    self.repairButton:setY(h - pad - S.BUTTON_H)
    local bottom = h - pad - S.BUTTON_H - 6

    local listW = math.floor(rw * 0.5)
    self.optionList:setX(x)
    self.optionList:setY(y)
    self.optionList:setWidth(listW)
    self.optionList:setHeight(math.max(self.optionList.itemheight, bottom - y))

    self.detailsX = x + listW + pad
    self.detailsY = y
    self.detailsW = rw - listW - pad
    self.detailsH = math.max(0, bottom - y)

    self.lastW, self.lastH = w, h
end

function DLRepairTab:refresh()
    if not self.player then self.player = getSpecificPlayer(self.playerNum) end
    if not self.player then return end
    self.perkLevel = self.player:getPerkLevel(Perks.Maintenance)
    local keep = self.selectedWeapon

    self.weaponList:clear()
    local weapons = DLRepair.getRepairableWeapons(self.player:getInventory())
    local reselect = nil
    for i, wpn in ipairs(weapons) do
        DLRepair.reapplyReinforcement(wpn)
        self.weaponList:addItem(wpn:getName(), wpn)
        if keep and wpn == keep then reselect = i end
    end

    if reselect then
        self.weaponList.selected = reselect
    elseif #weapons > 0 then
        self.weaponList.selected = 1
        keep = weapons[1]
    else
        self.weaponList.selected = 0
        keep = nil
    end
    self:setWeapon(keep)
end

function DLRepairTab:onSelectWeapon(weapon)
    self:setWeapon(weapon)
end

function DLRepairTab:setWeapon(weapon)
    local changed = weapon ~= self.selectedWeapon
    self.selectedWeapon = weapon
    self.perkLevel = self.player:getPerkLevel(Perks.Maintenance)
    if self.modelPanel then
        self.modelPanel:setWeaponType(weapon and weapon:getFullType() or nil)
    end
    self:rebuildOptions(changed)
end

function DLRepairTab:rebuildOptions(resetSelection)
    local keep = (not resetSelection) and self.selectedOption or nil
    self.optionList:clear()
    self.selectedOption = nil
    local weapon = self.selectedWeapon
    if not weapon then
        self.optionList.selected = 0
        return
    end
    local options = DLRepair.getOptions(weapon)
    local pick = nil
    for i, option in ipairs(options) do
        self.optionList:addItem(optionLabel(option), option)
        if keep and option == keep then pick = i end
    end
    if not pick and #options > 0 then
        for i, option in ipairs(options) do
            if self:optionEnabled(option) then pick = i; break end
        end
        pick = pick or 1
    end
    self.optionList.selected = pick or 0
    self.selectedOption = pick and options[pick] or nil
end

function DLRepairTab:onSelectOption(option)
    self.selectedOption = option
end

function DLRepairTab:optionEnabled(option)
    local weapon = self.selectedWeapon
    if not (weapon and option) then return false end
    local st = DLRepair.optionStatus(self.player:getInventory(), weapon, option, self.perkLevel)
    local full = weapon:getCondition() >= weapon:getConditionMax()
    return st.haveAll and st.hasTools and st.meetsSkill and not st.exhausted and not full, st
end

function DLRepairTab:blockReason(option)
    local weapon = self.selectedWeapon
    if not weapon then return "Select a weapon." end
    if not option then return "Select a repair option." end
    local st = DLRepair.optionStatus(self.player:getInventory(), weapon, option, self.perkLevel)
    if weapon:getCondition() >= weapon:getConditionMax() then return "This weapon is already at full condition." end
    if st.exhausted then return "This repair has no uses left on this weapon." end
    if not st.meetsSkill then return "Requires Maintenance " .. (option.maintenanceMin or 0) .. "." end
    if not st.hasTools then return "A required tool is missing." end
    if not st.haveAll then return "Required items are missing." end
    return nil
end

function DLRepairTab:onRepair()
    local weapon, option = self.selectedWeapon, self.selectedOption
    if not (weapon and option) then return end
    if not DLRepair.canAttempt(self.player:getInventory(), weapon, option, self.perkLevel) then return end
    local bench = self.window and self.window.bench or nil
    local time = DLRepair.computeTime(self.player, weapon)
    local tab = self
    ISTimedActionQueue.add(DLRepairWeaponAction:new(self.player, weapon, option, time, function()
        if tab.javaObject then tab:refresh() end
    end, bench))
end

function DLRepairTab:onOptionDoubleClick(option)
    self.selectedOption = option
    if self:optionEnabled(option) then self:onRepair() end
end

function DLRepairTab:drawWeaponRow(list, y, item, alt)
    local weapon = item.item
    local maxC = weapon:getConditionMax()
    local frac = maxC > 0 and (weapon:getCondition() / maxC) or 0
    local sub = "Condition: " .. S.percent(frac)
    return S.drawRow(list, y, item, S.texture(weapon), item.text, sub, S.conditionColor(frac), true)
end

function DLRepairTab:drawOptionRow(list, y, item, alt)
    local option = item.item
    local weapon = self.selectedWeapon
    local h = item.height or list.itemheight
    if not weapon then return y + h end
    local enabled, st = self:optionEnabled(option)
    local a = enabled and 0.9 or 0.3
    local w = list:getWidth()
    local bc = list.borderColor
    list:drawRectBorder(0, y, w, h - 1, a, bc.r, bc.g, bc.b)
    if list.selected == item.index then
        list:drawRect(0, y, w, h - 1, 0.3, 0.7, 0.35, 0.15)
    end
    local ty = y + (h - S.HS * 2) / 2
    list:drawText(item.text, 6, ty, 1, 1, 1, a, UIFont.Small)
    local c = S.chanceColor(st.chance)
    local sub = S.percent(st.chance) .. " chance"
    if st.maxUses then sub = sub .. "   " .. st.usesLeft .. " / " .. st.maxUses .. " uses left" end
    list:drawText(sub, 6, ty + S.HS, c.r, c.g, c.b, a, UIFont.Small)
    return y + h
end

function DLRepairTab:prerender()
    if self.lastW ~= self:getWidth() or self.lastH ~= self:getHeight() then self:layout() end
    ISPanel.prerender(self)
    local option = self.selectedOption
    local enabled = self:optionEnabled(option)
    S.setButtonState(self.repairButton, enabled, self:blockReason(option))
end

function DLRepairTab:render()
    ISPanel.render(self)
    local x, w = self.rightX, self.rightW
    local weapon = self.selectedWeapon
    if not weapon then
        local msg = (self.weaponList.count or 0) == 0 and "You have no weapons that can be repaired." or "Select a weapon."
        S.drawLine(self, msg, x, self.headerY, S.white, UIFont.Medium)
        return
    end

    local cat = ""
    local cats = weapon:getCategories()
    if cats and cats:size() > 0 then cat = cats:get(0) end
    S.drawHeader(self, x, self.headerY, S.texture(weapon), weapon:getName(), cat)

    local maxC = weapon:getConditionMax()
    local cur = weapon:getCondition()
    local frac = maxC > 0 and (cur / maxC) or 0
    local y = S.drawSection(self, "Condition: " .. cur .. " / " .. maxC, x, self.conditionY)
    S.drawBar(self, x, y, w, 10, frac, S.conditionColor(frac))
    y = y + 10 + 4
    S.drawLine(self, "Times repaired: " .. (weapon:getModData().DL_repairs or 0), x, y, S.grey)

    S.drawSection(self, "Repair Options:", x, self.optionsHeadY)
    if (self.optionList.count or 0) == 0 then
        S.drawLine(self, "No repair options for this weapon.", x + 6, self.detailsY + 4, S.grey)
        return
    end
    self:drawOptionDetails()
end

function DLRepairTab:drawOptionDetails()
    local option = self.selectedOption
    local weapon = self.selectedWeapon
    if not (option and weapon) then return end
    local x, y = self.detailsX, self.detailsY
    local inv = self.player:getInventory()
    local st = DLRepair.optionStatus(inv, weapon, option, self.perkLevel)

    self:setStencilRect(x, y, self.detailsW, self.detailsH)

    if option.items and #option.items > 0 then
        y = S.drawSection(self, "Required Items:", x, y)
        for _, req in ipairs(option.items) do
            local need = req.count or 1
            local have = DLRepair.availableForReq(inv, req)
            y = S.drawReqLine(self, x, y, S.texture(req.item),
                S.displayName(req.item) .. ": " .. have .. " / " .. need, have >= need)
        end
        y = y + 4
    end

    if option.tools and #option.tools > 0 then
        y = S.drawSection(self, "Required Tools:", x, y)
        for _, t in ipairs(option.tools) do
            local ft = DLRepair.toolType(t)
            y = S.drawReqLine(self, x, y, S.texture(ft), S.displayName(ft), DLRepair.hasTool(inv, t))
        end
        y = y + 4
    end

    if (option.maintenanceMin or 0) > 0 then
        y = S.drawSection(self, "Required Skills:", x, y)
        y = S.drawSkillLine(self, x, y, Perks.Maintenance, self.perkLevel, option.maintenanceMin)
        y = y + 4
    end

    if st.maxUses then
        y = S.drawLine(self, "Uses left on this weapon: " .. st.usesLeft .. " / " .. st.maxUses, x, y,
            st.exhausted and S.bad() or S.white)
    end
    y = S.drawLine(self, "Success chance: " .. S.percent(st.chance), x, y, S.chanceColor(st.chance), UIFont.Medium)
    local gain = DLRepair.computeRestoreAmount(weapon, option, self.perkLevel)
    gain = math.max(0, math.min(gain, weapon:getConditionMax() - weapon:getCondition()))
    S.drawLine(self, "On success: +" .. gain .. " condition", x, y, S.white)

    self:clearStencilRect()
end
