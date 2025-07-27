HuntLineSheep = HuntLineSheep or {}

function HuntLineSheep.isCrawler(zed)
	return zed:isCrawling()
end

function HuntLineSheep.setCrawler(zed)
    if not zed:isCrawling() then
		zed:toggleCrawling()
		if not zed:isCrawling() then
			--zed:setFallOnFront(true)
			zed:knockDown(true)
		end
		zed:setCanWalk(false)
		if not zed:isCrawling() then
			zed:setVariable('bbecomecrawler', 'true')
		end
		zed:setCanCrawlUnderVehicle(false)
    end

	local fitNum = tonumber(HuntLineSheep.getOutfitCrawlType(zed))
	local crawlType = zed:getCrawlerType()
	if fitNum ~= crawlType and (fitNum == 1 or  fitNum == 2) then
		zed:setCrawlerType(fitNum)
	end
	HuntLineSheep.setAnimSpeed(zed, HuntLineSheep.getMinAnimSpeed())
end


function HuntLineSheep.isWalkable(sq)
    if not sq then return false end
    if sq:isSolid() then return false end
    if sq:isSolidTrans() then return false end
    if sq:Is(IsoFlagType.water) then return false end
    --if not square:isNotBlocked(false) then return false end
    return true
end

function HuntLineSheep.stopWalking(targ)
	targ:getPathFindBehavior2():reset();
end



function HuntLineSheep.isStepped(zed)
	return zed:isBeingSteppedOn()
end





function HuntLineSheep.isShouldStand(zed)
	if not zed:isBeingSteppedOn() then
		if zed:isCanWalk() then return true end
		if zed:isFakeDead() then return true end
		if zed:isForceEatingAnimation() then return true end
		if zed:isOnFloor() then return true end
		if zed:isCrawling() then return true end
		if zed:isUseless() then return true end
		if zed:isSitAgainstWall() then return true end
	end
    return false
end

function HuntLineSheep.setStand(zed)
    if not zed:isCanWalk() then
        zed:setCanWalk(true)
    end
    if zed:isFakeDead() or zed:isCurrentState(FakeDeadZombieState.instance())  then
        zed:setFakeDead(false)
		zed:setForceFakeDead(false);
    end
    if zed:isForceEatingAnimation() then
        zed:setForceEatingAnimation(false)
    end
    if zed:isSitAgainstWall() then
        zed:setSitAgainstWall(false)
    end
    if zed:isCrawling() then
        zed:toggleCrawling()
		zed:setCrawler(false)
    end
	if zed:isOnFloor() then
		zed:knockDown(false)
		zed:changeState(ZombieGetUpState.instance())
	end
	if zed:isUseless() then
		zed:setUseless(false)
	end
	zed:setOnFloor(false);
end

function HuntLineSheep.getWalkType(zed)
	return tostring(zed:getVariableString("zombieWalkType"))
end

function HuntLineSheep.getWalkNum(zed)
	local walk = HuntLineSheep.getWalkType(zed)
	return tonumber(walk:match("%d+"))
end

function HuntLineSheep.isSprinter(zed)
	local walk = HuntLineSheep.getWalkType(zed)
	if walk then
		if tostring(walk:contains('sprint')) or luautils.stringStarts(walk, "sprint") then
			return true
		end
	end
	return false
end



function HuntLineSheep.normalize(x, min, max)
    x = math.max(min, math.min(x, max))
    return ((x - min) / (max - min)) * 100
end


function HuntLineSheep.setTurnSpeed(zed, int)
	if zed:getTurnDelta() ~= int  then
		zed:setTurnDelta(int)
	end
end
function HuntLineSheep.isMoving(zed)
	if not zed then return false end
	if not HuntLineSheep.isSheepAnimal(zed) then return false end
	if zed:getVariableBoolean('bMoving') then
		return true
	end
end
--math.max(0, math.min(100, res))

function HuntLineSheep.turnAround(targ)
	local x = targ:getX()
	local y = targ:getY()
	local offsetX = targ:getForwardDirection():getX() * 2
	local offsetY = targ:getForwardDirection():getY() * 2
	targ:faceLocation(x - offsetX, y - offsetY)
end

function HuntLineSheep.checkWalkableSq()
	local pl = getPlayer()
	local plSq = pl:getSquare()
	local rmSqs = plSq:getRoom():getSquares()
	if not pl:isOutside() then
		for i=0, rmSqs:size()-1 do
			local rmSq = rmSqs:get(i)
			local tab = {
				rmSq:getN(),
				rmSq:getS(),
				rmSq:getE(),
				rmSq:getW(),
			}
			for _, testSq in ipairs(tab) do
				if testSq  then
					local isGood = false
					if HuntLineSheep.isWalkable(testSq) then
						isGood = true
					end
					HuntLineSheep.TempMarker(testSq, isGood)
				end
			end
		end
	end
end

function HuntLineSheep.moveToXYZ(zed, x, y, z)
	--zed:pathToLocation(x, y, z)
	zed:getPathFindBehavior2():pathToLocation(x, y, z)
	local sq = getCell():getOrCreateGridSquare(x, y, z)
	if not sq:TreatAsSolidFloor() and sq:getZ() == zed:getZ() then
		zed:setVariable("bPathfind", false)
		zed:setVariable("bMoving", true)
	end
end
