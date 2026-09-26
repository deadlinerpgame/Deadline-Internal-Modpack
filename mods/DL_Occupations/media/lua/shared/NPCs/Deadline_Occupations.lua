require "NPCs/MainCreationMethods"

if not getActivatedMods():contains("ProfessionFramework") then return end

DL = DL or {}
local O = DL.Occupations
if O == nil or O.traits == nil or O.occupations == nil then return end

local PF = ProfessionFramework
PF.RemoveDefaultProfessions = true
PF.RemoveDefaultTraits = true

local function toPerks(byName, owner)
    if byName == nil then return nil end
    local out = {}
    for name, amount in pairs(byName) do
        local perk = Perks[name]
        if perk == nil then
            print("DL_Occupations: unknown skill '" .. tostring(name) .. "' on " .. tostring(owner))
        else
            out[perk] = amount
        end
    end
    return out
end

local BOOSTED_CATEGORIES = {
    [Perks.Combat] = true,
    [Perks.Crafting] = true,
    [Perks.Firearm] = true,
    [Perks.Survivalist] = true,
    [Perks.Agility] = true,
}

DL.TraitBoosts = {}

local function traitXp(trait, owner)
    local out = toPerks(trait.xp, owner) or {}
    local boosts = {}
    for perk, cap in pairs(toPerks(trait.caps, owner) or {}) do
        if BOOSTED_CATEGORIES[perk:getParent()] then
            boosts[perk] = math.floor(cap / 2)
            out[perk] = boosts[perk]
        end
    end
    if next(boosts) ~= nil then
        DL.TraitBoosts[owner] = boosts
    end
    if next(out) == nil then return nil end
    return out
end

local exclusions = {}
for _, pair in ipairs(O.exclusives) do
    local first = pair[1]
    exclusions[first] = exclusions[first] or {}
    table.insert(exclusions[first], pair[2])
end

DL.SkillCaps = DL.SkillCaps or {}
DL.SkillCaps.traits = DL.SkillCaps.traits or {}

for _, id in ipairs(O.traitOrder) do
    local trait = O.traits[id]
    PF.addTrait(id, {
        name = trait.name,
        description = trait.description,
        cost = trait.cost,
        profession = trait.hidden == true,
        xp = traitXp(trait, id),
        recipes = trait.recipes,
        add = trait.add,
        exclude = exclusions[id],
    })
    if trait.caps ~= nil then
        DL.SkillCaps.traits[id] = trait.caps
    end
end

for _, id in ipairs(O.occupationOrder) do
    local occupation = O.occupations[id]
    PF.addProfession(id, {
        name = occupation.name,
        icon = occupation.icon or "",
        cost = O.startingPoints,
    })
end

function O.applyDescriptions()
    for _, id in ipairs(O.traitOrder) do
        local trait = TraitFactory.getTrait(id)
        if trait ~= nil then
            trait:setDescription(O.traits[id].description)
        end
    end
    for _, id in ipairs(O.occupationOrder) do
        local profession = ProfessionFactory.getProfession(id)
        if profession ~= nil then
            profession:setDescription(O.occupations[id].description)
        end
    end
end

Events.OnGameBoot.Add(O.applyDescriptions)

local frameworkDoProfessions = BaseGameCharacterDetails.DoProfessions
BaseGameCharacterDetails.DoProfessions = function()
    frameworkDoProfessions()
    O.applyDescriptions()
end
