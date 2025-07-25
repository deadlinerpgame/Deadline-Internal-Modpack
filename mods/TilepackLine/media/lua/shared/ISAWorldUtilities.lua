local isa = require "ISAUtilities"

local WorldUtil = {}

WorldUtil.Types = {
    solarmod_tileset_01_0 = "Powerbank",
    solarmod_tileset_01_6 = "Panel",
    solarmod_tileset_01_7 = "Panel",
    solarmod_tileset_01_8 = "Panel",
    solarmod_tileset_01_9 = "Panel",
    solarmod_tileset_01_10 = "Panel",
    solarmod_tileset_01_15 = "Failsafe",
    solarmod_tileset_01_16 = "Powerbank",
}

function WorldUtil.getType(isoObject)
    return WorldUtil.Types[isoObject:getTextureName()]
end

function WorldUtil.objIsType(isoObject,modType)
    return WorldUtil.Types[isoObject:getTextureName()] == modType
end

function WorldUtil.getValidBackupArea(isoPlayer,level)
    local skillLevel = isoPlayer and isoPlayer:getPerkLevel(Perks.Electricity) or level or 3
    return { radius = skillLevel, levels = skillLevel > 5 and 1 or 0, distance = math.pow(skillLevel, 2) * 1.25 }
end

function WorldUtil.getLuaObjects(square,radius,level,distance)
    local banks = {}
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    for ix = x - radius, x + radius do
        for iy = y - radius, y + radius do
            for iz = z - level, z+level do
                local isquare = IsoUtils.DistanceToSquared(x,y,z,ix,iy,iz) <= distance and getSquare(ix, iy, iz)
                local pb
                if isquare then
                    if not isServer() then
                        pb = isa.PbSystem_client:getLuaObjectOnSquare(isquare)
                    else
                        pb = isa.PbSystem_server:getLuaObjectOnSquare(isquare)
                    end
                end
                if pb then
                    table.insert(banks,pb)
                end
            end
        end
    end
    return banks
end

function WorldUtil.findOnSquare(square,sprite)
    local special = square:getSpecialObjects()
    for i = 0, special:size()-1 do
        local obj = special:get(i)
        if obj:getTextureName() == sprite then
            return obj
        end
    end
end

function WorldUtil.findTypeOnSquare(square,type)
    local special = square:getSpecialObjects()
    for i = 0, special:size()-1 do
        local obj = special:get(i)
        if WorldUtil.Types[obj:getTextureName()] == type then
            return obj
        end
    end
    return nil
end

isa.WorldUtil = WorldUtil