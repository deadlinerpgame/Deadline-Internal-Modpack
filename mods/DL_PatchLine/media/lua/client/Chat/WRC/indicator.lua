if not isClient() then return end -- only in MP
WRC = WRC or {}

WRC.Indicator = WRC.Indicator or {
    players = {},
    tickDelay = 0,
    muteTyping = false,
}

function WRC.Indicator.shouldSync()
    return not WRC.Indicator.muteTyping and not getPlayer():isGhostMode()
end

local isTyping = false
local lastUpdate = 0
local isCleared = false

local nextXyRange = 0
local nextZRange = 0
local emptyObject = {}
function WRC.Indicator.onTyping(xyRange, zRange)
    if not WRC.Indicator.shouldSync() then
        isTyping = false
        return
    end
    nextXyRange = xyRange
    nextZRange = zRange
    isTyping = true
end

function WRC.Indicator.onCleared(immediately)
    isTyping = false
    if immediately then
        lastUpdate = 0
    end
end


function WRC.Indicator.doLog(text)
    local p = getPlayer()
    local x = math.floor(p:getX())
    local y = math.floor(p:getY())
    local z = math.floor(p:getZ())
    local currentLanguage = WRC.Meta.GetCurrentLanguage(p:getUsername())
    sendClientCommand(p, 'WRC', 'doLog', {x, y, z, text, currentLanguage})
end

function WRC.Indicator.doRadioLog(text)

    local p = getPlayer()
    local x = math.floor(p:getX())
    local y = math.floor(p:getY())
    local z = math.floor(p:getZ())
    local currentLanguage = WRC.Meta.GetCurrentLanguage(p:getUsername())
    sendClientCommand(p, 'WRC', 'doRadioLog', {x, y, z, text, currentLanguage})
end

function WRC.Indicator.update()
    local ts = getTimestampMs()

    if isTyping and (isCleared or ts - lastUpdate > 4000) then
        sendClientCommand(getPlayer(), 'WRC', 'onTyping', {nextXyRange, nextZRange})
        isCleared = false
        lastUpdate = ts
    end

    if not isTyping and not isCleared and ts - lastUpdate > 4000 then
        sendClientCommand(getPlayer(), 'WRC', 'onCleared', emptyObject)
        isCleared = true
        lastUpdate = ts
    end

    if WRC.Indicator.tickDelay > 0 then
        WRC.Indicator.tickDelay = WRC.Indicator.tickDelay - 1
    else
        WRC.Indicator.tickDelay = 30

        local toRemove = {}
        for username, lastTs in pairs(WRC.Indicator.players) do
            if lastTs + 8000 < ts then
                table.insert(toRemove, username)
            end
        end
        for _, username in pairs(toRemove) do
            WRC.Indicator.players[username] = nil
        end
    end
end

WRC.Indicator.IndicatorWidth = getTextManager():MeasureStringX(UIFont.Small, "...")
WRC.Indicator.IndicatorHeight = getTextManager():MeasureStringY(UIFont.Small, "...")
WRC.Indicator.UiElements = WRC.Indicator.UiElements or {}
function WRC.Indicator.DrawOverheads()
    local zoom = getCore():getZoom(0)
    local me = getPlayer()
    local c = math.floor(getTimestampMs()/1000) % 3
    local typingText = string.rep(".", c + 1)
    for _,x in pairs(WRC.Indicator.UiElements) do x.seen = false end
    for username, _ in pairs(WRC.Indicator.players) do
        local player = getPlayerFromUsername(username)
        if player and me:CanSee(player) then
            local x = isoToScreenX(0, player:getX(), player:getY(), player:getZ())
            local y = isoToScreenY(0, player:getX(), player:getY(), player:getZ())
            y = y - (130 / zoom) - (3*zoom)
            local ele = WRC.Indicator.UiElements[username]
            if ele then
                ele:setX(x - (ele.width / 2))
                ele:setY(y)
            else
                ele = ISUIElement:new(x - (WRC.Indicator.IndicatorWidth/2), y, WRC.Indicator.IndicatorWidth, WRC.Indicator.IndicatorHeight)
                ele.anchorTop = false
                ele.anchorBottom = true
                ele:initialise()
                ele:addToUIManager()
                ele:backMost()
                WRC.Indicator.UiElements[username] = ele
            end
            ele.seen = true
            ele:drawTextCentre(typingText, WRC.Indicator.IndicatorWidth/2, 0, 1, 1, 1, 1, UIFont.Small)
        end
    end
    for k,v in pairs(WRC.Indicator.UiElements) do
        if not v.seen then
            v:removeFromUIManager()
            WRC.Indicator.UiElements[k] = nil
        end
    end
end

local fntSize = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
function WRC.Indicator.DrawTypingInChat(chatInstance)
    local typers = {}
    for username, _ in pairs(WRC.Indicator.players) do
        table.insert(typers, WRC.Meta.GetName(username))
    end

    if #typers > 0 then
        table.sort(typers)

        local text = getText("UI_WRC_Typing") .. table.concat(typers, ", ")

        local textEntry = chatInstance.textEntry
        local x = textEntry:getX() + 2
        local y = textEntry:getY() - fntSize - 2
        local width = getTextManager():MeasureStringX(UIFont.Small, text)
        if width > textEntry:getWidth() then
            text = getText("UI_WRC_ManyTyping")
        end
        chatInstance:drawText(text, x, y, 1, 1, 1, 1, UIFont.Small)
    end
end