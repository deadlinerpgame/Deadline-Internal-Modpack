DL = DL or {}

if forageSystem == nil then
    return
end

local DL_SKILL_TAG = "dlReqSkill"
local registered = false

local function log(message)
    if DL.log ~= nil then
        DL.log(message)
    else
        print("[DL] " .. tostring(message))
    end
end

local function dlSkillGate(character, itemDef)
    local req = itemDef and itemDef[DL_SKILL_TAG]
    if req == nil or req.perk == nil then return true end
    local perk = Perks.FromString(req.perk)
    if perk == nil then return true end
    return character:getPerkLevel(perk) >= (req.level or 0)
end

local function ensureGate()
    local funcs = forageSystem.isForageableFuncs
    if funcs == nil then return end
    for _, f in ipairs(funcs) do
        if f == dlSkillGate then return end
    end
    funcs[#funcs + 1] = dlSkillGate
end

local function rollPool(spec)
    local picked = {}
    if spec == nil or spec.pool == nil then return picked end
    local total = 0
    for _, entry in ipairs(spec.pool) do
        total = total + (entry[2] or 1)
    end
    if total <= 0 then return picked end
    local rolls = spec.rolls or { 1, 1 }
    local low = rolls[1] or 1
    local high = rolls[2] or low
    local count = low
    if high > low then
        count = low + ZombRand(high - low + 1)
    end
    for _ = 1, count do
        local roll = ZombRand(total)
        for _, entry in ipairs(spec.pool) do
            roll = roll - (entry[2] or 1)
            if roll < 0 then
                picked[#picked + 1] = entry[1]
                break
            end
        end
    end
    return picked
end

local function makeSpawner(extras, contents)
    return function(character, inventory, itemDef, items)
        if contents ~= nil then
            for i = 0, items:size() - 1 do
                local item = items:get(i)
                if instanceof(item, "InventoryContainer") then
                    for _, fullType in ipairs(rollPool(contents)) do
                        item:getInventory():AddItem(fullType)
                    end
                end
            end
        end
        if extras ~= nil then
            for _, fullType in ipairs(rollPool(extras)) do
                local extra = InventoryItemFactory.CreateItem(fullType)
                if extra ~= nil then
                    items:add(extra)
                end
            end
        end
        return items
    end
end

local function buildDefs()
    local out = {}
    local lists = (DL.Config and DL.Config.forageLists) or {}
    for _, list in ipairs(lists) do
        if list.enabled ~= false and list.items then
            local cond = list.condition or {}
            for _, it in ipairs(list.items) do
                if it.type then
                    local def = {
                        type       = it.type,
                        minCount   = it.min or 1,
                        maxCount   = it.max or it.min or 1,
                        xp         = it.xp or list.xp or 1,
                        categories = it.categories or list.categories or { "Junk" },
                        zones      = it.zones or list.zones or { Forest = 1, DeepForest = 1 },
                    }
                    if it.months or list.months then def.months = it.months or list.months end
                    if cond.trait then
                        def.traits = { cond.trait }
                    end
                    if cond.skill then
                        def[DL_SKILL_TAG] = { perk = cond.skill, level = cond.level or 0 }
                    end
                    if it.extras ~= nil or it.contents ~= nil then
                        def.spawnFuncs = { makeSpawner(it.extras, it.contents) }
                    end
                    out[#out + 1] = { list = list.name or "unnamed list", def = def }
                end
            end
        end
    end
    return out
end

local function register(fs)
    if registered then return end
    fs = fs or forageSystem
    if fs == nil or fs.addItemDef == nil or fs.itemDefs == nil then return end
    ensureGate()
    local added, skipped = 0, 0
    for _, entry in ipairs(buildDefs()) do
        local def = entry.def
        if fs.itemDefs[def.type] ~= nil then
            skipped = skipped + 1
            log("forage: '" .. entry.list .. "' skipped " .. def.type .. " because it already has a forage entry")
        else
            local _, isAdded = fs.addItemDef(def)
            if isAdded then
                added = added + 1
            else
                skipped = skipped + 1
                log("forage: '" .. entry.list .. "' could not add " .. def.type)
            end
        end
    end
    registered = true
    log("forage: " .. added .. " custom item(s) added, " .. skipped .. " skipped")
end

local function addTraitBonuses()
    local bonuses = DL.Config and DL.Config.forageTraitBonuses
    if bonuses == nil or forageSkills == nil then return end
    for traitId, bonus in pairs(bonuses) do
        if forageSkills[traitId] == nil then
            forageSkills[traitId] = {
                name            = traitId,
                type            = "trait",
                visionBonus     = bonus.visionBonus or 0,
                weatherEffect   = bonus.weatherEffect or 0,
                darknessEffect  = bonus.darknessEffect or 0,
                specialisations = bonus.specialisations or {},
            }
        end
    end
end

addTraitBonuses()

if Events.onAddForageDefs == nil then LuaEventManager.AddEvent("onAddForageDefs") end
Events.onAddForageDefs.Add(function(fs) register(fs) end)

if forageSystem.generateLootTable then
    local _origGen = forageSystem.generateLootTable
    forageSystem.generateLootTable = function(...)
        register(forageSystem)
        return _origGen(...)
    end
end
