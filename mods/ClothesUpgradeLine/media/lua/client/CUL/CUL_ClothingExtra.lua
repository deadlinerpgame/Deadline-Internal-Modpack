local function afterCreateItem(newItem)
    if not (newItem and newItem.getModData) then return end
    local md = newItem:getModData()
    if not (md and md.CUL) then return end
    md.CUL.base = {}
    if ClothesUpgrade and ClothesUpgrade.reapply then
        ClothesUpgrade.reapply(newItem)
    end
end

local function install()
    if not (ISClothingExtraAction and ISClothingExtraAction.createItem) then return false end
    if ISClothingExtraAction.CUL_wrapped then return true end

    local orig = ISClothingExtraAction.createItem
    ISClothingExtraAction.createItem = function(self, item, itemType)
        local newItem = orig(self, item, itemType)
        afterCreateItem(newItem)
        return newItem
    end
    ISClothingExtraAction.CUL_wrapped = true
    return true
end

if not install() then
    Events.OnGameBoot.Add(install)
end
