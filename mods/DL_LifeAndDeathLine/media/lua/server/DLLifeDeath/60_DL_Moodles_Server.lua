if isClient() and not isServer() then return end
DL = DL or {}

local function strikeCount(username, now)
    local windowMs = ((DL.Config and DL.Config.knockdownWindowSec) or 300) * 1000
    local f = (DL.Paths and DL.Paths.knockStrikeFile) and DL.Paths.knockStrikeFile(username) or nil
    local c = 0
    if f then
        local raw = DL.Files.readString(f)
        if raw and raw ~= "" then
            for t in string.gmatch(raw, "[^,]+") do
                local n = tonumber(t)
                if n and (now - n) < windowMs then c = c + 1 end
            end
        end
    end
    return c
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLMoodle" or player == nil then return end
    if command == "statusrequest" then
        local u = player:getUsername()
        local w = (DL.Wounds and DL.Wounds.get and DL.Wounds.get(u)) or 0
        local k = strikeCount(u, getTimestampMs())
        sendServerCommand(player, "DLMoodle", "status", { w = w, k = k })
    end
end)

DL.log("moodle server loaded (wound + strike status replies)")
