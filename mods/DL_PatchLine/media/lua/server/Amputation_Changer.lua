local ALLOWED_ITEMS = {
    Amp_LA = true,
    Amp_RA = true,
    Amp_BA = true,
    Amp_LL = true,
    Amp_RL = true,
}


local function setItemVisual(playerObj, item, textureIndex)

    local clothingItem = item:getClothingItem()
    if not clothingItem then return end -- Prevent errors if item has no clothing component

    local itemVisual = item:getVisual()

    -- Set the new texture based on the chosen index
    if clothingItem:hasModel() then
        itemVisual:setTextureChoice(textureIndex)
    else
        itemVisual:setBaseTexture(textureIndex)
    end

    item:synchWithVisual()

    -- If the item is equipped, reset the player's model to update the appearance
    if item:isEquipped() then
        playerObj:resetModelNextFrame()
        triggerEvent("OnClothingUpdated", playerObj)
    end
end

-- Context menu listing all textures
local function onFillInventoryObjectContextMenu(player, context, items)
    local playerObj = getSpecificPlayer(player) -- Get the player object

    local itemList = {}
    for _, compoundItem in pairs(items) do
        if compoundItem.items and #compoundItem.items >= 1 then
            local item = compoundItem.items[1]
            -- Only use the ALLOWED_ITEMS list
            if item and ALLOWED_ITEMS[item:getType()] then
                local clothingItem = item:getClothingItem()
                if clothingItem and item:getVisual() then  -- Ensure item has visual data
                    local textureChoices = clothingItem:hasModel() and clothingItem:getTextureChoices() or clothingItem:getBaseTextures()
                    if textureChoices and textureChoices:size() > 1 then
                        table.insert(itemList, item)
                    end
                end
            end
        end
    end

    if #itemList > 0 then
        local firstItem = itemList[1]
        local clothingItem = firstItem:getClothingItem()
        local itemVisual = firstItem:getVisual()

        local textureChoices = clothingItem:hasModel() and clothingItem:getTextureChoices() or clothingItem:getBaseTextures()
        local choicesAmount = textureChoices:size()

        -- Only display if there are multiple textures
        if textureChoices and (choicesAmount > 1) then
            local mainOption = context:addOptionOnTop(getText("Modify Amputation (Texture)"))
            local mainMenu = ISContextMenu:getNew(context)
            context:addSubMenu(mainOption, mainMenu)

            -- List all skins in the submenu
            for i = 0, choicesAmount - 1 do
                local texturePath = textureChoices:get(i)
                local textureName = texturePath:match("([^/\\]+)$") or texturePath
                mainMenu:addOption(textureName, playerObj, setItemVisual, firstItem, i)
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)