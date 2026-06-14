DL = DL or {}

if forageSystem == nil then
    DL.log("forage loader: forageSystem absent (server JVM), skipping")
    return
end

local DL_SKILL_TAG = "dlReqSkill"
local _done = false

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
    for _, f in ipairs(funcs) do if f == dlSkillGate then return end end
    funcs[#funcs + 1] = dlSkillGate
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
                    elseif cond.skill then
                        def[DL_SKILL_TAG] = { perk = cond.skill, level = cond.level or 0 }
                    end
                    out[#out + 1] = def
                end
            end
        end
    end
    return out
end

local function register(fs)
    if _done then return end
    fs = fs or forageSystem
    if fs == nil or fs.addItemDef == nil then return end
    ensureGate()
    local defs = buildDefs()
    local added, rejected = 0, 0
    for _, def in ipairs(defs) do
        local exists = false
        pcall(function() exists = (fs.isItemExist and fs.isItemExist(nil, def)) or false end)
        if exists then
            pcall(function() fs.addItemDef(def) end)
            added = added + 1
            local gate = def[DL_SKILL_TAG]
            local note = ""
            if gate then note = " [needs " .. tostring(gate.perk) .. " " .. tostring(gate.level) .. "]" end
            if def.traits and def.traits[1] then note = note .. " [needs trait " .. tostring(def.traits[1]) .. "]" end
            DL.log("forage: added '" .. tostring(def.type) .. "'" .. note)
        else
            rejected = rejected + 1
            DL.warn("forage: SKIPPED '" .. tostring(def.type) .. "' -- that item type does not exist")
        end
    end
    DL.log("forage: registered " .. added .. " custom item(s); " .. rejected .. " rejected (bad type)")
    _done = true
end

if Events.onAddForageDefs == nil then LuaEventManager.AddEvent("onAddForageDefs") end
Events.onAddForageDefs.Add(function(fs) register(fs) end)

if forageSystem.generateLootTable then
    local _origGen = forageSystem.generateLootTable
    forageSystem.generateLootTable = function(...)
        register(forageSystem)
        return _origGen(...)
    end
end

DL.log("forage client loader ready")
