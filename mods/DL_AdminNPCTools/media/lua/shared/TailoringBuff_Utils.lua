TailoringBuff_Utils = {}
TailoringBuff_Utils.PATH = "JordansAdminTailor41_favoritergbs.txt"

function TailoringBuff_Utils.isAdmin(player)
    return player and (not isClient() or player:getAccessLevel() == "Admin")
end

function TailoringBuff_Utils.hasItem(player, item)
    return TailoringBuff_Utils.isAdmin(player) and item and player:getInventory():contains(item)
end

function TailoringBuff_Utils.getClothingItem(item)
    return item and item:getClothingItem() or nil
end

function TailoringBuff_Utils.canDye(player, item)
    local clothing = TailoringBuff_Utils.getClothingItem(item)
    return TailoringBuff_Utils.hasItem(player, item) and item:getVisual() and clothing and clothing:getAllowRandomTint()
end

function TailoringBuff_Utils.getTextures(player, item)
    if not (TailoringBuff_Utils.hasItem(player, item) and item:getVisual()) then return nil end
    local clothing = TailoringBuff_Utils.getClothingItem(item)
    return clothing and (clothing:hasModel() and clothing:getTextureChoices() or clothing:getBaseTextures()) or nil
end

function TailoringBuff_Utils.canTexture(player, item)
    local textures = TailoringBuff_Utils.getTextures(player, item)
    return textures and textures:size() > 1
end

function TailoringBuff_Utils.ensureFavoritesFile()
    if cacheFileExists(TailoringBuff_Utils.PATH) then return end
    local writer = getFileWriter(TailoringBuff_Utils.PATH, true, false)
    writer:write("0,0,0\n")
    writer:close()
end

function TailoringBuff_Utils.loadFavoriteColors()
    TailoringBuff_Utils.ensureFavoritesFile()
    local colors = {}
    local reader = getFileReader(TailoringBuff_Utils.PATH, true)
    local line = reader:readLine()
    while line do
        local r, g, b = line:match("(%d+),(%d+),(%d+)")
        if r and g and b then
            table.insert(colors, { r = tonumber(r), g = tonumber(g), b = tonumber(b) })
        end
        line = reader:readLine()
    end
    reader:close()
    return colors
end

function TailoringBuff_Utils.getClothingColor(item)
    local visual = item and item:getVisual()
    local clothing = TailoringBuff_Utils.getClothingItem(item)
    local tint = visual and clothing and visual:getTint(clothing)
    return tint and ColorInfo.new(tint:getRedFloat(), tint:getGreenFloat(), tint:getBlueFloat(), 1) or nil
end

function TailoringBuff_Utils.getTextureIndex(item)
    local visual = item and item:getVisual()
    local clothing = TailoringBuff_Utils.getClothingItem(item)
    if not (visual and clothing) then return 0 end
    return clothing:hasModel() and visual:getTextureChoice() or visual:getBaseTexture()
end

function TailoringBuff_Utils.clampRGB(value)
    value = tonumber(value) or 0
    return math.max(0, math.min(255, value))
end

function TailoringBuff_Utils.colorInfoToColor(info)
    return info and Color.new(info:getR(), info:getG(), info:getB(), 1) or nil
end

function TailoringBuff_Utils.applyPreviewColor(player, item, info)
    if not (TailoringBuff_Utils.canDye(player, item) and info) then return end
    local color = TailoringBuff_Utils.colorInfoToColor(info)
    item:setColor(color)
    item:getVisual():setTint(ImmutableColor.new(color))
    item:setCustomColor(true)
    item:synchWithVisual()
    if player:isEquipped(item) then player:resetModelNextFrame() end
end

function TailoringBuff_Utils.revertPreviewColor(player, item, info)
    TailoringBuff_Utils.applyPreviewColor(player, item, info)
end

function TailoringBuff_Utils.applyClothingTint(_, rgb, _, player, item)
    if not (TailoringBuff_Utils.canDye(player, item) and rgb) then return end
    local color = Color.new(rgb.r, rgb.g, rgb.b, 1)
    item:setColor(color)
    item:getVisual():setTint(ImmutableColor.new(color))
    item:setCustomColor(true)
    item:synchWithVisual()
    if player:isEquipped(item) then
        player:resetModelNextFrame()
        sendClothing(player)
    end
end

function TailoringBuff_Utils.applyPreviewTexture(player, item, index)
    if not (TailoringBuff_Utils.canTexture(player, item) and index) then return end
    local visual = item:getVisual()
    if TailoringBuff_Utils.getClothingItem(item):hasModel() then
        visual:setTextureChoice(index)
    else
        visual:setBaseTexture(index)
    end
    item:synchWithVisual()
    if player:isEquipped(item) then player:resetModelNextFrame() end
end

function TailoringBuff_Utils.revertPreviewTexture(player, item, index)
    TailoringBuff_Utils.applyPreviewTexture(player, item, index)
end

function TailoringBuff_Utils.applyTextureIndex(item, player, index)
    if not (TailoringBuff_Utils.canTexture(player, item) and index) then return end
    TailoringBuff_Utils.applyPreviewTexture(player, item, index)
    if player:isEquipped(item) then sendClothing(player) end
end

local function openPicker(initialColor, target, callback)
    local picker = ISColorPicker:new(getMouseX(), getMouseY())
    picker:initialise()
    picker.pickedTarget = target
    picker:setPickedFunc(function(_, rgb, _, pickedTarget)
        if rgb and pickedTarget then callback(pickedTarget, rgb) end
    end, target)
    picker:addToUIManager()
    picker:setInitialColor(initialColor)
end

function TailoringBuff_Utils.openClothingColorPicker(player, item, initialColor, window)
    if not (TailoringBuff_Utils.canDye(player, item) and initialColor and window) then return end
    openPicker(initialColor, window, function(target, rgb)
        target:setCurrentPreviewColor(ColorInfo.new(rgb.r, rgb.g, rgb.b, 1))
    end)
end

function TailoringBuff_Utils.openFavoritesColorPicker(initialColor, target, callback)
    if not (initialColor and target and callback) then return end
    openPicker(initialColor, target, callback)
end

return TailoringBuff_Utils
