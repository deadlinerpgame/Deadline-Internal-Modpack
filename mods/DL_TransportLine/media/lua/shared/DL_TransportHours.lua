DL_TransportHours = DL_TransportHours or {}
local H = DL_TransportHours

local function validHour(value)
    return type(value) == "number" and value >= 0 and value <= 23 and value == math.floor(value)
end

function H.isValid(hours)
    return type(hours) == "table" and validHour(hours.startHour)
        and validHour(hours.endHour) and hours.startHour ~= hours.endHour
end

function H.currentHour()
    return math.floor(getGameTime():getTimeOfDay()) % 24
end

-- Calendar day shown on the watch, game starts it at 0 so adding +1
function H.currentDay()
    return getGameTime():getDay() + 1
end

function H.isOpen(hours, hour, evenDays, oddDays)
    if (evenDays or oddDays) and H.currentDay() % 2 ~= (oddDays and 1 or 0) then return false end
    if hours == nil then return true end
    if not H.isValid(hours) then return false end
    hour = hour or H.currentHour()
    if hours.startHour < hours.endHour then
        return hour >= hours.startHour and hour < hours.endHour
    end
    return hour >= hours.startHour or hour < hours.endHour
end

function H.closedMessage(hours, evenDays, oddDays)
    if hours ~= nil and not H.isValid(hours) then return "Closed: invalid operating hours" end
    local text = hours and ("Closed: opens at " .. hours.startHour .. ", closes at " .. hours.endHour) or "Closed: open all hours"
    if evenDays or oddDays then
        text = text .. (oddDays and " on odd dates (1, 3, 5...)" or " on even dates (2, 4, 6...)")
    end
    return text
end
