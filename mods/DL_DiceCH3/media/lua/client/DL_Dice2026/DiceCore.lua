
local FileUtils = require("ElyonLib/FileUtils/FileUtils")
local MathUtils = require("ElyonLib/MathUtils/MathUtils")
local sha256 = require("DL_Dice2026/DiceSha")


local function hexToNum(s)
	local n = 0
	for i = 1, 8 do
		local b = string.byte(s, i)
		local d = 0
		if b >= 48 and b <= 57 then
			d = b - 48
		elseif b >= 97 and b <= 102 then
			d = b - 87
		end
		n = n * 16 + d
	end
	return n
end

local DiceCore = {}

DiceCore.MOD_ID = "DL_Dice2026"
DiceCore.SETTINGS_FILE = "DL_Dice2026_ui.json"
DiceCore.DICE_SIDES = 20
DiceCore.BASE_FONT_H = 14
DiceCore.RADIUS = 30

------------------------------------------------------------------------------

local cachedUnit = nil

function DiceCore.unit()
	if cachedUnit then
		return cachedUnit
	end
	local tm = getTextManager and getTextManager() or nil
	if tm and UIFont and UIFont.Small then
		cachedUnit = tm:getFontHeight(UIFont.Small)
	else
		cachedUnit = DiceCore.BASE_FONT_H
	end
	if not cachedUnit or cachedUnit < 8 then
		cachedUnit = DiceCore.BASE_FONT_H
	end
	return cachedUnit
end

function DiceCore.px(n)
	return math.max(1, math.floor((n * DiceCore.unit() / DiceCore.BASE_FONT_H) + 0.5))
end

------------------------------------------------------------------------------

DiceCore.OPACITY_STEPS = { 0.20, 0.50, 0.75, 1.00 }
DiceCore.SCALE_STEPS = { 1, 2, 4 }
DiceCore.rebuildPanel = nil

DiceCore.settings = { opacity = 0.75, panels = {} }

function DiceCore.loadSettings()
	local data = FileUtils.readJson(DiceCore.SETTINGS_FILE, DiceCore.MOD_ID, { createIfNull = true })
	if type(data) == "table" then
		if type(data.opacity) == "number" then
			DiceCore.settings.opacity = MathUtils.clamp(data.opacity, 0.2, 1.0)
		end
		if type(data.panels) == "table" then
			DiceCore.settings.panels = data.panels
		end
		if type(data.commitments) == "table" then
			DiceCore.settings.commitments = data.commitments
		end
	end
end

function DiceCore.saveSettings()
	FileUtils.writeJson(DiceCore.SETTINGS_FILE, DiceCore.settings, DiceCore.MOD_ID, { createIfNull = true })
end

function DiceCore.panelState(id, defaults)
	local panels = DiceCore.settings.panels
	if not panels[id] then
		panels[id] = {}
	end
	local st = panels[id]
	defaults = defaults or {}
	if st.xf == nil then st.xf = defaults.xf or 0.5 end
	if st.yf == nil then st.yf = defaults.yf or 0.5 end
	if st.visible == nil then st.visible = defaults.visible ~= false end
	if st.collapsed == nil then st.collapsed = defaults.collapsed == true end
	if st.scale == nil then st.scale = defaults.scale or 1 end
	return st
end

function DiceCore.panelScale(id)
	local p = DiceCore.settings.panels[id]
	local s = p and p.scale or 1
	if s ~= 1 and s ~= 2 and s ~= 4 then s = 1 end
	return s
end

function DiceCore.cyclePanelScale(id)
	local st = DiceCore.panelState(id)
	local current = DiceCore.panelScale(id)
	st.scale = current == 1 and 2 or (current == 2 and 4 or 1)
	DiceCore.saveSettings()
	if DiceCore.rebuildPanel then
		DiceCore.rebuildPanel(id)
	end
	return st.scale
end

function DiceCore.cycleOpacity()
	local steps = DiceCore.OPACITY_STEPS
	local index = 1
	for i = 1, #steps do
		if math.abs(steps[i] - DiceCore.settings.opacity) < 0.01 then
			index = i
			break
		end
	end
	index = index + 1
	if index > #steps then index = 1 end
	DiceCore.settings.opacity = steps[index]
	DiceCore.saveSettings()
	DiceCore.notify("opacity")
	return DiceCore.settings.opacity
end

function DiceCore.opacityLabel()
	return tostring(math.floor(DiceCore.settings.opacity * 100 + 0.5)) .. "%"
end

------------------------------------------------------------------------------
---
DiceCore.TRAITS = {
	brawler = { name = "Brawler", icon = "media/ui/ElyonLib/ui_skill_spiffo_combat.png" },
	marksman = { name = "Marksman", icon = "media/ui/ElyonLib/ui_skill_spiffo_aiming.png" },
	fleet = { name = "Fleet-footed", icon = "media/ui/ElyonLib/ui_skill_spiffo_sprinting.png" },
	medic = { name = "Medic", icon = "media/ui/ElyonLib/ui_skill_spiffo_first_aid.png" },
	tough = { name = "Tough", icon = "media/ui/ElyonLib/ui_skill_spiffo_fitness.png" },
	strong = { name = "Strong", icon = "media/ui/ElyonLib/ui_skill_spiffo_strength.png" },
	shadow = { name = "Shadow", icon = "media/ui/ElyonLib/ui_skill_spiffo_sneaking.png" },
	sharp = { name = "Sharp senses", icon = "media/ui/ElyonLib/ui_skill_spiffo_accuracy.png" },
}

local traitTextures = {}

function DiceCore.getTraitTexture(id)
	if traitTextures[id] ~= nil then
		return traitTextures[id] or nil
	end
	local def = DiceCore.TRAITS[id]
	local tex = def and getTexture and getTexture(def.icon) or nil
	traitTextures[id] = tex or false
	return tex
end

DiceCore.WEAPON_RULES = {
	unarmed = { name = "Unarmed", tip = "Unarmed: 1 HP damage, melee range" },
	melee1h = { name = "One-handed melee", tip = "One-handed melee: 2 HP damage" },
	melee2h = { name = "Two-handed melee", tip = "Two-handed melee: 3 HP damage" },
	pistol = { name = "Pistol", tip = "Pistol: 3 HP damage, max 15 range" },
	shotgun = { name = "Shotgun", tip = "Shotgun: 4 HP damage, max 15 range" },
	rifle = { name = "Rifle", tip = "Rifle: 4 HP damage, max 20 range" },
	crossbow = { name = "Crossbow", tip = "Crossbow: 4 HP damage, max 20 range, 1 turn reload" },
	thrown = { name = "Thrown weapon", tip = "Thrown weapon: 2 HP damage, max 10 range" },
	molotov = { name = "Molotov / fire bomb", tip = "Molotov: 1 HP per turn for 3 turns, 3x3 area, max 10 range" },
	bomb = { name = "Pipe / aerosol bomb", tip = "Pipe/aerosol bomb: 4 HP damage, 4x4 area, max 10 range" },
}

DiceCore.SCRAP_TIP = " (scrap/junk: -1 HP)"
DiceCore.WEAPON_ORDER = { "unarmed", "melee1h", "melee2h", "pistol", "shotgun", "rifle", "crossbow", "thrown", "molotov", "bomb" }

function DiceCore.weaponTip(combatant)
	local rule = DiceCore.WEAPON_RULES[combatant.weapon or "unarmed"] or DiceCore.WEAPON_RULES.unarmed
	local tip = rule.tip
	if combatant.weaponScrap then
		tip = tip .. DiceCore.SCRAP_TIP
	end
	return tip
end

function DiceCore.classifyWeapon(item)
	if not item then
		return "unarmed"
	end
	local ok, result = pcall(function()
		if not instanceof(item, "HandWeapon") then return "unarmed" end
		if item.getExplosionPower and item:getExplosionPower() > 0 then return "bomb" end
		if item.getFirePower and item:getFirePower() > 0 then return "molotov" end
		if item:isRanged() then
			local ammo = string.lower(item:getAmmoType() or "")
			if string.find(ammo, "shotgunshells", 1, true) then return "shotgun" end
			if string.find(ammo, "bolt", 1, true) then return "crossbow" end
			if item:isTwoHandWeapon() then return "rifle" end
			return "pistol"
		end
		if item:isTwoHandWeapon() then return "melee2h" end
		return "melee1h"
	end)
	return (ok and result) or "melee1h"
end

local GUN_CLASSES = { pistol = true, rifle = true, shotgun = true, crossbow = true }

function DiceCore.isScrapItem(item)
	if not item then
		return false
	end
	local ok, name = pcall(function()
		return string.lower(item:getDisplayName() or "")
	end)
	if not ok then
		return false
	end
	return (string.find(name, "scrap", 1, true) or string.find(name, "junk", 1, true)
		or string.find(name, "makeshift", 1, true) or string.find(name, "improvised", 1, true)) ~= nil
end

local iconCache = {}

function DiceCore.getIcon(name)
	if iconCache[name] ~= nil then
		return iconCache[name] or nil
	end
	local tex = getTexture and getTexture("media/ui/DL_Dice2026/icons/" .. name .. ".png") or nil
	iconCache[name] = tex or false
	return tex
end

------------------------------------------------------------------------------

DiceCore.listeners = {}

function DiceCore.addListener(fn)
	DiceCore.listeners[#DiceCore.listeners + 1] = fn
end

function DiceCore.notify(event)
	for i = 1, #DiceCore.listeners do
		pcall(DiceCore.listeners[i], event)
	end
end

------------------------------------------------------------------------------

DiceCore.allCombats = {}

DiceCore.state = {
	combatId = nil,
	spectating = false,
	phase = "idle",
	round = 0,
	currentId = nil,
	paused = false,
	anchor = nil,
	combatants = {},
	selectedTargetId = nil,
	movingNpcId = nil,
	showMoveRange = false,
	showGunRange = false,
	advantage = 0,
}

DiceCore.log = {}
DiceCore.LOG_MAX = 60

local function addLogLocal(line)
	local log = DiceCore.log
	log[#log + 1] = line
	while #log > DiceCore.LOG_MAX do
		table.remove(log, 1)
	end
	DiceCore.notify("log")
end

local function myUsername()
	local p = getPlayer and getPlayer() or nil
	if p and p.getUsername then
		local n = p:getUsername()
		if n and n ~= "" then
			return n
		end
	end
	return "Player"
end

local localMe = nil

local function getLocalMe()
	if not localMe then
		localMe = {
			id = "me", isMe = true, name = myUsername(),
			hp = 20, maxHp = 20, traits = {}, status = "idle",
			initiative = nil, inCover = false, armored = false,
			grappled = false, escapeWounds = false, poisoned = false,
			burning = false, suppressed = false, blinded = false,
			weapon = "unarmed", weaponScrap = false, advantage = 0,
		}
	end
	return localMe
end

function DiceCore.me()
	local list = DiceCore.state.combatants
	for i = 1, #list do
		if list[i].isMe then
			return list[i]
		end
	end
	return getLocalMe()
end

function DiceCore.isParticipant()
	return DiceCore.state.combatId ~= nil and not DiceCore.state.spectating
end

function DiceCore.isMyTurn()
	local me = DiceCore.me()
	return DiceCore.state.phase == "active" and DiceCore.state.currentId == me.id and DiceCore.isParticipant()
end

function DiceCore.findCombatant(id)
	local list = DiceCore.state.combatants
	for i = 1, #list do
		if list[i].id == id then
			return list[i]
		end
	end
	return nil
end

function DiceCore.getNpcs()
	local npcs = {}
	local list = DiceCore.state.combatants
	for i = 1, #list do
		if list[i].isNpc then
			npcs[#npcs + 1] = list[i]
		end
	end
	return npcs
end

local function refreshView()
	local name = myUsername()
	local view, spectating = nil, false

	for _, c in pairs(DiceCore.allCombats) do
		for i = 1, #c.combatants do
			if not c.combatants[i].isNpc and c.combatants[i].id == name then
				view = c
				break
			end
		end
		if view then
			break
		end
	end

	if not view then
		local p = getPlayer and getPlayer() or nil
		if p then
			local px, py = math.floor(p:getX()), math.floor(p:getY())
			for _, c in pairs(DiceCore.allCombats) do
				local d = math.max(math.abs(px - c.anchor.x), math.abs(py - c.anchor.y))
				if d <= DiceCore.RADIUS then
					view = c
					spectating = true
					break
				end
			end
		end
	end

	local s = DiceCore.state
	local oldId, oldPhase, oldCurrent = s.combatId, s.phase, s.currentId
	if view then
		s.combatId = view.id
		s.spectating = spectating
		s.phase = view.phase
		s.round = view.round or 0
		s.currentId = view.currentId
		s.paused = view.paused == true
		s.anchor = view.anchor
		s.combatants = view.combatants
		local me = nil
		for i = 1, #s.combatants do
			local m = s.combatants[i]
			m.isMe = (not m.isNpc) and m.id == name
			if m.isMe then
				me = m
			end
		end
		s.advantage = me and me.advantage or 0
		if s.selectedTargetId and not DiceCore.findCombatant(s.selectedTargetId) then
			s.selectedTargetId = nil
		end
	else
		s.combatId = nil
		s.spectating = false
		s.phase = "idle"
		s.round = 0
		s.currentId = nil
		s.paused = false
		s.anchor = nil
		s.combatants = {}
		s.selectedTargetId = nil
		s.movingNpcId = nil
		s.advantage = 0
	end

	if oldId ~= s.combatId or oldPhase ~= s.phase or oldCurrent ~= s.currentId then
		DiceCore.notify("state")
	end
end

------------------------------------------------------------------------------

DiceCore.awaitingServer = false
DiceCore.awaitTicks = 0
DiceCore.awaitAttempts = 0

function DiceCore.send(cmd, args)
	args = args or {}
	if isClient and isClient() then
		sendClientCommand(getPlayer(), DiceCore.MOD_ID, cmd, args)
	elseif DiceServer and DiceServer.handle then
		local ok, err = pcall(DiceServer.handle, getPlayer(), cmd, args)
		if not ok then
			addLogLocal("DICE ERROR (" .. tostring(cmd) .. "): " .. tostring(err))
			DiceCore.notify("state")
		end
	else
		addLogLocal("DICE ERROR: server module not loaded - command '" .. tostring(cmd) .. "' dropped.")
		DiceCore.notify("state")
	end
end

local function applyServerCommand(cmd, args)
	DiceCore.awaitingServer = false
	if cmd == "state" then
		DiceCore.allCombats[args.id] = args
		refreshView()
		DiceCore.notify("state")
	elseif cmd == "log" then
		if args.id == DiceCore.state.combatId then
			addLogLocal(args.line)
		end
	elseif cmd == "logBatch" then
		if args.id == DiceCore.state.combatId and type(args.lines) == "table" then
			for i = 1, #args.lines do
				addLogLocal(args.lines[i])
			end
		end
	elseif cmd == "ended" then
		DiceCore.allCombats[args.id] = nil
		refreshView()
		DiceCore.notify("state")
	elseif cmd == "snapBack" then
		local p = getPlayer and getPlayer() or nil
		if p then
			p:setX(args.x + 0.5)
			p:setY(args.y + 0.5)
			p:setZ(args.z)
			p:setLx(args.x + 0.5)
			p:setLy(args.y + 0.5)
			addLogLocal("You cannot leave the combat zone!")
		end
	elseif cmd == "notice" then
		local line = args.line or ""
		local day, hash = string.match(line, "day (%d+) roll commitment: (%x+)")
		if day and hash then
			DiceCore.settings.commitments = DiceCore.settings.commitments or {}
			local known = DiceCore.settings.commitments[day]
			if not known then
				DiceCore.settings.commitments[day] = hash
				local dayNum = tonumber(day)
				for k in pairs(DiceCore.settings.commitments) do
					if tonumber(k) and tonumber(k) < dayNum - 10 then
						DiceCore.settings.commitments[k] = nil
					end
				end
				DiceCore.saveSettings()
			elseif known ~= hash then
				addLogLocal("FAIRNESS WARNING: received a DIFFERENT commitment for day " .. day
					.. " than previously recorded - possible split-view tampering!")
			end
		end
		addLogLocal(line)
	elseif cmd == "auditChunk" then
		DiceCore.receiveAuditChunk(args)
	elseif cmd == "consumeAmmo" then
		local p = getPlayer and getPlayer() or nil
		if p then
			pcall(function()
				local item = p:getPrimaryHandItem()
				if item and item.getCurrentAmmoCount then
					item:setCurrentAmmoCount(math.max(0, item:getCurrentAmmoCount() - (args.count or 1)))
				end
			end)
		end
	elseif cmd == "consumeItem" then
		local p = getPlayer and getPlayer() or nil
		if p then
			pcall(function()
				local item = p:getPrimaryHandItem()
				if item then
					p:setPrimaryHandItem(nil)
					if p:getSecondaryHandItem() == item then
						p:setSecondaryHandItem(nil)
					end
					p:getInventory():Remove(item)
				end
			end)
			DiceCore.updateMyWeapon()
		end
	elseif cmd == "error" then
		DiceCore.errorText = args.message or "Action rejected."
		DiceCore.errorTicks = 300
		addLogLocal(DiceCore.errorText)
		DiceCore.notify("state")
	end
end

function DiceClientApply(cmd, args)
	applyServerCommand(cmd, args)
end

------------------------------------------------------------------------------

local auditBuffer = nil
local auditJob = nil

function DiceCore.receiveAuditChunk(args)
	if not auditBuffer or auditBuffer.day ~= args.day then
		auditBuffer = { day = args.day, seed = args.seed, rolls = {} }
	end
	local rolls = args.rolls or {}
	for i = 1, #rolls do
		auditBuffer.rolls[#auditBuffer.rolls + 1] = rolls[i]
	end
	if args.done then
		auditJob = { day = auditBuffer.day, seed = auditBuffer.seed, rolls = auditBuffer.rolls, index = 0, bad = 0 }
		auditBuffer = nil
		local stored = DiceCore.settings.commitments and DiceCore.settings.commitments[tostring(auditJob.day)] or nil
		auditJob.commit = stored
		if stored and sha256(auditJob.seed) ~= stored then
			addLogLocal("FAIRNESS AUDIT day " .. auditJob.day .. ": SEED MISMATCH - revealed seed does not match the commitment this client recorded. POSSIBLE TAMPERING!")
			auditJob = nil
		end
	end
end

local function stepAudit()
	if not auditJob then
		return
	end
	local j = auditJob
	local steps = 0
	while j.index < #j.rolls and steps < 20 do
		j.index = j.index + 1
		steps = steps + 1
		local rec = j.rolls[j.index]
		local digest = sha256(j.seed .. ":" .. rec.c .. ":" .. rec.i)
		local v = (hexToNum(digest) % rec.s) + 1
		if v ~= rec.r then
			j.bad = j.bad + 1
			if j.bad <= 5 then
				addLogLocal(string.format("FAIRNESS AUDIT: combat %d roll %d recorded %d but derives to %d - TAMPERED!", rec.c, rec.i, rec.r, v))
			end
		end
	end
	if j.index >= #j.rolls then
		if j.bad == 0 then
			addLogLocal("FAIRNESS AUDIT day " .. j.day .. ": " .. #j.rolls .. " rolls independently verified OK"
				.. (j.commit and " (commitment matched)" or " (no local commitment on record)"))
		else
			addLogLocal("FAIRNESS AUDIT day " .. j.day .. ": " .. j.bad .. "/" .. #j.rolls .. " ROLLS FAILED VERIFICATION - POSSIBLE TAMPERING!")
		end
		DiceCore.notify("state")
		auditJob = nil
	end
end

DiceCore.stepAudit = stepAudit

function DiceCore.requestState()
	DiceCore.awaitingServer = true
	DiceCore.awaitTicks = 0
	DiceCore.awaitAttempts = 0
	DiceCore.send("requestState", {})
end

------------------------------------------------------------------------------

function DiceCore.rollInitiative()
	DiceCore.send("rollInitiative", {})
end

function DiceCore.setReady(ready)
	DiceCore.send("ready", { ready = ready == true })
end

function DiceCore.finishTurn()
	DiceCore.send("finishTurn", {})
end

function DiceCore.leaveCombat()
	DiceCore.send("leave", {})
end

function DiceCore.setSurrender(flag)
	DiceCore.send("surrender", { flag = flag == true })
end

function DiceCore.diceWithDeath()
	DiceCore.send("dwd", {})
end

function DiceCore.setAdvantage(value)
	if DiceCore.isParticipant() then
		DiceCore.send("setAdvantage", { value = value })
	else
		local me = getLocalMe()
		me.advantage = (me.advantage == value) and 0 or value
		DiceCore.state.advantage = me.advantage
		DiceCore.notify("state")
	end
end

function DiceCore.selectTarget(id)
	local s = DiceCore.state
	s.selectedTargetId = (s.selectedTargetId == id) and nil or id
	if DiceCore.isParticipant() then
		DiceCore.send("aim", { targetId = s.selectedTargetId })
	end
	DiceCore.notify("state")
end

------------------------------------------------------------------------------

DiceCore.ROLLS = {
	{ id = "attack", label = "Attack / Throw", turnBound = true, combat = true },
	{ id = "escape", label = "Escape", turnBound = true, combat = true },
	{ id = "firstaid", label = "First aid", tip = "First aid (d20) - roll only, restores no HP in dice combat" },
	{ id = "sneak", label = "Sneak" },
	{ id = "notice", label = "Notice" },
	{ id = "physend", label = "Phys. endurance" },
	{ id = "mentend", label = "Ment. endurance" },
	{ id = "skill", label = "Skill roll" },
}

function DiceCore.getRollDef(id)
	for i = 1, #DiceCore.ROLLS do
		if DiceCore.ROLLS[i].id == id then
			return DiceCore.ROLLS[i]
		end
	end
	return nil
end

function DiceCore.canRoll(def)
	local s = DiceCore.state
	if not s.combatId or s.paused then
		return false
	end
	if s.spectating then
		return def ~= nil and not def.combat
	end
	local me = DiceCore.me()
	if me.status == "ko" or me.status == "surrendered" then
		return false
	end
	if def and def.id == "escape" and (me.escapeWounds or me.grappled) then
		return false
	end
	if def and def.turnBound and not DiceCore.isMyTurn() then
		return false
	end
	if def and def.combat and s.phase ~= "active" then
		return false
	end
	return true
end

function DiceCore.roll(id)
	local def = DiceCore.getRollDef(id)
	if not def or not DiceCore.canRoll(def) then
		return
	end
	if id == "attack" then
		if not DiceCore.state.selectedTargetId then
			addLogLocal("Select a target in the turn order first.")
			DiceCore.notify("state")
			return
		end
		local p = getPlayer and getPlayer() or nil
		local item = p and p:getPrimaryHandItem() or nil
		local class = DiceCore.classifyWeapon(item)
		local ammo = nil
		if GUN_CLASSES[class] then
			local ok, n = pcall(function()
				return item:getCurrentAmmoCount()
			end)
			ammo = (ok and n) or 0
			if ammo <= 0 then
				DiceCore.errorText = "Your weapon is not loaded."
				DiceCore.errorTicks = 300
				addLogLocal("Your weapon is not loaded.")
				DiceCore.notify("state")
				return
			end
		end
		DiceCore.send("attack", {
			targetId = DiceCore.state.selectedTargetId,
			ammo = ammo,
			weaponClass = class,
			weaponScrap = DiceCore.isScrapItem(item),
		})
	elseif id == "escape" then
		DiceCore.send("escape", {})
	else
		DiceCore.send("utilityRoll", { rollId = id, combatId = DiceCore.state.combatId })
	end
end

------------------------------------------------------------------------------

function DiceCore.changeHP(delta)
	if DiceCore.isParticipant() then
		DiceCore.send("selfHP", { delta = delta })
	else
		local me = getLocalMe()
		me.hp = MathUtils.clamp(me.hp + delta, 0, me.maxHp)
		if me.hp == 0 then
			me.status = "ko"
		end
		DiceCore.notify("state")
	end
end

function DiceCore.resetHP()
	if DiceCore.isParticipant() then
		DiceCore.send("selfReset", {})
	else
		local me = getLocalMe()
		me.hp = me.maxHp
		me.status = "idle"
		DiceCore.notify("state")
	end
end

function DiceCore.setKO(flag)
	if DiceCore.isParticipant() then
		DiceCore.send("selfKO", { flag = flag == true })
	else
		local me = getLocalMe()
		me.status = flag and "ko" or "idle"
		me.hp = flag and 0 or math.max(1, me.hp)
		DiceCore.notify("state")
	end
end

function DiceCore.setCover(flag)
	if DiceCore.isParticipant() then
		DiceCore.send("setCover", { flag = flag == true })
	else
		getLocalMe().inCover = flag == true
		DiceCore.notify("state")
	end
end

function DiceCore.setArmor(flag)
	if DiceCore.isParticipant() then
		DiceCore.send("setArmor", { flag = flag == true })
	else
		getLocalMe().armored = flag == true
		DiceCore.notify("state")
	end
end

function DiceCore.updateMyWeapon()
	local p = getPlayer and getPlayer() or nil
	local item = p and p:getPrimaryHandItem() or nil
	local me = getLocalMe()
	me.weapon = DiceCore.classifyWeapon(item)
	me.weaponScrap = DiceCore.isScrapItem(item)
	if DiceCore.isParticipant() then
		DiceCore.send("weaponPing", { class = me.weapon, scrap = me.weaponScrap })
	else
		DiceCore.notify("state")
	end
end

function DiceCore.toggleMoveRange()
	DiceCore.state.showMoveRange = not DiceCore.state.showMoveRange
	DiceCore.notify("state")
end

function DiceCore.toggleGunRange()
	DiceCore.state.showGunRange = not DiceCore.state.showGunRange
	DiceCore.notify("state")
end

------------------------------------------------------------------------------

function DiceCore.isStaff()
	if not isClient or not isClient() then
		return true
	end
	local ok, level = pcall(function() return getPlayer():getAccessLevel() end)
	return ok and level ~= nil and level ~= "None"
end

DiceCore.STAFF_STATUSES = {
	{ field = "grappled", label = "Grappled", icon = "st_grapple", tip = "Grappled: cannot move until the grapple is broken" },
	{ field = "escapeWounds", label = "Escape-preventing wounds", icon = "st_wounds", tip = "Escape-preventing wounds: cannot attempt to escape (staff-applied)" },
	{ field = "poisoned", label = "Poisoned", icon = "st_poison", tip = "Poisoned: -2 to all rolls for 3 of their turns" },
	{ field = "burning", label = "Burning", icon = "st_burning", tip = "Burning: 1 HP at the start of each of their turns" },
	{ field = "suppressed", label = "Suppressed", icon = "st_suppressed", tip = "Suppressed: pinned by heavy fire - roleplay accordingly" },
	{ field = "blinded", label = "Blinded", icon = "st_blind", tip = "Blinded: impaired vision - roleplay accordingly" },
}

function DiceCore.isLocalAdmin()
	if not (isClient and isClient()) then
		return true
	end
	local player = getPlayer()
	if not player then
		return false
	end
	local ok, level = pcall(function() return player:getAccessLevel() end)
	if not ok or level == nil then
		return false
	end
	return string.lower(tostring(level)) == "admin"
end

local function staffSend(cmd, args)
	args = args or {}
	args.combatId = DiceCore.state.combatId
	DiceCore.send(cmd, args)
end

function DiceCore.staffSkipTurn() staffSend("skipTurn") end
function DiceCore.staffKick(id) staffSend("kick", { id = id }) end
function DiceCore.staffAdjustHP(id, delta) staffSend("adjustHP", { id = id, delta = delta }) end
function DiceCore.staffSetKO(id, flag) staffSend("setKO", { id = id, flag = flag == true }) end
function DiceCore.staffToggleStatus(id, field) staffSend("toggleStatus", { id = id, field = field }) end
function DiceCore.staffSetInitiative(id, value) staffSend("setInitiative", { id = id, value = value }) end
function DiceCore.staffToggleMarker(id) staffSend("marker", { id = id }) end
function DiceCore.adminSetPaused(flag) staffSend("pause", { flag = flag == true }) end
function DiceCore.adminForceStart() staffSend("forceStart") end
function DiceCore.adminFinishNpcTurn() staffSend("npcFinishTurn") end
function DiceCore.adminMassRoll(rollId, radius, centerId) staffSend("massRoll", { rollId = rollId, radius = radius, centerId = centerId }) end
function DiceCore.adminAddNpc(name, hp, initiative) staffSend("addNpc", { name = name, hp = hp, initiative = initiative }) end
function DiceCore.staffNpcRoll(id, rollId) staffSend("npcRoll", { id = id, rollId = rollId, targetId = DiceCore.state.selectedTargetId }) end
function DiceCore.staffNpcDwd(id) staffSend("npcDwd", { id = id }) end
function DiceCore.staffSetCover(id) staffSend("npcState", { id = id, field = "inCover" }) end
function DiceCore.staffSetArmor(id) staffSend("npcState", { id = id, field = "armored" }) end
function DiceCore.staffSetNpcAdvantage(id, value) staffSend("npcState", { id = id, field = "advantage", value = value }) end
function DiceCore.staffSetWeapon(id, class) staffSend("npcState", { id = id, field = "weapon", value = class }) end

function DiceCore.staffBeginMoveNpc(id)
	DiceCore.state.movingNpcId = id
	addLogLocal("Click a tile to place the NPC (Escape cancels).")
	DiceCore.notify("state")
end

function DiceCore.staffCancelMoveNpc()
	if DiceCore.state.movingNpcId then
		DiceCore.state.movingNpcId = nil
		DiceCore.notify("state")
	end
end

function DiceCore.staffPlaceNpc(x, y, z)
	local id = DiceCore.state.movingNpcId
	DiceCore.state.movingNpcId = nil
	if id then
		staffSend("npcPlace", { id = id, x = x, y = y, z = z })
	end
	DiceCore.notify("state")
end

------------------------------------------------------------------------------

Events.OnServerCommand.Add(function(module, cmd, args)
	if module == DiceCore.MOD_ID then
		applyServerCommand(cmd, args or {})
	end
end)

local viewTick = 0
Events.OnTick.Add(function()
	DiceCore.stepAudit()
	if DiceCore.awaitingServer then
		DiceCore.awaitTicks = DiceCore.awaitTicks + 1
		if DiceCore.awaitTicks >= 300 then
			DiceCore.awaitTicks = 0
			DiceCore.awaitAttempts = (DiceCore.awaitAttempts or 0) + 1
			if DiceCore.awaitAttempts < 4 then
				DiceCore.send("requestState", {})
			else
				DiceCore.awaitingServer = false
				addLogLocal("WARNING: the dice server is not responding after 4 attempts. The server-side mod may have failed to load")
				DiceCore.errorText = "Dice server not responding see roll log"
				DiceCore.errorTicks = 600
				DiceCore.notify("state")
			end
		end
	end
	if (DiceCore.errorTicks or 0) > 0 then
		DiceCore.errorTicks = DiceCore.errorTicks - 1
		if DiceCore.errorTicks == 0 then
			DiceCore.errorText = nil
			DiceCore.notify("state")
		end
	end
	viewTick = viewTick + 1
	if viewTick >= 30 then
		viewTick = 0
		refreshView()
	end
end)

return DiceCore
