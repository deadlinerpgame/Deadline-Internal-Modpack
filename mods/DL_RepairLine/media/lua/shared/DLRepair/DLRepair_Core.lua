DLRepair = DLRepair or {}

DLRepair.CategoryClass = {
    Blunt      = "blunt",
    SmallBlunt = "blunt",
    Blade      = "blade",
    SmallBlade = "blade",
    LongBlade  = "blade",
    Axe        = "blade",
    Spear      = "blade",
}

function DLRepair.inferClass(item)
    if item.isRanged ~= nil and item:isRanged() then return "firearm" end
    local cats = item:getCategories()
    if cats then
        for i = 0, cats:size() - 1 do
            local cls = DLRepair.CategoryClass[cats:get(i)]
            if cls then return cls end
        end
    end
    return "generic"
end

function DLRepair.getProfile(item)
    if not item then return nil end
    local p = DLRepair.Profiles[item:getFullType()]
    if p then return p end
    return DLRepair.Defaults[DLRepair.inferClass(item)] or DLRepair.Defaults.generic
end

function DLRepair.getOptions(item)
    local p = DLRepair.getProfile(item)
    return (p and p.options) or {}
end

function DLRepair.isRepairableWeapon(item)
    if not item then return false end
    if not instanceof(item, "HandWeapon") then return false end
    if item:getConditionMax() <= 0 then return false end
    return true
end

function DLRepair.isListable(item)
    if not DLRepair.isRepairableWeapon(item) then return false end
    local p = DLRepair.getProfile(item)
    return p ~= nil and p.options ~= nil and #p.options > 0
end

function DLRepair.getRepairableWeapons(inventory)
    local out = {}
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if DLRepair.isListable(it) then
            table.insert(out, it)
        end
    end
    return out
end

function DLRepair.resolveDifficulty(diff)
    if diff == nil then diff = DLRepair.Config.defaultDifficulty end
    if type(diff) == "string" then
        return DLRepair.Difficulties[diff] or DLRepair.Difficulties.normal
    end
    return diff
end

local function interpChance(map, level)
    local lowK, lowV, highK, highV
    for k, v in pairs(map) do
        if type(k) == "number" then
            if k <= level and (not lowK or k > lowK) then lowK, lowV = k, v end
            if k >= level and (not highK or k < highK) then highK, highV = k, v end
        end
    end
    if lowK and highK then
        if lowK == highK then return lowV end
        local t = (level - lowK) / (highK - lowK)
        return lowV + (highV - lowV) * t
    end
    return lowV or highV or 0
end

function DLRepair.successChance(diff, level)
    local d = DLRepair.resolveDifficulty(diff)
    if type(d) ~= "table" then return 0 end
    local c
    if d.base == nil and d.perLevel == nil then
        c = interpChance(d, level)
    else
        if d.minLevel and level < d.minLevel then return 0 end
        c = (d.base or 0) + (d.perLevel or 0) * level
    end
    if c < 0 then c = 0 elseif c > 1 then c = 1 end
    return c
end

function DLRepair.optionDifficulty(weapon, option)
    if option and option.difficulty ~= nil then return option.difficulty end
    local p = DLRepair.getProfile(weapon)
    if p and p.difficulty ~= nil then return p.difficulty end
    return DLRepair.Config.defaultDifficulty
end

function DLRepair.optionChance(weapon, option, level)
    return DLRepair.successChance(DLRepair.optionDifficulty(weapon, option), level)
end

function DLRepair.isDrainableType(fullType)
    return ScriptManager.instance:isDrainableItemType(fullType)
end

function DLRepair.availableForReq(inventory, req)
    local ft = req.item
    local drain = DLRepair.isDrainableType(ft)
    local total = 0
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:getFullType() == ft then
            if drain then total = total + it:getDrainableUsesInt() else total = total + 1 end
        end
    end
    return total
end

function DLRepair.hasRequirement(inventory, req)
    return DLRepair.availableForReq(inventory, req) >= (req.count or 1)
end

function DLRepair.toolType(toolEntry)
    if type(toolEntry) == "string" then return toolEntry end
    return toolEntry and toolEntry.item or nil
end

function DLRepair.hasTool(inventory, toolEntry)
    local ft = DLRepair.toolType(toolEntry)
    if not ft then return true end
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        if items:get(i):getFullType() == ft then return true end
    end
    return false
end

function DLRepair.optionKey(option)
    if option.id then return option.id end
    local parts = {}
    for _, req in ipairs(option.items or {}) do
        parts[#parts + 1] = req.item .. "x" .. (req.count or 1)
    end
    local key = table.concat(parts, "+")
    if option.amount ~= nil then
        key = key .. "|a" .. tostring(option.amount)
    elseif option.restore ~= nil then
        key = key .. "|r" .. tostring(option.restore)
    end
    if option.label then key = key .. "|" .. option.label end
    return key
end

function DLRepair.optionUses(weapon, option)
    local m = weapon:getModData().DL_optionUses
    return (m and m[DLRepair.optionKey(option)]) or 0
end

function DLRepair.incrementOptionUse(weapon, option)
    local md = weapon:getModData()
    md.DL_optionUses = md.DL_optionUses or {}
    local k = DLRepair.optionKey(option)
    md.DL_optionUses[k] = (md.DL_optionUses[k] or 0) + 1
end

function DLRepair.optionStatus(inventory, weapon, option, perkLevel)
    local missing = {}
    for _, req in ipairs(option.items or {}) do
        if not DLRepair.hasRequirement(inventory, req) then
            table.insert(missing, req)
        end
    end
    local missingTools = {}
    for _, t in ipairs(option.tools or {}) do
        if not DLRepair.hasTool(inventory, t) then
            table.insert(missingTools, t)
        end
    end
    local meetsSkill = perkLevel >= (option.maintenanceMin or 0)
    local used = DLRepair.optionUses(weapon, option)
    local maxUses = option.maxUses
    return {
        haveAll      = #missing == 0,
        missing      = missing,
        hasTools     = #missingTools == 0,
        missingTools = missingTools,
        meetsSkill   = meetsSkill,
        chance       = DLRepair.optionChance(weapon, option, perkLevel),
        used         = used,
        maxUses      = maxUses,
        usesLeft     = maxUses and math.max(0, maxUses - used) or nil,
        exhausted    = (maxUses ~= nil) and (used >= maxUses),
    }
end

function DLRepair.consumeRequirement(character, req)
    local inv = character:getInventory()
    local ft = req.item
    local need = req.count or 1

    local matches = {}
    local items = inv:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:getFullType() == ft then table.insert(matches, it) end
    end

    local remaining = need
    if DLRepair.isDrainableType(ft) then
        for _, it in ipairs(matches) do
            if remaining <= 0 then break end
            local uses = it:getDrainableUsesInt()
            if uses > 0 then
                local drain = math.min(uses, remaining)
                for _ = 1, drain do it:Use() end
                remaining = remaining - drain
            end
        end
    else
        for _, it in ipairs(matches) do
            if remaining <= 0 then break end
            character:removeFromHands(it)
            local cont = it:getContainer() or inv
            cont:Remove(it)
            remaining = remaining - 1
        end
    end
    inv:setDrawDirty(true)
end

function DLRepair.consumeOption(character, option)
    for _, req in ipairs(option.items or {}) do
        DLRepair.consumeRequirement(character, req)
    end
end

function DLRepair.skillScale(perkLevel)
    local c = DLRepair.Config
    local t = perkLevel / 10.0
    if t < 0 then t = 0 elseif t > 1 then t = 1 end
    return c.skillScaleMin + (c.skillScaleMax - c.skillScaleMin) * t
end

function DLRepair.computeRestoreAmount(weapon, option, perkLevel)
    local add
    if option.amount ~= nil then
        add = math.floor(option.amount)
    else
        local maxC = weapon:getConditionMax()
        local restore = (option.restore or DLRepair.Config.defaultRestore) * DLRepair.skillScale(perkLevel)
        add = math.floor(maxC * restore)
    end
    if add < 1 then add = 1 end
    return add
end

function DLRepair.computeNewCondition(weapon, option, perkLevel)
    local maxC = weapon:getConditionMax()
    local newC = weapon:getCondition() + DLRepair.computeRestoreAmount(weapon, option, perkLevel)
    if newC > maxC then newC = maxC end
    return newC
end

function DLRepair.computeTime(character, weapon)
    local c = DLRepair.Config
    local lvl = character:getPerkLevel(Perks.Maintenance)
    local t = c.baseActionTime - lvl * c.timePerLevelReduction
    if t < c.minActionTime then t = c.minActionTime end
    return t
end

function DLRepair.applyWear(weapon, option)
    local cfg = DLRepair.Config
    if not cfg.enableWear then return end
    local chance = option.wearChance or cfg.defaultWearChance or 0
    if chance <= 0 then return end
    if ZombRand(100) >= math.floor(chance * 100) then return end
    local amt = option.wearAmount or cfg.defaultWearAmount or 1
    local newMax = weapon:getConditionMax() - amt
    if newMax < cfg.minConditionMax then newMax = cfg.minConditionMax end
    weapon:setConditionMax(newMax)
    if weapon:getCondition() > newMax then weapon:setCondition(newMax) end
end

local function haloFeedback(character, text, good)
    if not (HaloTextHelper and HaloTextHelper.addText) then return end
    local color
    if good and HaloTextHelper.getColorGreen then
        color = HaloTextHelper.getColorGreen()
    elseif HaloTextHelper.getColorRed then
        color = HaloTextHelper.getColorRed()
    end
    HaloTextHelper.addText(character, text, color)
end

function DLRepair.canAttempt(inventory, weapon, option, perkLevel)
    if weapon:getCondition() >= weapon:getConditionMax() then return false end
    local st = DLRepair.optionStatus(inventory, weapon, option, perkLevel)
    return st.haveAll and st.hasTools and st.meetsSkill and not st.exhausted
end

function DLRepair.attemptRepair(character, weapon, option)
    local cfg = DLRepair.Config
    local perk = character:getPerkLevel(Perks.Maintenance)
    if not DLRepair.canAttempt(character:getInventory(), weapon, option, perk) then
        return "invalid"
    end

    local chance = DLRepair.optionChance(weapon, option, perk)
    local success = ZombRand(100) < math.floor(chance * 100 + 0.5)

    if success then
        DLRepair.applyWear(weapon, option)
        local before = weapon:getCondition()
        weapon:setCondition(DLRepair.computeNewCondition(weapon, option, perk))
        local gained = weapon:getCondition() - before

        local md = weapon:getModData()
        md.DL_repairs = (md.DL_repairs or 0) + 1
        DLRepair.incrementOptionUse(weapon, option)
        if weapon.setHaveBeenRepaired ~= nil then
            weapon:setHaveBeenRepaired(md.DL_repairs)
        end

        character:getXp():AddXP(Perks.Maintenance, option.xp or cfg.defaultXp)
        DLRepair.consumeOption(character, option)

        local cont = weapon:getContainer()
        if cont and cont.setDrawDirty then cont:setDrawDirty(true) end
        character:getInventory():setDrawDirty(true)
        haloFeedback(character, "Repaired +" .. gained, true)
        return "success"
    else
        if cfg.consumeOnFailure then
            DLRepair.consumeOption(character, option)
        end
        local md = weapon:getModData()
        md.DL_attempts = (md.DL_attempts or 0) + 1
        character:getXp():AddXP(Perks.Maintenance, (option.xp or cfg.defaultXp) * (cfg.failXpFraction or 0))
        character:getInventory():setDrawDirty(true)
        haloFeedback(character, "Repair failed", false)
        return "fail"
    end
end

function DLRepair.getReinforceSpec(weapon)
    local ft = weapon:getFullType()
    if DLRepair.ReinforceProfiles and DLRepair.ReinforceProfiles[ft] then
        return DLRepair.ReinforceProfiles[ft]
    end
    if DLRepair.ReinforceDefaults then
        local cls = DLRepair.inferClass(weapon)
        if DLRepair.ReinforceDefaults[cls] then return DLRepair.ReinforceDefaults[cls] end
    end
    return DLRepair.DefaultReinforce
end

function DLRepair.getReinforceRecipe(weapon, level)
    local spec = DLRepair.getReinforceSpec(weapon)
    if spec.levels then
        local idx = level
        if idx < 1 then idx = 1 end
        if idx > #spec.levels then idx = #spec.levels end
        return spec.levels[idx]
    end
    return spec
end

function DLRepair.getBaseConditionMax(weapon)
    local md = weapon:getModData()
    if md.DL_baseMax and md.DL_baseMax > 0 then return md.DL_baseMax end
    local base
    local script = weapon:getScriptItem()
    if script then
        if script.getConditionMax ~= nil then
            local v = script:getConditionMax()
            if type(v) == "number" and v > 0 then base = v end
        end
    end
    if not base or base <= 0 then base = weapon:getConditionMax() end
    md.DL_baseMax = base
    return base
end

function DLRepair.reinforceLevel(weapon)
    return weapon:getModData().DL_reinforced or 0
end

function DLRepair.maxReinforce()
    return DLRepair.Config.maxReinforce or 5
end

function DLRepair.reinforcePerStep(weapon)
    local base = DLRepair.getBaseConditionMax(weapon)
    local v = math.floor(base * (DLRepair.Config.reinforcePercent or 0.10))
    if v < 1 then v = 1 end
    return v
end

function DLRepair.reinforceStatus(inventory, weapon, perkLevel)
    local level = DLRepair.reinforceLevel(weapon)
    local nextLevel = level + 1
    local recipe = DLRepair.getReinforceRecipe(weapon, nextLevel)
    local st = DLRepair.optionStatus(inventory, weapon, recipe, perkLevel)
    st.level     = level
    st.maxLevel  = DLRepair.maxReinforce()
    st.nextLevel = nextLevel
    st.atMax     = level >= st.maxLevel
    st.perStep   = DLRepair.reinforcePerStep(weapon)
    st.baseMax   = DLRepair.getBaseConditionMax(weapon)
    return st, recipe
end

function DLRepair.canReinforce(inventory, weapon, perkLevel)
    local st = DLRepair.reinforceStatus(inventory, weapon, perkLevel)
    return (not st.atMax) and st.haveAll and st.hasTools and st.meetsSkill
end

function DLRepair.attemptReinforce(character, weapon)
    local cfg = DLRepair.Config
    local perk = character:getPerkLevel(Perks.Maintenance)
    if not DLRepair.canReinforce(character:getInventory(), weapon, perk) then
        return "invalid"
    end

    DLRepair.reapplyReinforcement(weapon)

    local nextLevel = DLRepair.reinforceLevel(weapon) + 1
    local r = DLRepair.getReinforceRecipe(weapon, nextLevel)
    local chance = DLRepair.optionChance(weapon, r, perk)
    local success = ZombRand(100) < math.floor(chance * 100 + 0.5)

    if success then
        local per = DLRepair.reinforcePerStep(weapon)
        weapon:setConditionMax(weapon:getConditionMax() + per)
        weapon:setCondition(math.min(weapon:getConditionMax(), weapon:getCondition() + per))
        local md = weapon:getModData()
        md.DL_reinforced = (md.DL_reinforced or 0) + 1
        md.DL_maxBonus = (md.DL_maxBonus or 0) + per
        character:getXp():AddXP(Perks.Maintenance, r.xp or cfg.reinforceXp or cfg.defaultXp)
        DLRepair.consumeOption(character, r)
        local cont = weapon:getContainer()
        if cont and cont.setDrawDirty then cont:setDrawDirty(true) end
        character:getInventory():setDrawDirty(true)
        haloFeedback(character, "Reinforced +" .. per .. " max", true)
        return "success"
    else
        if cfg.consumeOnFailure then DLRepair.consumeOption(character, r) end
        character:getXp():AddXP(Perks.Maintenance, (r.xp or cfg.reinforceXp or cfg.defaultXp) * (cfg.failXpFraction or 0))
        character:getInventory():setDrawDirty(true)
        haloFeedback(character, "Reinforcement failed", false)
        return "fail"
    end
end

function DLRepair.reapplyReinforcement(weapon)
    if not weapon then return end
    local md = weapon:getModData()
    local reinforced = md.DL_reinforced or 0
    if reinforced <= 0 then return end
    local bonus = md.DL_maxBonus
    if not bonus then
        bonus = reinforced * DLRepair.reinforcePerStep(weapon)
        md.DL_maxBonus = bonus
    end
    if bonus <= 0 then return end
    local target = DLRepair.getBaseConditionMax(weapon) + bonus
    if weapon:getConditionMax() < target then
        weapon:setConditionMax(target)
    end
end

function DLRepair.reapplyForCharacter(character)
    if not character then return end
    local inv = character:getInventory()
    if not inv then return end
    local items = inv:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if instanceof(it, "HandWeapon") then
            DLRepair.reapplyReinforcement(it)
        end
    end
end
