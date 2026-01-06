-- Only MP
if not isServer() or isClient() then return end

local PlayerDB = {}

local function doRadioLog(sendingPlayer, args)
    local username = sendingPlayer:getUsername()

    local x, y, z, text, lang = args[1], args[2], args[3], args[4], args[5]
    local logMessage = string.format("%s (%s) %s", username, lang, text)
    writeLog("RadioChat", logMessage)
end


local function onWRCCommand2(module, command, sendingPlayer, args)
    if module ~= "WRC" then return end

    if command == "doRadioLog" then
        doRadioLog(sendingPlayer, args)
    end
end

Events.OnClientCommand.Add(onWRCCommand2)