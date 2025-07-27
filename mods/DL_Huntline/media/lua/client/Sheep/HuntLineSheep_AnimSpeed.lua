HuntLineSheep = HuntLineSheep or {}

function HuntLineSheep.setAnimSpeed(zed, int)
    if not int then
        int = HuntLineSheep.getAnimSpeed(zed)
    end
    if zed:getVariableString('AnimSpeed') ~= tostring(int) then
        zed:setVariable('AnimSpeed', tonumber(int))
    end
end


function HuntLineSheep.isZedOwner(user)
	if not user then user = getPlayer():getUsername() end
	local zInfo = getZombieInfo(zed)
	return zInfo.owner == user
end
function HuntLineSheep.isDataSender(zed)
    if HuntLineSheep.isAggro(zed) then
        return zed:getTarget() == true
    end
end

-- zed:isTargetVisible()

function HuntLineSheep.getAnimSpeed(zed)
    local min = 0.75
    local max = 0.75
    local AnimSpeed = min
    if HuntLineSheep.isAggro(zed) then
        local num = HuntLineSheep.getOutfitNum(zed)
        if num == 0 then
            AnimSpeed = 1
        end
    end
    local res =  math.max(min, math.min(max, AnimSpeed)) or min
    return tonumber(res)
end


-----------------------            ---------------------------
function HuntLineSheep.getMinAnimSpeed()
    return 1
end

function HuntLineSheep.getMaxAnimSpeed()
    return 1
end
