if not isClient() then return end -- only in MP
WRC = WRC or {}
WRC.Handlers = WRC.Handlers or {}



function WRC.Handlers.SpecialCommand(message)
    if message:sub(1,1) == "/" then
        local firstSpace = message:find(" ")
        if not firstSpace then
            firstSpace = message:len()
        else
            firstSpace = firstSpace - 1
        end
        if firstSpace then
            local command = message:sub(1, firstSpace)

            -- special case for roll volume
            if command:sub(1, 5) == "/roll" then
                extra = command:sub(6, command:len())
                args = message:sub(firstSpace + 1, message:len())
                if extra and extra ~= "" then
                    args = extra .. " " .. args
                end
                WRC.Commands.Roll(args)
                return true
            end

            if WRC.SpecialCommands[command] then
                local handler = WRC.SpecialCommands[command].handler
                local args = message:sub(firstSpace + 1, message:len())
                if WRC.Commands[handler] then
                    WRC.Commands[handler](args)
                    return true
                end
            end

            if command == "/all" and not SandboxVars.WastelandRpChat.EnableAll and not WRC.Override(true) then
                WL_Utils.addErrorToChat("All chat is disabled")
                return true
            end
        end
    end
    return false
end

function WRC.Handlers.HandleStaffTabCommand(message)
    if not WL_Utils.isStaff(getPlayer()) then
        WL_Utils.addErrorToChat("You are not staff")
        return true
    end
    sendClientCommand(getPlayer(), 'WRC', 'StaffChat', {message})
    return true
end

function WRC.Handlers.HandlePrivateTabCommand(message)
    if not WRC.Meta.HasPrivate() then
        WL_Utils.addErrorToChat("Private chat partner is no longer close or your two are no longer alone.")
        return true
    end
    local parsedMessage = WRC.Parsing.ParseMessage(message)
    if not parsedMessage then
        WL_Utils.addErrorToChat("Invalid Message")
        return true
    end

    local player = getPlayer()
    parsedMessage.playerUsername = player:getUsername()
    if not parsedMessage.language then
        parsedMessage.language = WRC.Meta.GetCurrentLanguage(parsedMessage.playerUsername)
    end
    local formatted = WRC.Parsing.FormatMessage(parsedMessage)
    local fakeMessage = WL_FakeMessage:new(formatted, {
        author = message.playerUsername,
        radioChannel = nil,
    })
    WRC.ISChatOriginal.addLineInChat(fakeMessage, WRC.PrivateTabId)

    message = WRC.Parsing.PrependPlayerData(player, message)
    sendClientCommand(getPlayer(), 'WRC', 'PrivateChat', {WRC.Meta.PrivatePartner, message, parsedMessage.language})
    return true
end

function WRC.Handlers.CommandEntered(message)
    local currentTabId = ISChat.instance.tabs[ISChat.instance.currentTabID].tabID

    if currentTabId == WRC.StaffTabId then
        return WRC.Handlers.HandleStaffTabCommand(message)
    end

    if currentTabId == WRC.PrivateTabId then
        return WRC.Handlers.HandlePrivateTabCommand(message)
    end

    local parsedMessage = WRC.Parsing.ParseMessage(message)
    if not parsedMessage then
        return false
    end

    if parsedMessage.chatModifier == "ooc" and not SandboxVars.WastelandRpChat.EnableOOC and not WRC.Override(true) then
        WL_Utils.addErrorToChat("OOC chat is disabled")
        return true
    end

    if parsedMessage.chatModifier == "alert" and not WRC.Override(true) then
        WL_Utils.addErrorToChat("Alert chat is disabled for non-staff")
        return true
    end

    if currentTabId == WRC.OocTabId then
        if parsedMessage.chatModifier == nil then
            message = WRC.Parsing.GetTextConvertedToOoc(parsedMessage)
            parsedMessage = WRC.Parsing.ParseMessage(message)
            if not parsedMessage then
                print("WRC: ooc coversion failed" .. message)
                WL_Utils.addErrorToChat("Failed to convert to OOC")
                return true
            end
        elseif parsedMessage.chatModifier ~= "ooc" then
            WL_Utils.addErrorToChat("This tab is for OOC chat only")
            return true
        end
    elseif parsedMessage.chatModifier == "ooc" then
        ISChat.instance.panel:activateView("OOC")
    end

    if parsedMessage.language and not WRC.Meta.CanSpeak(parsedMessage.language) then
        if not WRC.Languages[parsedMessage.language] then
            WL_Utils.addErrorToChat("Unknown language " .. parsedMessage.language)
        else
            WL_Utils.addErrorToChat("You don't know the language " .. WRC.Languages[parsedMessage.language].name)
        end
        return true
    end

    local player = getPlayer()
    parsedMessage.playerUsername = player:getUsername()

    if not parsedMessage.language then
        parsedMessage.language = WRC.Meta.GetCurrentLanguage(parsedMessage.playerUsername)
    end

    local isGeneralTab = ISChat.instance.tabs[ISChat.instance.currentTabID].tabID == 0
    local isIntoRadioTab = ISChat.instance.tabs[ISChat.instance.currentTabID].tabID == WRC.RadioTabId
    local shouldDisableRadio = not isIntoRadioTab or parsedMessage.language == "asl" or parsedMessage.chatModifer == "alert"
    local radiosOn = WRU_Utils.getPlayerRadios(player, true, true)
    local radiosMuted = {}
    local intoRadioSynced = false

    if shouldDisableRadio then
        local radioSync = WRC.Meta.GetRadioSync()
        for _, radio in ipairs(radiosOn) do
            local isRadioSync = isGeneralTab and WRU_Utils.getRadioFrequency(radio) == radioSync
            if isRadioSync then
                intoRadioSynced = true
            end
            if not isIntoRadioTab or not isRadioSync then
                WRU_Utils.setRadioBroadcastingInstant(player, radio, false)
                table.insert(radiosMuted, radio)
            end
        end
    end

    if (isIntoRadioTab or intoRadioSynced) and #radiosOn > 0 then
        message = "[radio]" .. message
    end


    if hasBracketsOrParentheses(message) and (isIntoRadioTab or intoRadioSynced) and #radiosOn > 0 or (isIntoRadioTab or intoRadioSynced) and #radiosOn > 0 and string.match(message, "/env")  then
        WL_Utils.addErrorToChat("OOC messages and environment messages will not be transmitted by radio. Do not attempt to cirumvent this.")
        message = ""
    else
    message = WRC.Parsing.PrependPlayerData(player, message)
    end
    if parsedMessage.chatType == "shout" then
        processShoutMessage(message)
    else
        processSayMessage(message)
    end

    for _, radio in ipairs(radiosMuted) do
        WRU_Utils.setRadioBroadcastingInstant(player, radio, true)
    end

    if parsedMessage.chatModifier == nil or parsedMessage.chatModifier == "me" then
        if WRC.Meta.IsSaveLastChatEnabled() then
            WRC.Meta.LastChat = "/" .. (parsedMessage.chatModifier or "") .. parsedMessage.chatType .. " "
        end
    elseif parsedMessage.chatModifier == "ooc" and WRC.Meta.IsSaveLastChatEnabled() then
        WRC.Meta.LastChat = "/ooc" .. parsedMessage.chatType .. " "
    end
    for _, callback in ipairs(WRC.CustomChatCallbacks) do
        callback(parsedMessage)
    end
    return true
end

local lastRadioAuthor = nil
local lastRadioChannel = nil
local lastRadioMessage = nil

--- @return boolean
function WRC.Handlers.AddLineInChat(chatMessage, tabID)
    chatMessage:setOverHeadSpeech(false)
    chatMessage:setShouldAttractZombies(false)

    local chatId = chatMessage:getChatID()
    if chatId ~= 1 and chatId ~= 2 and chatId ~= 3 then -- General, Shout, Radio
        return false
    end

    if chatMessage:isServerAlert() then
        return false
    end

    local rawText = chatMessage:getText()
    local parsedMessage = WRC.Parsing.ParseMessage(rawText)
    if not parsedMessage then
        return false
    end

    if not parsedMessage.playerUsername and
    (
        rawText == getText("IGUI_PlayerText_Sneeze")
        or rawText == getText("IGUI_PlayerText_Cough")
        or rawText == getText("IGUI_PlayerText_SneezeMuffled")
        or rawText == getText("IGUI_PlayerText_CoughMuffled")
    ) then
        chatMessage:setText("")
        return true
    end

    -- IGUI_PlayerText_Sneeze = "Ah-choo!",
    -- IGUI_PlayerText_Cough = "Cough!",
    -- IGUI_PlayerText_SneezeMuffled = "Ah-fmmph!",
    -- IGUI_PlayerText_CoughMuffled = "fmmmph!",

    local wasZombieYell = false
    if chatId == 2 and parsedMessage.chatType ~= "shout" and not parsedMessage.playerUsername then
        -- Was probably a zombie yell
        wasZombieYell = true
        parsedMessage.chatType = "shout"
        parsedMessage.playerUsername = chatMessage:getAuthor()
    end

    if not parsedMessage.playerUsername
        or parsedMessage.playerUsername == "Error"
        or parsedMessage.playerUsername == "Server"
    then
        return false
    end

    if not parsedMessage.language then
        parsedMessage.language = WRC.Meta.GetCurrentLanguage(parsedMessage.playerUsername)
    end

    local chattingPlayer = getPlayerFromUsername(parsedMessage.playerUsername)
    local myPlayer = getPlayer()
    local isMe = myPlayer:getUsername() == parsedMessage.playerUsername
    -- check if radio message
    if chatMessage:getRadioChannel() > 0 then
        parsedMessage.radioFrequency = chatMessage:getRadioChannel()

        if   lastRadioAuthor == parsedMessage.playerUsername
        and  lastRadioChannel == parsedMessage.radioFrequency
        and  lastRadioMessage == rawText
        then parsedMessage.isOwnRadio = false
        else
            local radios = WRU_Utils.getPlayerRadios(myPlayer, true)
            for _, radio in ipairs(radios) do
                local channel = WRU_Utils.getRadioFrequency(radio)
                if channel == parsedMessage.radioFrequency then
                    parsedMessage.isOwnRadio = true
                    break
                end
            end
            if parsedMessage.isOwnRadio then
                lastRadioAuthor = parsedMessage.playerUsername
                lastRadioChannel = parsedMessage.radioFrequency
                lastRadioMessage = rawText
            end

            
        end


        -- We do this to clear the original message which is showing above your head
        -- There is no other way to remove it AFAIK
        if parsedMessage.isOwnRadio then
            myPlayer:setSpeaking(false)
            myPlayer:addLineChatElement("", 0, 0, 0, UIFont.Dialogue, 0, "radio")
            myPlayer:addLineChatElement("", 0, 0, 0, UIFont.Dialogue, 0, "radio")
            myPlayer:addLineChatElement("", 0, 0, 0, UIFont.Dialogue, 0, "radio")
            myPlayer:addLineChatElement("", 0, 0, 0, UIFont.Dialogue, 0, "radio")
            myPlayer:addLineChatElement("", 0, 0, 0, UIFont.Dialogue, 0, "radio")
            myPlayer:addLineChatElement("", 0, 0, 0, UIFont.Dialogue, 0, "radio")
        end
    else
        local chatType = WRC.ChatTypes[parsedMessage.chatType]
        local pos

        -- Check if in range
        if parsedMessage.fromRecorder then
            chatType = WRC.ChatTypes["low"]
            local chattingPlayer = getPlayerFromUsername(chatMessage:getAuthor())
            if not chattingPlayer then
                chatMessage:setText("")
                return true
            end
            if not WRC.Meta.IsInRange(myPlayer, chattingPlayer, chatType.xyRange, chatType.zRange) then
                chatMessage:setText("")
                return true
            end
            pos = {x = chattingPlayer:getX(), y = chattingPlayer:getY()}
        elseif parsedMessage.isNpc then
            pos = {x = myPlayer:getX(), y = myPlayer:getY(), z = myPlayer:getZ()}
        elseif chattingPlayer then
            if not WRC.Meta.IsInRange(myPlayer, chattingPlayer, chatType.xyRange, chatType.zRange) then
                if myPlayer:getZ() == chattingPlayer:getZ() then
                    if parsedMessage.chatType == "whisper" and WRC.CanSeePlayer(chattingPlayer, false, WRC.ChatTypes["say"].xyRange) then
                        local colorRGB = WRC.Meta.GetNameColorRGB(parsedMessage.playerUsername)
                        if parsedMessage.onRadio then
                            chattingPlayer:addLineChatElement("Whispered into a walkie", colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["say"].xyRange, "")
                        else
                            chattingPlayer:addLineChatElement("Whispered", colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["say"].xyRange, "")
                        end
                    elseif parsedMessage.chatType == "low" and WRC.CanSeePlayer(chattingPlayer, false, WRC.ChatTypes["say"].xyRange) then
                        local colorRGB = WRC.Meta.GetNameColorRGB(parsedMessage.playerUsername)
                        if parsedMessage.onRadio then
                            chattingPlayer:addLineChatElement("Spoke Quietly into a walkie", colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["say"].xyRange, "")
                        else
                            chattingPlayer:addLineChatElement("Spoke Quietly", colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["say"].xyRange, "")
                        end
                    elseif parsedMessage.chatType == "say" and WRC.CanSeePlayer(chattingPlayer, false, WRC.ChatTypes["loud"].xyRange) then
                        local colorRGB = WRC.Meta.GetNameColorRGB(parsedMessage.playerUsername)
                        if parsedMessage.onRadio then
                            chattingPlayer:addLineChatElement("Spoke into a walkie", colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["loud"].xyRange, "")
                        else
                            chattingPlayer:addLineChatElement("Spoke", colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["loud"].xyRange, "")
                        end
                    end
                end
                chatMessage:setText("")
                return true
            end
            pos = {x = chattingPlayer:getX(), y = chattingPlayer:getY()}
        elseif parsedMessage.pos then
            if not WRC.Meta.IsInPosRange(myPlayer, parsedMessage.pos, chatType.xyRange, chatType.zRange) then
                chatMessage:setText("")
                return true
            end
            pos = parsedMessage.pos
        else
            chatMessage:setText("")
            return true
        end

        if WRC.Meta.CanUnderstand(parsedMessage.language) and myPlayer:HasTrait("HardOfHearing") and SandboxVars.WastelandRpChat.EnableHardOfHearing and not isMe then
            local chatType = WRC.ChatTypes[parsedMessage.chatType]
            local xyRange = chatType.xyRange + 0.99

            local xDist = myPlayer:getX() - pos.x
            local yDist = myPlayer:getY() - pos.y
            local xyDistSq = xDist * xDist + yDist * yDist
            local rangeRatio = xyDistSq / (xyRange * xyRange)
            WRC.Parsing.AdjustForHardOfHearing(parsedMessage, rangeRatio)
        end
    end

    if parsedMessage.radioFrequency and parsedMessage.chatModifier == "ooc" or parsedMessage.radioFrequency and parsedMessage.chatModifier == "env" then
        -- throw away, no ooc on radio
        return true
    end

    if myPlayer:HasTrait("Deaf") and SandboxVars.WastelandRpChat.EnableDeaf and (not isMe or parsedMessage.fromRecorder) then
        WRC.Parsing.AdjustForDeaf(parsedMessage)
    elseif not WRC.Meta.CanUnderstand(parsedMessage.language) then
        WRC.Parsing.AdjustForUnknownLanguage(parsedMessage)
    end

    local formattedMessage = WRC.Parsing.FormatMessage(parsedMessage)

    local fakeMessage = WL_FakeMessage:new(formattedMessage, {
        author = chatMessage:getAuthor(),
        radioChannel = chatMessage:getRadioChannel(),
        datetimeStr = chatMessage:getDatetimeStr(),
    })

    local blinkingTabsCurrently = {}
    if isMe or parsedMessage.chatModifier == "alert" then
        for _, tabTitle in ipairs(ISChat.instance.panel.blinkTabs) do
            table.insert(blinkingTabsCurrently, tabTitle)
        end
    end

    if chattingPlayer and not parsedMessage.radioFrequency and not parsedMessage.fromRecorder then
        local textOnlyMessage = WRC.Parsing.GetTextOnly(parsedMessage)
        -- capitalize first letter
        textOnlyMessage = textOnlyMessage:sub(1,1):upper() .. textOnlyMessage:sub(2)
        local colorRGB = WRC.Meta.GetNameColorRGB(parsedMessage.playerUsername)
        chattingPlayer:addLineChatElement(textOnlyMessage, colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, 30.0, "")
    end

    if parsedMessage.chatModifier == "alert" then
        for _, tab in ipairs(ISChat.instance.tabs) do
            WRC.ISChatOriginal.addLineInChat(fakeMessage, tab.tabID)
        end
        ISChat.instance.servermsg = parsedMessage.parts[1].text
        ISChat.instance.servermsgTimer = 5000
        ISChat.instance.panel.blinkTabs = blinkingTabsCurrently
        return true
    end

    local currentTabId = ISChat.instance.tabs[ISChat.instance.currentTabID].tabID
    local doInGeneral = false
    local doInFocus = false
    local doInRadio = false
    local doInOOC = false

    local radioSync = WRC.Meta.GetRadioSync()
    if parsedMessage.chatModifier == "ooc" then
        doInOOC = true
    else
        if parsedMessage.isOwnRadio then
            doInRadio = true
        else
            doInGeneral = true
        end

        if radioSync and radioSync == parsedMessage.radioFrequency then
            doInGeneral = true
        end

        if WRC.Meta.IsFocusedOn(parsedMessage.playerUsername) or (currentTabId == WRC.FocusTabId and isMe) then
            doInFocus = true
        end
    end

    if parsedMessage.chatModifier == nil or parsedMessage.chatModifier == "me" then
        WRC.Buffs.ApplyRpBuffs()
    end

    if not parsedMessage.isEmote then
        if doInGeneral then
            WRC.ISChatOriginal.addLineInChat(fakeMessage, 0)
        end
        if doInFocus then
            WRC.ISChatOriginal.addLineInChat(fakeMessage, WRC.FocusTabId)
        end
        if doInRadio then
            WRC.ISChatOriginal.addLineInChat(fakeMessage, WRC.RadioTabId)
        end
        if doInOOC then
            WRC.ISChatOriginal.addLineInChat(fakeMessage, WRC.OocTabId)
        end
        writeLog("ReadableChat", WRC.Parsing.GetLogText(parsedMessage))
    -- else
    --     local colorRGB = WRC.Meta.GetNameColorRGB(parsedMessage.playerUsername)
    --     chattingPlayer:addLineChatElement(WRC.Parsing.GetTextOnly(parsedMessage), colorRGB.r, colorRGB.g, colorRGB.b, UIFont.Dialogue, WRC.ChatTypes["say"].xyRange, "")
    end
    
    if parsedMessage.radioFrequency then
        -- search around the player to find any radios which could have broadcast this as well
        WRC.Handlers.FixWorldRadios(myPlayer, parsedMessage)
    end

    -- Clone the message if it was my one message.
    -- If in the radio tab, once for each radio that is on and broadcasting
    -- If in the general tab and the radio is synced, into the radio tab for that frequency
    local player = getSpecificPlayer(0)

    if currentTabId == WRC.RadioTabId and not wasZombieYell and isMe then
        local radios = WRU_Utils.getPlayerRadios(getPlayer(), true, true)
        for _, radio in ipairs(radios) do
            local channel = WRU_Utils.getRadioFrequency(radio)
            parsedMessage.radioFrequency = channel
            local radioFormatted = WRC.Parsing.FormatMessage(parsedMessage)
            local radioMessage = WL_FakeMessage:new(radioFormatted, {
                author = chatMessage:getAuthor(),
                radioChannel = chatMessage:getRadioChannel(),
                datetimeStr = chatMessage:getDatetimeStr(),
            })
            print(radioFormatted)
            if hasBracketsOrParentheses(radioFormatted, player) then
                
                WL_Utils.addErrorToChat("OOC messages and environment messages will not be transmitted by radio. Do not attempt to cirumvent this.")
            else
                WRC.ISChatOriginal.addLineInChat(radioMessage, WRC.RadioTabId)
            end
        end
    elseif currentTabId == 0 and radioSync then
        local radios = WRU_Utils.getPlayerRadios(getPlayer(), true, true)
        for _, radio in ipairs(radios) do
            local channel = WRU_Utils.getRadioFrequency(radio)
            if channel == radioSync then
                parsedMessage.radioFrequency = channel
                local radioFormatted = WRC.Parsing.FormatMessage(parsedMessage)
                local radioMessage = WL_FakeMessage:new(radioFormatted, {
                    author = chatMessage:getAuthor(),
                    radioChannel = chatMessage:getRadioChannel(),
                    datetimeStr = chatMessage:getDatetimeStr(),
                })
                print(radioFormatted)
            if hasBracketsOrParentheses(radioFormatted, player) then
                
                WL_Utils.addErrorToChat("OOC messages and environment messages will not be transmitted by radio. Do not attempt to cirumvent this.")
            else
                WRC.ISChatOriginal.addLineInChat(radioMessage, WRC.RadioTabId)
            end
            end
        end
    end

    if isMe then
        ISChat.instance.panel.blinkTabs = blinkingTabsCurrently
    end

    if parsedMessage.chatModifier ~= "ooc" then
        local primaryHand = myPlayer:getPrimaryHandItem()
        local secondaryHand = myPlayer:getSecondaryHandItem()
        if primaryHand and primaryHand:getType() == "WRCRecorder" then
            if WRC.Recorders.IsRecording(primaryHand) then
                WRC.Recorders.SaveToRecorder(myPlayer, primaryHand, rawText)
            end
        end
        if secondaryHand and secondaryHand:getType() == "WRCRecorder" then
            if WRC.Recorders.IsRecording(secondaryHand) then
                WRC.Recorders.SaveToRecorder(myPlayer, secondaryHand, rawText)
            end
        end
    end

    return true
end

function WRC.Handlers.AddStaffMessage(otherPlayerUsername, message)
    if not WL_Utils.isStaff(getPlayer()) then
        return
    end

    local fakeMessage = WL_FakeMessage:new(message, {
        author = otherPlayerUsername,
        radioChannel = nil,
    })
    WRC.ISChatOriginal.addLineInChat(fakeMessage, WRC.StaffTabId)
end

function WRC.Handlers.AddPrivateMessage(otherPlayerUsername, message)
    if not WRC.Meta.HasPrivate() then
        return
    end
    local chattingPlayer
    for i=0, getOnlinePlayers():size()-1 do
        local player = getOnlinePlayers():get(i)
        if player:getUsername() == otherPlayerUsername then
            chattingPlayer = player
            break
        end
    end
    if not chattingPlayer then return end
    local myPlayer = getPlayer()
    local parsedMessage = WRC.Parsing.ParseMessage(message)
    parsedMessage.playerUsername = otherPlayerUsername
    if not parsedMessage.language then
        parsedMessage.language = WRC.Meta.GetCurrentLanguage(parsedMessage.playerUsername)
    end
    if WRC.Meta.CanUnderstand(parsedMessage.language) and myPlayer:HasTrait("HardOfHearing") and SandboxVars.WastelandRpChat.EnableHardOfHearing then
        local chatType = WRC.ChatTypes[parsedMessage.chatType]
        local xyRange = chatType.xyRange + 0.99

        local xDist = myPlayer:getX() - chattingPlayer:getX()
        local yDist = myPlayer:getY() - chattingPlayer:getY()
        local xyDistSq = xDist * xDist + yDist * yDist
        local rangeRatio = xyDistSq / (xyRange * xyRange)
        WRC.Parsing.AdjustForHardOfHearing(parsedMessage, rangeRatio)
    elseif myPlayer:HasTrait("Deaf") and SandboxVars.WastelandRpChat.EnableDeaf then
        WRC.Parsing.AdjustForDeaf(parsedMessage)
    elseif not WRC.Meta.CanUnderstand(parsedMessage.language) then
        WRC.Parsing.AdjustForUnknownLanguage(parsedMessage)
    end
    local formatted = WRC.Parsing.FormatMessage(parsedMessage)

    local fakeMessage = WL_FakeMessage:new(formatted, {
        author = otherPlayerUsername,
        radioChannel = nil,
    })
    WRC.ISChatOriginal.addLineInChat(fakeMessage, WRC.PrivateTabId)
    WRC.Buffs.ApplyRpBuffs()
end


function WRC.Handlers.FixWorldRadios(myPlayer, parsedMessage)
    local msg = WRC.Parsing.GetTextOnly(parsedMessage)
    local playerX = myPlayer:getX()
    local playerY = myPlayer:getY()
    for x=playerX-15,playerX+15,1 do
    for y=playerY-15,playerY+15,1 do
    for z=0,7,1 do
        local square = getCell():getGridSquare(x, y, z)
        if square then
            local objects = square:getObjects()
            for i=0,objects:size()-1,1 do
                local object = objects:get(i)
                if instanceof(object, "IsoRadio") then
                    if WRU_Utils.isRadioOn(object) then
                        local channel = WRU_Utils.getRadioFrequency(object)
                        if channel == parsedMessage.radioFrequency then
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            if hasBracketsOrParentheses(msg) then
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            else
                            object:AddDeviceText(WRC.Meta.GetName(parsedMessage.playerUsername) .. " " .. WRC.Parsing.GetTextOnly(parsedMessage), 0.7, 0.7, 0.7, "", "", 30)
                            end
                        end
                    end
                end
            end
            local movingObjects = square:getMovingObjects()
            -- look for vehicle with radio on and on the same channel
            for i=0,movingObjects:size()-1,1 do
                local movingObject = movingObjects:get(i)
                if instanceof(movingObject, "BaseVehicle") then
                    local parts = movingObject:getPartCount()
                    for i=0,parts-1 do
                        local part = movingObject:getPartByIndex(i)
                        local data = part:getDeviceData()
                        if data and data:getIsTurnedOn() and data:getChannel() == parsedMessage.radioFrequency then
                            part:AddDeviceText("", 0, 0, 0, "", "", 30)
                            part:AddDeviceText("", 0, 0, 0, "", "", 30)
                            part:AddDeviceText("", 0, 0, 0, "", "", 30)
                            part:AddDeviceText("", 0, 0, 0, "", "", 30)
                            part:AddDeviceText("", 0, 0, 0, "", "", 30)
                            if hasBracketsOrParentheses(msg) then
                            object:AddDeviceText("", 0, 0, 0, "", "", 30)
                            else
                            part:AddDeviceText(WRC.Meta.GetName(parsedMessage.playerUsername) .. " " .. WRC.Parsing.GetTextOnly(parsedMessage), 0.7, 0.7, 0.7, "", "", 30)
                            end
                        end
                    end
                end
            end
        end
    end end end
end

function WRC.Handlers.DrawRadioPlaceholder(chatInstance)
    local message = ""

    local currentLang = WRC.Meta.GetCurrentLanguage(getPlayer():getUsername())
    if currentLang and currentLang ~= "en" then
        message = "Speaking " .. WRC.Languages[currentLang].name
    end

    local me = getPlayer()
    local textEntry = chatInstance.textEntry
    if not WRU_Utils.AreAnyRadiosTransmitting(me) then
        if message ~= "" then
            message = message .. ", "
        end
        message = message .. "No radio is transmitting"
    else
        local frequencies = {}
        local radios = WRU_Utils.getPlayerRadios(me, true, true)
        for _, radio in ipairs(radios) do
            table.insert(frequencies, tostring(WRU_Utils.getRadioFrequency(radio)/1000) .. " MHz")
        end
        local trasmitMessage = "TX on: " .. table.concat(frequencies, ", ")
        local width = getTextManager():MeasureStringX(UIFont.Medium, message .. ", " .. trasmitMessage)
        if width > textEntry:getWidth() then
            trasmitMessage = "TX on " .. #frequencies .. " frequencies"
        end

        if message ~= "" then
            message = message .. ", "
        end
        message = message .. trasmitMessage
    end

    chatInstance:drawText(message, textEntry:getX() + 5, textEntry:getY() + 4, 1, 0.2, 0.2, 0.2, UIFont.Medium)
end

function WRC.Handlers.DrawFocusPlaceholder(chatInstance)
    local message = ""

    local currentLang = WRC.Meta.GetCurrentLanguage(getPlayer():getUsername())
    if currentLang and currentLang ~= "en" then
        message = "Speaking " .. WRC.Languages[currentLang].name
    end

    local textEntry = chatInstance.textEntry
    local focusedNames = {}
    for _, username in ipairs(WRC.Meta.FocusedPersons) do
        table.insert(focusedNames, WRC.Meta.GetName(username))
    end
    local focusedOnMessage = "Focused on: " .. table.concat(focusedNames, ", ")
    local width = getTextManager():MeasureStringX(UIFont.Medium, message .. ", " .. focusedOnMessage)
    if width > textEntry:getWidth() then
        focusedOnMessage = "Focused on " .. #focusedNames .. " players"
    end
    if message ~= "" then
        message = message .. ", "
    end
    message = message .. focusedOnMessage
    chatInstance:drawText(message, textEntry:getX() + 5, textEntry:getY() + 4, 0.2, 0.2, 1, 0.7, UIFont.Medium)
end

function WRC.Handlers.DrawGeneralPlaceholder(chatInstance)
    local message = ""

    local currentLang = WRC.Meta.GetCurrentLanguage(getPlayer():getUsername())
    if currentLang and currentLang ~= "en" then
        message = "Speaking " .. WRC.Languages[currentLang].name
    end

    local radioSync = WRC.Meta.GetRadioSync()
    if radioSync then
        if message ~= "" then
            message = message .. ", "
        end
        message = message .. "Synced with " .. tostring(radioSync/1000) .. " MHz"
    end

    if message ~= "" then
        local textEntry = chatInstance.textEntry
        chatInstance:drawText(message, textEntry:getX() + 5, textEntry:getY() + 4, 0.4, 0.4, 1, 0.4, UIFont.Medium)
    end
end

function WRC.Handlers.IsOutdated(text)
    if text:sub(1, 3) == "/do" then
        WL_Utils.addErrorToChat("The /do command is no longer supported. Use /me for emotes, and /env for environmental.")
        return true
    end
    return false
end