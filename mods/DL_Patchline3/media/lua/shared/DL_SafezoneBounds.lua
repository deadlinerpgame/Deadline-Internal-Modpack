if not getActivatedMods():contains("WastelandSafezone_DL") then return end

DLSafezoneBounds = {
    areas = {
    },
    message = "Safezones can only be created inside the allowed area.",
}

function DLSafezoneBounds.contains(x1, y1, x2, y2)
    if #DLSafezoneBounds.areas == 0 then return true end
    local minX, maxX = math.min(x1, x2), math.max(x1, x2)
    local minY, maxY = math.min(y1, y2), math.max(y1, y2)
    for _, area in ipairs(DLSafezoneBounds.areas) do
        if minX >= math.min(area.x1, area.x2) and maxX <= math.max(area.x1, area.x2)
            and minY >= math.min(area.y1, area.y2) and maxY <= math.max(area.y1, area.y2) then
            return true
        end
    end
    return false
end

function DLSafezoneBounds.allowed(player, x1, y1, x2, y2)
    return WL_Utils.isStaff(player) or DLSafezoneBounds.contains(x1, y1, x2, y2)
end

local function patchSystem()
    local createZone = WSZ_System.createZone
    function WSZ_System:createZone(player, name, bounds)
        if not isClient() and not DLSafezoneBounds.allowed(player, bounds.x1, bounds.y1, bounds.x2, bounds.y2) then
            self:logInfo("Zone rejected: '" .. tostring(name) .. "' by " .. player:getUsername() .. " is outside the allowed safezone area")
            return
        end
        return createZone(self, player, name, bounds)
    end
end

Events.OnGameBoot.Add(patchSystem)
