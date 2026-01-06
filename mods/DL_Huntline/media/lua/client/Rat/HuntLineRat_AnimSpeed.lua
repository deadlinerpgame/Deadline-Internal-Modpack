HuntLineRat = HuntLineRat or {}

function HuntLineRat.setAnimSpeed(zed, int)
    if not int then
        int = HuntLineRat.getAnimSpeed(zed)
    end
    if zed:getVariableString('AnimSpeed') ~= tostring(int) then
        zed:setVariable('AnimSpeed', tonumber(int))
    end
end


function HuntLineRat.isZedOwner(user)
	if not user then user = getPlayer():getUsername() end
	local zInfo = getZombieInfo(zed)
	return zInfo.owner == user
end
function HuntLineRat.isDataSender(zed)
    if HuntLineRat.isAggro(zed) then
        return zed:getTarget() == true
    end
end

-- zed:isTargetVisible()

function HuntLineRat.getAnimSpeed(zed)
    local min = 1.5
    local max = 1.5
    local AnimSpeed = min
    if HuntLineRat.isAggro(zed) then
        local num = HuntLineRat.getOutfitNum(zed)
        if num == 0 then
            AnimSpeed = 1.5
        end
    end
    local res =  math.max(min, math.min(max, AnimSpeed)) or min
    return tonumber(res)
end


-----------------------            ---------------------------
function HuntLineRat.getMinAnimSpeed()
    return 1.5
end

function HuntLineRat.getMaxAnimSpeed()
    return 1.5
end
