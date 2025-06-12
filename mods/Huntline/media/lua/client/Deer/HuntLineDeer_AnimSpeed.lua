HuntLineDeer = HuntLineDeer or {}

function HuntLineDeer.setAnimSpeed(zed, int)
    if not int then
        int = HuntLineDeer.getAnimSpeed(zed)
    end
    if zed:getVariableString('AnimSpeed') ~= tostring(int) then
        zed:setVariable('AnimSpeed', tonumber(int))
    end
end


function HuntLineDeer.isZedOwner(user)
	if not user then user = getPlayer():getUsername() end
	local zInfo = getZombieInfo(zed)
	return zInfo.owner == user
end
function HuntLineDeer.isDataSender(zed)
    if HuntLineDeer.isAggro(zed) then
        return zed:getTarget() == true
    end
end

-- zed:isTargetVisible()

function HuntLineDeer.getAnimSpeed(zed)
    local min = 0.75
    local max = 0.75
    local AnimSpeed = min
    if HuntLineDeer.isAggro(zed) then
        local num = HuntLineDeer.getOutfitNum(zed)
        if num == 0 then
            AnimSpeed = 1
        end
    end
    local res =  math.max(min, math.min(max, AnimSpeed)) or min
    return tonumber(res)
end


-----------------------            ---------------------------
function HuntLineDeer.getMinAnimSpeed()
    return 1
end

function HuntLineDeer.getMaxAnimSpeed()
    return 1
end
