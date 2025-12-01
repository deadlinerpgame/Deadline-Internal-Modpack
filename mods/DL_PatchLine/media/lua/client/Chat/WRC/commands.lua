if not isClient() then return end -- only in MP
WRC = WRC or {}
WRC.Commands = WRC.Commands or {}
WRC.TabHandlers = WRC.TabHandlers or {}

-- will receive the message as a string: /name new name
function WRC.Commands.SetName(args)
    local name = args:gsub("^%s*(.-)%s*$", "%1") -- trim
    if name == nil or name == "" then
        WL_Utils.addErrorToChat("Invalid name. Use /name John")
        return
    end

    if name:len() > 32 then
        WL_Utils.addErrorToChat("Name too long. Use /name John")
        return
    end

if not name:match("^[A-Za-z0-9 ()]+$") and not isAdmin() then
    WL_Utils.addErrorToChat("Invalid characters in name. Only letters, numbers, spaces, and ( ) are allowed.")
    return
end

    WRC.Meta.SetName(name)
    WL_Utils.addInfoToChat("Name set to " .. name)
end

-- /color RRR,GGG,BBB
function WRC.Commands.SetColor(args)
    if not args or args == "" then
        WRC.Meta.SetColor(nil)
        WL_Utils.addInfoToChat(WRC.Meta.GetColor() .. "Color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    if ((color.r + color.g + color.b) / 3) < 0.3 and not WRC.Override() then
        WL_Utils.addErrorToChat("Color too dark. Try a brighter color (higher numbers).")
        return
    end
    WRC.Meta.SetNameColor(color.r, color.g, color.b)
    WL_Utils.addInfoToChat("<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">Color has been updated!")
end

function WRC.Commands.SetSayColor(args)
    if not args or args == "" then
        WRC.Meta.SetSayColor(nil)
        WL_Utils.addInfoToChat(WRC.Meta.GetSayColor() .. "Say color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetSayColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Say color has been updated!")
end

function WRC.Commands.SetEmoteColor(args)
    if not args or args == "" then
        WRC.Meta.SetEmoteColor(nil)
        WL_Utils.addInfoToChat(WRC.Meta.GetEmoteColor() .. "Emote color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetEmoteColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Emote color has been updated!")
end

function WRC.Commands.SetDoColor(args)
    if not args or args == "" then
        WRC.Meta.SetDoColor(nil)
        WL_Utils.addInfoToChat("Do color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetDoColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Do color has been updated!")
end

function WRC.Commands.SetOocColor(args)
    if not args or args == "" then
        WRC.Meta.SetOocColor(nil)
        WL_Utils.addInfoToChat(WRC.Meta.GetOocColor() .. "OOC color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetOocColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "OOC color has been updated!")
end

function WRC.Commands.SetWhisperVolumeColor(args)
    if not args or args == "" then
        WRC.Meta.SetWhisperVolumeColor(WRC.ChatColors["volumeprefixes"]["whisper"])
        WL_Utils.addInfoToChat(WRC.Meta.GetWhisperVolumeColor() .. "Whisper color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetWhisperVolumeColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Whisper color has been updated!")
end

function WRC.Commands.SetLowVolumeColor(args)
    if not args or args == "" then
        WRC.Meta.SetLowVolumeColor(WRC.ChatColors["volumeprefixes"]["low"])
        WL_Utils.addInfoToChat(WRC.Meta.GetLowVolumeColor() .. "Low color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetLowVolumeColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Low color has been updated!")
end

function WRC.Commands.SetSayVolumeColor(args)
    if not args or args == "" then
        WRC.Meta.SetSayVolumeColor(WRC.ChatColors["volumeprefixes"]["say"])
        WL_Utils.addInfoToChat(WRC.Meta.GetSayVolumeColor() .. "Say color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetSayVolumeColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Say color has been updated!")
end

function WRC.Commands.SetLoudVolumeColor(args)
    if not args or args == "" then
        WRC.Meta.SetLoudVolumeColor(WRC.ChatColors["volumeprefixes"]["loud"])
        WL_Utils.addInfoToChat(WRC.Meta.GetLoudVolumeColor() .. "Loud color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetLoudVolumeColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Loud color has been updated!")
end

function WRC.Commands.SetShoutVolumeColor(args)
    if not args or args == "" then
        WRC.Meta.SetShoutColor(WRC.ChatColors["volumeprefixes"]["shout"])
        WL_Utils.addInfoToChat(WRC.Meta.GetShoutColor() .. "Shout color reset to default.")
        return
    end
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local rgbString = "<RGB:" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
    WRC.Meta.SetShoutColor(rgbString)
    WL_Utils.addInfoToChat(rgbString .. "Shout color has been updated!")
end

function WRC.Commands.SetLang(args)
    local lang = args:gsub("^%s*(.-)%s*$", "%1") -- trim
    if lang == nil or lang == "" then
        local currentLang = WRC.Meta.GetCurrentLanguage(getPlayer():getUsername())
        local myLangs = WRC.Meta.GetKnownLanguages()
        local msg = "Current language is " .. WRC.Languages[currentLang].name .. " (" .. currentLang .. ")<LINE><LINE>Known languages:<INDENT:8>"
        for _, lang in ipairs(myLangs) do
            msg = msg .. "<LINE>" .. WRC.Languages[lang].name .. " (" .. lang .. ")" .. WL_Utils.MagicSpace
        end
        msg = msg .. "<LINE><LINE><INDENT:0>To Change language use /lang XX where XX is the language code. EX: /lang en"
        WL_Utils.addInfoToChat(msg)
        return
    end
    if lang == "all" then
        local langs = {}
        for lang, data in pairs(WRC.Languages) do
            table.insert(langs, data.name .. " (" .. lang .. ")")
        end
        local msg = "All Languages:<LINE><INDENT:8>" .. table.concat(langs, ", ") .. "<LINE><INDENT:0>"
        WL_Utils.addInfoToChat(msg)
        return
    end

    if not WRC.Languages[lang] then
        WL_Utils.addErrorToChat("Invalid language. Use /lang XX where XX is the language code. EX: /lang en")
        return
    end

    if not WRC.Meta.CanSpeak(lang) then
        WL_Utils.addErrorToChat("You don't know that language. To see your languages use /lang all")
        return
    end

    WRC.Meta.SetCurrentLanguage(lang)
    WL_Utils.addInfoToChat("Language set to " .. WRC.Languages[lang].name .. " (" .. lang .. ")")
end


local addLangUsageStr = "Use \"/addlang username XX\" where XX is the language code. EX: /addlang \"John Smith\" en"
local removeLangUsageStr = "Use \"/removelang username\" XX where XX is the language code. EX: /removelang \"John Smith\" en"

--- @param args string "user name" language
function WRC.Commands.AddLang(args)
    if not WRC.Override() then
        WL_Utils.addErrorToChat("You are not permitted to add languages.")
        return
    end

    local params = WRC.SplitString(args)
    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. " .. addLangUsageStr)
        return
    end
    local username, lang = params[1], params[2]
    if username == "" or lang == "" then
        WL_Utils.addErrorToChat("Invalid format. " .. addLangUsageStr)
        return
    end
    local player = getPlayerFromUsername(username)
    if not player then
        WL_Utils.addErrorToChat("Player not found. " .. addLangUsageStr)
        return
    end
    if not WRC.Languages[lang] then
        WL_Utils.addErrorToChat("Invalid language. " .. addLangUsageStr)
        return
    end

    if getPlayer() == player then
        WRC.Meta.AddKnownLanguage(lang)
        WL_Utils.addInfoToChat("Language " .. WRC.Languages[lang].name .. " (" .. lang .. ")" .. " added to yourself")
        return
    end

    WRC.Meta.AddLanguageTo(username, lang)
    WL_Utils.addInfoToChat("Language " .. WRC.Languages[lang].name .. " (" .. lang .. ")" .. " added to " .. player:getUsername())
end

--- @param args string "user name" language
function WRC.Commands.RemoveLang(args)
    if not WRC.Override() then
        WL_Utils.addErrorToChat("You are not permitted to remove languages.")
        return
    end

    local params = WRC.SplitString(args)
    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. " .. removeLangUsageStr)
        return
    end
    local username, lang = params[1], params[2]
    if username == "" or lang == "" then
        WL_Utils.addErrorToChat("Invalid format. " .. removeLangUsageStr)
        return
    end
    local player = getPlayerFromUsername(username)
    if not player then
        WL_Utils.addErrorToChat("Player not found. " .. removeLangUsageStr)
        return
    end
    if not WRC.Languages[lang] then
        WL_Utils.addErrorToChat("Invalid language. " .. removeLangUsageStr)
        return
    end

    if getPlayer() == player then
        WRC.Meta.RemoveKnownLanguage(lang)
        WL_Utils.addInfoToChat("Language " .. WRC.Languages[lang].name .. " (" .. lang .. ")" .. " removed from yourself")
        return
    end

    WRC.Meta.RemoveLanguageFrom(username, lang)
    WL_Utils.addInfoToChat("Language " .. WRC.Languages[lang].name .. " (" .. lang .. ")" .. " removed from " .. player:getUsername())
end

function WRC.Commands.Focus(args)
    local parts = WRC.SplitString(args)
    if #parts ~= 1 then
        WL_Utils.addErrorToChat("Invalid format. Use /focus username")
        return
    end
    local username = parts[1]:gsub("^%s*(.-)%s*$", "%1") -- trim
    if username == nil or username == "" then
        local msg = "Focused on: <INDENT:8>"
        for i=1, #WRC.Meta.FocusedPersons do
            msg = msg .. "<LINE>" .. WRC.Meta.FocusedPersons[i]
        end
        msg = msg .. "<INDENT:0>"
        WL_Utils.addInfoToChat(msg)
        return
    end

    if getPlayerFromUsername(username) == nil then
        WL_Utils.addErrorToChat("Player not found. Use /focus username")
        return
    end

    WRC.Meta.FocusOn(username)
    WL_Utils.addInfoToChat("You are now focused on " .. username)
end

function WRC.Commands.Unfocus(args)
    local parts = WRC.SplitString(args)
    if #parts ~= 1 then
        WL_Utils.addErrorToChat("Invalid format. Use /focus username")
        return
    end
    local username = parts[1]:gsub("^%s*(.-)%s*$", "%1") -- trim
    if username == nil or username == "" then
        WL_Utils.addErrorToChat("Invalid username. Use /unfocus username")
        return
    end
    if not WRC.Meta.IsFocusedOn(username) then
        WL_Utils.addErrorToChat("You are not focused on " .. username)
        return
    end
    WRC.Meta.UnfocusOn(username)
    WL_Utils.addInfoToChat("You are no longer focused on " .. username)
end

function WRC.Commands.Hammer(args)
    if not WRC.Override() and not WRC.Meta.HasAdminHammer(getPlayer():getUsername()) then
        WL_Utils.addErrorToChat("You are not permitted to use the hammer.")
        return
    end
    local onOff = args:gsub("^%s*(.-)%s*$", "%1") -- trim
    if onOff == nil or onOff == "" then
        WL_Utils.addErrorToChat("Invalid format. Use /hammer on or /hammer off")
        return
    end
    if onOff == "on" then
        WL_Utils.addInfoToChat("Hammer enabled")
        WRC.Meta.EnableAdminHammer()
    elseif onOff == "off" then
        WL_Utils.addInfoToChat("Hammer disabled")
        WRC.Meta.DisableAdminHammer()
    else
        WL_Utils.addErrorToChat("Invalid format. Use /hammer on or /hammer off")
    end
end

function WRC.Commands.Help()
    local msg = "Wasteland RP Chat Commands:<LINE>"
    for _, data in pairs(WRC.SpecialCommands) do
        if not data.adminOnly or WRC.Override() then
            msg = msg .. "<LINE><INDENT:8>" .. data.usage .. "<LINE><INDENT:16>" .. data.help
        end
    end
    msg = msg .. "<LINE><INDENT:0>"
    WL_Utils.addInfoToChat(msg)
end

function WRC.Commands.SendPM(args)
    if not SandboxVars.WastelandRpChat.EnablePM and not WRC.Override(true) then
        WL_Utils.addErrorToChat("Private messages are disabled.")
        return
    end

    local params = WRC.SplitString(args)
    if #params < 2 then
        WL_Utils.addErrorToChat("Invalid format. Use /pm username message")
        return
    end
    local username = params[1]
    table.remove(params, 1)
    local message = table.concat(params, " ")
    if message == nil or message == "" then
        WL_Utils.addErrorToChat("Invalid format. Use /pm username message")
        return
    end
    if username:find(" ") then
        username = '"' .. username .. '"'
    end
    proceedPM(username .. " " .. message)
end

function WRC.Commands.GoAFK()
    if WRC.Afk.IsSelfAfk() then
        WL_Utils.addErrorToChat("You are already AFK. Walk around to stop being AFK.")
    else
        WRC.Afk.StartAfk()
    end
end

function WRC.Commands.GrowBeard()
    local player = getPlayer()
    if player:isFemale() then
        WL_Utils.addErrorToChat("You can't grow a beard.")
        return
    end
    local action = ISTrimBeard:new(player, "Long", nil, 0)
    action:perform()
end

function WRC.Commands.GrowHair()
    local player = getPlayer()
    if player:isFemale() then
        local action = ISCutHair:new(player, "Long2", nil, 0)
        action:perform()
    else
        local action = ISCutHair:new(player, "Fabian", nil, 0)
        action:perform()
    end
end

function WRC.Commands.SetHairColor(args)
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local player = getPlayer()
    player:getHumanVisual():setHairColor(ImmutableColor.new(color.r, color.g, color.b, 1))
    sendVisual(player)
    triggerEvent("OnClothingUpdated", player)
    player:resetModel()
end

function WRC.Commands.SetBeardColor(args)
    local color = WRC.GetColor(args)
    if not color then
        return
    end
    local player = getPlayer()
    player:getHumanVisual():setBeardColor(ImmutableColor.new(color.r, color.g, color.b, 1))
    sendVisual(player)
    triggerEvent("OnClothingUpdated", player)
    player:resetModel()
end

function WRC.Commands.Override(args)
    local onOff = args:gsub("^%s*(.-)%s*$", "%1") -- trim
    if onOff == "on" then
        WL_Utils.addInfoToChat("Override enabled")
        WRC.Meta.DisableOverride = false
    elseif onOff == "off" then
        WL_Utils.addInfoToChat("Override disabled")
        WRC.Meta.DisableOverride = true
    else
        WL_Utils.addErrorToChat("Invalid format. Use /override on or /override off")
    end
end

local function getSortForMod(x)
    if x == nil then return "00" end
    if x == "me" then return "01" end
    if x == "env" then return "02" end
    if x == "ooc" then return "03" end
    return "04"
end
local function getRangeForType(type)
    local r = WRC.ChatTypes[type].xyRange
    if r < 10 then
        r = "0" .. r
    end
    return r
end
local function sortCommands(a, b)
    local aCommand = WRC.ChatCommands[a]
    local bCommand = WRC.ChatCommands[b]
    local aMod = getSortForMod(aCommand.modifier)
    local bMod = getSortForMod(bCommand.modifier)
    local aXyRange = getRangeForType(aCommand.type)
    local bXyRange = getRangeForType(bCommand.type)
    return aXyRange .. aMod < bXyRange .. bMod
end
-- a few pastel colors
local commandPossibleColors = {
    "<RGB:0.5,0.5,1>", -- blue
    "<RGB:0.5,1,0.5>", -- green
    "<RGB:1,0.5,0.5>", -- red
    "<RGB:1,0.5,1>", -- pink
    "<RGB:1,1,0.5>", -- yellow
    "<RGB:1,0.75,0.5>", -- orange
}
function WRC.Commands.ListAllCommands()
    local commands = {}
    for command, data in pairs(WRC.ChatCommands) do
        if not data.language then
            table.insert(commands, command)
        end
    end
    table.sort(commands, sortCommands)

    local lastType = WRC.ChatCommands[commands[1]].type
    local lastModifier = WRC.ChatCommands[commands[1]].modifier
    local lastColorIndex = 1
    local msg = "All possible RP Chat Commands<LINE><LINE><INDENT:8>" .. commandPossibleColors[lastColorIndex]
    for _,command in ipairs(commands) do
        local data = WRC.ChatCommands[command]
        if data.type ~= "alert" or WRC.Override(true) then
            if data.type ~= lastType or data.modifier ~= lastModifier then
                lastColorIndex = lastColorIndex + 1
                if lastColorIndex > #commandPossibleColors then
                    lastColorIndex = 1
                end
                msg = msg .. commandPossibleColors[lastColorIndex] .. WL_Utils.MagicSpace
                lastType = data.type
                lastModifier = data.modifier
            end
            msg = msg .. command .. " "
        end
    end
    msg = msg .. "<LINE><INDENT:0>"
    WL_Utils.addInfoToChat(msg)
end

function WRC.Commands.KeepLast(args)
    local onOff = args:gsub("^%s*(.-)%s*$", "%1") -- trim
    if onOff == "on" then
        WL_Utils.addInfoToChat("Keep last enabled")
        WRC.Meta.EnableSaveLastChat()
    elseif onOff == "off" then
        WL_Utils.addInfoToChat("Keep last disabled")
        WRC.Meta.DisableSaveLastChat()
    else
        WL_Utils.addErrorToChat("Invalid format. Use /keeplast on or /keeplast off")
    end
end

local function parseRoll(rollString)
    local numDice, numSides, bonus = 0, 0, 0

    local _, _, dicePart, bonusPart = rollString:find("(%d+d%d+)(.*)")
    if dicePart then
        local _, _, numDiceStr, numSidesStr = dicePart:find("(%d+)d(%d+)")
        if numDiceStr and numSidesStr then
            numDice = tonumber(numDiceStr) or 0
            numSides = tonumber(numSidesStr) or 0
        end
    end

    if bonusPart then
        local _, _, bonusStr = bonusPart:find("(%d+)")
        if bonusStr then
            bonus = tonumber(bonusStr) or 0
        end
    end

    if numDice == 0 or numSides == 0 then
        numDice = 1
        local numSidesStr = rollString:match("%d+")
        if numSidesStr then
            numSides = tonumber(numSidesStr) or 0
        end
    end

    return numDice, numSides, bonus
end

function WRC.Commands.Roll(args)
    local instance = ISChat.instance
    local currentTabID = instance.tabs[instance.currentTabID].tabID
    if currentTabID ~= 0 then
        WL_Utils.addErrorToChat("You must be in the General tab to roll.")
        return
    end

    local parts = WRC.SplitString(args)

    local numDice, numSides, bonus, volume = 0, 0, 0, "say"
    if #parts == 1 then
        numDice, numSides, bonus = parseRoll(parts[1])
    elseif #parts == 2 then
        volume = parts[1]:gsub("^%s*(.-)%s*$", "%1") -- trim
        numDice, numSides, bonus = parseRoll(parts[2])
    else
        WL_Utils.addErrorToChat("Invalid format. <LINE> " .. WRC.SpecialCommands["/roll"].usage)
        return
    end

    if not WRC.ChatTypes[volume] then
        for t, v in pairs(WRC.ChatTypes) do
            for _, a in ipairs(v.command) do
                if a == volume then
                    volume = t
                    break
                end
            end
        end
    end

    if numDice == 0 or numSides == 0 then
        WL_Utils.addErrorToChat("Invalid format. <LINE> " .. WRC.SpecialCommands["/roll"].usage)
        return
    end

    local rolls = {}
    local total = bonus
    for i=1, numDice do
        local roll = ZombRand(numSides) + 1
        table.insert(rolls, roll)
        total = total + roll
    end

    local mutedRadios = {}
    local player = getPlayer()
    local radiosOn = WRU_Utils.getPlayerRadios(player, true)
    for _, radio in ipairs(radiosOn) do
        if WRU_Utils.isRadioBroadcasting(radio) then
            WRU_Utils.setRadioBroadcastingInstant(player, radio, false)
            table.insert(mutedRadios, radio)
        end
    end
    processSayMessage("[UN:" .. player:getUsername() .. "]/roll " .. volume .. " " .. numDice .. " " .. numSides .. " " .. bonus .. " " .. total .. " ".. table.concat(rolls, ","))
    for _, radio in ipairs(mutedRadios) do
        WRU_Utils.setRadioBroadcastingInstant(player, radio, true)
    end
end

function WRC.Commands.Trade(args)
    local parts = WRC.SplitString(args)
    if #parts ~= 1 then
        WL_Utils.addErrorToChat("Invalid format. Use /trade username")
        return
    end
    local username = parts[1]:gsub("^%s*(.-)%s*$", "%1") -- trim
    local player = getPlayer()
    local target = getPlayerFromUsername(username)

    if not target or not WRC.CanSeePlayer(target) then
        WL_Utils.addErrorToChat("Player not found or too far. Use /trade username")
        return
    end

    ISWorldObjectContextMenu.onTrade(nil, player, target)
end

function WRC.Commands.Injure(args)
    local parts = WRC.SplitString(args)
    if #parts ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. Use /injure bodypart injury")
        return
    end
    local bodyPartStr = parts[1]:gsub("^%s*(.-)%s*$", "%1") -- trim
    local injury = parts[2]:gsub("^%s*(.-)%s*$", "%1") -- trim

    -- check if valid body part
    local found = false
    for _,str in ipairs(WRC.GetBodyParts()) do
        if str == bodyPartStr then
            found = true
            break
        end
    end
    if not found then
        WL_Utils.addErrorToChat("Invalid body part. Use /injure bodypart injury")
        return
    end

    local bodyPartType = BodyPartType.FromString(bodyPartStr)
    local bodyPart = getPlayer():getBodyDamage():getBodyPart(bodyPartType)
    if injury == "Bleeding" then
        bodyPart:setBleedingTime(10)
    elseif injury == "Bullet" then
        bodyPart:setHaveBullet(true, 0)
    elseif injury == "Burned" then
        bodyPart:setBurnTime(50)
    elseif injury == "Deep Wound" then
        bodyPart:generateDeepWound()
    elseif injury == "Fracture" then
        bodyPart:setFractureTime(21)
    elseif injury == "Glass Shards" then
        bodyPart:generateDeepShardWound()
    elseif injury == "Infected" then
        bodyPart:setWoundInfectionLevel(10)
    elseif injury == "Scratched" then
        bodyPart:setScratched(true, true)
    elseif injury == "Laceration" then
        bodyPart:setCut(true)
    elseif injury == "Bite" then
        bodyPart:SetBitten(true)
        bodyPart:SetInfected(false)
        bodyPart:SetFakeInfected(false)
    else
        WL_Utils.addErrorToChat("Invalid injury. Use /injure bodypart injury")
        return
    end
    WL_Utils.addInfoToChat("<RGB:1.0,0.0,0.0>Injury applied!")
end

-- args should be a radio frequency: 123, 321.5, 123.4
function WRC.Commands.RadioSync(args)
    if args == nil or args == "" then
        WRC.Meta.SetRadioSync(nil)
        WL_Utils.addInfoToChat("Radio sync disabled")
        return
    end
    local frequency = tonumber(args)
    if frequency == nil then
        WL_Utils.addErrorToChat("Invalid format. Use /radiosync [frequency]")
        return
    end
    WRC.Meta.SetRadioSync(math.floor(frequency * 1000))
    WL_Utils.addInfoToChat("Radio sync set to " .. frequency .. "MHz")
end

function WRC.Commands.SetStatus(args)
    local status = args:gsub("^%s*(.-)%s*$", "%1") -- trim
    if status == nil or status == "" then
        local currentStatus = WRC.Meta.GetStatus(getPlayer():getUsername())
        local msg = "Current status is: " .. currentStatus .. "<LINE><LINE>To change your status use \"/status <status message>\" or \"/status clear\" to clear your status."
        WL_Utils.addInfoToChat(msg)
        return
    end
    if status == "clear" then
        WRC.Meta.SetStatus(nil)
        WL_Utils.addInfoToChat("Status cleared")
        return
    end
    if status:len() < 8 then
        WL_Utils.addErrorToChat("Status too short. Use /status <status message>")
        return
    end
    if status:len() > 64 then
        WL_Utils.addErrorToChat("Status too long. Use /status <status message>")
        return
    end
    WRC.Meta.SetStatus(status)
    WL_Utils.addInfoToChat("Status set to " .. status)
end

function WRC.Commands.PrivateChat(args)
    if not SandboxVars.WastelandRpChat.EnablePrivate then
        WL_Utils.addErrorToChat("Private chat is disabled.")
        return
    end
    local parts = WRC.SplitString(args)
    if #parts ~= 1 then
        WL_Utils.addErrorToChat("Invalid format. Use /private username")
        return
    end
    local username = parts[1]:gsub("^%s*(.-)%s*$", "%1") -- trim
    local target = getPlayerFromUsername(username)

    if WRC.Meta.HasPrivate(true) then
        WL_Utils.addErrorToChat("You are already in a private chat. Use /stopprivate to stop it.")
        return
    end

    if not WRC.Meta.InvitePrivate(username) then
        WL_Utils.addErrorToChat("Player not found or too far. Use /private <username>", {chatId = 1})
        return
    end
end

function WRC.Commands.StopPrivateChat()
    if WRC.Meta.HasPrivate(true) then
        WRC.Meta.StopPrivate()
        WRC.Meta.ClosePrivate()
    else
        WL_Utils.addErrorToChat("You are not in a private chat")
    end
end

function WRC.Commands.Coords()
    if not SandboxVars.WastelandRpChat.AllowPlayerCoords and not WRC.Override() then
        WL_Utils.addErrorToChat("Coordinates are disabled.")
        return
    end
    local player = getPlayer()
    local x = math.floor(player:getX())
    local y = math.floor(player:getY())
    local z = math.floor(player:getZ())
    WL_Utils.addInfoToChat(player:getUsername() .. " is at " .. x .. ", " .. y .. ", " .. z)
end


--- Takes a list and some text
--- if the text is empty it will return the first item in the list
--- if the text matches an item in the list it will return the next item in the list (wrap around) or if isShiftKeyDown() is true it will return the previous item in the list (wrap around)
--- if the text matches the start of an item in the list, it will return that item
---@param list any
---@param text any
function WRC.TabListHandler(list, text)
    if text == nil or text == "" then
        return list[1]
    end
    for i=1, #list do
        if list[i] == text then
            if isShiftKeyDown() then
                return list[(i - 2) % #list + 1]
            end
            return list[(i % #list) + 1]
        end
    end
    for i=1, #list do
        if list[i]:sub(1, #text) == text then
            return list[i]
        end
    end
    return nil
end

function WRC.TabHandlers.MyLangs(text)
    local langs = WRC.Meta.GetKnownLanguages()
    table.sort(langs)
    return WRC.TabListHandler(langs, text)
end

function WRC.TabHandlers.UsernameNotSelf(text)
    local playersArr = getOnlinePlayers()
    local players = {}
    for i=0, playersArr:size()-1 do
        local player = playersArr:get(i)
        -- 10 squares away
        -- not invisible
        if WRC.CanSeePlayer(player) then
            table.insert(players, player:getUsername())
        end
    end
    table.sort(players)
    return WRC.TabListHandler(players, text)
end

function WRC.TabHandlers.Username(text)
    local playersArr = getOnlinePlayers()
    local players = {}
    for i=0, playersArr:size()-1 do
        local player = playersArr:get(i)
        -- 10 squares away
        -- not invisible
        if WRC.CanSeePlayer(player, true) then
            table.insert(players, player:getUsername())
        end
    end
    table.sort(players)
    return WRC.TabListHandler(players, text)
end

function WRC.TabHandlers.AnyLang(text)
    local langs = {}
    for lang, _ in pairs(WRC.Languages) do
        table.insert(langs, lang)
    end
    table.sort(langs)
    return WRC.TabListHandler(langs, text)
end

function WRC.TabHandlers.FocusedUsername(text)
    table.sort(WRC.Meta.FocusedPersons)
    return WRC.TabListHandler(WRC.Meta.FocusedPersons, text)
end

function WRC.TabHandlers.OnOff(text)
    local onOff = {"on", "off"}
    return WRC.TabListHandler(onOff, text)
end

function WRC.TabHandlers.BodyPart(text)
    local bodyParts = {}
    for i=0,16 do
        table.insert(bodyParts, BodyPartType:ToString(BodyPartType.FromIndex(i)))
    end
    return WRC.TabListHandler(WRC.GetBodyParts(), text)
end

function WRC.TabHandlers.Injury(text)
    return WRC.TabListHandler(WRC.GetInjuries(), text)
end

function WRC.TabHandlers.RadioFrequencies(text)
    local radios = WRU_Utils.getPlayerRadios(getPlayer(), true)
    local frequencies = {}
    for _, radio in ipairs(radios) do
        table.insert(frequencies, tostring(WRU_Utils.getRadioFrequency(radio) / 1000))
    end
    return WRC.TabListHandler(frequencies, text)
end