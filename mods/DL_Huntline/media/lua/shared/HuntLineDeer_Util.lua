
HuntLineDeer = HuntLineDeer or {}

function HuntLineDeer.findzedID(int)
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if instanceof(zed, "IsoZombie") then
			local zedID=zed:getOnlineID()
			if zedID and zedID == int then return zed end
		end
	end
	return nil
end

function HuntLineDeer.normalizeTo100(x, min, max)
    x = math.max(min, math.min(x, max))
    return ((x - min) / (max - min)) * 100
end

-----------------------            ---------------------------
function HuntLineDeer.checkDist(pl, zed)
	local dist = pl:DistTo(zed:getX(), zed:getY())
    return math.floor(dist)
end

function HuntLineDeer.isWithinRange(pl, zed, range)
	local dist = pl:DistTo(zed:getX(), zed:getY())
    return dist <= range
end

function HuntLineDeer.isClosestPl(pl, zed)
	if not HuntLineDeer.isDeerAnimal(zed) then return end
	local plDist = HuntLineDeer.checkDist(pl, zed)
	local compare = round(zed:distToNearestCamCharacter())
	if plDist == compare then
		return true
	end
	return false
end
