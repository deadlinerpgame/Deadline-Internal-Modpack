if isClient() and not isServer() then return end
DL = DL or {}
DL.Death = DL.Death or {}
DL.Death._last = DL.Death._last or {}

local SAME_DEATH_MS = 15000

local function nowMs()
    if getTimestampMs then return getTimestampMs() end
    return (getTimestamp() or 0) * 1000
end

local function nameOf(character)
    local u = "?"
    pcall(function() if character and character.getUsername then u = tostring(character:getUsername()) end end)
    return u
end

function DL.Death.firstFire(tag, character)
    local username = nameOf(character)
    local key = tostring(tag) .. "|" .. username
    local now = nowMs()
    local last = DL.Death._last[key]
    if last ~= nil and (now - last) < SAME_DEATH_MS then
        DL.log("death dedupe: '" .. username .. "' " .. tostring(tag)
            .. " -> DUPLICATE (" .. tostring(now - last) .. "ms after first; suppressed)")
        return false
    end
    DL.Death._last[key] = now
    DL.log("death dedupe: '" .. username .. "' " .. tostring(tag) .. " -> FIRST (processing)")
    return true
end

DL.log("death common loaded (time-window dedupe, " .. tostring(SAME_DEATH_MS / 1000) .. "s)")
