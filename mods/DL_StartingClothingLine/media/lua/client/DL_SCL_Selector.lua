require "Definitions/ClothingSelectionDefinitions"
require "OptionScreens/CharacterCreationMain"

local catalog = require "DL_SCL_Catalog"
local reported = {}
-- Clothing chances
local newCategoryChances = { Jacket = 30, Sweater = 30, Skirt = 50 }
-- many checks for items, UI breaks if item doesn't exist or doesn't have a display name
local function availableItem(fullType)
    local item = ScriptManager.instance:FindItem(fullType)
    if item and (item:getType() == Type.Clothing or
            (item:getType() == Type.Container and item.CanBeEquipped == "Back")) and
            item:getClothingItemAsset() then
        return item
    end
    if not reported[fullType] then
        reported[fullType] = true
        print("[StartingClothingLine] Skipping missing or non-wearable item: " .. fullType)
    end
end

local function AddClothingDL()
    for _, sex in ipairs({ "Female", "Male" }) do
        local slots = ClothingSelectionDefinitions.default[sex]
        for category, items in pairs(catalog) do
            local slot = slots[category]
            if not slot then
                slot = { chance = newCategoryChances[category] or 10, items = {} }
                slots[category] = slot
            end
            local seen = {}
            for _, fullType in ipairs(slot.items) do seen[fullType] = true end
            for _, fullType in ipairs(items) do
                if not seen[fullType] and availableItem(fullType) then
                    slot.items[#slot.items + 1] = fullType
                    seen[fullType] = true
                end
            end
        end
    end

    -- Let vanilla create the controls, then populate by item ID
    -- Vanilla populates by display name, hiding items with same display names
    local originalPopulate = CharacterCreationMain.doClothingCombo
    function CharacterCreationMain:doClothingCombo(definition, erasePrevious)
        if not self.clothingPanel then return end
        local empty = {}
        for category, slot in pairs(definition) do
            empty[category] = { chance = slot.chance, items = {} }
        end
        originalPopulate(self, empty, erasePrevious)

        for category, slot in pairs(definition) do
            local combo = self.clothingCombo[category]
            local options, seen, counts = {}, {}, {}
            local function add(fullType)
                if seen[fullType] then return end
                seen[fullType] = true
                local item = availableItem(fullType)
                if not item then return end
                local name = item:getDisplayName()
                counts[name] = (counts[name] or 0) + 1
                options[#options + 1] = { text = name, data = fullType }
            end
            -- Keep default choices when vanilla adds profession choices
            for index = 2, #combo.options do add(combo.options[index].data) end
            for _, fullType in ipairs(slot.items) do add(fullType) end
            table.sort(options, function(left, right)
                if left.text == right.text then return left.data < right.data end
                return left.text < right.text
            end)
            combo.options = { combo.options[1] }
            for _, option in ipairs(options) do
                local label = option.text
                if counts[label] > 1 then label = label .. " (" .. option.data .. ")" end
                combo:addOptionWithData(label, option.data)
            end
        end
        self:updateSelectedClothingCombo()
    end

    local originalSelect = CharacterCreationMain.updateSelectedClothingCombo
    function CharacterCreationMain:updateSelectedClothingCombo()
        originalSelect(self)
        if CharacterCreationMain.debug or not self.clothingCombo then return end
        local descriptor = MainScreen.instance.desc
        for category, combo in pairs(self.clothingCombo) do
            local worn = descriptor:getWornItem(category)
            if worn then combo:selectData(worn:getFullType()) end
        end
    end
end

Events.OnGameBoot.Add(AddClothingDL)
