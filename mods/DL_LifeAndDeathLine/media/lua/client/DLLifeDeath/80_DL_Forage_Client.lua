DL = DL or {}

local DL_SKILL_TAG = "dlReqSkill"

local function dlSkillGate(character, itemDef)
    local req = itemDef and itemDef[DL_SKILL_TAG]
    if req == nil or req.perk == nil then return true end
    local perk = Perks.FromString(req.perk)
    if perk == nil then return true end
    return character:getPerkLevel(perk) >= (req.level or 0)
end

local function ensureGate()
    local funcs = forageSystem.isForageableFuncs
    for _, f in ipairs(funcs) do if f == dlSkillGate then return end end
    funcs[#funcs + 1] = dlSkillGate
end

local function registerLists(fs)
    ensureGate()
    local lists = (DL.Config and DL.Config.forageLists) or {}
    local count = 0
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
                    fs.addItemDef(def)
                    count = count + 1
                end
            end
        end
    end
    DL.log("forage: registered " .. count .. " custom item def(s) from lists")
end

if Events.onAddForageDefs == nil then LuaEventManager.AddEvent("onAddForageDefs") end
Events.onAddForageDefs.Add(registerLists)

DL.log("forage client loader ready")
