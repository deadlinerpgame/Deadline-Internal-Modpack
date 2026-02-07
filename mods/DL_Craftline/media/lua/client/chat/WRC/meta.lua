if not isClient() then return end -- only in MP

require "WL_Utils"

WRC = WRC or {}
WRC.Meta = WRC.Meta or {}

WRC.Meta.DisableOverride = false
WRC.Meta.LastChat = nil
WRC.Meta.ChatPreferences = WRC.Meta.ChatPreferences or {
    SayColor = WRC.ChatColors["text"],
    EmoteColor = WRC.ChatColors["emote"],
    DoColor = WRC.ChatColors["environment"],
    OocColor = WRC.ChatColors["ooc"],
    WhisperVolumeColor = WRC.ChatColors["volumeprefixes"]["whisper"],
    LowVolumeColor = WRC.ChatColors["volumeprefixes"]["low"],
    SayVolumeColor = WRC.ChatColors["volumeprefixes"]["say"],
    LoudVolumeColor = WRC.ChatColors["volumeprefixes"]["loud"],
    ShoutVolumeColor = WRC.ChatColors["volumeprefixes"]["shout"],
    UnreadTabTextColor = {r = 0, g = 0, b = 0},
    UnreadTabBackgroundColor = {r = 1, g = 0, b = 0},
    UnreadTabBlinking = true,
    OverheadTypingIndicator = true,
    SaveLastChat = false,
}

local function changeModifer(modifer, enable)
    local args = {}
    if enable then
        args[1] = "enable"
    else
        args[1] = "disable"
    end
    args[2] = modifer
    sendClientCommand(getPlayer(), "WRC", "SetModifier", args)
end

local function getModifier(username, modifier)
    if not WRC.PlayerModifiers[username] then return false end
    if not WRC.PlayerModifiers[username][modifier] then return false end
    return true
end

-- Writes the WRC.Meta.ChatPreferences to a WRC_ChatPreferences.txt file
-- key1=value1
-- key2=value2
-- ...
local function writeChatPrefs()
    local file = getFileWriter("WRC_ChatPreferences.txt", true, false)
    if not file then return end
    for k, v in pairs(WRC.Meta.ChatPreferences) do
        if type(v) == "boolean" then
            v = tostring(v)
        elseif type(v) == "table" and v.r ~= nil and v.g ~= nil and v.b ~= nil then
            v = v.r .. "," .. v.g .. "," .. v.b
        elseif type(v) == "number" then
            v = tostring(v)
        elseif type(v) == "string" then
            -- do nothing
        else
            print("WRC: Unknown type for chat preference " .. k .. ": " .. type(v))
            v = ""
        end
        file:write(k .. "=" .. v .. "\n")
    end
    file:close()
end

-- Updates WRC.Meta.ChatPreferences then writes it
local function writeChatPref(preference, value)
    WRC.Meta.ChatPreferences[preference] = value
    writeChatPrefs()
end

local function getChatPref(preference)
    return WRC.Meta.ChatPreferences[preference]
end

-- Reads the WRC.Meta.ChatPreferences from a WRC_ChatPreferences.txt file
local function readChatPrefs()
    local file = getFileReader("WRC_ChatPreferences.txt", false)
    if not file then return end
    local line = file:readLine()
    while line do
        local split = string.split(line, "=")
        if #split == 2 then
            local val = split[2]
            -- true/false
            if val == "true" then
                val = true
            elseif val == "false" then
                val = false
            else
                local r, g, b = val:match("^(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)$")
                if r and g and b then
                    local rgb = string.split(val, ",")
                    val = {r = tonumber(rgb[1]), g = tonumber(rgb[2]), b = tonumber(rgb[3])}
                -- number
                elseif val:match("^%d+$") then
                    val = tonumber(val)
                end
            end
            WRC.Meta.ChatPreferences[split[1]] = val
        end
        line = file:readLine()
    end
    file:close()
end

function WRC.Meta.GetKnownLanguages()
    local md = getPlayer():getModData()
    local numKnown = md["WRC_NumKnownLanguages"] or 0
    if numKnown == 0 then
        md["WRC_NumKnownLanguages"] = 1
        md["WRC_KnownLanguage1"] = "en"
        return {"en"}
    end
    local languages = {}
    for i=1, numKnown do
        table.insert(languages, md["WRC_KnownLanguage" .. i])
    end
    return languages
end

function WRC.Meta.AddLanguageTo(username, language)
    local args = {}
    args[1] = username
    args[2] = language
    -- TODO move this
    sendClientCommand(getPlayer(), "WRC", "AddKnownLanguage", args)
end

function WRC.Meta.RemoveLanguageFrom(username, language)
    local args = {}
    args[1] = username
    args[2] = language
    sendClientCommand(getPlayer(), "WRC", "RemoveKnownLanguage", args)
end

local function writeLanguages(languages)
    local md = getPlayer():getModData()
    local numKnown = #languages
    if numKnown == 0 then
        numKnown = 1
        md["WRC_KnownLanguage1"] = "en"
        return
    end
    md["WRC_NumKnownLanguages"] = numKnown
    for i=1, numKnown do
        md["WRC_KnownLanguage" .. i] = languages[i]
    end
end

function WRC.Meta.AddKnownLanguage(language)
    local languages = WRC.Meta.GetKnownLanguages()
    for i=1, #languages do
        if languages[i] == language then
            return
        end
    end
    table.insert(languages, language)
    writeLanguages(languages)
end

function WRC.Meta.RemoveKnownLanguage(language)
    local md = getPlayer():getModData()
    local known = WRC.Meta.GetKnownLanguages()
    local toKeep = {}
    for i=1, #known do
        if known[i] ~= language then
            table.insert(toKeep, known[i])
        end
    end
    writeLanguages(toKeep)
end

function WRC.Meta.CanSpeak(language)
    if WRC.Override() then return true end
    local known = WRC.Meta.GetKnownLanguages()
    for i=1, #known do
        if known[i] == language then
            return true
        end
    end
    return false
end

function WRC.Meta.CanUnderstand(language)
    if WRC.Override() then return true end
    local known = WRC.Meta.GetKnownLanguages()
    for i=1, #known do
        if known[i] == language then
            return true
        end
    end
    return false
end

function WRC.Meta.CanPartiallyUnderstand(language)
    if WRC.Override() then return true end
    local known = WRC.Meta.GetKnownLanguages()
    for _, l in ipairs(known) do
        for _, partialLanguage in ipairs(WRC.Languages[l].canPartiallyUnderstand) do
            if partialLanguage == language then
                return true
            end
        end
    end
    return false
end

--- @param username string
function WRC.Meta.GetCurrentLanguage(username)
    if WRC.PlayerLanguages and WRC.PlayerLanguages[username] then
        return WRC.PlayerLanguages[username]
    end
    return "en"
end

function WRC.Meta.SetCurrentLanguage(language)
    local args = {}
    args[1] = language
    sendClientCommand(getPlayer(), "WRC", "SetPlayerLanguage", args)
end

function WRC.Meta.IsInRange(myPlayer, chattingPlayer, xyRange, zRange)
    if WRC.Override() then return true end

    xyRange = xyRange + 0.99
    if myPlayer:getDistanceSq(chattingPlayer) > xyRange * xyRange or math.abs(myPlayer:getZ() - chattingPlayer:getZ()) > zRange then
        return false
    end

    return true
end

function WRC.Meta.IsInPosRange(myPlayer, pos, xyRange, zRange)
    if WRC.Override() then return true end

    xyRange = xyRange + 0.99

    local xDist = myPlayer:getX() - pos.x
    local yDist = myPlayer:getY() - pos.y
    local zDist = math.abs(myPlayer:getZ() - pos.z)
    local xyDistSq = xDist * xDist + yDist * yDist

    if xyDistSq > xyRange * xyRange or zDist > zRange then
        return false
    end

    return true
end

function WRC.Meta.GetStatus(username)
    local status = nil
    if WRC.PlayerStatus and WRC.PlayerStatus[username] then
        status = WRC.PlayerStatus[username]
    end
    return status
end

function WRC.Meta.SetStatus(status)
    local args = {}
    args[1] = status
    sendClientCommand(getPlayer(), "WRC", "SetPlayerStatus", args)
end

function WRC.Meta.GetName(username)
    local name = username
    if WRC.PlayerNames and WRC.PlayerNames[username] then
        name = WRC.PlayerNames[username]
    end
	return name
end

function WRC.Meta.SetName(newName)
    local player = getPlayer()
    player:getDescriptor():setForename(newName)
    player:getDescriptor():setSurname("")
    sendPlayerStatsChange(player)
    local args = {}
    args[1] = newName
    sendClientCommand(player, "WRC", "SetPlayerName", args)
end

function WRC.Meta.GetNameColor(username)
    local c = WRC.ChatColors["playerDefault"]
    if WRC.PlayerColors and WRC.PlayerColors[username] then
        c = WRC.PlayerColors[username]
    end
    return "<RGB:" .. c.r .. "," .. c.g .. "," .. c.b .. ">"
end

function WRC.Meta.GetNameColorRGB(username)
    local c = WRC.ChatColors["playerDefault"]
    if WRC.PlayerColors and WRC.PlayerColors[username] then
        c = WRC.PlayerColors[username]
    end
    return c
end

function WRC.Meta.SetNameColor(r, g, b)
    local args = {}
    args[1] = r
    args[2] = g
    args[3] = b
    sendClientCommand(getPlayer(), "WRC", "SetPlayerColor", args)
end

function WRC.Meta.GetSayColor()
    return getChatPref("SayColor")
end

function WRC.Meta.SetSayColor(color)
    writeChatPref("SayColor", color)
end

function WRC.Meta.GetEmoteColor()
    return getChatPref("EmoteColor")
end

function WRC.Meta.SetEmoteColor(color)
    writeChatPref("EmoteColor", color)
end

function WRC.Meta.GetDoColor()
    return getChatPref("DoColor")
end

function WRC.Meta.SetDoColor(doColor)
    writeChatPref("DoColor", doColor)
end

function WRC.Meta.GetOocColor()
    return getChatPref("OocColor")
end

function WRC.Meta.SetOocColor(color)
    writeChatPref("OocColor", color)
end

function WRC.Meta.GetWhisperVolumeColor()
    return getChatPref("WhisperVolumeColor")
end

function WRC.Meta.SetWhisperVolumeColor(color)
    writeChatPref("WhisperVolumeColor", color)
end

function WRC.Meta.GetLowVolumeColor()
    return getChatPref("LowVolumeColor")
end

function WRC.Meta.SetLowVolumeColor(color)
    writeChatPref("LowVolumeColor", color)
end

function WRC.Meta.GetSayVolumeColor()
    return getChatPref("SayVolumeColor")
end

function WRC.Meta.SetSayVolumeColor(color)
    writeChatPref("SayVolumeColor", color)
end

function WRC.Meta.GetLoudVolumeColor()
    return getChatPref("LoudVolumeColor")
end

function WRC.Meta.SetLoudVolumeColor(color)
    writeChatPref("LoudVolumeColor", color)
end

function WRC.Meta.GetShoutVolumeColor()
    return getChatPref("ShoutVolumeColor")
end

function WRC.Meta.SetShoutVolumeColor(color)
    writeChatPref("ShoutVolumeColor", color)
end

function WRC.Meta.EnableSaveLastChat()
    writeChatPref("SaveLastChat", true)
end

function WRC.Meta.DisableSaveLastChat()
    writeChatPref("SaveLastChat", false)
end

function WRC.Meta.IsSaveLastChatEnabled()
    return getChatPref("SaveLastChat")
end

WRC.Meta.FocusedPersons = WRC.Meta.FocusedPersons or {}

function WRC.Meta.FocusOn(username)
    if not WRC.Meta.FocusedPersons then
        WRC.Meta.FocusedPersons = {}
    end

    if WRC.Meta.IsFocusedOn(username) then return end

    table.insert(WRC.Meta.FocusedPersons, username)
end

function WRC.Meta.UnfocusOn(username)
    if not WRC.Meta.FocusedPersons then
        WRC.Meta.FocusedPersons = {}
    end
    local newFocused = {}
    for i=1, #WRC.Meta.FocusedPersons do
        if WRC.Meta.FocusedPersons[i] ~= username then
            table.insert(newFocused, WRC.Meta.FocusedPersons[i])
        end
    end
    WRC.Meta.FocusedPersons = newFocused
end

function WRC.Meta.HasFocus()
    if not WRC.Meta.FocusedPersons then
        WRC.Meta.FocusedPersons = {}
    end
    return #WRC.Meta.FocusedPersons > 0
end

function WRC.Meta.IsFocusedOn(username)
    if not WRC.Meta.FocusedPersons then
        WRC.Meta.FocusedPersons = {}
    end
    for i=1, #WRC.Meta.FocusedPersons do
        if WRC.Meta.FocusedPersons[i] == username then
            return true
        end
    end
    return false
end

function WRC.Meta.InvitePrivate(username)
    if not username then return false end
    local target = getPlayerFromUsername(username)
    if not target or target == getPlayer() then return false end
    if getPlayer():getDistanceSq(target) > 100 then return false end -- 10 tiles
    if WRC.Meta.PrivateWith then return false end
    sendClientCommand(getPlayer(), "WRC", "InvitePrivate", {username})
    WL_Utils.addInfoToChat("You have invited " .. WRC.Meta.GetName(username) .. " to a private chat.")
    return true
end

function WRC.Meta.OnPrivateInvite(otherUser)
    local w = 300
    local h = 200
    local x = getCore():getScreenWidth() / 2 - w / 2
    local y = getCore():getScreenHeight() / 2 - h / 2
    local othersName = WRC.Meta.GetName(otherUser)
    local dialog = ISModalDialog:new(x, y, w, h, "Start private chat with " .. othersName .. "?", true, otherUser, WRC.Meta.OnPrivateInviteResponse)
    dialog:initialise()
    dialog:addToUIManager()
end

function WRC.Meta.OnPrivateInviteResponse(otherUser, button)
    if button.internal == "YES" then
        WRC.Meta.StartPrivate(otherUser)
        ISChat.instance.panel:activateView("Private")
        WL_Utils.addInfoToChat("Private chat started with " .. WRC.Meta.GetName(otherUser) .. ".")
        sendClientCommand(getPlayer(), "WRC", "AcceptPrivateInvite", {otherUser})
    else
        sendClientCommand(getPlayer(), "WRC", "DeclinePrivateInvite", {otherUser})
    end
end

function WRC.Meta.StartPrivate(username)
    WRC.Meta.PrivatePartner = username
    WRC.Meta.ShowPrivateChat = true
end

function WRC.Meta.StopPrivate(skipSend)
    if not skipSend and WRC.Meta.PrivatePartner then
        sendClientCommand(getPlayer(), "WRC", "StopPrivate", {WRC.Meta.PrivatePartner})
    end
    WRC.Meta.PrivatePartner = nil
end

function WRC.Meta.ClosePrivate()
    ISChat.instance.panel:activateView("Private")
    ISChat.instance:onContextClear()
    WRC.Meta.ShowPrivateChat = false
    ISChat.instance.panel:activateView("General")
end

function WRC.Meta.HasPrivate(simple)
    if simple and WRC.Meta.ShowPrivateChat then return true end
    if not WRC.Meta.PrivatePartner then return false end
    local others = WRC.GetAllPlayersInRange(10, 0)
    if #others ~= 1 or others[1]:getUsername() ~= WRC.Meta.PrivatePartner then return false end
    return true
end

function WRC.Meta.EnableAdminHammer()
    if not WL_Utils.canModerate(getPlayer()) then return end
    changeModifer("adminHammer", true)
end

function WRC.Meta.DisableAdminHammer()
    changeModifer("adminHammer", false)
end

function WRC.Meta.HasAdminHammer(username)
    return getModifier(username, "adminHammer")
end

function WRC.Meta.EnableAfk()
    changeModifer("afk", true)
end

function WRC.Meta.DisableAfk()
    changeModifer("afk", false)
end

function WRC.Meta.IsAfk(username)
    return getModifier(username, "afk")
end

function WRC.Meta.GetUnreadTabOptions()
    local textColor = getChatPref("UnreadTabTextColor")
    local backgroundColor = getChatPref("UnreadTabBackgroundColor")
    local blinking = getChatPref("UnreadTabBlinking")
    return textColor, backgroundColor, blinking
end

function WRC.Meta.SetUnreadTabTextColor(color)
    if not color or color == "" then
        writeChatPref("UnreadTabTextColor", nil)
        WL_Utils.addInfoToChat("Unread tab text color reset to default.")
        return
    end
    local colorVals = WRC.GetColor(color)
    if not colorVals then return end
    writeChatPref("UnreadTabTextColor", colorVals)
    WL_Utils.addInfoToChat("<RGB:" .. colorVals.r .. "," .. colorVals.g .. "," .. colorVals.b .. ">Unread tab text color updated.")
end

function WRC.Meta.SetUnreadTabBackgroundColor(color)
    if not color or color == "" then
        writeChatPref("UnreadTabBackgroundColor", nil)
        WL_Utils.addInfoToChat("Unread tab background color reset to default.")
        return
    end
    local colorVals = WRC.GetColor(color)
    if not colorVals then return end
    writeChatPref("UnreadTabBackgroundColor", colorVals)
    WL_Utils.addInfoToChat("<RGB:" .. colorVals.r .. "," .. colorVals.g .. "," .. colorVals.b .. ">Unread tab background color updated.")
end

function WRC.Meta.SetUnreadTabBlinking(blinking)
    writeChatPref("UnreadTabBlinking", blinking)
end

function WRC.Meta.GetOverheadTypingIndicator()
    return getChatPref("OverheadTypingIndicator")
end

function WRC.Meta.SetOverheadTypingIndicator(enabled)
    writeChatPref("OverheadTypingIndicator", enabled)
end

local radioSyncOption = nil
function WRC.Meta.GetRadioSync()
    return radioSyncOption
end

function WRC.Meta.SetRadioSync(channel)
    radioSyncOption = channel
end

function WRC.Meta.CreateActionsContext(context, myPlayer, players)
    local actionsOption = context:addOptionOnTop("Actions", nil, nil)
    local actionsContext = context:getNew(context)
    context:addSubMenu(actionsOption, actionsContext)

    actionsContext:addOption("Go AFK", nil, WRC.Commands.GoAFK)

    local languageOption = actionsContext:addOption("Choose Language", nil, nil)
    local languageContext = actionsContext:getNew(actionsContext)
    actionsContext:addSubMenu(languageOption, languageContext)

    for _, language in ipairs(WRC.Meta.GetKnownLanguages()) do
        languageContext:addOption(WRC.Languages[language].name .. " (" .. language .. ")", language, WRC.Commands.SetLang)
    end

    local focusablePlayers = {}
    local unfocusablePlayers = {}
    local tradablePlayers = {}
    for i=0,players:size()-1 do
        local player = players:get(i)
        local username = player:getUsername()
        if WRC.Meta.IsFocusedOn(username) then
            table.insert(unfocusablePlayers, username)
        else
            if WRC.CanSeePlayer(player) then
                table.insert(focusablePlayers, username)
            end
        end
        if WRC.CanSeePlayer(player) then
            table.insert(tradablePlayers, player)
        end
    end
    table.sort(focusablePlayers)
    table.sort(unfocusablePlayers)
    table.sort(tradablePlayers, function (a,b) return myPlayer:getDistanceSq(a) < myPlayer:getDistanceSq(b) end)
    local focusOption = actionsContext:addOption("Focus On", nil, nil)
    if #focusablePlayers > 0 then
        table.sort(focusablePlayers)
        local focusContext = actionsContext:getNew(actionsContext)
        actionsContext:addSubMenu(focusOption, focusContext)
        for _, username in ipairs(focusablePlayers) do
            focusContext:addOption(WRC.Meta.GetName(username), '"' .. username .. '"', WRC.Commands.Focus)
        end
        focusOption.notAvailable = false
    else
        focusOption.notAvailable = true
    end

    local unfocusOption = actionsContext:addOption("Unfocus From", nil, nil)
    if #unfocusablePlayers > 0 then
        table.sort(unfocusablePlayers)
        local unfocusContext = actionsContext:getNew(actionsContext)
        actionsContext:addSubMenu(unfocusOption, unfocusContext)
        for _, username in ipairs(unfocusablePlayers) do
            unfocusContext:addOption(WRC.Meta.GetName(username), '"' .. username .. '"', WRC.Commands.Unfocus)
        end
        unfocusOption.notAvailable = false
    else
        unfocusOption.notAvailable = true
    end

    local tradingOption = actionsContext:addOption("Trade With", nil, nil)
    if #tradablePlayers > 0 then
        local tradingContext = context:getNew(context)
        context:addSubMenu(tradingOption, tradingContext)
        for _, player in ipairs(tradablePlayers) do
            local username = player:getUsername()
            tradingContext:addOption(WRC.Meta.GetName(username) , '"' .. username .. '"', WRC.Commands.Trade)
        end
        tradingOption.notAvailable = false
    else
        tradingOption.notAvailable = true
    end

    if SandboxVars.WastelandRpChat.EnablePrivate then
        if WRC.Meta.HasPrivate(true) then
            actionsContext:addOption("Close Private Chat", nil, WRC.Commands.StopPrivateChat)
        else
            local privateablePlayers = WRC.GetAllPlayersInRange(5, 0)
            if #privateablePlayers == 1 then
                local name = WRC.Meta.GetName(privateablePlayers[1]:getUsername())
                actionsContext:addOption("Invite Private: " .. name, privateablePlayers[1]:getUsername(), WRC.Meta.InvitePrivate)
            end
        end
    end

    actionsContext:addOption("Show Help", nil, WRC.Commands.Help)
    actionsContext:addOption("List RP Chat Commands", nil, WRC.Commands.ListAllCommands)
end

function WRC.Meta.CreateCharacterContext(context, myPlayer)
    local characterOption = context:insertOptionAfter("Actions", "Character", nil, nil)
    local characterContext = context:getNew(context)
    context:addSubMenu(characterOption, characterContext)

    if SandboxVars.WastelandRpChat.EnableModCharacter then
        characterContext:addOption("Set Name", nil, WRC.MakeShowDialogPrompt("Input your new name", WRC.Commands.SetName))
        characterContext:addOption("Set Name Color", nil, WRC.MakeColorDialogPrompt("New Name Color (blank for default)", WRC.Commands.SetColor))

        characterContext:addOption("Grow Hair", nil, WRC.Commands.GrowHair)
        characterContext:addOption("Set Hair Color", nil, WRC.MakeColorDialogPrompt("Set Hair Color", WRC.Commands.SetHairColor))
        if not myPlayer:isFemale() then
            characterContext:addOption("Grow Beard", nil, WRC.Commands.GrowBeard)
            characterContext:addOption("Set Beard Color", nil, WRC.MakeColorDialogPrompt("Set Beard Color", WRC.Commands.SetBeardColor))
        end
    end

    if SandboxVars.WastelandRpChat.EnableAutoCleanup then
        if WRC.Buffs.IsAutoCleanEnabled() then
            characterContext:addOption("Disable Autoclean", false, WRC.Buffs.SetAutoCleanEnabled)
        else
            characterContext:addOption("Enable Autoclean", true, WRC.Buffs.SetAutoCleanEnabled)
        end
    end

    if SandboxVars.WastelandRpChat.EnableSelfInjury then
        local injureSelfOption = characterContext:addOption("Add Injury", nil, nil)
        local injureSelfContext = characterContext:getNew(characterContext)
        characterContext:addSubMenu(injureSelfOption, injureSelfContext)

        for _, bodyPartStr in ipairs(WRC.GetBodyParts()) do
            local bodyPart = BodyPartType.FromString(bodyPartStr)
            local bodyPartOption = injureSelfContext:addOption(BodyPartType.getDisplayName(bodyPart), nil, nil)
            local bodyPartContext = injureSelfContext:getNew(injureSelfContext)
            injureSelfContext:addSubMenu(bodyPartOption, bodyPartContext)

            for _, injury in ipairs(WRC.GetInjuries()) do
                bodyPartContext:addOption(injury, '"' .. bodyPartStr .. '" "' .. injury .. '"', WRC.Commands.Injure)
            end
        end
    end
end

function WRC.Meta.CreateChatSettingsContext(context)
    local chatSettingsOption = context:insertOptionAfter("Character", "RP Chat Settings", nil, nil)
    local chatSettingsContext = context:getNew(context)
    context:addSubMenu(chatSettingsOption, chatSettingsContext)

    local saveLast = WRC.Meta.IsSaveLastChatEnabled()
    chatSettingsContext:addOption((saveLast and "Disable" or "Enable") .. " Keep Last", not saveLast and "on" or "off", WRC.Commands.KeepLast)

    local chatColorsOption = chatSettingsContext:addOption("Chat Colors", nil, nil)
    local chatColorsContext = chatSettingsContext:getNew(chatSettingsContext)
    chatSettingsContext:addSubMenu(chatColorsOption, chatColorsContext)

    chatColorsContext:addOption("Set Speech Color", nil, WRC.MakeColorDialogPrompt("New Speech Color (blank for default)", WRC.Commands.SetSayColor))
    chatColorsContext:addOption("Set Emote Color", nil, WRC.MakeColorDialogPrompt("New Emote Color (blank for default)", WRC.Commands.SetEmoteColor))
    chatColorsContext:addOption("Set Do Color", nil, WRC.MakeColorDialogPrompt("New Do Color (blank for default)", WRC.Commands.SetDoColor))
    chatColorsContext:addOption("Set OOC Color", nil, WRC.MakeColorDialogPrompt("New OOC Color (blank for default)", WRC.Commands.SetOocColor))

    local volumeColorsOption = chatColorsContext:addOption("Volume Prefix Colors", nil, nil)
    local volumeColorsContext = chatColorsContext:getNew(chatColorsContext)
    chatSettingsContext:addSubMenu(volumeColorsOption, volumeColorsContext)

    volumeColorsContext:addOption("Set Whisper Color", nil, WRC.MakeColorDialogPrompt("New Whisper Volume Color (blank for default)", WRC.Commands.SetWhisperVolumeColor))
    volumeColorsContext:addOption("Set Low Color", nil, WRC.MakeColorDialogPrompt("New Low Volume Color (blank for default)", WRC.Commands.SetLowVolumeColor))
    volumeColorsContext:addOption("Set Say Color", nil, WRC.MakeColorDialogPrompt("New Say Volume Color (blank for default)", WRC.Commands.SetSayVolumeColor))
    volumeColorsContext:addOption("Set Loud Color", nil, WRC.MakeColorDialogPrompt("New Loud Volume Color (blank for default)", WRC.Commands.SetLoudVolumeColor))
    volumeColorsContext:addOption("Set Shout Color", nil, WRC.MakeColorDialogPrompt("New Shout Volume Color (blank for default)", WRC.Commands.SetShoutVolumeColor))
    volumeColorsContext:addOption("Set Distance Colors", nil, WRC.MakeColorDialogPrompt("New Max Distance Color (blank for default) <LINE> <RGB:0.3,0.3,0.3> Default looks like this (0.3,0.3,0.3)."), WRC.Commands.SetDistanceLowestColor);


    local unreadTabOption = chatSettingsContext:addOption("Unread Tab Options", nil, nil)
    local unreadTabContext = chatSettingsContext:getNew(chatSettingsContext)
    chatSettingsContext:addSubMenu(unreadTabOption, unreadTabContext)

    local _, _, blinking = WRC.Meta.GetUnreadTabOptions()
    unreadTabContext:addOption("Set Title Color", nil, WRC.MakeColorDialogPrompt("New Title Color (blank for default)", WRC.Meta.SetUnreadTabTextColor))
    unreadTabContext:addOption("Set Background Color", nil, WRC.MakeColorDialogPrompt("New Background Color (blank for default)", WRC.Meta.SetUnreadTabBackgroundColor))
    unreadTabContext:addOption((blinking and "Disable" or "Enable") .. " Blinking", not blinking, WRC.Meta.SetUnreadTabBlinking)

    local overheadTypingIndicator = WRC.Meta.GetOverheadTypingIndicator()
    chatSettingsContext:addOption((overheadTypingIndicator and "Disable" or "Enable") .. " Overhead Typing Indicator", not overheadTypingIndicator, WRC.Meta.SetOverheadTypingIndicator)
end

function WRC.Meta.CreateAdminContext(context, myPlayer, players)
    local adminOption = context:insertOptionAfter("RP Chat Settings", "RP Chat Admin", nil, nil)
    local adminContext = context:getNew(context)
    context:addSubMenu(adminOption, adminContext)

    if WRC.Meta.HasAdminHammer(myPlayer:getUsername()) then
        adminContext:addOption("Disable Admin Hammer", "off", WRC.Commands.Hammer)
    else
        adminContext:addOption("Enable Admin Hammer", "on", WRC.Commands.Hammer)
    end

    if WRC.Meta.DisableOverride then
        adminContext:addOption("Enable Admin Chat Override", "on", WRC.Commands.Override)
    else
        adminContext:addOption("Disable Admin Chat Override", "off", WRC.Commands.Override)
    end

    local usernames = {}
    for i=0,players:size()-1 do
        local username = players:get(i):getUsername()
        table.insert(usernames, {WRC.Meta.GetName(username) .. " (" .. username .. ")", username})
    end
    local languages = {}
    for code, language in pairs(WRC.Languages) do
        table.insert(languages, {language.name .. " (" .. code .. ")", code})
    end
    table.sort(usernames, function (a,b) return a[1] < b[1] end)
    table.sort(languages, function (a,b) return a[1] < b[1] end)

    -- add lang to player
    local addLangOption = adminContext:addOption("Add Language", nil, nil)
    local addLangContext = adminContext:getNew(adminContext)
    adminContext:addSubMenu(addLangOption, addLangContext)
    for _,p in ipairs(usernames) do
        local userDisplayName = p[1]
        local username = p[2]
        local playerOption = addLangContext:addOption(userDisplayName, nil, nil)
        local playerContext = addLangContext:getNew(addLangContext)
        addLangContext:addSubMenu(playerOption, playerContext)
        for _, l in ipairs(languages) do
            local languageDisplayName = l[1]
            local code = l[2]
            playerContext:addOption(languageDisplayName, '"' .. username .. '" ' .. code, WRC.Commands.AddLang)
        end
    end
    local removeLangOption = adminContext:addOption("Remove Language", nil, nil)
    local removeLangContext = adminContext:getNew(adminContext)
    adminContext:addSubMenu(removeLangOption, removeLangContext)
    for _,p in ipairs(usernames) do
        local userDisplayName = p[1]
        local username = p[2]
        local playerOption = removeLangContext:addOption(userDisplayName, nil, nil)
        local playerContext = removeLangContext:getNew(removeLangContext)
        removeLangContext:addSubMenu(playerOption, playerContext)
        for _, l in ipairs(languages) do
            local languageDisplayName = l[1]
            local code = l[2]
            playerContext:addOption(languageDisplayName, '"' .. username .. '" ' .. code, WRC.Commands.RemoveLang)
        end
    end
end

Events.OnLoad.Add(function()
    readChatPrefs()
end)