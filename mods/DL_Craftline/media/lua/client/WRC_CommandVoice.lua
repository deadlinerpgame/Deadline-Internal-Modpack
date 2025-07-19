if not isClient() then return end -- only in MP



WRC = WRC or {}
WRC.Commands = WRC.Commands or {}
WRC.TabHandlers = WRC.TabHandlers or {}

function WRC.Commands.doTTS(args)

    local text = args:gsub("^%s*(.-)%s*$", "%1")
    if text == nil or text == "" then
        WL_Utils.addErrorToChat("You must provide text to use /tts.")
        return
    end

    local player = getPlayer()
    local inventory = player:getInventory()
    local equippedItem = player:getPrimaryHandItem()
    if not equippedItem or equippedItem:getType() ~= "HCWoodenwheelbarrow2" then
        WL_Utils.addErrorToChat("And how exactly do you plan to use Text To Speech?")
        return
    end

    local sayColor = WRC.Meta.GetSayColor()
    local emoteColor = WRC.Meta.GetEmoteColor()
    local playerName = player:getDescriptor():getForename()
    local player = getPlayer()
--    local message = string.format("%s types on the keyboard, and a robotic voice plays from the speakers, \"%s\"", playerName, text)
    local emote = text
    print(sayColor)
    local message = WRC.Parsing.PrependPlayerData(player, "/me types on the keyboard, and a robotic voice plays from the speakers, \"" .. emote)
    print(message)
    local xyRange = SandboxVars.WastelandRpChat.RangeXYSay or 20
    local zRange = SandboxVars.WastelandRpChat.RangeZSay or 1
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "TTSMachine", logText = message})
    processSayMessage(message)


end

WRC.SpecialCommands["/tts"] = {
    handler = "doTTS",
    tabHandlers = {},
    usage = "/tts",
    help = ".",
    adminOnly = false,
}