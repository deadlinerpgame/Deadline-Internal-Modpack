---@diagnostic disable: duplicate-set-field
if not isClient() then return end -- only in MP

-- TODO: Refactor this file. Its a mess.

require "Chat/ISChat"
require "Chat/WRC"
require "GroundHightlighter"

WRC = WRC or {}
WRC.ISChatOriginal = WRC.ISChatOriginal or {}

local fntSize = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()

WRC.ISChatOriginal.initialise = WRC.ISChatOriginal.initialise or ISChat.initialise
function ISChat:initialise()
    WRC.ISChatOriginal.initialise(self)

    -- Panel Overrides for Prod
    self.panel.render = WRC.ISTabPanel.render
    self.panel.getTabIndexAtX = WRC.ISTabPanel.getTabIndexAtX
    -- Panel Overrides for Dev
    -- self.panel.render = function (s) WRC.ISTabPanel.render(s) end
    -- self.panel.getTabIndexAtX = function (s, x, scrollX) return WRC.ISTabPanel.getTabIndexAtX(s, x, scrollX) end

    local nextStreamId = #ISChat.allChatStreams+1
    WRC.FocusTabId = 90
    WRC.FocusStreamId = nextStreamId
    ISChat.allChatStreams[nextStreamId] = {name = "Focused", command = "/focusedchat", tabID = 91}

    nextStreamId = nextStreamId+1
    WRC.PrivateTabId = 91
    WRC.PrivateStreamId = nextStreamId
    ISChat.allChatStreams[nextStreamId] = {name = "Private", command = "/privatechat", tabID = 92}

    nextStreamId = nextStreamId+1
    WRC.RadioTabId = 92
    WRC.RadioStreamId = nextStreamId
    ISChat.allChatStreams[nextStreamId] = {name = "Radio", command = "/radiochat", tabID = 93}

    nextStreamId = nextStreamId+1
    WRC.OocTabId = 93
    WRC.OocStreamId = nextStreamId
    ISChat.allChatStreams[nextStreamId] = {name = "OOC", command = "/oocchat", tabID = 94}

    nextStreamId = nextStreamId+1
    WRC.StaffTabId = 94
    WRC.StaffStreamId = nextStreamId
    ISChat.allChatStreams[nextStreamId] = {name = "Staff", command = "/staff", tabID = 95}

    ISChat.allChatStreams[7].tabID = 7
    ISChat.defaultTabStream[7] = ISChat.allChatStreams[7]
end

WRC.ISChatOriginal.onTextChange = WRC.ISChatOriginal.onTextChange or ISChat.onTextChange
function ISChat:onTextChange()
    if ISChat.instance.currentTabID > 6 then
        WRC.ISChatOriginal.onTextChange(self)
        WRC.Indicator.onCleared()
        return
    end

    local text = ISChat.instance.textEntry:getInternalText()
    local textLen = text:len()

    local firstLetter = text:sub(1, 1)
    local firstSpace = text:find(" ")
    if firstLetter == "/" and textLen > 2 and firstSpace then
        local ending = text:sub(firstSpace , textLen)
        if ending == " /" then
            WRC.Indicator.onCleared()
            ISChat.instance.textEntry:setText("/")
            return
        end
    end

    if textLen == 0 then
        WRC.Indicator.onCleared()
        return
    end

    local xyRange, zRange = WRC.GetRangeFromMessage(text)
    if xyRange and xyRange > 0 then
        WRC.Indicator.onTyping(xyRange, zRange)
        return
    end

    WRC.Indicator.onCleared()
end

WRC.ISChatOriginal.calcTabSize = WRC.ISChatOriginal.calcTabSize or ISChat.calcTabSize
function ISChat:calcTabSize()
    local tabSize = WRC.ISChatOriginal.calcTabSize(self)
    -- Make room for the typing indicator
    tabSize.height = tabSize.height - fntSize - 4
    return tabSize
end

WRC.Incapacitation = {};
WRC.Incapacitation.UIElements = {};

function WRC.Incapacitation.ShowCasualties()
    local zoom = getCore():getZoom(0);
    for _, x in pairs(WRC.Incapacitation.UIElements) do x.seen = false end
    
    local allPlayers = getOnlinePlayers()
    if not allPlayers then return end
    local me = getPlayer()
    for i=0,allPlayers:size()-1 do
        local player = allPlayers:get(i)
        local username = player:getUsername()
        -- we double check the distance because admins can see players everyone on the map
        if player:getModData().JaxeRevival_Incapacitated and WRC.CanSeePlayer(player, true, 20) and me:getDistanceSq(player) < 2500 then
            local x = isoToScreenX(0, player:getX(), player:getY(), player:getZ())
            local y = isoToScreenY(0, player:getX(), player:getY(), player:getZ())
            y = y - WRC.Afk.IndicatorHeight;
            if WRC.Indicator.players[username] then y = y - WRC.Indicator.IndicatorHeight - 2 end
            local ele = WRC.Incapacitation.UIElements[username]

            local width = getTextManager():MeasureStringX(UIFont.Small, "[INJURED!]");

            if ele then
                ele:setX(x - (ele.width / 2))
                ele:setY(y)
            else
                ele = ISUIElement:new(x - (width/2), y, width, WRC.Afk.IndicatorHeight);
                ele.anchorTop = false
                ele.anchorBottom = true
                ele:initialise()
                ele:addToUIManager()
                ele:backMost()
                WRC.Incapacitation.UIElements[username] = ele
            end
            ele.seen = true
            ele:drawTextCentre("[INJURED!]", width/2, 8, 1, 0.2, 0.2, 1.0);
            ele:drawTextCentre("[INJURED!]", width/2, 8, 1, 0, 0, 1.0);
        end
    end
     for k,v in pairs(WRC.Incapacitation.UIElements) do
         if not v.seen then
             v:removeFromUIManager()
             WRC.Incapacitation.UIElements[k] = nil
         end
     end
end

WRC.ISChatOriginal.render = WRC.ISChatOriginal.render or ISChat.render
function ISChat:render()
    WRC.ISChatOriginal.render(self)
    if not ISChat.instance or not ISChat.instance.chatText then return end

    -- Only show scroll to bottom button if we're not scrolled to the bottom
    if ISChat.instance.chatText then
        local chatText = ISChat.instance.chatText
        local scrolledToBottom = (chatText:getScrollHeight() <= chatText:getHeight()) or (chatText.vscroll and chatText.vscroll.pos == 1)
        if self.scrollToBottomButton:getIsVisible() == scrolledToBottom then
            self.scrollToBottomButton:setVisible(not scrolledToBottom)
        end
    end

    -- Toggle the range indicator
    if ISChat.instance.showRangeTicks > 0 then
        if self.showRangeTicks % 20 == 0 then
            if self.showRangeSwitch then
                self.groundHighlighter:setColor(0.8, 0.8, 0.8, 1.0)
            else
                self.groundHighlighter:setColor(0.2, 0.2, 0.2, 1.0)
            end
            self.showRangeSwitch = not self.showRangeSwitch
        end

        if ISChat.instance.showRangeTicks == 1 then
            self.groundHighlighter:remove()
        end
        ISChat.instance.showRangeTicks = ISChat.instance.showRangeTicks - 1
    end

    local tabID = ISChat.instance.tabs[ISChat.instance.currentTabID].tabID
    local hasNoText = ISChat.instance.textEntry:getInternalText():len() == 0

    -- Placeholders!
    if hasNoText then
        if tabID == 0 then
            WRC.Handlers.DrawGeneralPlaceholder(self)
        elseif tabID == WRC.RadioTabId then
            WRC.Handlers.DrawRadioPlaceholder(self)
        elseif tabID == WRC.FocusTabId then
            WRC.Handlers.DrawFocusPlaceholder(self)
        elseif tabID == WRC.PrivateTabId then
            -- WRC.Handlers.DrawPrivatePlaceholder(self) TODO: Implement
        end
    end

    WRC.Afk.ShowAfkOnPlayers()
    WRC.Incapacitation.ShowCasualties()
    WRC.StatusIndicator.ShowStatusIndicatorOnHovered()
    DeadlineDice.RenderNPCData();

    if WRC.Meta.GetOverheadTypingIndicator() then
        WRC.Indicator.DrawOverheads()
    end

    WRC.Indicator.DrawTypingInChat(self)

    
end

WRC.ISChatOriginal.createChildren = WRC.ISChatOriginal.createChildren or ISChat.createChildren
function ISChat:createChildren()
    WRC.ISChatOriginal.createChildren(self)

    self.muteTypingButton = ISButton:new(self.gearButton:getX() - 30, 1, 20, 16, "", self, ISChat.onMuteTypingButtonClick)
    self.muteTypingButton.anchorRight = true
    self.muteTypingButton.anchorLeft = false
    self.muteTypingButton:initialise()
    self.muteTypingButton.borderColor.a = 0.0
    self.muteTypingButton.backgroundColor.a = 0.0
    self.muteTypingButton.backgroundColorMouseOver.a = 0.0
    if WRC.Indicator.muteTyping then
        self.muteTypingButton:setImage(getTexture("media/ui/WRC_typing_off.png"))
    else
        self.muteTypingButton:setImage(getTexture("media/ui/WRC_typing_on.png"))
    end
    self.muteTypingButton:setUIName("toggle typing indicator")
    self:addChild(self.muteTypingButton)
    self.muteTypingButton:setVisible(true)

    self.showRangeButton = ISButton:new(self.muteTypingButton:getX() - 30, 1, 20, 16, "", self, ISChat.onShowRangeButtonClick)
    self.showRangeButton.anchorRight = true
    self.showRangeButton.anchorLeft = false
    self.showRangeButton:initialise()
    self.showRangeButton.borderColor.a = 0.0
    self.showRangeButton.backgroundColor.a = 0.0
    self.showRangeButton.backgroundColorMouseOver.a = 0.0
    self.showRangeButton:setImage(getTexture("media/ui/WRC_range.png"))
    self.showRangeButton:setUIName("toggle range indicator")
    self:addChild(self.showRangeButton)
    self.showRangeButton:setVisible(true)
    self.showRangeTicks = 0

    self.scrollToBottomButton = ISButton:new(self.width - 20, self.height - self.textEntry.height - 30, 20, 16, "", self, ISChat.onScrollToBottomClick)
    self.scrollToBottomButton.anchorRight = true
    self.scrollToBottomButton.anchorLeft = false
    self.scrollToBottomButton.anchorBottom = true
    self.scrollToBottomButton.anchorTop = false
    self.scrollToBottomButton:initialise()
    self.scrollToBottomButton.borderColor.a = 0.0
    self.scrollToBottomButton.backgroundColor.a = 0.0
    self.scrollToBottomButton.backgroundColorMouseOver.a = 0.0
    self.scrollToBottomButton:setImage(getTexture("media/ui/WRC_scrollBottom.png"))
    self.scrollToBottomButton:setUIName("scroll to bottom")
    self:addChild(self.scrollToBottomButton)
    self.scrollToBottomButton:setVisible(false)

    self.groundHighlighter = GroundHightlighter:new()
    self.groundHighlighter:setColor(0.8, 0.8, 0.8, 0.5)
end

WRC.ISChatOriginal.onGearButtonClick = WRC.ISChatOriginal.onGearButtonClick or ISChat.onGearButtonClick
function ISChat:onGearButtonClick()
    WRC.ISChatOriginal.onGearButtonClick(self)
    local context = getPlayerContextMenu(0)
    if context then
        local myPlayer = getPlayer()
        local players = getOnlinePlayers()
        WRC.Meta.CreateActionsContext(context, myPlayer, players)
        WRC.Meta.CreateCharacterContext(context, myPlayer)
        WRC.Meta.CreateChatSettingsContext(context)
        if WRC.Override(true) then
            WRC.Meta.CreateAdminContext(context, myPlayer, players)
        end
    end
end

WRC.ISChatOriginal.onTabAdded = WRC.ISChatOriginal.onTabAdded or ISChat.onTabAdded
function ISChat.onTabAdded(title, tabID)
    if tabID == 0 then
        WRC.ISChatOriginal.onTabAdded(title, tabID)
        WRC.ISChatOriginal.onTabAdded("Focused", WRC.FocusTabId)
        WRC.ISChatOriginal.onTabAdded("Private", WRC.PrivateTabId)
        WRC.ISChatOriginal.onTabAdded("Radio", WRC.RadioTabId)
        WRC.ISChatOriginal.onTabAdded("OOC", WRC.OocTabId)
        WRC.ISChatOriginal.onTabAdded("Staff", WRC.StaffTabId)
    elseif tabID == 1 then
        WRC.ISChatOriginal.onTabAdded(title, 6)
    else
        WRC.ISChatOriginal.onTabAdded(title, tabID)
    end
end

WRC.ISChatOriginal.onTabRemoved = WRC.ISChatOriginal.onTabRemoved or ISChat.onTabRemoved
function ISChat.onTabRemoved(tabTitle, tabID)
    if tabID == 0 then
        WRC.ISChatOriginal.onTabRemoved(tabTitle, tabID)
        WRC.ISChatOriginal.onTabRemoved("Focus", WRC.FocusTabId)
        WRC.ISChatOriginal.onTabRemoved("Private", WRC.PrivateTabId)
        WRC.ISChatOriginal.onTabRemoved("Radio", WRC.RadioTabId)
        WRC.ISChatOriginal.onTabRemoved("OOC", WRC.OocTabId)
        WRC.ISChatOriginal.onTabAdded("Staff", WRC.StaffTabId)
    elseif tabID == 1 then
        WRC.ISChatOriginal.onTabRemoved(tabTitle, 6)
    else
        WRC.ISChatOriginal.onTabRemoved(tabTitle, tabID)
    end
end

WRC.ISChatOriginal.unfocus = WRC.ISChatOriginal.unfocus or ISChat.unfocus
function ISChat:unfocus()
    WRC.ISChatOriginal.unfocus(self)
    WRC.Indicator.onCleared()
end

WRC.ISChatOriginal.focus = WRC.ISChatOriginal.focus or ISChat.focus
function ISChat:focus()
    WRC.ISChatOriginal.focus(self)
    if ISChat.instance.currentTabID == 5 then
        self.textEntry:setText(WRC.Meta.IsSaveLastChatEnabled() and WRC.Meta.LastOoc or "/ooc ")
    elseif ISChat.instance.currentTabID < 7 then
        self.textEntry:setText(WRC.Meta.IsSaveLastChatEnabled() and WRC.Meta.LastChat or "")
    end
end

WRC.ISChatOriginal.onCommandEntered = WRC.ISChatOriginal.onCommandEntered or ISChat.onCommandEntered
function ISChat:onCommandEntered()
    local text = ISChat.instance.textEntry:getInternalText()

    WRC.Indicator.onCleared(true)
    local currentTabId = ISChat.instance.tabs[ISChat.instance.currentTabID].tabID
    if currentTabId == WRC.RadioTabId then
        WRC.Indicator.doRadioLog(text)
    end
    if currentTabId ~= WRC.PrivateTabId then
        WRC.Indicator.doLog(text)
    end


    if WRC.Handlers.SpecialCommand(text) or WRC.Handlers.CommandEntered(text) or WRC.Handlers.IsOutdated(text) then
        ISChat.instance:logChatCommand(text)
        ISChat.instance:unfocus()
        doKeyPress(false)
        ISChat.instance.timerTextEntry = 20
        return
    end

    WRC.ISChatOriginal.onCommandEntered(self)
end

function ISChat:onMuteTypingButtonClick()
    WRC.Indicator.muteTyping = not WRC.Indicator.muteTyping
    if WRC.Indicator.muteTyping then
        self.muteTypingButton:setImage(getTexture("media/ui/WRC_typing_off.png"))
    else
        self.muteTypingButton:setImage(getTexture("media/ui/WRC_typing_on.png"))
    end
end

function ISChat:onShowRangeButtonClick()
    if self.showRangeTicks > 0 then
        self.showRangeTicks = 1
    end

    local context = ISContextMenu.get(0, self:getAbsoluteX() + self:getWidth() / 2, self:getAbsoluteY() + self.showRangeButton:getY())
    if not context then return end

    for chatType, data in pairs(WRC.ChatTypes) do
        context:addOption(chatType, ISChat.instance, ISChat.instance.showMessageRange, data.xyRange)
    end
end

function ISChat:onScrollToBottomClick()
    if ISChat.instance.chatText then
        ISChat.instance.chatText:setYScroll(-10000);
    end
end

function ISChat:showMessageRange(range)
    local p = getPlayer()
    local x = p:getX()
    local y = p:getY()
    local z = p:getZ()
    self.lastRange = range
    self.showRangeTicks = 100
    self.showRangeSwitch = false
    self.groundHighlighter:highlightCircle(x, y, range + .99, z)
end

WRC.ISChatOriginal.addLineInChat = WRC.ISChatOriginal.addLineInChat or ISChat.addLineInChat
function ISChat.addLineInChat(chatMessage, tabID)
    if WRC.Handlers.AddLineInChat(chatMessage, tabID) then
        return
    end

    if tabID == 1 then
        tabID = 6 -- Admin Chat
    end

    WRC.ISChatOriginal.addLineInChat(chatMessage, tabID)
end

-- We have to override this to stop the focusOnTab issue
function ISChat:onActivateView()
    if self.tabCnt > 1 then
        self.chatText = self.panel.activeView.view
    end
    for i,blinkedTab in ipairs(self.panel.blinkTabs) do
        if self.chatText.tabTitle and self.chatText.tabTitle == blinkedTab then
            table.remove(self.panel.blinkTabs, i)
            break
        end
    end
    for i,tab in ipairs(self.tabs) do
        if tab.tabTitle == self.chatText.tabTitle then
            self.currentTabID = i
            break
        end
    end
    if not self.chatText.tabTitle then
        self.currentTabID = 0
        return
    end
    if self.chatText.tabID == WRC.FocusTabId
    or self.chatText.tabID == WRC.RadioTabId
    or self.chatText.tabID == WRC.OocTabId
    or self.chatText.tabID == WRC.PrivateTabId
    or self.chatText.tabID == WRC.StaffTabId then
        focusOnTab(0)
    elseif self.chatText.tabID == 6 then
        focusOnTab(1)
    else
        focusOnTab(self.chatText.tabID)
    end
end

-- We have to override this entire thing to handle tab complete
WRC.ISChatOriginal.onSwitchStream = WRC.ISChatOriginal.onSwitchStream or ISChat.onSwitchStream
function ISChat.onSwitchStream()
    local tabId = ISChat.instance.currentTabID
    if tabId > 6 then
        WRC.ISChatOriginal.onSwitchStream()
        return
    end

    if not ISChat.focused then return end

    local t = ISChat.instance.textEntry
    ---@type string
    local internalText = t:getInternalText()
    local parts = WRC.SplitString(internalText)
    local possibleCommands = {}
    for command, data in pairs(WRC.SpecialCommands) do
        if not data.adminOnly or WRC.Override() then
            table.insert(possibleCommands, command)
        end
    end
    if #parts == 0 then return end

    if #parts == 1 and internalText:sub(internalText:len(), internalText:len()) ~= " " then
        local complete = WRC.TabListHandler(possibleCommands, parts[1])
        if complete then
            t:setText(complete)
            return
        end
    end

    if not WRC.SpecialCommands[parts[1]] then return end
    local cnt = #parts
    local text = ""
    if internalText:sub(internalText:len(), internalText:len()) == " " then
        cnt = cnt + 1
    else
        text = parts[cnt]
    end
    local tabHandlers = WRC.SpecialCommands[parts[1]].tabHandlers
    if cnt - 1 > #tabHandlers then
        return
    end
    local handler =  tabHandlers[cnt - 1]
    if not handler or handler == "" then
        return
    end
    local complete = WRC.TabHandlers[handler](text)
    if not complete then
        return
    end
    local newText = ""
    for i=1,cnt-1 do
        if parts[i]:find(" ") then
            newText = newText .. '"' .. parts[i] .. '" '
        else
            newText = newText .. parts[i] .. " "
        end
    end
    if complete:find(" ") then
        newText = newText .. '"' .. complete .. '"'
    else
        newText = newText .. complete
    end
    t:setText(newText)
end


WRC.ISTabPanel = {}
-- An alternative panel render which doesn't blink tabs, but changes the text to red instead
function WRC.ISTabPanel:render()
    local showPrivate = WRC.Meta.HasPrivate(true)
    local showFocused = WRC.Meta.HasFocus()
    local showRadio = WRU_Utils.AreAnyRadiosOn(getPlayer())
    local showStaff = WL_Utils.isStaff(getPlayer())

    if not showStaff and self.activeView.name == "Staff" then
        for i,v in ipairs(self.viewList) do
            if v.name == "Staff" then
                local next = self.viewList[i % #self.viewList + 1].name
                self:activateView(next)
                break
            end
        end
    end

    if not showPrivate and self.activeView.name == "Private" then
        for i,v in ipairs(self.viewList) do
            if v.name == "Private" then
                local next = self.viewList[i % #self.viewList + 1].name
                self:activateView(next)
                break
            end
        end
    end

    if not showFocused and self.activeView.name == "Focused" then
        for i,v in ipairs(self.viewList) do
            if v.name == "Focused" then
                local next = self.viewList[i % #self.viewList + 1].name
                self:activateView(next)
                break
            end
        end
    end

    if not showRadio and self.activeView.name == "Radio" then
        for i,v in ipairs(self.viewList) do
            if v.name == "Radio" then
                local next = self.viewList[i % #self.viewList + 1].name
                self:activateView(next)
                break
            end
        end
    end

	local newViewList = {}
	local tabDragSelected = -1
	if self.draggingTab and not self.isDragging and ISTabPanel.xMouse > -1 and ISTabPanel.xMouse ~= self:getMouseX() then -- do we move the mouse since we have let the left button down ?
		self.isDragging = self.allowDraggingTabs
	end
	local tabWidth = self.maxLength
	local inset = 1 -- assumes a 1-pixel window border on the left to avoid
	local gap = 1 -- gap between tabs
	if self.isDragging and not ISTabPanel.mouseOut then
		-- we fetch all our view to remove the tab of the view we're dragging
		for i,viewObject in ipairs(self.viewList) do
			if i ~= (self.draggingTab + 1) then
				table.insert(newViewList, viewObject)
			else
				ISTabPanel.viewDragging = viewObject
			end
		end
		-- in wich tab slot are we dragging our tab
		tabDragSelected = self:getTabIndexAtX(self:getMouseX()) - 1
		tabDragSelected = math.min(#self.viewList - 1, math.max(tabDragSelected, 0))
		-- we draw a white rectangle to show where our tab is going to be
		self:drawRectBorder(inset + (tabDragSelected * (tabWidth + gap)), 0, tabWidth, self.tabHeight - 1, 1,1,1,1)
	else -- no dragging, we display all our tabs
		newViewList = self.viewList
	end
	-- our principal rect, wich display our different view
	self:drawRect(0, self.tabHeight, self.width, self.height - self.tabHeight, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
	self:drawRectBorder(0, self.tabHeight, self.width, self.height - self.tabHeight, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
	local x = inset
	if self.centerTabs and (self:getWidth() >= self:getWidthOfAllTabs()) then
		x = (self:getWidth() - self:getWidthOfAllTabs()) / 2
	else
		x = x + self.scrollX
	end
	local widthOfAllTabs = self:getWidthOfAllTabs()
	local overflowLeft = self.scrollX < 0
	local overflowRight = x + widthOfAllTabs > self.width
    self.blinkAlphaDirection = self.blinkAlphaDirection or 1
    self.blinkAlpha = (self.blinkAlpha or 0) + (self.blinkAlphaDirection * (UIManager.getMillisSinceLastRender() / 500))
    if self.blinkAlpha >= 1 then
        self.blinkAlpha = 1
        self.blinkAlphaDirection = -1
    elseif self.blinkAlpha <= 0 then
        self.blinkAlpha = 0
        self.blinkAlphaDirection = 1
    end
    local unreadTextColor, unreadBackgroundColor, unreadBlinking = WRC.Meta.GetUnreadTabOptions()
	if widthOfAllTabs > self.width then
		self:setStencilRect(0, 0, self.width, self.tabHeight)
	end
	for i,viewObject in ipairs(newViewList) do
        if  (showFocused or viewObject.name ~= "Focused")
        and (showRadio or viewObject.name ~= "Radio")
        and (showPrivate or viewObject.name ~= "Private")
        and (showStaff or viewObject.name ~= "Staff")
        then
            tabWidth = self.equalTabWidth and self.maxLength or viewObject.tabWidth
            -- if we drag a tab over an existing one, we move the other
            if tabDragSelected ~= -1 and i == (tabDragSelected + 1) then
                x = x + tabWidth + gap
            end
            self.shouldBlink = self.blinkTab
            if self.blinkTabs then
                for j,tab in ipairs(self.blinkTabs) do
                    if tab and tab == viewObject.name then
                        self.shouldBlink = true
                    end
                end
            end
            -- if this tab is the active one, we make the tab btn lighter
            if viewObject.name == self.activeView.name and not self.isDragging and not ISTabPanel.mouseOut then
                self:drawTextureScaled(ISTabPanel.tabSelected, x, 0, tabWidth, self.tabHeight - 1, self.tabTransparency,1,1,1)
                self.shouldBlink = false
            else
                self:drawTextureScaled(ISTabPanel.tabUnSelected, x, 0, tabWidth, self.tabHeight - 1, self.tabTransparency,1,1,1)
                if self:getMouseY() >= 0 and self:getMouseY() < self.tabHeight and self:isMouseOver() and self:getTabIndexAtX(self:getMouseX()) == i then
                    viewObject.fade:setFadeIn(true)
                else
                    viewObject.fade:setFadeIn(false)
                end
                viewObject.fade:update()
                self:drawTextureScaled(ISTabPanel.tabSelected, x, 0, tabWidth, self.tabHeight - 1, 0.2 * viewObject.fade:fraction(),1,1,1)
            end

            if self.shouldBlink then
                self:drawTextureScaled(ISTabPanel.tabSelected, x, 0, tabWidth, self.tabHeight - 1, self.tabTransparency,1,1,1)
                self:drawRect(x, 0,
                              tabWidth, self.tabHeight - 1,
                              (unreadBlinking and self.blinkAlpha or (0.5 * self.tabTransparency)) * 0.8,
                              unreadBackgroundColor.r, unreadBackgroundColor.g, unreadBackgroundColor.b);

                self:drawTextCentre(viewObject.name, x + (tabWidth / 2), 3, unreadTextColor.r, unreadTextColor.g, unreadTextColor.b, self.textTransparency, UIFont.Small);
            else
                self:drawTextCentre(viewObject.name, x + (tabWidth / 2), 3, 1, 1, 1, self.textTransparency, UIFont.Small);
            end
            x = x + tabWidth + gap
        end
	end
	local butPadX = 3
	if overflowLeft then
		local tex = getTexture("media/ui/ArrowLeft.png")
		local butWid = tex:getWidthOrig() + butPadX * 2
		self:drawRect(inset, 0, butWid, self.tabHeight, 1, 0, 0, 0)
		self:drawRectBorder(inset, 0, butWid, self.tabHeight, 1, 1, 1, 1)
		self:drawTexture(tex, inset + butPadX, (self.tabHeight - tex:getHeight()) / 2, 1, 1, 1, 1)
	end
	if overflowRight then
		local tex = getTexture("media/ui/ArrowRight.png")
		local butWid = tex:getWidthOrig() + butPadX * 2
		self:drawRect(self.width - inset - butWid, 0, butWid, self.tabHeight, 1, 0, 0, 0)
		self:drawRectBorder(self.width - inset - butWid, 0, butWid, self.tabHeight, 1, 1, 1, 1)
		self:drawTexture(tex, self.width - butWid + butPadX, (self.tabHeight - tex:getHeight()) / 2, 1, 1, 1, 1)
	end
	if widthOfAllTabs > self.width then
		self:clearStencilRect()
	end
	-- we draw a ghost of our tab we currently dragging
	if self.draggingTab and self.isDragging and not ISTabPanel.mouseOut then
		if self.draggingTab > 0 then
			self:drawTextureScaled(ISTabPanel.tabSelected, inset + (self.draggingTab * (tabWidth + gap)) + (self:getMouseX() - ISTabPanel.xMouse), 0, tabWidth, self.tabHeight - 1, 0.8,1,1,1)
			self:drawTextCentre(ISTabPanel.viewDragging.name, inset + (self.draggingTab * (tabWidth + gap)) + (self:getMouseX() - ISTabPanel.xMouse) + (tabWidth / 2), 3, 1, 1, 1, 1, UIFont.Normal)
		else
			self:drawTextureScaled(ISTabPanel.tabSelected, inset + (self:getMouseX() - ISTabPanel.xMouse), 0, tabWidth, self.tabHeight - 1, 0.8,1,1,1)
			self:drawTextCentre(ISTabPanel.viewDragging.name, inset + (self:getMouseX() - ISTabPanel.xMouse) + (tabWidth / 2), 3, 1, 1, 1, 1, UIFont.Normal)
		end
    end
end

function WRC.ISTabPanel:getTabIndexAtX(x, scrollX)
	local inset = 1
	local gap = 1
	local left = inset
	if self.centerTabs and (self:getWidth() >= self:getWidthOfAllTabs()) then
		left = (self:getWidth() - self:getWidthOfAllTabs()) / 2
	else
		left = left + (scrollX or self.scrollX)
	end

    local showFocused = WRC.Meta.HasFocus()
    local showRadio = WRU_Utils.AreAnyRadiosOn(getPlayer())
    local showPrivate = WRC.Meta.HasPrivate(true)
    local showStaff = WL_Utils.isStaff(getPlayer())
	for index,viewObject in ipairs(self.viewList) do
        if  (showFocused or viewObject.name ~= "Focused")
        and (showRadio or viewObject.name ~= "Radio")
        and (showPrivate or viewObject.name ~= "Private")
        and (showStaff or viewObject.name ~= "Staff")
        then
            local tabWidth = self.equalTabWidth and self.maxLength or viewObject.tabWidth
            if x >= left and x < left + tabWidth + gap then
                return index
            end
            left = left + tabWidth + gap
        end
	end
	return -1
end

function WRC.MakeShowDialogPrompt(message, callback)
    return function()
        local scale = getTextManager():MeasureStringY(UIFont.Small, "XXX") / 12

        local width = 200 * scale
        local height = 130 * scale
        local x = (getCore():getScreenWidth() / 2) - (width / 2)
        local y = (getCore():getScreenHeight() / 2) - (height / 2)
        local modal = ISTextBox:new(x, y, width, height, message, "", nil, function (_, button)
            if callback and button.internal == "OK" then
                callback(button.parent.entry:getText())
            end
        end, nil)
        modal:initialise()
        modal:addToUIManager()
        return modal
    end
end
local function getColors(numColors, numBrights)
    local colors = {}
    for bright=0,(numBrights-1) * 2,1 do
        table.insert(colors, {r=bright/((numBrights-1) * 2), g=bright/((numBrights-1) * 2), b=bright/((numBrights-1) * 2), a=1})
    end
    for hue=0,numColors-2,1 do
        for bright=1,numBrights,1 do
            local color = Color.HSBtoRGB(hue/(numColors-1), 1.0, bright/numBrights)
            table.insert(colors, {r=color:getRedFloat(), g=color:getGreenFloat(), b=color:getBlueFloat(), a=1})
        end
        for sat=0,numBrights-2,1 do
            local color = Color.HSBtoRGB(hue/(numColors-1), 1.0 - sat/numBrights, 1.0)
            table.insert(colors, {r=color:getRedFloat(), g=color:getGreenFloat(), b=color:getBlueFloat(), a=1})
        end
    end
    return colors
end
function WRC.MakeColorDialogPrompt(message, callback)
    return function()
        local modal = WRC.MakeShowDialogPrompt(message, callback)()
        modal.colorPicker.buttonSize = 14
        modal.colorPicker:setColors(getColors(18, 10), 19, 18)
        modal:enableColorPicker()
        modal.colorBtn.onclick = function (self, btn)
            local x = (getCore():getScreenWidth() / 2) - (self.colorPicker.width / 2)
            local y = (getCore():getScreenHeight() / 2) - (self.colorPicker.height / 2)
            self.colorPicker:setX(x);
            self.colorPicker:setY(y);
            self.colorPicker:setVisible(true);
            self.colorPicker:bringToTop();
            self.colorPicker.pickedFunc = modal.onPickedColor
        end
        modal.onPickedColor = function(self, color)
            self.currentColor = ColorInfo.new(color.r, color.g, color.b,1);
            self.colorBtn.backgroundColor = {r = color.r, g = color.g, b = color.b, a = 1};
            self.colorPicker:setVisible(false);
            local r = math.floor(color.r * 255)
            local g = math.floor(color.g * 255)
            local b = math.floor(color.b * 255)
            self.entry:setText(r .. "," .. g .. "," .. b)
        end
        modal.entry.onTextChange = function ()
            local r,g,b = modal.entry.javaObject:getInternalText():match("(%d+),(%d+),(%d+)")
            if r and g and b then
                modal.currentColor = ColorInfo.new(r/255, g/255, b/255,1);
                modal.colorBtn.backgroundColor = {r = r/255, g = g/255, b = b/255, a = 1};
            end
        end
        return modal
    end
end
