DL = DL or {}

if ISTimedActionQueue == nil then return end

local _origAdd = ISTimedActionQueue.add
ISTimedActionQueue.add = function(action)
    local p = getPlayer()
    if p ~= nil then
        local md = p:getModData()
        if md and md.dl_downed and not (action and action.dlBypassLockout) then
            return
        end
    end
    return _origAdd(action)
end

DL.log("knockdown lockout loaded (no object/vehicle/inventory interaction while downed)")
