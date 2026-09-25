if CharacterCreationProfession == nil then return end

DL = DL or {}
local O = DL.Occupations
if O == nil or O.occupations == nil or O.traits == nil then return end

local groupOf = {}
for id, trait in pairs(O.traits) do
    if trait.group ~= nil then
        groupOf[id] = trait.group
    end
end

local orderIndex = {}
for i, id in ipairs(O.occupationOrder) do
    orderIndex[id] = i
end

local function occupationRank(entry)
    return orderIndex[entry.item:getType()] or (#O.occupationOrder + 1)
end

local function firstRemovable(screen)
    for i, entry in ipairs(screen.listboxTraitSelected.items) do
        if not entry.item:isFree() then
            return i
        end
    end
    return nil
end

local function fillList(list, traits)
    list:clear()
    list:setScrollHeight(0)
    for _, trait in ipairs(traits) do
        local entry = list:addItem(trait:getLabel(), trait)
        entry.tooltip = trait:getDescription()
    end
    list.selected = -1
end

function O.refreshTraitLists(screen)
    if screen.listboxTraitSelected == nil or screen.listboxTrait == nil or screen.listboxBadTrait == nil then return end
    local chosen = {}
    local blocked = {}
    local groupCount = {}
    for _, entry in ipairs(screen.listboxTraitSelected.items) do
        local trait = entry.item
        local id = trait:getType()
        chosen[id] = true
        local exclusive = trait:getMutuallyExclusiveTraits()
        for i = 0, exclusive:size() - 1 do
            blocked[exclusive:get(i)] = true
        end
        local group = groupOf[id]
        if group ~= nil then
            groupCount[group] = (groupCount[group] or 0) + 1
        end
    end
    local good = {}
    local bad = {}
    local all = TraitFactory.getTraits()
    for i = 0, all:size() - 1 do
        local trait = all:get(i)
        local id = trait:getType()
        local cost = trait:getCost()
        local show = not trait:isFree() and cost ~= 0 and not chosen[id] and not blocked[id]
        if show and trait:isRemoveInMP() and isClient() then
            show = false
        end
        if show then
            local group = groupOf[id]
            local limit = nil
            if group ~= nil then
                limit = O.pickLimits[group]
            end
            if limit ~= nil and (groupCount[group] or 0) >= limit then
                show = false
            end
        end
        if show then
            if cost > 0 then
                table.insert(good, trait)
            else
                table.insert(bad, trait)
            end
        end
    end
    fillList(screen.listboxTrait, good)
    fillList(screen.listboxBadTrait, bad)
    CharacterCreationMain.sort(screen.listboxTrait.items)
    CharacterCreationMain.invertSort(screen.listboxBadTrait.items)
    if screen.addTraitBtn ~= nil then
        screen.addTraitBtn:setEnable(false)
    end
    if screen.addBadTraitBtn ~= nil then
        screen.addBadTraitBtn:setEnable(false)
    end
end

function O.pickTrait(screen, id)
    local trait = TraitFactory.getTrait(id)
    if trait == nil or trait:isFree() then return false end
    local bad = trait:getCost() < 0
    local list = screen.listboxTrait
    if bad then
        list = screen.listboxBadTrait
    end
    for i, entry in ipairs(list.items) do
        if entry.item:getType() == id then
            list.selected = i
            screen:addTrait(bad)
            return true
        end
    end
    return false
end

local function clearRemovableTraits(screen)
    local guard = 0
    local index = firstRemovable(screen)
    while index ~= nil and guard < 500 do
        guard = guard + 1
        screen.listboxTraitSelected.selected = index
        screen:removeTrait()
        index = firstRemovable(screen)
    end
end

function O.applyPreset(screen, profession)
    local wasSuppressed = screen.dlNoChoicePrompt
    screen.dlNoChoicePrompt = true
    local kept = {}
    if O.captureChoices ~= nil then
        kept = O.captureChoices(screen)
    end
    clearRemovableTraits(screen)
    local occupation = nil
    if profession ~= nil then
        occupation = O.occupations[profession:getType()]
    end
    if occupation ~= nil and occupation.preset ~= nil then
        for _, id in ipairs(occupation.preset) do
            O.pickTrait(screen, id)
        end
    end
    if O.applyPresetChoices ~= nil then
        O.applyPresetChoices(screen, occupation, kept)
    end
    screen.dlNoChoicePrompt = wasSuppressed
end

function O.selectDefaultOccupation(screen)
    local list = screen.listboxProf
    if list == nil then return end
    for i, entry in ipairs(list.items) do
        if entry.item:getType() == O.defaultOccupation then
            list.selected = i
            screen:onSelectProf(entry.item)
            return
        end
    end
end

local vanillaPopulateProfessionList = CharacterCreationProfession.populateProfessionList
function CharacterCreationProfession:populateProfessionList(list)
    vanillaPopulateProfessionList(self, list)
    table.sort(list.items, function(a, b)
        local rankA = occupationRank(a)
        local rankB = occupationRank(b)
        if rankA ~= rankB then
            return rankA < rankB
        end
        return a.item:getName() < b.item:getName()
    end)
end

local vanillaCreate = CharacterCreationProfession.create
function CharacterCreationProfession:create()
    vanillaCreate(self)
    O.selectDefaultOccupation(self)
end

local function updateChoices(screen)
    if O.updateChoices == nil then return end
    O.clearPostponed(screen)
    O.updateChoices(screen)
end

local vanillaOnSelectProf = CharacterCreationProfession.onSelectProf
function CharacterCreationProfession:onSelectProf(item)
    local changed = self.profession ~= item
    vanillaOnSelectProf(self, item)
    if changed and not self.dlKeepTraits then
        O.applyPreset(self, item)
        self:checkXPBoost()
    end
    O.refreshTraitLists(self)
    updateChoices(self)
end

local vanillaAddTrait = CharacterCreationProfession.addTrait
function CharacterCreationProfession:addTrait(bad)
    vanillaAddTrait(self, bad)
    O.refreshTraitLists(self)
    updateChoices(self)
end

local vanillaRemoveTrait = CharacterCreationProfession.removeTrait
function CharacterCreationProfession:removeTrait()
    vanillaRemoveTrait(self)
    O.refreshTraitLists(self)
    updateChoices(self)
end

local vanillaLoadBuild = CharacterCreationProfession.loadBuild
function CharacterCreationProfession.loadBuild(self, box)
    self.dlKeepTraits = true
    self.dlNoChoicePrompt = true
    vanillaLoadBuild(self, box)
    self.dlKeepTraits = nil
    self.dlNoChoicePrompt = nil
    O.refreshTraitLists(self)
    self:checkXPBoost()
    updateChoices(self)
end

function CharacterCreationProfession:resetBuild()
    if self.listboxProf.items[1] ~= nil then
        self.listboxProf.selected = 1
        self:onSelectProf(self.listboxProf.items[1].item)
    end
    clearRemovableTraits(self)
    updateChoices(self)
    O.refreshTraitLists(self)
end

function CharacterCreationProfession:resetTraits()
    local selected = self.listboxProf.selected
    if self.listboxProf.items[1] ~= nil then
        self:onSelectProf(self.listboxProf.items[1].item)
    end
    clearRemovableTraits(self)
    updateChoices(self)
    if self.listboxProf.items[selected] ~= nil then
        self.listboxProf.selected = selected
        self:onSelectProf(self.listboxProf.items[selected].item)
    end
    O.refreshTraitLists(self)
end

local vanillaRandomizeTraits = CharacterCreationProfession.randomizeTraits
function CharacterCreationProfession:randomizeTraits()
    self.dlNoChoicePrompt = true
    vanillaRandomizeTraits(self)
    self.dlNoChoicePrompt = nil
    updateChoices(self)
end
