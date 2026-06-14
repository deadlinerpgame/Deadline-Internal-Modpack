require("ISUI/ISComboBox")
require("ISUI/ISTextEntryBox")

local Theme = require("ElyonLib/UI/Theme/Theme")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceAdmin = DicePanelBase:derive("DiceAdmin")

local PAD = 4

function DiceAdmin:rowHeight()
	return math.max(self:S(18), self.fontHgt + self:S(4))
end

function DiceAdmin:addEntry(x, y, w, text, tooltip)
	local e = ISTextEntryBox:new(text or "", x, y, w, self:rowHeight())
	e.font = self.font
	e:initialise()
	e:instantiate()
	if tooltip then
		e:setTooltip(tooltip)
	end
	Theme.applyFieldStyle(e)
	self:addChild(e)
	self:registerControl(e)
	return e
end

function DiceAdmin:addBtn(x, y, w, label, callback, variant)
	local b = ISButton:new(x, y, w, self:rowHeight(), label, self, callback)
	b:initialise()
	b.font = self.font
	Theme.applyButtonStyle(b, variant)
	self:addChild(b)
	self:registerControl(b)
	return b
end

function DiceAdmin:addCombo(x, y, w)
	local c = ISComboBox:new(x, y, w, self:rowHeight(), self, nil)
	c.font = self.font
	c:initialise()
	c:instantiate()
	Theme.applyComboStyle(c)
	self:addChild(c)
	self:registerControl(c)
	return c
end

function DiceAdmin:createChildren()
	DicePanelBase.createChildren(self)

	local pad = self:S(PAD)
	local rowH = self:rowHeight()
	local labelH = self.fontHgt + self:S(3)
	local w = self.width - pad * 2
	local y = self.headerH + pad

	self.pauseButton = self:addBtn(pad, y, w, "Pause combat", DiceAdmin.onPause, "warning")
	y = y + rowH + pad

	self.forceStartButton = self:addBtn(pad, y, w, "Force start combat", DiceAdmin.onForceStart, "primary")
	y = y + rowH + pad

	self.massLabelY = y
	y = y + labelH

	self.rollCombo = self:addCombo(pad, y, w)
	local rolls = Core.ROLLS
	for i = 1, #rolls do
		self.rollCombo:addOptionWithData(rolls[i].label, rolls[i].id)
	end
	self.rollCombo.selected = 1
	y = y + rowH + pad

	local radiusW = self:S(40)
	self.radiusEntry = self:addEntry(pad, y, radiusW, "5", "Radius in tiles")
	self.radiusEntry:setOnlyNumbers(true)
	self.centerCombo = self:addCombo(pad * 2 + radiusW, y, w - radiusW - pad)
	y = y + rowH + pad

	self.massRollButton = self:addBtn(pad, y, w, "Roll for everyone in radius", DiceAdmin.onMassRoll, "primary")
	y = y + rowH + pad

	self.npcLabelY = y + self:S(2)
	y = y + labelH + self:S(2)

	local hpW = self:S(40)
	self.npcNameEntry = self:addEntry(pad, y, w - hpW - pad, "", "NPC name (blank = auto)")
	self.npcHpEntry = self:addEntry(pad * 2 + (w - hpW - pad), y, hpW, "10", "NPC max HP")
	self.npcHpEntry:setOnlyNumbers(true)
	y = y + rowH + pad

	local initW = self:S(40)
	self.npcInitEntry = self:addEntry(pad, y, initW, "", "Initiative (blank = auto-roll)")
	self.npcInitEntry:setOnlyNumbers(true)
	self.addNpcButton = self:addBtn(pad * 2 + initW, y, w - initW - pad, "Add NPC", DiceAdmin.onAddNpc, "success")
	y = y + rowH + pad

	local smallW = self:S(44)
	self.npcCombo = self:addCombo(pad, y, w - (smallW + pad) * 2)
	self.npcKoButton = self:addBtn(pad * 2 + w - (smallW + pad) * 2, y, smallW, "KO", DiceAdmin.onNpcKo, "danger")
	self.npcRemoveButton = self:addBtn(pad * 3 + w - (smallW + pad) * 2 + smallW, y, smallW, "X", DiceAdmin.onNpcRemove, "danger")
	self.npcRemoveButton:setTooltip("Remove NPC from the turn order")
	y = y + rowH + pad

	self.finishNpcButton = self:addBtn(pad, y, w, "Finish NPC turn", DiceAdmin.onFinishNpcTurn, "warning")
	y = y + rowH + pad

	self.fullH = y + pad
	self:setHeight(self.fullH)
	self:refreshControls()
end

function DiceAdmin:onPause()
	Core.adminSetPaused(not Core.state.paused)
end

function DiceAdmin:onForceStart()
	Core.adminForceStart()
end

function DiceAdmin:onMassRoll()
	local rollId = self.rollCombo:getOptionData(self.rollCombo.selected)
	local centerId = "me"
	if self.centerCombo.selected and self.centerCombo.selected > 0 then
		centerId = self.centerCombo:getOptionData(self.centerCombo.selected) or "me"
	end
	Core.adminMassRoll(rollId, self.radiusEntry:getInternalText(), centerId)
end

function DiceAdmin:onAddNpc()
	Core.adminAddNpc(self.npcNameEntry:getInternalText(), self.npcHpEntry:getInternalText(), self.npcInitEntry:getInternalText())
	self.npcNameEntry:setText("")
	self.npcInitEntry:setText("")
end

function DiceAdmin:selectedNpcId()
	if self.npcCombo.selected and self.npcCombo.selected > 0 then
		return self.npcCombo:getOptionData(self.npcCombo.selected)
	end
	return nil
end

function DiceAdmin:onNpcKo()
	local id = self:selectedNpcId()
	if id then
		local npc = Core.findCombatant(id)
		Core.staffSetKO(id, npc and npc.status ~= "ko")
	end
end

function DiceAdmin:onNpcRemove()
	local id = self:selectedNpcId()
	if id then
		Core.staffKick(id)
	end
end

function DiceAdmin:onFinishNpcTurn()
	Core.adminFinishNpcTurn()
end

local function rebuildCombo(combo, entries, keepData)
	local previous = nil
	if keepData and combo.selected and combo.selected > 0 then
		previous = combo:getOptionData(combo.selected)
	end
	combo.options = {}
	for i = 1, #entries do
		combo:addOptionWithData(entries[i].text, entries[i].data)
	end
	combo.selected = #entries > 0 and 1 or 0
	if previous then
		for i = 1, #entries do
			if entries[i].data == previous then
				combo.selected = i
				break
			end
		end
	end
end

function DiceAdmin:refreshControls()
	local centers = { { text = "Around me", data = "me" } }
	local list = Core.state.combatants
	for i = 1, #list do
		if not list[i].isMe then
			centers[#centers + 1] = { text = "Around " .. list[i].name, data = list[i].id }
		end
	end
	rebuildCombo(self.centerCombo, centers, true)

	local npcs = Core.getNpcs()
	local npcEntries = {}
	for i = 1, #npcs do
		local suffix = npcs[i].status == "ko" and " (KO)" or ""
		npcEntries[#npcEntries + 1] = { text = npcs[i].name .. suffix, data = npcs[i].id }
	end
	rebuildCombo(self.npcCombo, npcEntries, true)
	local hasNpcs = #npcEntries > 0
	self.npcKoButton.enable = hasNpcs
	self.npcRemoveButton.enable = hasNpcs

	local current = Core.findCombatant(Core.state.currentId)
	local npcTurn = Core.state.phase == "active" and current ~= nil and current.isNpc == true
	self.finishNpcButton.enable = npcTurn
	self.finishNpcButton:setTitle(npcTurn and ("Finish " .. current.name .. "'s turn") or "Finish NPC turn")

	local paused = Core.state.paused
	self.pauseButton:setTitle(paused and "Resume combat" or "Pause combat")
	Theme.applyButtonStyle(self.pauseButton, paused and "danger" or "warning")
	self.pauseButton.enable = Core.state.combatId ~= nil
	self.forceStartButton.enable = Core.state.phase == "forming"

	self:applyOpacity()
end

function DiceAdmin:render()
	if self.collapsed then
		return
	end
	local textA = self:textAlpha()
	local pad = self:S(PAD)
	self:drawText("Mass roll", pad, self.massLabelY, T.textDim.r, T.textDim.g, T.textDim.b, textA * 0.9, self.font)
	self:drawText("NPCs", pad, self.npcLabelY, T.textDim.r, T.textDim.g, T.textDim.b, textA * 0.9, self.font)
end

function DiceAdmin:onCoreEvent(event)
	if event == "state" then
		self:refreshControls()
	elseif event == "opacity" then
		self:applyOpacity()
	end
end

function DiceAdmin:restoreState()
	DicePanelBase.restoreState(self)
	if not Core.isLocalAdmin() then
		self:setVisible(false)
	end
end

function DiceAdmin:new()
	local s = Core.panelScale("admin")
	local width = Core.px(230 * s)
	local o = DicePanelBase.new(self, "admin", "Admin tools", width, Core.px(200 * s), { xf = 0.58, yf = 0.30, visible = false })
	return o
end

return DiceAdmin
