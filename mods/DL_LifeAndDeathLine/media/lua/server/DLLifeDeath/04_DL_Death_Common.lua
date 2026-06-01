DL = DL or {}
DL.Death = DL.Death or {}
DL.Death._last = DL.Death._last or {}

local WINDOW_MS    = 30000
local HOURS_EPS    = 0.02

local function nowMs()
    if getTimestampMs then return getTimestampMs() end
    return (getTimestamp() or 0) * 1000
end

function DL.Death.firstFire(tag, character)
    local username = "?"
    pcall(function() if character and character.getUsername then username = tostring(character:getUsername()) end end)
    local hours = 0
    pcall(function() if character and character.getHoursSurvived then hours = character:getHoursSurvived() or 0 end end)
    local obj = tostring(character)

    local key = tostring(tag) .. "|" .. username
    local now = nowMs()
    local last = DL.Death._last[key]

    if last then

        if last.obj == obj then return false end

        if (now - last.t) < WINDOW_MS and hours >= (last.hours - HOURS_EPS) then
            return false
        end
    end

    DL.Death._last[key] = { t = now, hours = hours, obj = obj }
    return true
end

DL.log("death common loaded (two-stage death dedupe)")
