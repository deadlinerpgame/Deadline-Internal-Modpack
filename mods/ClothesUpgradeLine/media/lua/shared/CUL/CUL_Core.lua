ClothesUpgrade = ClothesUpgrade or {}

ClothesUpgrade.Stats = {
    insulation = {
        kind = "apparel", label = "Insulation",
        getters = { "getInsulation" }, setters = { "setInsulation" },
        integer = false, min = 0, max = 1, decimals = 2,
    },
    windResistance = {
        kind = "apparel", label = "Wind Resistance",
        getters = { "getWindresistance", "getWindResistance" },
        setters = { "setWindresistance", "setWindResistance" },
        integer = false, min = 0, max = 1, decimals = 2,
    },
    waterResistance = {
        kind = "apparel", label = "Water Resistance",
        getters = { "getWaterResistance", "getWaterresistance" },
        setters = { "setWaterResistance", "setWaterresistance" },
        integer = false, min = 0, max = 1, decimals = 2,
    },
    scratchDefense = {
        kind = "apparel", label = "Scratch Defense",
        getters = { "getScratchDefense" }, setters = { "setScratchDefense" },
        integer = false, min = 0, max = 100, decimals = 0,
    },
    biteDefense = {
        kind = "apparel", label = "Bite Defense",
        getters = { "getBiteDefense" }, setters = { "setBiteDefense" },
        integer = false, min = 0, max = 100, decimals = 0,
    },
    bulletDefense = {
        kind = "apparel", label = "Bullet Defense",
        getters = { "getBulletDefense" }, setters = { "setBulletDefense" },
        integer = false, min = 0, max = 100, decimals = 0,
    },
    conditionMax = {
        kind = "apparel", label = "Durability",
        getters = { "getConditionMax" }, setters = { "setConditionMax" },
        integer = true, min = 1, scriptGetter = true, decimals = 0,
    },
    capacity = {
        kind = "pack", label = "Capacity",
        getters = { "getCapacity" }, setters = { "setCapacity" },
        integer = true, min = 1, scriptGetter = true, decimals = 0,
    },
    weightReduction = {
        kind = "pack", label = "Weight Reduction",
        getters = { "getWeightReduction" }, setters = { "setWeightReduction" },
        integer = true, min = 0, max = 95, decimals = 0,
    },
}

function ClothesUpgrade.statDef(statId)
    return ClothesUpgrade.Stats[statId]
end

function ClothesUpgrade.formatStat(statId, value)
    local d = ClothesUpgrade.Stats[statId]
    local dec = d and d.decimals or 0
    if dec <= 0 then return tostring(math.floor(value + 0.5)) end
    return string.format("%." .. dec .. "f", value)
end

function ClothesUpgrade.perk()
    local name = ClothesUpgrade.Config.perk or "Tailoring"
    return Perks[name] or Perks.Tailoring
end

ClothesUpgrade.Caps = ClothesUpgrade.Caps or {}

local function tryMethods(item, names, cacheKey, ...)
    if cacheKey and ClothesUpgrade.Caps[cacheKey] == false then return false end
    if cacheKey and type(ClothesUpgrade.Caps[cacheKey]) == "string" then
        local fn = item[ClothesUpgrade.Caps[cacheKey]]
        if fn then return true, fn(item, ...) end
        return false
    end
    for _, m in ipairs(names) do
        local fn = item[m]
        if fn then
            if cacheKey then ClothesUpgrade.Caps[cacheKey] = m end
            return true, fn(item, ...)
        end
    end
    if cacheKey then ClothesUpgrade.Caps[cacheKey] = false end
    return false
end

function ClothesUpgrade.statSupported(item, statId)
    local d = ClothesUpgrade.Stats[statId]
    if not d then return false end
    local ok = tryMethods(item, d.getters, "get|" .. statId)
    return ok == true
end

function ClothesUpgrade.statGetLive(item, statId)
    local d = ClothesUpgrade.Stats[statId]
    if not d then return nil end
    local ok, val = tryMethods(item, d.getters, "get|" .. statId)
    if ok and type(val) == "number" then return val end
    return nil
end

function ClothesUpgrade.statSetLive(item, statId, value)
    local d = ClothesUpgrade.Stats[statId]
    if not d then return false end
    if d.min ~= nil and value < d.min then value = d.min end
    if d.max ~= nil and value > d.max then value = d.max end
    if d.integer then value = math.floor(value + 0.5) end
    local ok = tryMethods(item, d.setters, "set|" .. statId, value)
    if ok and statId == "capacity" then
        local inner = item.getInventory and item:getInventory()
        if inner and inner.setCapacity then inner:setCapacity(value) end
    end
    return ok == true
end

function ClothesUpgrade.ensureMD(item)
    local md = item:getModData()
    md.CUL = md.CUL or {}
    local cul = md.CUL
    cul.base  = cul.base  or {}
    cul.bonus = cul.bonus or {}
    cul.level = cul.level or {}
    cul.flaws = cul.flaws or {}
    return cul
end

local function scriptStatValue(item, statId)
    local d = ClothesUpgrade.Stats[statId]
    if not (d and d.scriptGetter) then return nil end
    local s = item.getScriptItem and item:getScriptItem()
    if not s then return nil end
    for _, g in ipairs(d.getters) do
        if s[g] then
            local v = s[g](s)
            if type(v) == "number" then return v end
        end
    end
    return nil
end

function ClothesUpgrade.getBaseStat(item, statId)
    local cul = ClothesUpgrade.ensureMD(item)
    if cul.base[statId] ~= nil then return cul.base[statId] end
    local base = scriptStatValue(item, statId)
    if base == nil then base = ClothesUpgrade.statGetLive(item, statId) end
    if base == nil then base = 0 end
    cul.base[statId] = base
    return base
end

local function flawSumForStat(cul, statId)
    local s = 0
    for _, f in ipairs(cul.flaws or {}) do
        if f.stat == statId then s = s + (f.amount or 0) end
    end
    return s
end
ClothesUpgrade.flawSumForStat = flawSumForStat

function ClothesUpgrade.applyStat(item, statId)
    local cul = ClothesUpgrade.ensureMD(item)
    local base = ClothesUpgrade.getBaseStat(item, statId)
    local target = base + (cul.bonus[statId] or 0) + flawSumForStat(cul, statId)
    ClothesUpgrade.statSetLive(item, statId, target)
end

function ClothesUpgrade.reapply(item)
    if not item then return end
    local md = item:getModData()
    if not md.CUL then return end
    local cul = md.CUL
    local seen = {}
    for statId, _ in pairs(cul.bonus or {}) do seen[statId] = true end
    for _, f in ipairs(cul.flaws or {}) do if f.stat then seen[f.stat] = true end end
    for statId, _ in pairs(seen) do
        ClothesUpgrade.applyStat(item, statId)
    end
end

function ClothesUpgrade.reapplyForCharacter(character)
    if not character then return end
    for _, it in ipairs(ClothesUpgrade.collectItems(character, nil)) do
        ClothesUpgrade.reapply(it)
    end
end

function ClothesUpgrade.isExcludedPack(item)
    local ex = ClothesUpgrade.Config and ClothesUpgrade.Config.packExclude
    if not ex then return false end
    if ex[item:getFullType()] then return true end
    local t = item.getType and item:getType()
    if t and ex[t] then return true end
    return false
end

function ClothesUpgrade.getKind(item)
    if not item then return nil end
    if instanceof(item, "InventoryContainer") then
        if ClothesUpgrade.isExcludedPack(item) then return nil end
        return "pack"
    end
    if instanceof(item, "Clothing") then return "apparel" end
    return nil
end

local BODYLOC_CLASS = {
    Hat = "head", FullHat = "head", MaskFull = "head", MaskEyes = "head",

    Torso1 = "torso", TorsoExtra = "torso", TorsoExtraVest = "torso",
    TankTop = "torso", Tshirt = "torso", ShortSleeveShirt = "torso", Shirt = "torso",
    Sweater = "torso", SweaterHat = "torso",
    Jacket = "torso", Jacket_Down = "torso", Jacket_Bulky = "torso",
    JacketHat = "torso", JacketHat_Bulky = "torso", JacketSuit = "torso",
    Boilersuit = "torso", FullTop = "torso", FullSuit = "torso",
    FullSuitHead = "torso", BodyCostume = "torso", BathRobe = "torso",
    Dress = "torso", Torso1Legs1 = "torso",

    Legs1 = "legs", Pants = "legs", Skirt = "legs", LongJohns = "legs",

    Shoes = "feet", Socks = "feet",
    Hands = "hands",
}

function ClothesUpgrade.inferApparelClass(item)
    local loc = item.getBodyLocation and item:getBodyLocation()
    if loc and BODYLOC_CLASS[loc] then return BODYLOC_CLASS[loc] end
    return "generic"
end

function ClothesUpgrade.collectItems(character, kind)
    local out, seen = {}, {}
    local function consider(it)
        if not it or seen[it] then return end
        seen[it] = true
        local k = ClothesUpgrade.getKind(it)
        if not k then return end
        if kind and k ~= kind then return end
        if #ClothesUpgrade.getTracks(it) == 0 then return end
        out[#out + 1] = it
    end

    local inv = character:getInventory()
    if inv then
        local items = inv:getItems()
        for i = 0, items:size() - 1 do consider(items:get(i)) end
    end
    local worn = character.getWornItems and character:getWornItems()
    if worn then
        for i = 0, worn:size() - 1 do
            local w = worn:get(i)
            if w then consider(w:getItem()) end
        end
    end
    for _, getter in ipairs({ "getClothingItem_Back", "getPrimaryHandItem", "getSecondaryHandItem" }) do
        if character[getter] then
            local b = character[getter](character)
            if b then consider(b) end
        end
    end
    return out
end

local function visualOf(item)
    if not (item and item.getVisual) then return nil end
    local alt = item.getAlternateModelName and item:getAlternateModelName()
    if alt then
        alt = string.lower(alt)
        if alt == "righthand" and not item:getItemReplacementPrimaryHand() then return nil end
        if alt == "lefthand" and not item:getItemReplacementSecondHand() then return nil end
    end
    return item:getVisual()
end

function ClothesUpgrade.getAppearance(item)
    if not item then return nil end
    if ClothesUpgrade.getKind(item) == nil then return nil end

    local visual = visualOf(item)
    if not visual then return nil end

    local ci = visual:getClothingItem()
    if not ci and item.getClothingItem then ci = item:getClothingItem() end
    if not ci then return nil end

    local canTint = false
    if ci.getAllowRandomTint then canTint = (ci:getAllowRandomTint() == true) end

    local texCount = 0
    local tc = ci.getTextureChoices and ci:getTextureChoices()
    if tc and tc.size then texCount = tc:size() end

    local hasModel = true
    if ci.hasModel then hasModel = (ci:hasModel() == true) end

    if (not canTint) and texCount <= 1 then return nil end
    return {
        canTint      = canTint,
        textureCount = texCount,
        hasModel     = hasModel,
    }
end

function ClothesUpgrade.collectAppearanceItems(character)
    local out, seen = {}, {}
    local function consider(it)
        if not it or seen[it] then return end
        seen[it] = true
        if ClothesUpgrade.getAppearance(it) then out[#out + 1] = it end
    end
    local inv = character:getInventory()
    if inv then
        local items = inv:getItems()
        for i = 0, items:size() - 1 do consider(items:get(i)) end
    end
    local worn = character.getWornItems and character:getWornItems()
    if worn then
        for i = 0, worn:size() - 1 do
            local w = worn:get(i)
            if w then consider(w:getItem()) end
        end
    end
    if character.getClothingItem_Back then
        local b = character:getClothingItem_Back()
        if b then consider(b) end
    end
    return out
end

function ClothesUpgrade.getTintRGB(item)
    local r, g, b = 1, 1, 1
    local vis = visualOf(item)
    local ci = vis and vis:getClothingItem()
    local c = ci and vis:getTint(ci)
    if c then r, g, b = c:getRedFloat(), c:getGreenFloat(), c:getBlueFloat() end
    return r, g, b
end

function ClothesUpgrade.getTextureIndex(item)
    local vis = visualOf(item)
    return vis and vis:getTextureChoice() or 0
end

function ClothesUpgrade.applyTint(character, item, r, g, b)
    local vis = visualOf(item)
    if vis then vis:setTint(ImmutableColor.new(r, g, b, 1)) end
    if item.setColor then item:setColor(Color.new(r, g, b, 1)) end
    if item.setCustomColor then item:setCustomColor(true) end
    ClothesUpgrade.refreshVisual(character, item)
end

function ClothesUpgrade.applyTexture(character, item, idx)
    local vis = visualOf(item)
    if vis then
        local ci = vis:getClothingItem()
        local hasModel = true
        if ci and ci.hasModel then hasModel = (ci:hasModel() == true) end
        if hasModel then vis:setTextureChoice(idx) else vis:setBaseTexture(idx) end
    end
    if item.synchWithVisual then item:synchWithVisual() end
    ClothesUpgrade.refreshVisual(character, item)
end

function ClothesUpgrade.refreshVisual(character, item)
    if item.setDrawDirty then item:setDrawDirty(true) end
    local cont = item.getContainer and item:getContainer()
    if cont and cont.setDrawDirty then cont:setDrawDirty(true) end
    local inv = character and character:getInventory()
    if inv then inv:setDrawDirty(true) end
    if character and character.resetModelNextFrame then character:resetModelNextFrame() end
end

function ClothesUpgrade.dyeStatus(inventory, perkLevel)
    local cfg = ClothesUpgrade.Config.dye or {}
    if cfg.enabled == false then
        return { free = true, haveAll = true, hasTools = true, meetsSkill = true,
                 cost = {}, missing = {}, missingTools = {}, skillMin = 0 }
    end
    local missing = {}
    for _, req in ipairs(cfg.cost or {}) do
        if not ClothesUpgrade.hasRequirement(inventory, req) then missing[#missing + 1] = req end
    end
    local mt = {}
    for _, t in ipairs(cfg.tools or {}) do
        if not ClothesUpgrade.hasTool(inventory, t) then mt[#mt + 1] = t end
    end
    return {
        free = false, cost = cfg.cost or {},
        haveAll = #missing == 0, missing = missing,
        hasTools = #mt == 0, missingTools = mt,
        meetsSkill = perkLevel >= (cfg.skillMin or 0), skillMin = cfg.skillMin or 0,
    }
end

function ClothesUpgrade.canDye(inventory, perkLevel)
    local st = ClothesUpgrade.dyeStatus(inventory, perkLevel)
    return st.haveAll and st.hasTools and st.meetsSkill
end

function ClothesUpgrade.consumeDye(character)
    local cfg = ClothesUpgrade.Config.dye or {}
    if cfg.enabled == false then return end
    for _, req in ipairs(cfg.cost or {}) do
        ClothesUpgrade.consumeRequirement(character, req)
    end
end

function ClothesUpgrade.revertStalePreviews(character)
    if not character then return end
    local function check(it)
        if not it then return end
        local md = it:getModData()
        local pv = md and md.CULpv
        if not pv then return end
        if pv.tint then
            ClothesUpgrade.applyTint(character, it, pv.tint[1] or 1, pv.tint[2] or 1, pv.tint[3] or 1)
        end
        if pv.tex ~= nil then
            ClothesUpgrade.applyTexture(character, it, pv.tex)
        end
        md.CULpv = nil
    end
    local inv = character:getInventory()
    if inv then
        local items = inv:getItems()
        for i = 0, items:size() - 1 do check(items:get(i)) end
    end
    local worn = character.getWornItems and character:getWornItems()
    if worn then
        for i = 0, worn:size() - 1 do
            local w = worn:get(i)
            if w then check(w:getItem()) end
        end
    end
    if character.getClothingItem_Back then
        local b = character:getClothingItem_Back()
        if b then check(b) end
    end
end

function ClothesUpgrade.getProfile(item)
    local kind = ClothesUpgrade.getKind(item)
    local ft = item:getFullType()
    if kind == "pack" then
        if ClothesUpgrade.PackProfiles and ClothesUpgrade.PackProfiles[ft] then
            return ClothesUpgrade.PackProfiles[ft]
        end
        return ClothesUpgrade.PackDefaults and ClothesUpgrade.PackDefaults.generic
    elseif kind == "apparel" then
        if ClothesUpgrade.ApparelProfiles and ClothesUpgrade.ApparelProfiles[ft] then
            return ClothesUpgrade.ApparelProfiles[ft]
        end
        local cls = ClothesUpgrade.inferApparelClass(item)
        local d = ClothesUpgrade.ApparelDefaults or {}
        return d[cls] or d.generic
    end
    return nil
end

function ClothesUpgrade.getTracks(item)
    local p = ClothesUpgrade.getProfile(item)
    if not (p and p.tracks) then return {} end
    local out = {}
    for _, t in ipairs(p.tracks) do
        local statId = t.stat or t.id
        if ClothesUpgrade.statSupported(item, statId) then
            out[#out + 1] = t
        end
    end
    return out
end

function ClothesUpgrade.trackById(item, trackId)
    for _, t in ipairs(ClothesUpgrade.getTracks(item)) do
        if (t.id or t.stat) == trackId then return t end
    end
    return nil
end

function ClothesUpgrade.trackId(track)
    return track.id or track.stat
end

function ClothesUpgrade.trackLevel(item, track)
    local cul = ClothesUpgrade.ensureMD(item)
    return cul.level[ClothesUpgrade.trackId(track)] or 0
end

function ClothesUpgrade.recipeForLevel(track, level)
    local list = track.levels or {}
    if #list == 0 then return {} end
    local idx = level
    if idx < 1 then idx = 1 end
    if idx > #list then idx = #list end
    return list[idx]
end

function ClothesUpgrade.resolveDifficulty(diff)
    if diff == nil then diff = ClothesUpgrade.Config.defaultDifficulty end
    if type(diff) == "string" then
        return ClothesUpgrade.Difficulties[diff] or ClothesUpgrade.Difficulties.normal
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

function ClothesUpgrade.successChance(diff, level)
    local d = ClothesUpgrade.resolveDifficulty(diff)
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

function ClothesUpgrade.recipeDifficulty(track, recipe)
    if recipe and recipe.difficulty ~= nil then return recipe.difficulty end
    if track and track.difficulty ~= nil then return track.difficulty end
    return ClothesUpgrade.Config.defaultDifficulty
end

function ClothesUpgrade.isDrainableType(fullType)
    return ScriptManager.instance:isDrainableItemType(fullType)
end

function ClothesUpgrade.availableForReq(inventory, req)
    local ft = req.item
    local drain = ClothesUpgrade.isDrainableType(ft)
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

function ClothesUpgrade.hasRequirement(inventory, req)
    return ClothesUpgrade.availableForReq(inventory, req) >= (req.count or 1)
end

function ClothesUpgrade.toolType(toolEntry)
    if type(toolEntry) == "string" then return toolEntry end
    return toolEntry and toolEntry.item or nil
end

function ClothesUpgrade.hasTool(inventory, toolEntry)
    local ft = ClothesUpgrade.toolType(toolEntry)
    if not ft then return true end
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        if items:get(i):getFullType() == ft then return true end
    end
    return false
end

function ClothesUpgrade.consumeRequirement(character, req)
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
    if ClothesUpgrade.isDrainableType(ft) then
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

function ClothesUpgrade.consumeRecipe(character, recipe)
    for _, req in ipairs(recipe.items or {}) do
        ClothesUpgrade.consumeRequirement(character, req)
    end
end

function ClothesUpgrade.trackPerStep(track)
    return track.perStep or 1
end

function ClothesUpgrade.trackHeadroom(item, track)
    if track.maxValue == nil then return nil end
    local statId = track.stat or track.id
    local base = ClothesUpgrade.getBaseStat(item, statId)
    local cul = ClothesUpgrade.ensureMD(item)
    local bonus = cul.bonus[statId] or 0
    return track.maxValue - (base + bonus)
end

function ClothesUpgrade.effectiveStep(item, track)
    local step = ClothesUpgrade.trackPerStep(track)
    local head = ClothesUpgrade.trackHeadroom(item, track)
    if head ~= nil and head < step then step = head end
    if step < 0 then step = 0 end
    return step
end

function ClothesUpgrade.trackAtCap(item, track)
    local level = ClothesUpgrade.trackLevel(item, track)
    if track.maxLevel and level >= track.maxLevel then return true end
    local statId = track.stat or track.id
    local cul = ClothesUpgrade.ensureMD(item)
    local bonus = cul.bonus[statId] or 0
    if track.maxBonus and bonus + ClothesUpgrade.trackPerStep(track) > track.maxBonus + 1e-6 then
        return true
    end
    if track.maxValue then
        local base = ClothesUpgrade.getBaseStat(item, statId)
        if (base + bonus) >= track.maxValue - 1e-6 then return true end
    end
    return false
end

function ClothesUpgrade.recipeTools(track, recipe)
    return (recipe and recipe.tools) or (track and track.tools) or {}
end

function ClothesUpgrade.trackStatus(inventory, item, track, perkLevel)
    local statId = track.stat or track.id
    local level  = ClothesUpgrade.trackLevel(item, track)
    local recipe = ClothesUpgrade.recipeForLevel(track, level + 1)
    local tools  = ClothesUpgrade.recipeTools(track, recipe)

    local missing = {}
    for _, req in ipairs(recipe.items or {}) do
        if not ClothesUpgrade.hasRequirement(inventory, req) then table.insert(missing, req) end
    end
    local missingTools = {}
    for _, t in ipairs(tools) do
        if not ClothesUpgrade.hasTool(inventory, t) then table.insert(missingTools, t) end
    end

    local cul = ClothesUpgrade.ensureMD(item)
    local skillMin = recipe.skillMin or track.skillMin or 0

    return {
        statId    = statId,
        recipe    = recipe,
        level     = level,
        maxLevel  = track.maxLevel,
        perStep   = ClothesUpgrade.trackPerStep(track),
        effStep   = ClothesUpgrade.effectiveStep(item, track),
        bonus     = cul.bonus[statId] or 0,
        maxBonus  = track.maxBonus,
        maxValue  = track.maxValue,
        base      = ClothesUpgrade.getBaseStat(item, statId),
        current   = ClothesUpgrade.statGetLive(item, statId),
        atCap     = ClothesUpgrade.trackAtCap(item, track),
        haveAll   = #missing == 0,
        missing   = missing,
        tools     = tools,
        hasTools  = #missingTools == 0,
        missingTools = missingTools,
        meetsSkill = perkLevel >= skillMin,
        skillMin  = skillMin,
        chance    = ClothesUpgrade.successChance(ClothesUpgrade.recipeDifficulty(track, recipe), perkLevel),
    }
end

function ClothesUpgrade.canUpgrade(inventory, item, track, perkLevel)
    local st = ClothesUpgrade.trackStatus(inventory, item, track, perkLevel)
    return (not st.atCap) and st.haveAll and st.hasTools and st.meetsSkill
end

function ClothesUpgrade.computeTime(character, item)
    local c = ClothesUpgrade.Config
    local lvl = character:getPerkLevel(ClothesUpgrade.perk())
    local t = c.baseActionTime - lvl * c.timePerLevelReduction
    if t < c.minActionTime then t = c.minActionTime end
    return t
end

local function pickWeighted(pool)
    local total = 0
    for _, e in ipairs(pool) do total = total + (e.weight or 1) end
    if total <= 0 then return nil end
    local r = ZombRand(total) + 1
    local acc = 0
    for _, e in ipairs(pool) do
        acc = acc + (e.weight or 1)
        if r <= acc then return e end
    end
    return pool[#pool]
end

function ClothesUpgrade.rollBotch(character, item)
    local cfg = ClothesUpgrade.Config.botch
    if not (cfg and cfg.enabled) then return nil end
    if ClothesUpgrade.getKind(item) ~= "apparel" then return nil end
    local cul = ClothesUpgrade.ensureMD(item)
    if #cul.flaws >= (cfg.maxPerGarment or 99) then return nil end

    local level = character:getPerkLevel(ClothesUpgrade.perk())
    local chance = (cfg.chance or 0) - (cfg.perLevelReduction or 0) * level
    if chance < (cfg.minChance or 0) then chance = cfg.minChance or 0 end
    if ZombRand(1000) >= math.floor(chance * 1000 + 0.5) then return nil end

    local pool = {}
    for _, e in ipairs(cfg.pool or {}) do
        if ClothesUpgrade.statSupported(item, e.stat) then pool[#pool + 1] = e end
    end
    local choice = pickWeighted(pool)
    if not choice then return nil end

    local flaw = { stat = choice.stat, amount = choice.amount, label = choice.label }
    table.insert(cul.flaws, flaw)
    ClothesUpgrade.applyStat(item, choice.stat)
    return flaw
end

local function haloFeedback(character, text, good)
    if not (HaloTextHelper and HaloTextHelper.addText) then return end
    local color
    if good and HaloTextHelper.getColorGreen then color = HaloTextHelper.getColorGreen()
    elseif HaloTextHelper.getColorRed then color = HaloTextHelper.getColorRed() end
    if color then
        HaloTextHelper.addText(character, text, color)
    else
        HaloTextHelper.addText(character, text)
    end
end

function ClothesUpgrade.attemptUpgrade(character, item, track)
    local cfg = ClothesUpgrade.Config
    local perk = character:getPerkLevel(ClothesUpgrade.perk())
    local inv = character:getInventory()
    if not ClothesUpgrade.canUpgrade(inv, item, track, perk) then
        return "invalid"
    end

    local statId = track.stat or track.id
    local recipe = ClothesUpgrade.recipeForLevel(track, ClothesUpgrade.trackLevel(item, track) + 1)
    local chance = ClothesUpgrade.successChance(ClothesUpgrade.recipeDifficulty(track, recipe), perk)
    local success = ZombRand(100) < math.floor(chance * 100 + 0.5)
    local xp = recipe.xp or track.xp or cfg.defaultXp

    if success then
        local cul = ClothesUpgrade.ensureMD(item)
        ClothesUpgrade.getBaseStat(item, statId)
        local step = ClothesUpgrade.effectiveStep(item, track)
        cul.bonus[statId] = (cul.bonus[statId] or 0) + step
        cul.level[ClothesUpgrade.trackId(track)] = ClothesUpgrade.trackLevel(item, track) + 1
        ClothesUpgrade.applyStat(item, statId)

        character:getXp():AddXP(ClothesUpgrade.perk(), xp)
        ClothesUpgrade.consumeRecipe(character, recipe)

        local flaw = ClothesUpgrade.rollBotch(character, item)

        local cont = item:getContainer()
        if cont and cont.setDrawDirty then cont:setDrawDirty(true) end
        inv:setDrawDirty(true)

        if flaw then
            haloFeedback(character, "Upgraded, but botched: " .. (flaw.label or "flaw"), false)
            return "botched", flaw
        end
        haloFeedback(character, "Upgraded: " .. (ClothesUpgrade.Stats[statId].label or statId), true)
        return "success"
    else
        if cfg.consumeOnFailure then ClothesUpgrade.consumeRecipe(character, recipe) end
        character:getXp():AddXP(ClothesUpgrade.perk(), xp * (cfg.failXpFraction or 0))
        inv:setDrawDirty(true)
        haloFeedback(character, "Upgrade failed", false)
        return "fail"
    end
end
