local DiceTraits = {}

DiceTraits.showTraitNames = true

DiceTraits.tuning = {
	baseMove = 5,
	baseThrowRange = 10,
	lungeTiles = 3,
	escapeThreshold = 18,
	aooRange = 1,
}

DiceTraits.defs = {

	ThickSkinned = { name = "Thick-Skinned", text = "Advantage on Dice with Death", dwd = 1 },
	Thinskinned = { name = "Thin-Skinned", text = "Disadvantage on Dice with Death", dwd = -1 },
	Dextrous = { name = "Dextrous", text = "+1 Initiative", initiative = 1 },
	AllThumbs = { name = "All Thumbs", text = "-1 Initiative", initiative = -1 },

	NightVision = { name = "Cat's Eyes", text = "+1 Notice", notice = 1 },
	EagleEyed = { name = "Eagle Eyes", text = "+1 Notice", notice = 1 },
	KeenHearing = { name = "Keen Hearing", text = "+1 Notice", notice = 1 },
	HardOfHearing = { name = "Hard of Hearing", text = "-2 Notice", notice = -2 },
	ShortSighted = { name = "Poor Eyesight", text = "-2 Notice", notice = -2 },
	daydreamer = { name = "Daydreamer", text = "-1 Notice", notice = -1 },
	oblivious = { name = "Oblivious", text = "-2 Notice", notice = -2 },

	Graceful = { name = "Graceful", text = "+1 Hide", sneak = 1 },
	Clumsy = { name = "Clumsy", text = "-1 Hide", sneak = -1 },
	Inconspicuous = { name = "Inconspicuous", text = "+1 Hide", sneak = 1 },
	Conspicuous = { name = "Conspicuous", text = "-1 Hide", sneak = -1 },
	softstep = { name = "Softstep", text = "+1 Hide", sneak = 1 },
	prowler = { name = "Prowler", text = "+1 Hide", sneak = 1 },
	deadly_quiet = { name = "Deadly Quiet", text = "+2 Hide", sneak = 2 },
	ghost = { name = "Ghost", text = "+2 Hide", sneak = 2 },
	heavy_footed = { name = "Heavy-Footed", text = "-1 Hide", sneak = -1 },
	lumbering = { name = "Lumbering", text = "-2 Hide", sneak = -2 },

	Asthmatic = { name = "Short of Breath", text = "-1 Physical Endurance", physend = -1 },
	asthmatic_dice = { name = "Asthmatic", text = "-3 Physical Endurance", physend = -3 },
	tireless = { name = "Tireless", text = "+2 Physical Endurance", physend = 2 },
	Hemophobic = { name = "Fear of Blood", text = "-1 Mental Endurance", mentend = -1 },
	faint_hearted = { name = "Faint-Hearted", text = "-3 Mental Endurance", mentend = -3 },
	iron_will = { name = "Iron Will", text = "+2 Mental Endurance", mentend = 2 },

	first_aid = { name = "First Aid", text = "+1 First Aid rolls", firstaid = 1 },
	sawbones = { name = "Sawbones", text = "+2 First Aid rolls", firstaid = 2 },

	hewer = { name = "Hewer", text = "+2 Attack with Axes", attackCat = { Axe = 2 } },
	limbsplitter = { name = "Limbsplitter", text = "+4 Attack with Axes", attackCat = { Axe = 4 } },
	cudgeller = { name = "Cudgeller", text = "+2 Attack with Long Blunts", attackCat = { Blunt = 2 } },
	bonebreaker = { name = "Bonebreaker", text = "+4 Attack with Long Blunts", attackCat = { Blunt = 4 } },
	thumper = { name = "Thumper", text = "+2 Attack with Short Blunts", attackCat = { SmallBlunt = 2 } },
	skullcracker = { name = "Skullcracker", text = "+4 Attack with Short Blunts", attackCat = { SmallBlunt = 4 } },
	slasher = { name = "Slasher", text = "+2 Attack with Long Blades", attackCat = { LongBlade = 2 } },
	cleaver = { name = "Cleaver", text = "+4 Attack with Long Blades", attackCat = { LongBlade = 4 } },
	cutter = { name = "Cutter", text = "+2 Attack with Short Blades", attackCat = { SmallBlade = 2 } },
	redhand = { name = "Redhand", text = "+4 Attack with Short Blades", attackCat = { SmallBlade = 4 } },
	sticker = { name = "Sticker", text = "+2 Attack with Spears", attackCat = { Spear = 2 } },
	longreach = { name = "Longreach", text = "+4 Attack with Spears", attackCat = { Spear = 4 } },
	scrapper = { name = "Scrapper", text = "+1 Attack Unarmed and Improvised", attackCat = { Unarmed = 1, Improvised = 1 } },

	snapshooter = { name = "Snapshooter", text = "+1 Attack with Guns, +2 total at close range", attackGun = 1, attackGunRange = { close = 1 } },
	gunslinger = { name = "Gunslinger", text = "+2 Attack with Guns, +4 total at close range", attackGun = 2, attackGunRange = { close = 2 } },
	rifleman = { name = "Rifleman", text = "+1 Attack with Guns, +2 total at medium range", attackGun = 1, attackGunRange = { medium = 1 } },
	dead_eye = { name = "Dead-Eye", text = "+2 Attack with Guns, +4 total at medium range", attackGun = 2, attackGunRange = { medium = 2 } },
	spotter = { name = "Spotter", text = "+1 Attack with Guns, +2 total at long range", attackGun = 1, attackGunRange = { long = 1 } },
	longshot = { name = "Longshot", text = "+2 Attack with Guns, +4 total at long range", attackGun = 2, attackGunRange = { long = 2 } },

	timid = { name = "Timid", text = "-2 Attack, melee and ranged", attackMelee = -2, attackRanged = -2 },
	meek = { name = "Meek", text = "-4 Attack, melee and ranged", attackMelee = -4, attackRanged = -4 },

	heavyweight = { name = "Heavyweight", text = "+1 Attack in melee, -1 movement tile", attackMelee = 1, move = -1 },
	featherweight = { name = "Featherweight", text = "-1 Attack in melee, +1 movement tile", attackMelee = -1, move = 1 },
	lunger = { name = "Lunger", text = "+2 Attack in melee after moving 3 or more tiles in a straight line", lunge = 2 },
	spearwall = { name = "Spearwall", text = "-2 Attack, and an attack of opportunity when someone leaves your melee range while you hold a two handed melee weapon", attack = -2, aoo = true },
	strong_arm = { name = "Strong Arm", text = "+1 thrown damage, +3 throw range, -1 on every attack that is not a throw",
		throwDamage = 1, throwRange = 3, attackNonThrown = -1, canThrowMelee = true },

	spry = { name = "Spry", text = "+1 Defend close", defclose = 1 },
	furtive = { name = "Furtive", text = "+2 Defend close", defclose = 2 },
	glass_jaw = { name = "Glass Jaw", text = "-4 Defend close", defclose = -4 },
	longstrider = { name = "Longstrider", text = "+1 Defend ranged", defranged = 1 },
	roadburner = { name = "Roadburner", text = "+2 Defend ranged", defranged = 2 },
	bullet_magnet = { name = "Bullet Magnet", text = "-4 Defend ranged", defranged = -4 },
	evasive = { name = "Evasive", text = "+1 Defend ranged, -1 Defend close", defranged = 1, defclose = -1 },
	sturdy = { name = "Sturdy", text = "+1 Defend close, -1 Defend ranged", defclose = 1, defranged = -1 },

	wrestler = { name = "Wrestler", text = "+2 Grapple and break free", grapple = 2 },
	slippery = { name = "Slippery", text = "+2 Escape", escape = 2 },
	quickdraw = { name = "Quickdraw", text = "+3 Initiative when the fight starts with a pistol in hand, lost if you swap weapon", initiativePistol = 3 },

	wildcard = { name = "Wildcard", text = "Critical success on 19-20, critical failure on 1-2", critHitLower = 1, critFailRaise = 1 },
	even_keel = { name = "Even Keel", text = "No critical successes and no critical failures", noCrit = true, noCritFail = true },
	lucky_dice = { name = "Lucky", text = "Status effects end one turn sooner, one turn minimum", statusTurns = -1 },
	unlucky_dice = { name = "Unlucky", text = "Status effects last one turn longer", statusTurns = 1 },
}

DiceTraits.gunRangeByType = {
	["Base.Shotgun"] = "close",
	["Base.ShotgunSawnoff"] = "close",
	["Base.DoubleBarrelShotgun"] = "close",
	["Base.DoubleBarrelShotgunSawnoff"] = "close",
	["aerx.T1Shotgun1"] = "close",
	["aerx.T1Shotgun2"] = "close",
	["aerx.T2Shotgun"] = "close",
	["aerx.T2SMG1"] = "close",
	["Base.T3SMG"] = "close",
	["Base.T3MG"] = "close",
	["Base.Mossberg500"] = "close",
	["Base.Mossberg500Tactical"] = "close",
	["Base.Remington870Wood"] = "close",
	["Base.Remington870Sawnoff"] = "close",
	["Base.SPAS12"] = "close",
	["Base.LAW12"] = "close",
	["Base.ShotgunShort"] = "close",
	["Base.DoubleBarrelShotgunShort"] = "close",
	["Base.OUShotgun"] = "close",
	["Base.OUShotgunShort"] = "close",
	["Base.OUShotgunSawnoff"] = "close",
	["Base.M1887"] = "close",
	["Base.M1887Short"] = "close",
	["Base.M1887Sawn"] = "close",
	["Base.MP5"] = "close",
	["Base.UZI"] = "close",
	["Base.M633"] = "close",
	["Base.Mac10"] = "close",
	["Base.M3Grease"] = "close",
	["Base.VarmintRifle_Sawn"] = "close",
	["Base.HuntingRifle_Sawn"] = "close",
	["Base.Rugerm7722_Sawn"] = "close",
	["Base.M1903Springfield_Sawn"] = "close",
	["Base.Winchester77_Sawn"] = "close",
	["Base.Mini14Sawn"] = "close",
	["Base.SKSSawn"] = "close",
	["Base.SKSMagSawn"] = "close",
	["Base.Winchester94Sawn"] = "close",
	["Base.Winchester73Sawn"] = "close",
	["Base.Rossi92Sawn"] = "close",
	["Base.Pistol"] = "medium",
	["Base.Pistol2"] = "medium",
	["Base.Pistol3"] = "medium",
	["Base.Revolver"] = "medium",
	["Base.Revolver_Short"] = "medium",
	["Base.Revolver_Long"] = "medium",
	["aerx.T1Pistol1"] = "medium",
	["aerx.T1Pistol2"] = "medium",
	["aerx.T1Revolver"] = "medium",
	["aerx.T2Pistol1"] = "medium",
	["aerx.T2MP1"] = "medium",
	["Base.T3Pistol"] = "medium",
	["Base.T3Revolver"] = "medium",
	["Base.Pistol_M45A1"] = "medium",
	["Base.Glock17"] = "medium",
	["Base.ColtAce"] = "medium",
	["Base.Pistol_Compact"] = "medium",
	["Base.Revolver_M29"] = "medium",
	["Base.ColtPython"] = "medium",
	["Base.ColtPythonStubby"] = "medium",
	["Base.ColtPythonHunter"] = "medium",
	["Base.ColtAnaconda"] = "medium",
	["Base.ColtPeacemaker"] = "medium",
	["Base.ColtSingleAction22"] = "medium",
	["Base.AssaultRifle"] = "long",
	["Base.AssaultRifle2"] = "long",
	["Base.VarmintRifle"] = "long",
	["Base.HuntingRifle"] = "long",
	["aerx.T2Rifle1"] = "long",
	["aerx.T2DMR1"] = "long",
	["Base.T3Rifle"] = "long",
	["Base.T3Bolt"] = "long",
	["Base.FN_FAL"] = "long",
	["Base.M16A2"] = "long",
	["Base.M733"] = "long",
	["Base.AR15"] = "long",
	["Base.Mini14"] = "long",
	["Base.AC556"] = "long",
	["Base.M60"] = "long",
	["Base.BrowningAR"] = "long",
	["Base.AK47"] = "long",
	["Base.AK47S"] = "long",
	["Base.Winchester94"] = "long",
	["Base.Winchester73"] = "long",
	["Base.Rossi92"] = "long",
	["Base.Rugerm7722"] = "long",
	["Base.M24Rifle"] = "long",
	["Base.M1903Springfield"] = "long",
	["Base.SKS"] = "long",
	["Base.SKSMag"] = "long",
	["Base.M14A1"] = "long",
	["Base.M1Garand"] = "long",
	["Base.Winchester77"] = "long",
	["Base.AssaultRifleShort"] = "long",
	["Base.M16A2Short"] = "long",
	["Base.AR15Short"] = "long",
	["Base.FN_FALShort"] = "long",
	["Base.Mini14Short"] = "long",
	["Base.AC556Short"] = "long",
	["Base.BrowningARShort"] = "long",
	["Base.VarmintRifleShort"] = "long",
	["Base.HuntingRifleShort"] = "long",
	["Base.SKSShort"] = "long",
	["Base.SKSMagShort"] = "long",
	["Base.AssaultRifle2Short"] = "long",
	["Base.M14A1Short"] = "long",
	["Base.M1903SpringfieldShort"] = "long",
	["Base.AssaultRifleBayonet"] = "long",
	["Base.M16A2Bayonet"] = "long",
	["Base.AR15Bayonet"] = "long",
	["Base.SKSBayonet"] = "long",
	["Base.SKSMagBayonet"] = "long",
	["Base.AK47Bayonet"] = "long",
	["Base.M1GarandBayonet"] = "long",
	["Base.M1903SpringfieldBayonet"] = "long",
}

DiceTraits.gunRangeByName = {
	{ "machine pistol", "medium" },
	{ "shotgun", "close" },
	{ "submachine", "close" },
	{ "smg", "close" },
	{ "machine gun", "close" },
	{ "sniper", "long" },
	{ "marksman", "long" },
	{ "dmr", "long" },
	{ "carbine", "long" },
	{ "rifle", "long" },
	{ "revolver", "medium" },
	{ "handgun", "medium" },
	{ "pistol", "medium" },
}

DiceTraits.gunRangeByClass = { pistol = "medium", smg = "close", shotgun = "close", rifle = "long", crossbow = "long" }

DiceTraits.weaponClassByType = {
	["aerx.T1Shotgun1"] = "shotgun",
	["aerx.T1Shotgun2"] = "shotgun",
	["aerx.T2Shotgun"] = "shotgun",
	["Base.T3Bolt"] = "rifle",
	["aerx.T2SMG1"] = "smg",
	["Base.T3SMG"] = "smg",
	["Base.MP5"] = "smg",
	["Base.UZI"] = "smg",
	["Base.M633"] = "smg",
	["Base.Mac10"] = "smg",
	["Base.M3Grease"] = "smg",
}

DiceTraits.weaponClassByName = {
	{ "crossbow", "crossbow" },
	{ "shotgun", "shotgun" },
	{ "rifle", "rifle" },
}

DiceTraits.THROW_CATEGORIES = { SmallBlunt = true, SmallBlade = true }

DiceTraits.THROWABLE_TYPES = {}

local MELEE_CLASSES = { unarmed = true, melee1h = true, melee2h = true }
local GUN_CLASSES = { pistol = true, smg = true, shotgun = true, rifle = true, crossbow = true }
local RANGED_CLASSES = { pistol = true, smg = true, shotgun = true, rifle = true, crossbow = true, thrown = true, molotov = true, bomb = true }

DiceTraits.ROLL_LABELS = {
	attack = "Attack",
	defclose = "Defend close",
	defranged = "Defend ranged",
	escape = "Escape",
	grapple = "Grapple",
	sneak = "Hide",
	notice = "Notice",
	physend = "Physical endurance",
	mentend = "Mental endurance",
	firstaid = "First aid",
	skill = "Skill roll",
	initiative = "Initiative",
}

DiceTraits.order = {}
for id in pairs(DiceTraits.defs) do
	DiceTraits.order[#DiceTraits.order + 1] = id
end
table.sort(DiceTraits.order)

function DiceTraits.def(id)
	return DiceTraits.defs[id]
end

function DiceTraits.isMelee(class)
	return MELEE_CLASSES[class] == true
end

function DiceTraits.isGun(class)
	return GUN_CLASSES[class] == true
end

function DiceTraits.isRanged(class)
	return RANGED_CLASSES[class] == true
end

function DiceTraits.categoriesOf(item)
	local cats = {}
	if item == nil or item.getCategories == nil then
		return cats
	end
	local list = item:getCategories()
	if list == nil or list.size == nil then
		return cats
	end
	for i = 0, list:size() - 1 do
		local value = list:get(i)
		if value ~= nil then
			cats[tostring(value)] = true
		end
	end
	return cats
end

local function displayNameOf(item)
	if item == nil or item.getDisplayName == nil then
		return nil
	end
	local name = item:getDisplayName()
	if type(name) ~= "string" then
		return nil
	end
	return string.lower(name)
end

local function matchByName(list, name)
	if name == nil then
		return nil
	end
	for i = 1, #list do
		if string.find(name, list[i][1], 1, true) then
			return list[i][2]
		end
	end
	return nil
end

function DiceTraits.weaponClassOf(item, class)
	if item == nil then
		return class
	end
	if class == "molotov" or class == "bomb" or class == "unarmed" then
		return class
	end
	if item.getFullType ~= nil then
		local byType = DiceTraits.weaponClassByType[item:getFullType()]
		if byType then
			return byType
		end
	end
	if item.isRanged == nil or not item:isRanged() then
		return class
	end
	return matchByName(DiceTraits.weaponClassByName, displayNameOf(item)) or class
end

function DiceTraits.gunRangeOf(item, class)
	if not GUN_CLASSES[class] then
		return nil
	end
	if item ~= nil and item.getFullType ~= nil then
		local byType = DiceTraits.gunRangeByType[item:getFullType()]
		if byType then
			return byType
		end
	end
	local byName = matchByName(DiceTraits.gunRangeByName, displayNameOf(item))
	if byName then
		return byName
	end
	return DiceTraits.gunRangeByClass[class]
end

function DiceTraits.fromPlayer(player)
	local out = {}
	if player == nil then
		return out
	end
	if player.getTraits ~= nil then
		local list = player:getTraits()
		if list ~= nil and list.size ~= nil then
			for i = 0, list:size() - 1 do
				local id = list:get(i)
				if id ~= nil and DiceTraits.defs[tostring(id)] ~= nil then
					out[#out + 1] = tostring(id)
				end
			end
		end
	end
	if #out > 0 then
		table.sort(out)
		return out
	end
	if player.HasTrait ~= nil then
		for i = 1, #DiceTraits.order do
			local id = DiceTraits.order[i]
			if player:HasTrait(id) then
				out[#out + 1] = id
			end
		end
	end
	return out
end

function DiceTraits.sanitize(list)
	local out = {}
	if type(list) ~= "table" then
		return out
	end
	local seen = {}
	for i = 1, #list do
		local id = list[i]
		if type(id) == "string" and DiceTraits.defs[id] ~= nil and not seen[id] then
			seen[id] = true
			out[#out + 1] = id
		end
	end
	table.sort(out)
	return out
end

function DiceTraits.has(traits, id)
	if type(traits) ~= "table" then
		return false
	end
	for i = 1, #traits do
		if traits[i] == id then
			return true
		end
	end
	return false
end

function DiceTraits.total(traits, key)
	local sum = 0
	if type(traits) ~= "table" then
		return sum
	end
	for i = 1, #traits do
		local def = DiceTraits.defs[traits[i]]
		if def and type(def[key]) == "number" then
			sum = sum + def[key]
		end
	end
	return sum
end

function DiceTraits.flag(traits, key)
	if type(traits) ~= "table" then
		return false
	end
	for i = 1, #traits do
		local def = DiceTraits.defs[traits[i]]
		if def and def[key] == true then
			return true
		end
	end
	return false
end

local function attackValue(def, ctx)
	local class = ctx and ctx.class or "unarmed"
	local value = def.attack or 0
	if MELEE_CLASSES[class] then
		value = value + (def.attackMelee or 0)
		if ctx and ctx.lunge then
			value = value + (def.lunge or 0)
		end
	end
	if RANGED_CLASSES[class] then
		value = value + (def.attackRanged or 0)
	end
	if GUN_CLASSES[class] then
		value = value + (def.attackGun or 0)
		local range = ctx and ctx.gunRange or nil
		if range ~= nil and def.attackGunRange ~= nil then
			value = value + (def.attackGunRange[range] or 0)
		end
	end
	if ctx and ctx.thrown then
		value = value + (def.attackThrown or 0)
	else
		value = value + (def.attackNonThrown or 0)
	end
	if def.attackCat ~= nil and ctx ~= nil and ctx.cats ~= nil and not ctx.thrown then
		for cat, amount in pairs(def.attackCat) do
			if ctx.cats[cat] then
				value = value + amount
			end
		end
	end
	return value
end

local function valueFor(def, kind, ctx)
	if kind == "attack" then
		return attackValue(def, ctx)
	end
	local value = 0
	if type(def[kind]) == "number" then
		value = def[kind]
	end
	if kind == "initiative" and ctx and ctx.pistol then
		value = value + (def.initiativePistol or 0)
	end
	return value
end

function DiceTraits.bonus(traits, kind, ctx)
	local total = 0
	local parts = {}
	if type(traits) ~= "table" or kind == nil then
		return total, parts
	end
	for i = 1, #traits do
		local def = DiceTraits.defs[traits[i]]
		if def then
			local value = valueFor(def, kind, ctx)
			if value ~= 0 then
				total = total + value
				parts[#parts + 1] = { name = def.name, value = value }
			end
		end
	end
	return total, parts
end

function DiceTraits.signed(value)
	if value > 0 then
		return "+" .. value
	end
	return tostring(value)
end

function DiceTraits.suffix(total, parts)
	if total == 0 or #parts == 0 then
		return ""
	end
	if not DiceTraits.showTraitNames then
		return " [" .. DiceTraits.signed(total) .. " traits]"
	end
	if #parts == 1 then
		return " [" .. DiceTraits.signed(parts[1].value) .. " " .. parts[1].name .. "]"
	end
	local names = {}
	for i = 1, #parts do
		names[i] = parts[i].name .. " " .. DiceTraits.signed(parts[i].value)
	end
	return " [" .. DiceTraits.signed(total) .. " traits: " .. table.concat(names, ", ") .. "]"
end

function DiceTraits.modifierText(traits, kind, ctx)
	local total, parts = DiceTraits.bonus(traits, kind, ctx)
	if total == 0 and #parts == 0 then
		return nil
	end
	local names = {}
	for i = 1, #parts do
		names[i] = parts[i].name .. " " .. DiceTraits.signed(parts[i].value)
	end
	return DiceTraits.signed(total) .. " (" .. table.concat(names, ", ") .. ")"
end

function DiceTraits.critRange(traits)
	local hitFrom = 20
	local failTo = 1
	local noCrit = false
	local noCritFail = false
	if type(traits) == "table" then
		for i = 1, #traits do
			local def = DiceTraits.defs[traits[i]]
			if def then
				hitFrom = hitFrom - (def.critHitLower or 0)
				failTo = failTo + (def.critFailRaise or 0)
				if def.noCrit then
					noCrit = true
				end
				if def.noCritFail then
					noCritFail = true
				end
			end
		end
	end
	if noCrit then
		hitFrom = 21
	end
	if noCritFail then
		failTo = 0
	end
	if hitFrom < 2 then
		hitFrom = 2
	end
	if failTo > 19 then
		failTo = 19
	end
	return hitFrom, failTo
end

function DiceTraits.dwd(traits)
	local value = DiceTraits.total(traits, "dwd")
	if value > 0 then
		return 1
	end
	if value < 0 then
		return -1
	end
	return 0
end

function DiceTraits.statusTurns(traits, base)
	local turns = base + DiceTraits.total(traits, "statusTurns")
	if turns < 1 then
		turns = 1
	end
	return turns
end

function DiceTraits.moveRange(traits)
	local tiles = DiceTraits.tuning.baseMove + DiceTraits.total(traits, "move")
	if tiles < 1 then
		tiles = 1
	end
	return tiles
end

function DiceTraits.throwRange(traits)
	local tiles = DiceTraits.tuning.baseThrowRange + DiceTraits.total(traits, "throwRange")
	if tiles < 1 then
		tiles = 1
	end
	return tiles
end

function DiceTraits.throwDamage(traits, base)
	local damage = base + DiceTraits.total(traits, "throwDamage")
	if damage < 1 then
		damage = 1
	end
	return damage
end

function DiceTraits.canThrowMelee(traits, cats)
	if not DiceTraits.flag(traits, "canThrowMelee") then
		return false
	end
	if type(cats) ~= "table" then
		return false
	end
	for cat in pairs(DiceTraits.THROW_CATEGORIES) do
		if cats[cat] then
			return true
		end
	end
	return false
end

function DiceTraits.canThrowItem(traits, cats, fullType, class)
	if class == "molotov" or class == "bomb" then
		return true
	end
	if class == "unarmed" or class == nil then
		return false
	end
	if fullType ~= nil and DiceTraits.THROWABLE_TYPES[fullType] then
		return true
	end
	return DiceTraits.canThrowMelee(traits, cats)
end

function DiceTraits.lunged(fromPos, x, y, z)
	if fromPos == nil or x == nil or fromPos.z ~= z then
		return false
	end
	local dx = x - fromPos.x
	local dy = y - fromPos.y
	local absX = math.abs(dx)
	local absY = math.abs(dy)
	local distance = math.max(absX, absY)
	if distance < DiceTraits.tuning.lungeTiles then
		return false
	end
	return dx == 0 or dy == 0 or absX == absY
end

function DiceTraits.listFor(traits)
	local lines = {}
	if type(traits) ~= "table" then
		return lines
	end
	for i = 1, #traits do
		local def = DiceTraits.defs[traits[i]]
		if def then
			lines[#lines + 1] = def.name .. ": " .. def.text
		end
	end
	return lines
end

return DiceTraits
