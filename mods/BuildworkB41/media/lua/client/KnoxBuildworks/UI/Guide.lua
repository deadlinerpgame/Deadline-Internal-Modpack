require("ISUI/ISCollapsableWindow")
require("ISUI/ISScrollingListBox")
require("ISUI/ISRichTextPanel")
require("ISUI/ISButton")

local Theme = require("KnoxBuildworks/UI/Theme")

local Guide = {
    instance = nil
}

local ICONS = {
    info = "media/ui/inventoryPanes/Button_Info.png",
    favorite = "media/ui/inventoryPanes/FavouriteYes.png",
    pin = "media/ui/inventoryPanes/Button_Pin.png",
    gear = "media/ui/inventoryPanes/Button_Gear.png",
    grid = "media/ui/craftingMenus/Icon_Grid.png",
    list = "media/ui/craftingMenus/Icon_List.png",
    clock = "media/ui/craftingMenus/BuildProperty_Clock_16.png",
    light = "media/ui/craftingMenus/BuildProperty_Light_16.png",
    book = "media/ui/craftingMenus/BuildProperty_Book_16.png",
    walking = "media/ui/craftingMenus/BuildProperty_Walking_16.png",
    surface = "media/ui/craftingMenus/BuildProperty_Surface_16.png",
    resize = "media/ui/ResizeIcon.png",
    question = "media/ui/foraging/questionMark.png"
}

local TOPICS = {
    { header = true, titleKey = "IGUI_KBW_GuideSectionPlayers" },
    {
        id = "welcome",
        icon = ICONS.info,
        titleKey = "IGUI_KBW_GuideWelcomeTitle",
        bodyKey = "IGUI_KBW_GuideWelcomeBody"
    },
    {
        id = "catalog",
        icon = ICONS.grid,
        titleKey = "IGUI_KBW_GuideCatalogTitle",
        bodyKey = "IGUI_KBW_GuideCatalogBody"
    },
    { id = "views", icon = ICONS.list, titleKey = "IGUI_KBW_GuideViewsTitle", bodyKey = "IGUI_KBW_GuideViewsBody" },
    {
        id = "choices",
        icon = ICONS.favorite,
        titleKey = "IGUI_KBW_GuideChoicesTitle",
        bodyKey = "IGUI_KBW_GuideChoicesBody"
    },
    {
        id = "details",
        icon = ICONS.surface,
        titleKey = "IGUI_KBW_GuideDetailsTitle",
        bodyKey = "IGUI_KBW_GuideDetailsBody"
    },
    {
        id = "readiness",
        icon = ICONS.book,
        titleKey = "IGUI_KBW_GuideReadinessTitle",
        bodyKey = "IGUI_KBW_GuideReadinessBody"
    },
    {
        id = "building",
        icon = ICONS.walking,
        titleKey = "IGUI_KBW_GuideBuildingTitle",
        bodyKey = "IGUI_KBW_GuideBuildingBody"
    },
    {
        id = "finishes",
        icon = ICONS.light,
        titleKey = "IGUI_KBW_GuideFinishesTitle",
        bodyKey = "IGUI_KBW_GuideFinishesBody"
    },
    {
        id = "functional",
        icon = ICONS.surface,
        titleKey = "IGUI_KBW_GuideFunctionalTitle",
        bodyKey = "IGUI_KBW_GuideFunctionalBody"
    },
    { id = "pinned", icon = ICONS.pin, titleKey = "IGUI_KBW_GuidePinnedTitle", bodyKey = "IGUI_KBW_GuidePinnedBody" },
    {
        id = "planning",
        icon = ICONS.grid,
        titleKey = "IGUI_KBW_GuidePlanningTitle",
        bodyKey = "IGUI_KBW_GuidePlanningBody"
    },
    { id = "queue", icon = ICONS.clock, titleKey = "IGUI_KBW_GuideQueueTitle", bodyKey = "IGUI_KBW_GuideQueueBody" },
    {
        id = "sharing",
        icon = ICONS.book,
        titleKey = "IGUI_KBW_GuideSharingTitle",
        bodyKey = "IGUI_KBW_GuideSharingBody"
    },
    {
        id = "appearance",
        icon = ICONS.gear,
        titleKey = "IGUI_KBW_GuideAppearanceTitle",
        bodyKey = "IGUI_KBW_GuideAppearanceBody"
    },
    {
        id = "multiplayer",
        icon = ICONS.question,
        titleKey = "IGUI_KBW_GuideMultiplayerTitle",
        bodyKey = "IGUI_KBW_GuideMultiplayerBody"
    },
    { header = true, titleKey = "IGUI_KBW_GuideSectionAdmins" },
    {
        id = "admin_rules",
        icon = ICONS.gear,
        titleKey = "IGUI_KBW_GuideAdminRulesTitle",
        bodyKey = "IGUI_KBW_GuideAdminRulesBody"
    },
    {
        id = "admin_scopes",
        icon = ICONS.grid,
        titleKey = "IGUI_KBW_GuideAdminScopesTitle",
        bodyKey = "IGUI_KBW_GuideAdminScopesBody"
    },
    {
        id = "admin_recipes",
        icon = ICONS.book,
        titleKey = "IGUI_KBW_GuideAdminRecipesTitle",
        bodyKey = "IGUI_KBW_GuideAdminRecipesBody"
    },
    {
        id = "admin_presets",
        icon = ICONS.favorite,
        titleKey = "IGUI_KBW_GuideAdminPresetsTitle",
        bodyKey = "IGUI_KBW_GuideAdminPresetsBody"
    },
    {
        id = "admin_sandbox",
        icon = ICONS.gear,
        titleKey = "IGUI_KBW_GuideAdminSandboxTitle",
        bodyKey = "IGUI_KBW_GuideAdminSandboxBody"
    },
    {
        id = "admin_authority",
        icon = ICONS.pin,
        titleKey = "IGUI_KBW_GuideAdminAuthorityTitle",
        bodyKey = "IGUI_KBW_GuideAdminAuthorityBody"
    },
    {
        id = "admin_tools",
        icon = ICONS.question,
        titleKey = "IGUI_KBW_GuideAdminToolsTitle",
        bodyKey = "IGUI_KBW_GuideAdminToolsBody"
    },
    {
        id = "admin_addons",
        icon = ICONS.surface,
        titleKey = "IGUI_KBW_GuideAdminAddonsTitle",
        bodyKey = "IGUI_KBW_GuideAdminAddonsBody"
    },
    {
        id = "admin_workflow",
        icon = ICONS.info,
        titleKey = "IGUI_KBW_GuideAdminWorkflowTitle",
        bodyKey = "IGUI_KBW_GuideAdminWorkflowBody"
    },
    { header = true, titleKey = "IGUI_KBW_GuideSectionAbout" },
    { id = "about", icon = ICONS.favorite, titleKey = "IGUI_KBW_GuideAboutTitle", bodyKey = "IGUI_KBW_GuideAboutBody" }
}

KBWGuideWindow = ISCollapsableWindow:derive("KBWGuideWindow")

function KBWGuideWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.infoButton:setVisible(false)

    self.topicList = ISScrollingListBox:new(0, 0, 100, 100)
    self.topicList:initialise()
    self.topicList:instantiate()
    self.topicList.itemheight = self.rowH
    self.topicList.font = UIFont.Small
    self.topicList.drawBorder = true
    self.topicList.backgroundColor = Theme.color(Theme.surface)
    self.topicList.borderColor = Theme.color(Theme.borderSoft)
    self.topicList.doDrawItem = self.drawTopic
    self.topicList:setOnMouseDownFunction(self, self.onTopicSelected)
    self:addChild(self.topicList)

    self.content = ISRichTextPanel:new(0, 0, 100, 100)
    self.content:initialise()
    self.content:instantiate()
    self.content.autosetheight = false
    self.content.clip = true
    self.content.doRepaintStencil = true
    self.content.background = true
    self.content.backgroundColor = Theme.color(Theme.surface)
    self.content.borderColor = Theme.color(Theme.borderSoft)
    self.content.marginLeft = 18
    self.content.marginRight = 24
    self.content.marginTop = 14
    self.content:addScrollBars()
    self:addChild(self.content)

    self.closeGuideButton = ISButton:new(0, 0, 130, self.actionH, getText("UI_btn_close"), self, self.close)
    self.closeGuideButton:initialise()
    self.closeGuideButton:instantiate()
    Theme.applyActionButton(self.closeGuideButton, true, false)
    self:addChild(self.closeGuideButton)

    local supportLabel = getText("IGUI_KBW_GuideSupportKoFi")
    local supportWidth = math.max(180, getTextManager():MeasureStringX(UIFont.Small, supportLabel) + 28)
    self.supportButton = ISButton:new(0, 0, supportWidth, self.actionH, supportLabel, self, self.onSupport)
    self.supportButton:initialise()
    self.supportButton:instantiate()
    self.supportButton:setTooltip(getText("IGUI_KBW_GuideSupportKoFiTooltip"))
    Theme.applyActionButton(self.supportButton, true, false)
    self.supportButton:setVisible(false)
    self:addChild(self.supportButton)

    self:populateTopics()
    self:layout()
    self:selectTopic(self.openTopicId or "welcome")
end

function KBWGuideWindow:populateTopics()
    self.topicList:clear()
    for topicIndex = 1, #TOPICS do
        local topic = TOPICS[topicIndex]
        topic.texture = topic.icon and getTexture(topic.icon) or nil
        self.topicList:addItem(getText(topic.titleKey), topic)
    end
end

function KBWGuideWindow:drawTopic(y, item, alt)
    local topic = item.item
    if topic.header then
        self:drawRect(0, y, self.width, self.itemheight - 1, .72, Theme.backdrop.r, Theme.backdrop.g, Theme.backdrop.b)
        self:drawRect(0, y + self.itemheight - 2, self.width, 2, 1, Theme.accent.r, Theme.accent.g, Theme.accent.b)
        self:drawText(
            item.text, 10, y + math.floor((self.itemheight - self.parent.fontH) / 2), Theme.accent.r, Theme.accent.g,
            Theme.accent.b, 1, UIFont.Small
        )
    else
        if self.selected == item.index then
            self:drawRect(
                0, y, self.width, self.itemheight - 1, Theme.selected.a, Theme.selected.r, Theme.selected.g,
                Theme.selected.b
            )
            self:drawRect(0, y, 4, self.itemheight - 1, 1, Theme.accent.r, Theme.accent.g, Theme.accent.b)
        elseif alt then
            self:drawRect(
                0, y, self.width, self.itemheight - 1, .22, Theme.surfaceRaised.r, Theme.surfaceRaised.g,
                Theme.surfaceRaised.b
            )
        end
        local textX = 14
        if topic.texture then
            local iconSize = math.min(20, self.itemheight - 8)
            self:drawTextureScaledAspect(
                topic.texture, 10, y + math.floor((self.itemheight - iconSize) / 2), iconSize, iconSize, 1, 1, 1, 1
            )
            textX = 38
        end
        self:drawText(
            item.text, textX, y + math.floor((self.itemheight - self.parent.fontH) / 2), Theme.text.r, Theme.text.g,
            Theme.text.b, 1, UIFont.Small
        )
    end
    self:drawRectBorder(
        0, y, self.width, self.itemheight - 1, Theme.borderSoft.a, Theme.borderSoft.r, Theme.borderSoft.g,
        Theme.borderSoft.b
    )
    return y + self.itemheight
end

function KBWGuideWindow:onTopicSelected()
    local row = self.topicList.items[self.topicList.selected]
    local topic = row and row.item or nil
    if not topic or topic.header then
        self.topicList.selected = self.selectedTopicIndex or 2
        return
    end
    self.selectedTopicIndex = self.topicList.selected
    self:showTopic(topic)
end

function KBWGuideWindow:showTopic(topic)
    if not topic or topic.header then return end
    self.currentTopicId = topic.id
    local title = getText(topic.titleKey)
    local body = getText(topic.bodyKey)
    self.supportButton:setVisible(topic.id == "about")
    local image = topic.icon and (" <IMAGECENTRE:" .. topic.icon .. ",32,32> <BR> ") or " "
    self.content.text = image .. " <PUSHRGB:0.88,0.78,0.40> <H1> " .. title .. " <POPRGB> <TEXT> <LEFT> <BR> " .. body
    self.content:setYScroll(0)
    self.content:paginate()
end

function KBWGuideWindow:onSupport()
    local url = "https://steamcommunity.com/linkfilter/?u=https://ko-fi.com/ely0n"
    openUrl(url)
end

function KBWGuideWindow:selectTopic(topicId)
    local fallback = 2
    for rowIndex = 1, #self.topicList.items do
        local topic = self.topicList.items[rowIndex].item
        if topic and not topic.header then
            fallback = fallback or rowIndex
            if topic.id == topicId then
                self.topicList.selected = rowIndex
                self.selectedTopicIndex = rowIndex
                self:showTopic(topic)
                if self.topicList.ensureVisible then self.topicList:ensureVisible(rowIndex) end
                return
            end
        end
    end
    self.topicList.selected = fallback
    self.selectedTopicIndex = fallback
    self:showTopic(self.topicList.items[fallback].item)
    if self.topicList.ensureVisible then self.topicList:ensureVisible(fallback) end
end

function KBWGuideWindow:layout()
    local titleH = self:titleBarHeight()
    local resizeH = self:resizeWidgetHeight()
    local top = titleH + self.pad
    local bottomY = self.height - resizeH - self.pad - self.actionH
    local bodyH = bottomY - self.pad - top
    local listW = math.min(math.max(250, self.fontH * 13), math.floor(self.width * .36))
    self.topicList:setX(self.pad)
    self.topicList:setY(top)
    self.topicList:setWidth(listW)
    self.topicList:setHeight(bodyH)
    self.content:setX(self.topicList:getRight() + self.gap)
    self.content:setY(top)
    local contentWidth = self.width - self.pad - self.content:getX()
    local contentWidthChanged = self.content:getWidth() ~= contentWidth
    self.content:setWidth(contentWidth)
    self.content:setHeight(bodyH)
    if contentWidthChanged and self.content.text and self.content.text ~= "" then self.content:paginate() end
    self.closeGuideButton:setX(self.width - self.pad - self.closeGuideButton:getWidth())
    self.closeGuideButton:setY(bottomY)
    self.supportButton:setX(self.content:getX())
    self.supportButton:setY(bottomY)
    self.lastLayoutWidth = self.width
    self.lastLayoutHeight = self.height
end

function KBWGuideWindow:prerender()
    if self.width ~= self.lastLayoutWidth or self.height ~= self.lastLayoutHeight then self:layout() end
    ISCollapsableWindow.prerender(self)
end

function KBWGuideWindow:close()
    self:setVisible(false)
end

function KBWGuideWindow:isKeyConsumed(key)
    return Keyboard and key == Keyboard.KEY_ESCAPE
end

function KBWGuideWindow:onKeyRelease(key)
    if self:isVisible() and self:isKeyConsumed(key) then
        self:close()
        return
    end
end

function KBWGuideWindow:new(player, topicId)
    local o = ISCollapsableWindow:new(
        math.floor((getCore():getScreenWidth() - 720) / 2), math.floor((getCore():getScreenHeight() - 520) / 2), 720,
        520
    )
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.openTopicId = topicId
    o.title = getText("IGUI_KBW_GuideTitle")
    o.resizable = true
    o.pin = true
    o.pad = 10
    o.gap = 8
    o.fontH = getTextManager():getFontHeight(UIFont.Small)
    o.rowH = math.max(32, o.fontH + 14)
    o.actionH = math.max(30, o.fontH + 10)
    o.minimumWidth = 720
    o.minimumHeight = 520
    o.backgroundColor = Theme.color(Theme.backdrop)
    o.borderColor = Theme.color(Theme.border)
    o:setWantKeyEvents(true)
    return o
end

function Guide.open(player, topicId)
    if Guide.instance then
        Guide.instance.player = player or getPlayer()
        Guide.instance:setVisible(true)
        Guide.instance:selectTopic(topicId or Guide.instance.currentTopicId or "welcome")
        Guide.instance:bringToTop()
        return Guide.instance
    end
    local window = KBWGuideWindow:new(player or getPlayer(), topicId or "welcome")
    window:initialise()
    window:addToUIManager()
    window:setAlwaysOnTop(true)
    Guide.instance = window
    return window
end

return Guide
