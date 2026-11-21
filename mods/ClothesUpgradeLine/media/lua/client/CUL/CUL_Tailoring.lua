require "ISUI/ISGarmentUI"
require "ISUI/ISInventoryPaneContextMenu"
require "TimedActions/ISRepairClothing"

local function coveredPart(clothing, part)
    local parts = clothing:getCoveredParts()
    for i = 0, parts:size() - 1 do
        if parts:get(i) == part then return true end
    end
    return false
end

local function canRestoreEarly(character, clothing, part, fabric)
    local level = character:getPerkLevel(Perks.Tailoring)
    local holes = clothing:getHolesNumber()
    local material = clothing:getFabricType()
    return level >= 6 and level <= 7 and holes >= 1 and holes <= 2 -- Level 6-7 tailors can fully repair garments with just one or two holes.
        and (material == "Cotton" or material == "Denim" or material == "Leather")
        and fabric:getFabricType() == material and coveredPart(clothing, part)
        and clothing:getVisual():getHole(part) > 0 and not clothing:getPatchType(part)
end

local function refreshClothing(character, clothing)
    clothing:synchWithVisual()
    character:resetModel()
    sendClothing(character)
    sendVisual(character)
    triggerEvent("OnClothingUpdated", character)
end

-- Remember whether this repair should close the hole rather than leave a patch.
local originalNew = ISRepairClothing.new
function ISRepairClothing:new(character, clothing, part, fabric, thread, needle)
    local action = originalNew(self, character, clothing, part, fabric, thread, needle)
    action.CULRestoreHole = canRestoreEarly(character, clothing, part, fabric)
    return action
end

local originalValid = ISRepairClothing.isValid
function ISRepairClothing:isValid()
    if not originalValid(self) then return false end
    if not self.CULRestoreHole then return true end
    return self.thread:getDrainableUsesInt() > 0
        and (canRestoreEarly(self.character, self.clothing, self.part, self.fabric)
            or self.clothing:canFullyRestore(self.character, self.part, self.fabric))
end

local originalPerform = ISRepairClothing.perform
function ISRepairClothing:perform()
    if not self.CULRestoreHole then return originalPerform(self) end
    if self:isValid() then
        -- If the tailor has since reached level 8, the game can handle the repair itself.
        if self.clothing:canFullyRestore(self.character, self.part, self.fabric) then return originalPerform(self) end
        self.clothing:getVisual():removeHole(self.part:index())
        self.clothing:setCondition(math.min(self.clothing:getConditionMax(),
            self.clothing:getCondition() + self.clothing:getCondLossPerHole()))
        self.character:getInventory():Remove(self.fabric)
        self.thread:Use()
        self.character:getXp():AddXP(Perks.Tailoring, ZombRand(1, 3))
        refreshClothing(self.character, self.clothing)
    end
    ISBaseTimedAction.perform(self)
end

-- Tell the player when this fabric will fully repair the hole.
local originalPatch = ISGarmentUI.doPatch
function ISGarmentUI:doPatch(fabric, thread, needle, part, context, submenu)
    local result = originalPatch(self, fabric, thread, needle, part, context, submenu)
    if result and canRestoreEarly(self.chr, self.clothing, part, fabric) then
        local option = result:getOptionFromName(fabric:getDisplayName())
        if option and option.toolTip then
            option.toolTip.description = getText("Tooltip_FullyRestore") .. " <LINE>Requires Tailoring 6 and 1-2 holes with matching fabric."
        end
    end
    return result
end

local function canAddHole(character, clothing, part)
    return character:getInventory():contains(clothing) and coveredPart(clothing, part)
        and clothing:getVisual():getHole(part) == 0 and not clothing:getPatchType(part)
end

local function addHole(character, clothing, part)
    if not canAddHole(character, clothing, part) then return end
    clothing:getVisual():setHole(part)
    clothing:setCondition(math.max(0, clothing:getCondition() - clothing:getCondLossPerHole()))
    refreshClothing(character, clothing)
end

local originalContext = ISGarmentUI.doContextMenu
function ISGarmentUI:doContextMenu(part, x, y)
    local context = originalContext(self, part, x, y)
    if context and canAddHole(self.chr, self.clothing, part) and not context:getOptionFromName("Add Hole") then
        local option = context:addOption("Add Hole", self.chr, addHole, self.clothing, part)
        option.toolTip = ISInventoryPaneContextMenu.addToolTip()
        option.toolTip.description = "Add a hole to this part and reduce clothing condition."
    end
    return context
end
