require "NPCs/ZombiesZoneDefinition"
require "DebugUIs/ISSpawnHordeUI"

local AnimalOutfits = {
    AnimalCow = true,
    AnimalDeer = true,
    AnimalPig = true,
    AnimalRabbit = true,
    AnimalRat = true,
    AnimalSheep = true,
}

local function getOutfitPool(ui)
    local pool = {}
    local total = 0
    for _, def in ipairs(ZombiesZoneDefinition.Default) do
        local chance = tonumber(def.chance) or 0
        if def.name and chance > 0 and not AnimalOutfits[def.name]
                and (ui.maleOutfits:contains(def.name) or ui.femaleOutfits:contains(def.name)) then
            total = total + chance
            table.insert(pool, { name = def.name, chance = chance })
        end
    end
    return pool, total
end

local function rollOutfit(pool, total)
    local roll = ZombRandFloat(0, total)
    for _, entry in ipairs(pool) do
        roll = roll - entry.chance
        if roll < 0 then return entry.name end
    end
    return pool[#pool].name
end

local original_onSpawn = ISSpawnHordeUI.onSpawn
function ISSpawnHordeUI:onSpawn()
    if self:getOutfit() then
        return original_onSpawn(self)
    end

    local pool, total = getOutfitPool(self)
    if #pool == 0 then
        return original_onSpawn(self)
    end

    local batches = {}
    for i = 1, self:getZombiesNumber() do
        local outfit = rollOutfit(pool, total)
        batches[outfit] = (batches[outfit] or 0) + 1
    end

    for outfit, count in pairs(batches) do
        self.getOutfit = function() return outfit end
        self.getZombiesNumber = function() return count end
        original_onSpawn(self)
    end
    self.getOutfit = nil
    self.getZombiesNumber = nil
end
