if isClient() then return end

local FileUtils = require("ElyonLib/FileUtils/FileUtils")
local MathUtils = require("ElyonLib/MathUtils/MathUtils")

DiceServer = DiceServer or {}

local MOD = "DL_Dice2026"
local RADIUS = 30
local DICE_SIDES = 20
local LOG_MAX = 300

DiceServer.combats = {}
DiceServer.nextId = 1

-----------------------------------------------------------------------------

local function roll(sides)
	sides = sides or DICE_SIDES
	if ZombRand then
		return ZombRand(sides) + 1
	end
	return math.random(sides)
end

local function cheb(x1, y1, x2, y2)
	return math.max(math.abs(x1 - x2), math.abs(y1 - y2))
end

local function findPlayer(username)
	local players = getOnlinePlayers and getOnlinePlayers() or nil
	if players then
		for i = 0, players:size() - 1 do
			local p = players:get(i)
			if p and p:getUsername() == username then
				return p
			end
		end
	end
	if not isServer() and getPlayer then
		local p = getPlayer()
		if p and p:getUsername() == username then
			return p
		end
	end
	return nil
end

local function isStaff(player)
	if not isServer() then
		return true
	end
	if not player then
		return false
	end
	local ok, level = pcall(function() return player:getAccessLevel() end)
	return ok and level ~= nil and string.lower(tostring(level)) == "admin"
end

local function posOf(c)
	if c.isNpc then
		if c.pos then
			return c.pos.x, c.pos.y, c.pos.z
		end
		return nil
	end
	local p = findPlayer(c.id)
	if p then
		return math.floor(p:getX()), math.floor(p:getY()), math.floor(p:getZ())
	end
	if c.pos then
		return c.pos.x, c.pos.y, c.pos.z
	end
	return nil
end

------------------------------------------------------------------------------

local function broadcast(cmd, args)
	if isServer() then
		pcall(sendServerCommand, MOD, cmd, args)
	elseif DiceClientApply then
		DiceClientApply(cmd, args)
	end
end

local function sendTo(player, cmd, args)
	if isServer() then
		pcall(sendServerCommand, player, MOD, cmd, args)
	elseif DiceClientApply then
		DiceClientApply(cmd, args)
	end
end

local function snapshot(c)
	local s = {}
	for k, v in pairs(c) do
		if k ~= "log" and k ~= "rolls" then
			s[k] = v
		end
	end
	return s
end

------------------------------------------------------------------------------

local function combatFile(id)
	return "DL_Dice2026/combat_" .. id .. ".json"
end

local function saveRegistry()
	local ids = {}
	for id in pairs(DiceServer.combats) do
		ids[#ids + 1] = id
	end
	FileUtils.writeJson("DL_Dice2026/active.json", { ids = ids, nextId = DiceServer.nextId }, MOD, { createIfNull = true })
end

local function saveCombat(c)
	FileUtils.writeJson(combatFile(c.id), c, MOD, { createIfNull = true })
end

local function archiveCombat(c, reason)
	c.endedReason = reason
	c.endedAt = getTimestamp and getTimestamp() or 0
	FileUtils.writeJson("DL_Dice2026/archive_" .. c.id .. ".json", c, MOD, { createIfNull = true })
	FileUtils.writeJson(combatFile(c.id), {}, MOD, { createIfNull = true })
end

local function loadCombats()
	local reg = FileUtils.readJson("DL_Dice2026/active.json", MOD, {})
	if type(reg) ~= "table" or type(reg.ids) ~= "table" then
		saveRegistry()
		return
	end
	DiceServer.nextId = reg.nextId or 1
	local now = getTimestamp and getTimestamp() or 0
	for i = 1, #reg.ids do
		local c = FileUtils.readJson(combatFile(reg.ids[i]), MOD, {})
		if type(c) == "table" and c.id then
			for j = 1, #(c.combatants or {}) do
				if not c.combatants[j].isNpc then
					c.combatants[j].online = false
				end
			end
			c.lastActivity = now
			DiceServer.combats[c.id] = c
		end
	end
end

------------------------------------------------------------------------------

local sha256 = require("DL_Dice2026/DiceSha")
DiceServer.sha256 = sha256

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

------------------------------------------------------------------------------

local seeds = {}
local currentDay = nil

local function dayId()
	local ts = getTimestamp and getTimestamp() or 0
	return math.floor(ts / 86400)
end

local function plog(text)
	if writeLog then
		pcall(writeLog, "DiceCombat", text)
	end
end

local function readFileSilent(path)
	local ok, reader = pcall(getFileReader, path, false)
	if not ok or not reader then
		return nil
	end
	local lines = {}
	local line = reader:readLine()
	while line do
		lines[#lines + 1] = line
		line = reader:readLine()
	end
	reader:close()
	return table.concat(lines, "\n")
end

local function getSeed(day)
	local cached = seeds[day]
	if cached ~= nil then
		return cached or nil
	end
	local content = readFileSilent("DL_Dice2026/seed_" .. day .. ".txt")
	if content and content ~= "" then
		content = string.gsub(content, "%s+", "")
		seeds[day] = content
		return content
	end
	seeds[day] = false
	return nil
end

local function publishNotice(line, quiet)
	plog(line)
	FileUtils.writeFile("DL_Dice2026/fairness.txt", line .. "\n", MOD, { createIfNull = true, append = true })
	if not quiet then
		broadcast("notice", { line = line })
	end
end

function DiceServer.commitLine()
	local seed = getSeed(dayId())
	if seed then
		return "FAIRNESS: day " .. dayId() .. " roll commitment: " .. sha256(seed)
	end
	return nil
end

local function ensureSeed(quiet)
	local day = dayId()
	if currentDay == day and seeds[day] then
		return seeds[day]
	end

	local prevDay = currentDay or (day - 1)
	if prevDay < day then
		local old = getSeed(prevDay)
		if old then
			publishNotice("FAIRNESS: day " .. prevDay .. " seed REVEALED: " .. old .. " (commitment was " .. sha256(old) .. ")", quiet)
			DiceServer.broadcastAudit(prevDay, old, quiet)
		end
	end
	local seed = getSeed(day)
	if not seed then
		local entropy = tostring(getTimestampMs and getTimestampMs() or 0)
		for _ = 1, 8 do
			entropy = entropy .. "-" .. tostring(ZombRand(1000000000))
		end
		seed = sha256(entropy)
		FileUtils.writeFile("DL_Dice2026/seed_" .. day .. ".txt", seed, MOD, { createIfNull = true })
		seeds[day] = seed
	end
	currentDay = day
	publishNotice("FAIRNESS: day " .. day .. " roll commitment: " .. sha256(seed)
		.. " | roll = SHA256(seed:combatId:index) first 8 hex % sides + 1 | seed reveals tomorrow", quiet)
	return seed
end

local function croll(c, sides, what)
	local seed = c.seedDay and getSeed(c.seedDay) or nil
	if not seed then
		seed = ensureSeed()
		c.seedDay = currentDay
	end
	c.rollIndex = (c.rollIndex or 0) + 1
	local value
	if seed then
		local digest = sha256(seed .. ":" .. c.id .. ":" .. c.rollIndex)
		value = (hexToNum(digest) % sides) + 1
	else
		value = roll(sides)
		plog("[c" .. c.id .. "] WARNING: no seed available, fell back to ZombRand")
	end
	c.rolls = c.rolls or {}
	c.rolls[#c.rolls + 1] = { i = c.rollIndex, d = "d" .. sides, what = what or "?", r = value }
	plog("[c" .. c.id .. "] ROLL i=" .. c.rollIndex .. " d" .. sides .. " what=" .. (what or "?") .. " r=" .. value)
	if seed then
		FileUtils.writeFile("DL_Dice2026/rolls_" .. (c.seedDay or currentDay) .. ".txt",
			c.id .. ":" .. c.rollIndex .. ":" .. sides .. ":" .. value .. "\n",
			MOD, { createIfNull = true, append = true })
	end
	return value
end

------------------------------------------------------------------------------

DiceServer.lastAudit = nil

function DiceServer.sendAudit(player)
	local a = DiceServer.lastAudit
	if not a then
		return
	end
	local total = #a.rolls
	if total == 0 then
		local payload = { day = a.day, seed = a.seed, total = 0, rolls = {}, done = true }
		if player then
			sendTo(player, "auditChunk", payload)
		else
			broadcast("auditChunk", payload)
		end
		return
	end
	local CHUNK = 200
	local offset = 0
	while offset < total do
		local chunk = {}
		for i = offset + 1, math.min(offset + CHUNK, total) do
			chunk[#chunk + 1] = a.rolls[i]
		end
		offset = offset + #chunk
		local payload = { day = a.day, seed = a.seed, total = total, rolls = chunk, done = offset >= total }
		if player then
			sendTo(player, "auditChunk", payload)
		else
			broadcast("auditChunk", payload)
		end
	end
end

function DiceServer.broadcastAudit(day, seed, quiet)
	local content = readFileSilent("DL_Dice2026/rolls_" .. day .. ".txt") or ""
	local rolls = {}
	for cid, i, s, r in string.gmatch(content, "(%d+):(%d+):(%d+):(%d+)") do
		rolls[#rolls + 1] = { c = tonumber(cid), i = tonumber(i), s = tonumber(s), r = tonumber(r) }
	end
	DiceServer.lastAudit = { day = day, seed = seed, rolls = rolls }
	plog("AUDIT prepared: day " .. day .. ", " .. #rolls .. " rolls")
	if not quiet then
		DiceServer.sendAudit(nil)
	end
end

------------------------------------------------------------------------------

local function addLog(c, line)
	c.log = c.log or {}
	c.log[#c.log + 1] = line
	while #c.log > LOG_MAX do
		table.remove(c.log, 1)
	end
	plog("[c" .. c.id .. "] " .. line)
	broadcast("log", { id = c.id, line = line })
end

local function push(c)
	c.lastActivity = getTimestamp and getTimestamp() or 0
	saveCombat(c)
	broadcast("state", snapshot(c))
end

local function findCombatant(c, id)
	for i = 1, #c.combatants do
		if c.combatants[i].id == id then
			return c.combatants[i], i
		end
	end
	return nil
end


local function findByPlayer(username)
	for _, c in pairs(DiceServer.combats) do
		local m = findCombatant(c, username)
		if m then
			return c, m
		end
	end
	return nil
end

local function hasHumanParticipants(c)
	for i = 1, #c.combatants do
		if not c.combatants[i].isNpc then
			return true
		end
	end
	return false
end

local function endCombat(c, reason)
	addLog(c, "Combat has ended (" .. reason .. ").")
	archiveCombat(c, reason)
	DiceServer.combats[c.id] = nil
	saveRegistry()
	broadcast("ended", { id = c.id })
end

------------------------------------------------------------------------------

local DAMAGE = {
	unarmed = 1, melee1h = 2, melee2h = 3,
	pistol = 3, shotgun = 4, rifle = 4, crossbow = 4,
	thrown = 2, molotov = 1, bomb = 4,
}
local RANGED = { pistol = true, shotgun = true, rifle = true, crossbow = true, thrown = true, molotov = true, bomb = true }
local WEAPON_NAMES = {
	unarmed = "Unarmed", melee1h = "One-handed melee", melee2h = "Two-handed melee",
	pistol = "Pistol", shotgun = "Shotgun", rifle = "Rifle", crossbow = "Crossbow",
	thrown = "Thrown weapon", molotov = "Molotov", bomb = "Pipe/aerosol bomb",
}

local function classifyItem(item)
	if not item then
		return "unarmed", false
	end
	local ok, class = pcall(function()
		if not instanceof(item, "HandWeapon") then
			return "unarmed"
		end
		if item.getExplosionPower and item:getExplosionPower() > 0 then
			return "bomb"
		end
		if item.getFirePower and item:getFirePower() > 0 then
			return "molotov"
		end
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
	class = ok and class or "melee1h"
	local scrap = false
	if RANGED[class] then
		local okN, name = pcall(function() return string.lower(item:getDisplayName() or "") end)
		if okN then
			scrap = (string.find(name, "scrap", 1, true) or string.find(name, "junk", 1, true)
				or string.find(name, "makeshift", 1, true) or string.find(name, "improvised", 1, true)) ~= nil
		end
	end
	return class, scrap
end

local function refreshWeapon(c, hintClass, hintScrap)
	if c.isNpc then
		return
	end
	local p = findPlayer(c.id)
	if not p then
		return
	end
	local item = p:getPrimaryHandItem()
	if not item and hintClass and DAMAGE[hintClass] then
		c.weapon = hintClass
		c.weaponScrap = hintScrap == true
		return
	end
	c.weapon, c.weaponScrap = classifyItem(item)
end

------------------------------------------------------------------------------

local function rollFor(c, m)
	local r1 = croll(c, DICE_SIDES, "d20:" .. (m.name or "?"))
	local raw, suffix = r1, ""
	local adv = m.advantage or 0
	if adv ~= 0 then
		local r2 = croll(c, DICE_SIDES, "d20adv:" .. (m.name or "?"))
		raw = adv > 0 and math.max(r1, r2) or math.min(r1, r2)
		suffix = string.format(" [%d/%d %s]", r1, r2, adv > 0 and "adv" or "dis")
		m.advantage = 0
	end
	local total = raw
	if m.poisoned then
		total = total - 2
		suffix = suffix .. " [-2 poison]"
	end
	return total, raw, suffix
end

------------------------------------------------------------------------------

local advanceTurn

local function applyDamage(c, victim, amount, source)
	victim.hp = MathUtils.clamp(victim.hp - amount, 0, victim.maxHp)
	addLog(c, victim.name .. " takes " .. amount .. " damage" .. (source and (" (" .. source .. ")") or "") .. " - " .. victim.hp .. "/" .. victim.maxHp .. " HP.")
	if victim.hp == 0 and victim.status ~= "ko" then
		victim.status = "ko"
		addLog(c, victim.name .. " is knocked out!")
	end
end

local function tickBurn(c, m)
	if (m.burnTurns or 0) > 0 then
		m.burnTurns = m.burnTurns - 1
		if m.burnTurns <= 0 then
			m.burning = false
		end
		applyDamage(c, m, 1, "burning")
		return m.status == "ko"
	end
	return false
end

advanceTurn = function(c, depth)
	depth = (depth or 0) + 1
	if depth > (#c.combatants + 2) then
		c.currentId = nil
		return
	end
	local list = c.combatants
	local index = 0
	for i = 1, #list do
		if list[i].id == c.currentId then
			index = i
			break
		end
	end
	for step = 1, #list do
		local nextIndex = index + step
		if nextIndex > #list then
			nextIndex = nextIndex - #list
		end
		local m = list[nextIndex]
		if m and m.status ~= "ko" and m.status ~= "surrendered" then
			if nextIndex <= index then
				c.round = (c.round or 1) + 1
				addLog(c, "Round " .. c.round .. " begins.")
			end
			c.currentId = m.id
			addLog(c, "It is now " .. m.name .. "'s turn.")
			if tickBurn(c, m) then
				advanceTurn(c, depth)
			end
			return
		end
	end
	c.currentId = nil
end

local function endTurn(c)
	local m = findCombatant(c, c.currentId)
	if m then
		m.aimingAt = nil
	end
	if m and (m.poisonTurns or 0) > 0 then
		m.poisonTurns = m.poisonTurns - 1
		if m.poisonTurns <= 0 then
			m.poisoned = false
			addLog(c, m.name .. " is no longer poisoned.")
		end
	end
	advanceTurn(c)
end

------------------------------------------------------------------------------

local function newCombatant(username, name)
	return {
		id = username, name = name, isNpc = false,
		hp = 20, maxHp = 20, traits = {},
		status = "idle", ready = false, initiative = nil,
		inCover = false, armored = false, grappled = false, escapeWounds = false,
		poisoned = false, poisonTurns = 0, burning = false, burnTurns = 0,
		suppressed = false, blinded = false,
		advantage = 0, weapon = "unarmed", weaponScrap = false,
		showMarker = false, online = true,
	}
end

local function rerollTies(c)
	for _ = 1, 8 do
		local seen, tied = {}, {}
		for i = 1, #c.combatants do
			local m = c.combatants[i]
			if seen[m.initiative] then
				tied[#tied + 1] = m
				tied[#tied + 1] = seen[m.initiative]
			else
				seen[m.initiative] = m
			end
		end
		if #tied == 0 then
			return
		end
		for i = 1, #tied do
			tied[i].initiative = croll(c, DICE_SIDES, "tie:" .. tied[i].name)
			addLog(c, "Initiative tie: " .. tied[i].name .. " re-rolls " .. tied[i].initiative .. ".")
		end
	end
end

local function startCombat(c, forced)
	rerollTies(c)
	table.sort(c.combatants, function(a, b)
		return (a.initiative or 0) > (b.initiative or 0)
	end)
	c.phase = "active"
	c.round = 1
	c.currentId = nil
	for i = 1, #c.combatants do
		local m = c.combatants[i]
		if m.status ~= "ko" and m.status ~= "surrendered" then
			c.currentId = m.id
			break
		end
	end
	local first = findCombatant(c, c.currentId)
	addLog(c, (forced and "STAFF force-starts combat! " or "Everyone is ready - combat begins! ")
		.. (first and (first.name .. " acts first.") or ""))
end

local function maybeAutoStart(c)
	if c.phase ~= "forming" then
		return
	end
	for i = 1, #c.combatants do
		local m = c.combatants[i]
		if not m.isNpc and not m.ready then
			return
		end
	end
	startCombat(c, false)
end

local function handleRollInitiative(player)
	local username = player:getUsername()
	local existing = findByPlayer(username)
	if existing then
		sendTo(player, "error", { message = "You are already in combat #" .. existing.id .. "." })
		push(existing)
		return
	end
	local px = math.floor(player:getX())
	local py = math.floor(player:getY())
	local pz = math.floor(player:getZ())

	local nearest = nil
	for _, c in pairs(DiceServer.combats) do
		if cheb(px, py, c.anchor.x, c.anchor.y) <= RADIUS then
			nearest = c
			break
		end
	end
	if nearest then
		if nearest.phase == "active" then
			sendTo(player, "error", { message = "This combat has already started - you cannot join." })
			return
		end
		local m = newCombatant(username, username)
		m.pos = { x = px, y = py, z = pz }
		refreshWeapon(m)
		local total, _, suffix = rollFor(nearest, m)
		m.initiative = math.max(1, total)
		nearest.combatants[#nearest.combatants + 1] = m
		addLog(nearest, username .. " rolls initiative: " .. m.initiative .. suffix)
		push(nearest)
		return
	end

	for _, c in pairs(DiceServer.combats) do
		if cheb(px, py, c.anchor.x, c.anchor.y) <= RADIUS * 2 then
			sendTo(player, "error", { message = "Too close to another ongoing combat." })
			return
		end
	end

	ensureSeed()
	local c = {
		id = DiceServer.nextId,
		anchor = { x = px, y = py, z = pz },
		phase = "forming",
		round = 0,
		currentId = nil,
		paused = false,
		combatants = {},
		npcCounter = 0,
		log = {},
		seedDay = currentDay,
		rollIndex = 0,
		rolls = {},
	}
	DiceServer.nextId = DiceServer.nextId + 1
	DiceServer.combats[c.id] = c
	local m = newCombatant(username, username)
	m.pos = { x = px, y = py, z = pz }
	refreshWeapon(m)
	local total, _, suffix = rollFor(c, m)
	m.initiative = math.max(1, total)
	c.combatants[#c.combatants + 1] = m
	addLog(c, username .. " starts a combat and rolls initiative: " .. m.initiative .. suffix)
	saveRegistry()
	push(c)
end

------------------------------------------------------------------------------

local function defenseRoll(c, defender, isRangedAttack)
	local total, raw, suffix = rollFor(c, defender)
	if defender.inCover and isRangedAttack then
		total = total + 2
		suffix = suffix .. " [+2 cover]"
	end
	return total, raw, suffix
end

local function aoeVictims(c, cx, cy, cz, radius)
	local victims = {}
	for i = 1, #c.combatants do
		local m = c.combatants[i]
		local x, y = posOf(m)
		if x and cheb(x, y, cx, cy) <= radius then
			victims[#victims + 1] = m
		end
	end
	return victims
end

local AMMO_USE = { pistol = -1, rifle = -1, shotgun = 1, crossbow = 1 }

local function checkAndConsumeAmmo(c, attacker, class, intent)
	if attacker.isNpc then
		return true
	end
	local use = AMMO_USE[class]
	if not use then
		return true
	end
	local p = findPlayer(attacker.id)
	local count = 0
	if p then
		local ok, n = pcall(function()
			local item = p:getPrimaryHandItem()
			return item and item.getCurrentAmmoCount and item:getCurrentAmmoCount() or 0
		end)
		count = ok and (n or 0) or 0
	end
	if count <= 0 and intent then
		count = tonumber(intent.ammo) or 0
	end
	if count <= 0 then
		if p then
			sendTo(p, "error", { message = "Your weapon is not loaded." })
		end
		return false
	end
	local need = use == -1 and croll(c, 3, "ammo:" .. attacker.name) or use
	local used = math.min(count, need)
	if p then
		sendTo(p, "consumeAmmo", { count = used })
	end
	addLog(c, attacker.name .. " fires " .. used .. " round" .. (used == 1 and "" or "s") .. ".")
	return true
end

local function consumeExplosive(c, attacker)
	if attacker.isNpc then
		return
	end
	local p = findPlayer(attacker.id)
	if p then
		sendTo(p, "consumeItem", {})
	end
	attacker.weapon = "unarmed"
	attacker.weaponScrap = false
end

local function resolveAttack(c, attacker, target, intent)
	refreshWeapon(attacker, intent and intent.weaponClass or nil, intent and intent.weaponScrap or nil)
	local class = attacker.weapon or "unarmed"
	if not checkAndConsumeAmmo(c, attacker, class, intent) then
		return
	end
	local isRangedAttack = RANGED[class] == true
	local dmg = DAMAGE[class] or 1
	if attacker.weaponScrap then
		dmg = math.max(1, dmg - 1)
	end
	local isAoe = class == "molotov" or class == "bomb"

	local atkTotal, atkRaw, atkSuffix = rollFor(c, attacker)
	local verb = (class == "thrown" or isAoe) and "throws at" or "attacks"

	if atkRaw == 1 then
		addLog(c, attacker.name .. " " .. verb .. " " .. target.name .. " with " .. WEAPON_NAMES[class] .. ": CRITICAL FAILURE!")
		if isAoe then
			local ax, ay, az = posOf(attacker)
			if ax then
				addLog(c, "The explosive detonates in " .. attacker.name .. "'s hands!")
				local victims = aoeVictims(c, ax, ay, az, 1)
				for i = 1, #victims do
					applyDamage(c, victims[i], dmg, "explosion")
				end
			end
			consumeExplosive(c, attacker)
		end
		endTurn(c)
		return
	end

	if isAoe then
		local tx, ty, tz = posOf(target)
		if not tx then
			addLog(c, attacker.name .. "'s throw fizzles (target position unknown).")
			endTurn(c)
			return
		end
		local radius = class == "molotov" and 1 or 2
		addLog(c, attacker.name .. " throws a " .. WEAPON_NAMES[class] .. " at " .. target.name .. ": " .. atkTotal .. atkSuffix)
		local victims = aoeVictims(c, tx, ty, tz, radius)
		for i = 1, #victims do
			local v = victims[i]
			local defTotal, _, defSuffix = defenseRoll(c, v, true)
			if atkTotal >= defTotal then
				addLog(c, v.name .. " fails to evade (" .. defTotal .. defSuffix .. ").")
				applyDamage(c, v, dmg, WEAPON_NAMES[class])
				if class == "molotov" then
					v.burning = true
					v.burnTurns = 2
					addLog(c, v.name .. " is set on fire!")
				end
			else
				addLog(c, v.name .. " evades (" .. defTotal .. defSuffix .. ").")
			end
		end
		consumeExplosive(c, attacker)
		endTurn(c)
		return
	end

	local defTotal, _, defSuffix = defenseRoll(c, target, isRangedAttack)
	local defType = isRangedAttack and "Defend ranged" or "Defend close"
	if atkTotal >= defTotal then
		local critLine = ""
		if atkRaw == 20 then
			local bonus = croll(c, 4, "crit:" .. attacker.name)
			dmg = dmg + bonus
			critLine = " CRITICAL HIT (+" .. bonus .. ")!"
		end
		addLog(c, attacker.name .. " " .. verb .. " " .. target.name .. " with " .. WEAPON_NAMES[class]
			.. ": " .. atkTotal .. atkSuffix .. " vs " .. defType .. " " .. defTotal .. defSuffix .. " - HIT." .. critLine)
		applyDamage(c, target, dmg, WEAPON_NAMES[class])
	else
		addLog(c, attacker.name .. " " .. verb .. " " .. target.name .. " with " .. WEAPON_NAMES[class]
			.. ": " .. atkTotal .. atkSuffix .. " vs " .. defType .. " " .. defTotal .. defSuffix .. " - MISS.")
	end
	endTurn(c)
end

------------------------------------------------------------------------------

local function resolveEscape(c, m)
	local mx, my = posOf(m)
	local nearest = nil
	for i = 1, #c.combatants do
		local o = c.combatants[i]
		if o.id ~= m.id and o.status ~= "ko" and o.status ~= "surrendered" then
			local ox, oy = posOf(o)
			if mx and ox then
				local d = cheb(mx, my, ox, oy)
				if not nearest or d < nearest then
					nearest = d
				end
			end
		end
	end
	local tilesBetween = math.max(0, (nearest or 1) - 1)
	local threshold = 20 - 2 * tilesBetween
	local total, _, suffix = rollFor(c, m)
	if total >= threshold then
		addLog(c, m.name .. " rolls Escape: " .. total .. suffix .. " vs " .. threshold .. " - ESCAPED! They must leave the scene.")
		return true
	end
	addLog(c, m.name .. " rolls Escape: " .. total .. suffix .. " vs " .. threshold .. " - failed. They remain in combat.")
	return false
end

------------------------------------------------------------------------------

local UTILITY = { firstaid = "First aid", sneak = "Sneak", notice = "Notice", physend = "Phys. endurance", mentend = "Ment. endurance", skill = "Skill roll", defclose = "Defend close", defranged = "Defend ranged" }

local DWD_OUTCOMES = {
	"died of their wounds. No actions after death without staff/opponent approval.",
	"died of their wounds. No actions after death without staff/opponent approval.",
	"will survive ONLY with First Aid 6+ treatment within 60 IRL minutes.",
	"will survive ONLY with First Aid 6+ treatment within 60 IRL minutes.",
	"is unconscious and incapable of fighting until the enemy leaves.",
	"is unconscious and incapable of fighting until the enemy leaves.",
}

local function removeParticipant(c, id, logLine)
	local m, index = findCombatant(c, id)
	if not m then
		return
	end
	if c.currentId == id then
		advanceTurn(c)
	end
	table.remove(c.combatants, index)
	if c.currentId == id then
		c.currentId = nil
	end
	for i = 1, #c.combatants do
		if c.combatants[i].aimingAt == id then
			c.combatants[i].aimingAt = nil
		end
	end
	if logLine then
		addLog(c, logLine)
	end
	if not hasHumanParticipants(c) then
		endCombat(c, "everyone left")
		return true
	end
	return false
end

function DiceServer.handle(player, cmd, args)
	args = args or {}
	local username = player and player:getUsername() or "?"
	local c, m = findByPlayer(username)

	if cmd == "requestState" then
		ensureSeed()
		local commit = DiceServer.commitLine()
		if commit then
			sendTo(player, "notice", { line = commit })
		end
		DiceServer.sendAudit(player)
		for _, combat in pairs(DiceServer.combats) do
			sendTo(player, "state", snapshot(combat))
			local tail = {}
			local log = combat.log or {}
			for i = math.max(1, #log - 40), #log do
				tail[#tail + 1] = log[i]
			end
			sendTo(player, "logBatch", { id = combat.id, lines = tail })
		end
		return
	end

	if cmd == "rollInitiative" then
		handleRollInitiative(player)
		return
	end

	if cmd == "weaponPing" then
		if c and m then
			refreshWeapon(m, args.class, args.scrap)
			push(c)
		end
		return
	end

	if cmd == "utilityRoll" then
		local label = UTILITY[args.rollId]
		if not label then
			return
		end
		local combat = c
		if not combat then
			combat = DiceServer.combats[args.combatId]
			if not combat then
				return
			end
			local d = cheb(math.floor(player:getX()), math.floor(player:getY()), combat.anchor.x, combat.anchor.y)
			if d > RADIUS then
				return
			end
		end
		if combat.paused then
			return
		end
		local roller = m or { name = username, advantage = args.advantage or 0 }
		if m and (m.status == "ko" or m.status == "surrendered") then
			return
		end
		local total, _, suffix = rollFor(combat, roller)
		addLog(combat, roller.name .. " rolls " .. label .. ": " .. total .. suffix)
		push(combat)
		return
	end

	if not c or not m then
		return
	end

	if cmd == "ready" then
		if c.phase == "forming" then
			m.ready = args.ready == true
			m.status = m.ready and "ready" or "idle"
			addLog(c, m.name .. (m.ready and " is ready." or " is no longer ready."))
			maybeAutoStart(c)
			push(c)
		end
	elseif cmd == "setAdvantage" then
		if not c.paused then
			m.advantage = (m.advantage == args.value) and 0 or (args.value or 0)
			push(c)
		end
	elseif cmd == "aim" then
		if args.targetId == nil or findCombatant(c, args.targetId) then
			m.aimingAt = args.targetId
			push(c)
		end
	elseif cmd == "setCover" then
		m.inCover = args.flag == true
		addLog(c, m.name .. (m.inCover and " takes cover." or " leaves cover."))
		push(c)
	elseif cmd == "setArmor" then
		m.armored = args.flag == true
		addLog(c, m.name .. (m.armored and " is wearing armor." or " removes armor."))
		push(c)
	elseif cmd == "attack" then
		if c.phase == "active" and not c.paused and c.currentId == m.id
			and m.status ~= "ko" and m.status ~= "surrendered" then
			local target = findCombatant(c, args.targetId)
			if target and target.id ~= m.id and target.status ~= "ko" and target.status ~= "surrendered" then
				resolveAttack(c, m, target, args)
				push(c)
			else
				sendTo(player, "error", { message = "Invalid target." })
			end
		end
	elseif cmd == "escape" then
		if c.phase == "active" and not c.paused and c.currentId == m.id
			and m.status ~= "ko" and m.status ~= "surrendered" and not m.escapeWounds and not m.grappled then
			if resolveEscape(c, m) then
				if not removeParticipant(c, m.id, nil) then
					push(c)
				end
			else
				push(c)
			end
		end
	elseif cmd == "finishTurn" then
		if c.phase == "active" and not c.paused and c.currentId == m.id then
			endTurn(c)
			push(c)
		end
	elseif cmd == "surrender" then
		if args.flag and m.status ~= "surrendered" and m.status ~= "ko" then
			m.status = "surrendered"
			addLog(c, m.name .. " surrenders!")
			if c.currentId == m.id then
				advanceTurn(c)
			end
			push(c)
		elseif not args.flag and m.status == "surrendered" then
			m.status = c.phase == "forming" and "idle" or "ready"
			addLog(c, m.name .. " withdraws their surrender and is a valid target again.")
			push(c)
		end
	elseif cmd == "leave" then
		if not removeParticipant(c, m.id, m.name .. " leaves combat.") then
			push(c)
		end
	elseif cmd == "dwd" then
		local r = croll(c, 6, "dwd:" .. m.name)
		addLog(c, m.name .. " Dices with Death: rolls " .. r .. " - " .. DWD_OUTCOMES[r])
		push(c)
	elseif cmd == "selfHP" then
		local delta = MathUtils.parseNumber(args.delta, 0, -99, 99)
		m.hp = MathUtils.clamp(m.hp + delta, 0, m.maxHp)
		if m.hp == 0 and m.status ~= "ko" then
			m.status = "ko"
			addLog(c, m.name .. " is knocked out!")
			if c.currentId == m.id then
				advanceTurn(c)
			end
		end
		push(c)
	elseif cmd == "selfReset" then
		m.hp = m.maxHp
		if m.status == "ko" then
			m.status = c.phase == "forming" and "idle" or "ready"
		end
		addLog(c, m.name .. " resets HP to " .. m.maxHp .. ".")
		push(c)
	elseif cmd == "selfKO" then
		if args.flag then
			m.status = "ko"
			m.hp = 0
			addLog(c, m.name .. " is knocked out!")
			if c.currentId == m.id then
				advanceTurn(c)
			end
		elseif m.status == "ko" then
			m.status = c.phase == "forming" and "idle" or "ready"
			if m.hp == 0 then
				m.hp = 1
			end
			addLog(c, m.name .. " is back on their feet.")
		end
		push(c)
	else
		DiceServer.handleStaff(player, cmd, args, c, m)
	end
end

------------------------------------------------------------------------------

local STATUS_LABELS = {
	grappled = "Grappled", escapeWounds = "Escape-preventing wounds",
	poisoned = "Poisoned", suppressed = "Suppressed", blinded = "Blinded", burning = "Burning",
}

function DiceServer.handleStaff(player, cmd, args, c, m)
	if not isStaff(player) then
		return
	end
	c = c or DiceServer.combats[args.combatId]
	if not c then
		return
	end
	local target = args.id and findCombatant(c, args.id) or nil

	if cmd == "forceStart" then
		if c.phase == "forming" then
			startCombat(c, true)
			push(c)
		end
	elseif cmd == "pause" then
		c.paused = args.flag == true
		addLog(c, c.paused and "STAFF: combat is PAUSED - hold all actions." or "STAFF: combat resumed.")
		push(c)
	elseif cmd == "skipTurn" then
		if c.phase == "active" and c.currentId then
			local current = findCombatant(c, c.currentId)
			addLog(c, "Staff skipped " .. (current and current.name or "?") .. "'s turn.")
			endTurn(c)
			push(c)
		end
	elseif cmd == "kick" and target then
		if not removeParticipant(c, target.id, target.name .. " was removed from combat by staff.") then
			push(c)
		end
	elseif cmd == "adjustHP" and target then
		local delta = MathUtils.parseNumber(args.delta, 0, -99, 99)
		target.hp = MathUtils.clamp(target.hp + delta, 0, target.maxHp)
		if target.hp == 0 and target.status ~= "ko" then
			target.status = "ko"
			addLog(c, target.name .. " is knocked out! (staff)")
			if c.currentId == target.id then
				advanceTurn(c)
			end
		else
			addLog(c, "Staff set " .. target.name .. "'s HP to " .. target.hp .. "/" .. target.maxHp .. ".")
		end
		push(c)
	elseif cmd == "setKO" and target then
		if args.flag then
			target.status = "ko"
			target.hp = 0
			addLog(c, target.name .. " was knocked out by staff.")
			if c.currentId == target.id then
				advanceTurn(c)
			end
		else
			target.status = c.phase == "forming" and "idle" or "ready"
			if target.hp == 0 then
				target.hp = 1
			end
			addLog(c, target.name .. " was revived by staff.")
		end
		push(c)
	elseif cmd == "toggleStatus" and target then
		local field = args.field
		if not STATUS_LABELS[field] then
			return
		end
		if field == "poisoned" then
			target.poisoned = not target.poisoned
			target.poisonTurns = target.poisoned and 3 or 0
		elseif field == "burning" then
			target.burning = not target.burning
			target.burnTurns = target.burning and 3 or 0
		else
			target[field] = not target[field]
		end
		addLog(c, target.name .. (target[field] and " gains status: " or " loses status: ") .. STATUS_LABELS[field] .. ". (staff)")
		push(c)
	elseif cmd == "setInitiative" and target then
		if args.value then
			local v = MathUtils.parseNumber(args.value, nil, 1, 99)
			if not v then
				return
			end
			target.initiative = math.floor(v)
			addLog(c, "Staff set " .. target.name .. "'s initiative to " .. target.initiative .. ".")
		else
			target.initiative = croll(c, DICE_SIDES, "init:" .. target.name)
			addLog(c, target.name .. " re-rolls initiative: " .. target.initiative .. ". (staff)")
		end
		if c.phase == "active" then
			table.sort(c.combatants, function(a, b)
				return (a.initiative or 0) > (b.initiative or 0)
			end)
		end
		push(c)
	elseif cmd == "marker" and target then
		target.showMarker = not target.showMarker
		push(c)
	elseif cmd == "massRoll" then
		local label = UTILITY[args.rollId] or (args.rollId == "attack" and "Attack")
		if not label then
			return
		end
		local radius = MathUtils.parseNumber(args.radius, 5, 1, 50)
		local cx, cy
		local centerName = "the admin"
		if args.centerId and args.centerId ~= "me" then
			local center = findCombatant(c, args.centerId)
			if center then
				cx, cy = posOf(center)
				centerName = center.name
			end
		else
			cx, cy = math.floor(player:getX()), math.floor(player:getY())
		end
		if not cx then
			return
		end
		addLog(c, "ADMIN: everyone within " .. radius .. " tiles of " .. centerName .. " rolls " .. label .. "!")
		for i = 1, #c.combatants do
			local v = c.combatants[i]
			if v.status ~= "ko" and v.status ~= "surrendered" then
				local x, y = posOf(v)
				if x and cheb(x, y, cx, cy) <= radius then
					local total, _, suffix = rollFor(c, v)
					addLog(c, v.name .. " rolls " .. label .. ": " .. total .. suffix)
				end
			end
		end
		push(c)
	elseif cmd == "addNpc" then
		c.npcCounter = (c.npcCounter or 0) + 1
		local npc = newCombatant("npc" .. c.id .. "_" .. c.npcCounter, nil)
		npc.isNpc = true
		npc.owner = player:getUsername()
		npc.name = (args.name and args.name ~= "") and args.name or ("NPC " .. c.npcCounter)
		npc.maxHp = MathUtils.parseNumber(args.hp, 10, 1, 99)
		npc.hp = npc.maxHp
		npc.ready = true
		npc.status = "ready"
		npc.initiative = MathUtils.parseNumber(args.initiative, nil, 1, 99) or croll(c, DICE_SIDES, "npc-init")
		npc.pos = { x = math.floor(player:getX()), y = math.floor(player:getY()), z = math.floor(player:getZ()) }
		local list = c.combatants
		if c.phase == "active" then
			local pos = #list + 1
			for i = 1, #list do
				if (list[i].initiative or 0) < npc.initiative then
					pos = i
					break
				end
			end
			table.insert(list, pos, npc)
		else
			list[#list + 1] = npc
			maybeAutoStart(c)
		end
		addLog(c, "ADMIN: " .. npc.name .. " joins combat (HP " .. npc.maxHp .. ", initiative " .. npc.initiative .. ").")
		push(c)
	elseif cmd == "npcFinishTurn" then
		local current = findCombatant(c, c.currentId)
		if c.phase == "active" and current and current.isNpc then
			addLog(c, current.name .. " finishes their turn.")
			endTurn(c)
			push(c)
		end
	elseif cmd == "npcRoll" and target and target.isNpc then
		local label = UTILITY[args.rollId]
		if args.rollId == "attack" or args.rollId == "throw" then
			local victim = findCombatant(c, args.targetId)
			if victim and victim.id ~= target.id and victim.status ~= "ko" and victim.status ~= "surrendered" then
				resolveAttack(c, target, victim)
				push(c)
			end
		elseif label then
			local total, _, suffix = rollFor(c, target)
			addLog(c, target.name .. " rolls " .. label .. ": " .. total .. suffix)
			push(c)
		end
	elseif cmd == "npcState" and target and target.isNpc then
		if args.field == "inCover" or args.field == "armored" then
			target[args.field] = not target[args.field]
			addLog(c, target.name .. (target[args.field]
				and (args.field == "inCover" and " takes cover." or " is wearing armor.")
				or (args.field == "inCover" and " leaves cover." or " removes armor.")))
		elseif args.field == "advantage" then
			target.advantage = (target.advantage == args.value) and 0 or args.value
		elseif args.field == "weapon" and DAMAGE[args.value] then
			target.weapon = args.value
			target.weaponScrap = false
			addLog(c, target.name .. " switches to: " .. WEAPON_NAMES[args.value] .. ".")
		end
		push(c)
	elseif cmd == "npcPlace" and target and target.isNpc then
		target.pos = { x = args.x, y = args.y, z = args.z }
		addLog(c, target.name .. " repositioned.")
		push(c)
	elseif cmd == "npcDwd" and target and target.isNpc then
		local r = croll(c, 6, "dwd:" .. target.name)
		addLog(c, target.name .. " Dices with Death: rolls " .. r .. " - " .. DWD_OUTCOMES[r])
		push(c)
	end
end

------------------------------------------------------------------------------

local tickCounter = 0

local INACTIVITY_LIMIT = 3600

local function onTick()
	tickCounter = tickCounter + 1
	if tickCounter < 20 then
		return
	end
	tickCounter = 0
	if currentDay and dayId() ~= currentDay then
		ensureSeed()
	end
	local now = getTimestamp and getTimestamp() or 0
	local expired = {}

	for id, c in pairs(DiceServer.combats) do
		if c.lastActivity and now - c.lastActivity > INACTIVITY_LIMIT then
			expired[#expired + 1] = id
		else
			local onlineChanged = false
			for i = 1, #c.combatants do
				local m = c.combatants[i]
				if not m.isNpc then
					local p = findPlayer(m.id)
					local nowOnline = p ~= nil
					if m.online ~= nowOnline then
						m.online = nowOnline
						onlineChanged = true
					end
					if p then
						local x, y = math.floor(p:getX()), math.floor(p:getY())
						m.pos = { x = x, y = y, z = math.floor(p:getZ()) }
						if c.phase == "active" and cheb(x, y, c.anchor.x, c.anchor.y) > RADIUS then
							local nx = MathUtils.clamp(x, c.anchor.x - (RADIUS - 1), c.anchor.x + (RADIUS - 1))
							local ny = MathUtils.clamp(y, c.anchor.y - (RADIUS - 1), c.anchor.y + (RADIUS - 1))
							sendTo(p, "snapBack", { x = nx, y = ny, z = c.anchor.z })
						end
					end
				end
			end
			if onlineChanged then
				push(c)
			end
		end
	end

	for i = 1, #expired do
		local c = DiceServer.combats[expired[i]]
		if c then
			endCombat(c, "no activity for 1 hour")
		end
	end
end

------------------------------------------------------------------------------

local function safeHandle(player, cmd, args)
	local ok, err = pcall(DiceServer.handle, player, cmd, args)
	if not ok then
		local line = "[DL_Dice2026] ERROR in command '" .. tostring(cmd) .. "': " .. tostring(err)
		print(line)
		plog(line)
		if player then
			pcall(sendTo, player, "error", { message = "Server error during '" .. tostring(cmd) .. "' - check server console." })
		end
	end
end

local function onClientCommand(module, cmd, player, args)
	if module ~= MOD then
		return
	end
	safeHandle(player, cmd, args)
end

local function boot()
	local ok, err = pcall(loadCombats)
	if not ok then
		print("[DL_Dice2026] ERROR loading combats: " .. tostring(err))
	end
	ok, err = pcall(ensureSeed, true)
	if not ok then
		print("[DL_Dice2026] ERROR in ensureSeed at boot: " .. tostring(err))
		plog("ERROR in ensureSeed at boot: " .. tostring(err))
	end
	local count = 0
	for _ in pairs(DiceServer.combats) do
		count = count + 1
	end
	print("[DL_Dice2026] server module loaded, " .. count .. " combat(s) restored")
end

Events.OnClientCommand.Add(onClientCommand)
Events.OnTick.Add(onTick)
Events.OnInitGlobalModData.Add(boot)

return DiceServer
