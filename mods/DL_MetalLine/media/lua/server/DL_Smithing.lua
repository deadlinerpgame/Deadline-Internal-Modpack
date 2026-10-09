DL = DL or {}
DL.Smithing = {}

local function opt(key, fallback)
    local sv = SandboxVars
    if sv then
        if sv.MetalLine and sv.MetalLine[key] ~= nil then return sv.MetalLine[key] end
        if sv.CraftLine and sv.CraftLine[key] ~= nil then return sv.CraftLine[key] end
    end
    return fallback
end

function DL.Smithing.adjustFromLevel(item, level, player)
    if not item then return end

    local minLevel = opt("BlacksmithModifierMinLevel", 8)
    if not level or level < minLevel then return end

    if not instanceof(item, "HandWeapon") then return end
    if item:isRanged() and opt("BlacksmithStatMeleeOnly", true) then return end

    local perLevel = (opt("BlacksmithStatModPerLevel", 5) / 100) or 0.05
    local levelDiff = (level - minLevel) + 1
    local mod = perLevel * levelDiff

    if opt("BlacksmithAllowModifyWeight", true) then
        item:setWeight(Math.ceil(item:getWeight() * (1 - mod)))
    end
    if opt("BlacksmithAllowModifyMinDamage", true) then
        item:setMinDamage(Math.ceil(item:getMinDamage() * (1 + mod)))
    end
    if opt("BlacksmithAllowModifyMaxDamage", true) then
        item:setMaxDamage(Math.ceil(item:getMaxDamage() * (1 + mod)))
    end
    if opt("BlacksmithAllowModifyChanceOneIn", true) then
        item:setConditionLowerChance(Math.ceil(item:getConditionLowerChance() * (1 + mod)))
    end
    if opt("BlacksmithAllowModifyMaxCondition", true) then
        local maxCondition = Math.ceil(item:getConditionMax() * (1 + mod))
        item:setConditionMax(maxCondition)
        item:setCondition(maxCondition)
    end
    if opt("BlacksmithAllowModifyEnduranceMod", true) then
        item:setEnduranceMod(Math.ceil(item:getEnduranceMod() * (1 - mod)))
    end
    if opt("BlacksmithAllowCritChance", true) then
        item:setCriticalChance(Math.ceil(item:getCriticalChance() * (1 + mod)))
    end

    if player and player.getDescriptor then
        item:getModData().DLM_ForgedBy = player:getDescriptor():getForename()
    end
end

DL.Smithing.AlloyBuffs = {
    steel            = { conditionMax = 1.25 },
    stainless_steel  = { conditionMax = 1.35 },
    cast_iron        = { conditionMax = 1.10 },
    invar            = { conditionMax = 1.20 },
    duralumin        = { conditionMax = 1.15 },
    bronze           = { conditionMax = 1.05 },
}

function DL.Smithing.adjustFromAlloy(result, mat)
    if not (result and mat) then return end

    local buff = mat.alloyId and DL.Smithing.AlloyBuffs[mat.alloyId] or nil
    if not buff and mat.label then
        for id, values in pairs(DL.Smithing.AlloyBuffs) do
            if id:gsub("_", " ") == string.lower(mat.label) then buff = values break end
        end
    end
    if not buff then return end

    if buff.conditionMax then
        local newMax = Math.floor(result:getConditionMax() * buff.conditionMax)
        result:setConditionMax(newMax)
        result:setCondition(newMax)
    end
end
