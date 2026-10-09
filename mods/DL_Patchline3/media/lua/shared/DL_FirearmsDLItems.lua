require "JayFirearmsUtil"

local function baseType(itemType)
    return (itemType:gsub("^DL", ""))
end

local function spriteProxy(weap)
    return {
        getType = function() return baseType(weap:getType()) end,
        getWeaponSprite = function() return weap:getWeaponSprite() end,
        setWeaponSprite = function(_, spriteName) weap:setWeaponSprite(spriteName) end,
    }
end

local changeWeapSprite = JFAUtil.ChangeWeapSprite
JFAUtil.ChangeWeapSprite = function(weap, part, isRemove)
    local partType = type(part) == "string" and part or part:getType()
    return changeWeapSprite(spriteProxy(weap), baseType(partType), isRemove)
end

JFAUtil.RefreshWeapSprite = function(weap)
    local pad = weap:getRecoilpad()
    if pad and baseType(pad:getType()) == "FiberglassStock" then
        return JFAUtil.ChangeWeapSprite(weap, pad, false)
    end
    return false
end

local getBayonetTypeForGun = JFAUtil.GetBayonetTypeForGun
JFAUtil.GetBayonetTypeForGun = function(gun)
    return getBayonetTypeForGun({ getType = function() return baseType(gun:getType()) end })
end
