local KBWB41 = require("KnoxBuildworks/Compat/B41")
local Mannequins = {}

local SPRITE_SCRIPTS = {
    location_shop_mall_01_65 = { script = "FemaleWhite01", facing = "SE" },
    location_shop_mall_01_66 = { script = "FemaleWhite02", facing = "S" },
    location_shop_mall_01_67 = { script = "FemaleWhite03", facing = "SE" },
    location_shop_mall_01_68 = { script = "MaleWhite01", facing = "SE" },
    location_shop_mall_01_69 = { script = "MaleWhite02", facing = "S" },
    location_shop_mall_01_70 = { script = "MaleWhite03", facing = "SE" },
    location_shop_mall_01_73 = { script = "FemaleBlack01", facing = "SE" },
    location_shop_mall_01_74 = { script = "FemaleBlack02", facing = "S" },
    location_shop_mall_01_75 = { script = "FemaleBlack03", facing = "SE" },
    location_shop_mall_01_76 = { script = "MaleBlack01", facing = "SE" },
    location_shop_mall_01_77 = { script = "MaleBlack02", facing = "S" },
    location_shop_mall_01_78 = { script = "MaleBlack03", facing = "SE" }
}

local DIRECTION_ORDER = { "N", "NW", "W", "SW", "S", "SE", "E", "NE" }
local DIRECTION_INDEX = { N = 1, NW = 2, W = 3, SW = 4, S = 5, SE = 6, E = 7, NE = 8 }

Mannequins.CONTAINER_TYPE = "mannequin"

function Mannequins.isMannequinSprite(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then return false end
    local sprite = getSprite(spriteName)
    if not sprite then return false end
    if IsoMannequin and IsoMannequin.isMannequinSprite then
        return IsoMannequin.isMannequinSprite(sprite) == true
    end
    local properties = sprite:getProperties()
    return properties ~= nil and KBWB41.propIs(properties, "CustomName") and KBWB41.propVal(properties, "CustomName") == "Mannequin"
end

function Mannequins.scriptForSprite(spriteName)
    local entry = type(spriteName) == "string" and SPRITE_SCRIPTS[spriteName] or nil
    return entry and entry.script or nil
end

function Mannequins.baseFacing(spriteName)
    local entry = type(spriteName) == "string" and SPRITE_SCRIPTS[spriteName] or nil
    return entry and entry.facing or "S"
end

function Mannequins.directionIndex(spriteName, nSprite)
    local base = DIRECTION_INDEX[Mannequins.baseFacing(spriteName)] or DIRECTION_INDEX.S
    local step = ((tonumber(nSprite) or 1) - 1) % 4
    return (base - 1 - step * 2) % 8
end

function Mannequins.direction(spriteName, nSprite)
    local name = DIRECTION_ORDER[Mannequins.directionIndex(spriteName, nSprite) + 1]
    return IsoDirections[name] or IsoDirections.S
end

function Mannequins.detect(spriteName)
    if not Mannequins.isMannequinSprite(spriteName) then return nil end
    if not Mannequins.scriptForSprite(spriteName) then return nil end
    return "mannequin"
end

function Mannequins.applyScript(mannequin, spriteName, scriptOverride)
    if not mannequin or not mannequin.setMannequinScriptName then return end
    local script = scriptOverride or Mannequins.scriptForSprite(spriteName)
    if type(script) ~= "string" or script == "" then return end
    local manager = getScriptManager and getScriptManager() or nil
    if manager and manager.getMannequinScript and not KBWB41.call(manager, "getMannequinScript", script) then return end
    mannequin:setMannequinScriptName(script)
end

function Mannequins.strip(mannequin)
    if not mannequin then return end
    local container = mannequin.getContainer and mannequin:getContainer() or nil
    if container then container:clear() end
    if mannequin.checkClothing then mannequin:checkClothing(nil) end
end

local previewItems = {}
local PREVIEW_FALLBACK_ITEMS = { "Base.Mov_MannequinMale", "Base.Mov_MannequinFemale" }

local function moveableForSprite(spriteName)
    local sprite = getSprite(spriteName)
    if not sprite then return nil end
    if ISMoveableSpriteProps then
        local props = ISMoveableSpriteProps.new(sprite)
        if props and props.isMoveable then
            local item = props:instanceItem(spriteName)
            if item and instanceof(item, "Moveable") then return item end
        end
    end
    for index = 1, #PREVIEW_FALLBACK_ITEMS do
        local item = instanceItem(PREVIEW_FALLBACK_ITEMS[index])
        if item and instanceof(item, "Moveable") and item:ReadFromWorldSprite(spriteName) then return item end
    end
    return nil
end

function Mannequins.previewItem(spriteName)
    if not IsoMannequin or not Mannequins.scriptForSprite(spriteName) then return nil end
    local cached = previewItems[spriteName]
    if cached ~= nil then
        if cached == false then return nil end
        return cached
    end
    local item = moveableForSprite(spriteName)
    if not item then
        previewItems[spriteName] = false
        return nil
    end
    previewItems[spriteName] = false
    local mannequin = IsoMannequin.new(getCell(), nil, getSprite(spriteName))
    Mannequins.applyScript(mannequin, spriteName)
    Mannequins.strip(mannequin)
    mannequin:setCustomSettingsToItem(item)
    previewItems[spriteName] = item
    return item
end

function Mannequins.renderPreview(spriteName, x, y, z, nSprite)
    if not IsoMannequin or not IsoMannequin.renderMoveableItem then return false end
    local item = Mannequins.previewItem(spriteName)
    if not item then return false end
    IsoMannequin.renderMoveableItem(item, x, y, z, Mannequins.direction(spriteName, nSprite))
    return true
end

return Mannequins
