HuntLineSheep = HuntLineSheep or {}
local Commands = {};
Commands.HuntLineSheep = {};

HuntLineSheep.skin0 = 'Base.AnimalSheep'


-----------------------            ---------------------------
function HuntLineSheep.getTargetedZombie(pl)
    local zombies = getCell():getZombieList()
    local targetedZombie = nil
    for i = 0, zombies:size() - 1 do
        local zed = zombies:get(i)
		if HuntLineSheep.isTarg(pl, zed) then
            targetedZombie = zed
            break
        end
    end

    return targetedZombie
end


function HuntLineSheep.getDistanceBetween(pl, zed)
    local plX, plY = pl:getX(), pl:getY()
    local zedX, zedY = zed:getX(), zed:getY()
    return math.sqrt((plX - zedX) ^ 2 + (plY - zedY) ^ 2)
end

function HuntLineSheep.getFov()
    return 90
end

function HuntLineSheep.isTarg(pl, targ)
	local fov = HuntLineSheep.getFov()
    local plX, plY = pl:getX(), pl:getY()
    local targX, targY = targ:getX(), targ:getY()

    local targDirX = targX - plX
    local targDirY = targY - plY

	--print(pl:getDotWithForwardDirection(targ:getX(), targ:getY()))
	--local fVec = pl:getForwardDirection()

	 local aimAngle = pl:getLookAngleRadians()

	--local angle = pl:getDirectionAngle()
    local angle = math.atan2(targDirY, targDirX)

    local angleDiff = math.abs(aimAngle - angle)


    if angleDiff > math.pi then
        angleDiff = 2 * math.pi - angleDiff
    end

    local fovInRadians = math.rad(fov) / 2

	--print(angleDiff)
	--print(fovInRadians)

	--print(angle)

    return angleDiff <= fovInRadians
end
