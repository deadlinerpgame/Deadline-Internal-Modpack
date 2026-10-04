require "ISUI/ISPanel"
require "ISUI/ISScrollingListBox"
require "ISUI/ISButton"

local S = require("DLRepair/ui/DLRepairStyle")

DLReinforceTab = ISPanel:derive("DLReinforceTab")

function DLReinforceTab:new(x, y, width, height, playerNum, window)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum or 0
    o.player = getSpecificPlayer(o.playerNum)
    o.window = window
    o.background = false
    o.selectedWeapon = nil
    o.perkLevel = 0
    return o
end

function DLReinforceTab:createChildren()
    local tab = self

    self.weaponList = S.newList(self, S.ROW_H,
        function(t, weapon) t:onSelectWeapon(weapon) end,
        function(list, y, item, alt) return tab:drawWeaponRow(list, y, item, alt) end)
    self:addChild(self.weaponList)

    if DLRepair.Config.showWeaponModel then
        self.modelPanel = DLWeaponModelPanel:new(0, 0, 10, 10)
        self:addChild(self.modelPanel)
    end

    self.reinforceButton = S.newButton(self, "Reinforce", DLReinforceTab.onReinforce)
    self:addChild(self.reinforceButton)

    self:layout()
    self:refresh()
end

function DLReinforceTab:layout()
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

    self.durabilityY = y
    y = y + S.HM + 2 + 10 + 4 + S.HS + 6

    self.infoY = y
    self.reinforceButton:setX(x)
    self.reinforceButton:setY(h - pad - S.BUTTON_H)
    self.infoH = math.max(0, (h - pad - S.BUTTON_H - 6) - y)

    self.lastW, self.lastH = w, h
end

function DLReinforceTab:refresh()
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
    self:onSelectWeapon(keep)
end

function DLReinforceTab:onSelectWeapon(weapon)
    self.selectedWeapon = weapon
    self.perkLevel = self.player:getPerkLevel(Perks.Maintenance)
    if self.modelPanel then
        self.modelPanel:setWeaponType(weapon and weapon:getFullType() or nil)
    end
end

function DLReinforceTab:blockReason(st, recipe)
    if not self.selectedWeapon then return "Select a weapon." end
    if st.atMax then return "This weapon is fully reinforced." end
    if not st.meetsSkill then return "Requires Maintenance " .. ((recipe and recipe.maintenanceMin) or 0) .. "." end
    if not st.hasTools then return "A required tool is missing." end
    if not st.haveAll then return "Required items are missing." end
    return nil
end

function DLReinforceTab:onReinforce()
    local weapon = self.selectedWeapon
    if not weapon then return end
    if not DLRepair.canReinforce(self.player:getInventory(), weapon, self.perkLevel) then return end
    local bench = self.window and self.window.bench or nil
    local time = math.floor(DLRepair.computeTime(self.player, weapon) * 1.6)
    local tab = self
    ISTimedActionQueue.add(DLReinforceAction:new(self.player, weapon, time, function()
        if tab.javaObject then tab:refresh() end
    end, bench))
end

function DLReinforceTab:drawWeaponRow(list, y, item, alt)
    local weapon = item.item
    local lvl = DLRepair.reinforceLevel(weapon)
    local maxL = DLRepair.maxReinforce()
    local sub = "Reinforced: " .. lvl .. " / " .. maxL
    return S.drawRow(list, y, item, S.texture(weapon), item.text, sub, (lvl >= maxL) and S.good() or S.white, true)
end

function DLReinforceTab:prerender()
    if self.lastW ~= self:getWidth() or self.lastH ~= self:getHeight() then self:layout() end
    ISPanel.prerender(self)
    local weapon = self.selectedWeapon
    if not weapon then
        S.setButtonState(self.reinforceButton, false, "Select a weapon.")
        return
    end
    local st, recipe = DLRepair.reinforceStatus(self.player:getInventory(), weapon, self.perkLevel)
    local reason = self:blockReason(st, recipe)
    S.setButtonState(self.reinforceButton, reason == nil, reason)
end

function DLReinforceTab:render()
    ISPanel.render(self)
    local x, w = self.rightX, self.rightW
    local weapon = self.selectedWeapon
    if not weapon then
        local msg = (self.weaponList.count or 0) == 0 and "You have no weapons that can be reinforced." or "Select a weapon."
        S.drawLine(self, msg, x, self.headerY, S.white, UIFont.Medium)
        return
    end

    local cat = ""
    local cats = weapon:getCategories()
    if cats and cats:size() > 0 then cat = cats:get(0) end
    S.drawHeader(self, x, self.headerY, S.texture(weapon), weapon:getName(), cat)

    local inv = self.player:getInventory()
    local st, recipe = DLRepair.reinforceStatus(inv, weapon, self.perkLevel)

    local maxC = weapon:getConditionMax()
    local cur = weapon:getCondition()
    local frac = maxC > 0 and (cur / maxC) or 0
    local y = S.drawSection(self, "Durability: " .. cur .. " / " .. maxC, x, self.durabilityY)
    S.drawBar(self, x, y, w, 10, frac, S.conditionColor(frac))
    y = y + 10 + 4
    S.drawLine(self, "Base maximum: " .. (st.baseMax or maxC), x, y, S.grey)

    y = self.infoY
    self:setStencilRect(x, y, w, self.infoH)
    y = S.drawSection(self, "Reinforcement:", x, y)
    y = S.drawLine(self, " - Level: " .. st.level .. " / " .. st.maxLevel, x + 15, y, S.white)
    y = S.drawLine(self, " - Each success: +" .. st.perStep .. " maximum durability", x + 15, y, S.white)
    y = y + 4

    if st.atMax then
        S.drawLine(self, "Fully reinforced (+" .. (st.perStep * st.maxLevel) .. " maximum durability).", x, y, S.good(), UIFont.Medium)
        self:clearStencilRect()
        return
    end

    if recipe.items and #recipe.items > 0 then
        y = S.drawSection(self, "Required Items (level " .. st.nextLevel .. "):", x, y)
        for _, req in ipairs(recipe.items) do
            local need = req.count or 1
            local have = DLRepair.availableForReq(inv, req)
            y = S.drawReqLine(self, x, y, S.texture(req.item),
                S.displayName(req.item) .. ": " .. have .. " / " .. need, have >= need)
        end
        y = y + 4
    end
    if recipe.tools and #recipe.tools > 0 then
        y = S.drawSection(self, "Required Tools:", x, y)
        for _, t in ipairs(recipe.tools) do
            local ft = DLRepair.toolType(t)
            y = S.drawReqLine(self, x, y, S.texture(ft), S.displayName(ft), DLRepair.hasTool(inv, t))
        end
        y = y + 4
    end
    if (recipe.maintenanceMin or 0) > 0 then
        y = S.drawSection(self, "Required Skills:", x, y)
        y = S.drawSkillLine(self, x, y, Perks.Maintenance, self.perkLevel, recipe.maintenanceMin)
        y = y + 4
    end
    S.drawLine(self, "Success chance: " .. S.percent(st.chance), x, y, S.chanceColor(st.chance), UIFont.Medium)
    self:clearStencilRect()
end
