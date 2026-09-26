require "ISUI/ISPanelJoypad"
require "ISUI/ISButton"
require "ISUI/ISScrollingListBox"

if CharacterCreationProfession == nil then return end

DL = DL or {}
local O = DL.Occupations
if O == nil or O.choiceGroups == nil then return end

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

DLTraitChoiceWindow = ISPanelJoypad:derive("DLTraitChoiceWindow")

function DLTraitChoiceWindow:drawOption(y, item, alt)
    local height = self.itemheight
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), height - 1, 0.3, 0.7, 0.35, 0.15)
    end
    self:drawRectBorder(0, y, self:getWidth(), height - 1, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawText(item.item:getLabel(), 8, y + 4, 1, 1, 1, 1, UIFont.Small)
    self:drawText(item.item:getDescription(), 8, y + 4 + FONT_HGT_SMALL, 0.7, 0.7, 0.7, 1, UIFont.Small)
    return y + height
end

function DLTraitChoiceWindow:initialise()
    ISPanelJoypad.initialise(self)
    local padding = 10
    local buttonHeight = math.max(25, FONT_HGT_SMALL + 6)
    local buttonWidth = 100
    local listTop = padding + FONT_HGT_SMALL * 2 + padding
    local listHeight = self.height - listTop - buttonHeight - padding * 2

    self.list = ISScrollingListBox:new(padding, listTop, self.width - padding * 2, listHeight)
    self.list:initialise()
    self.list:instantiate()
    self.list.itemheight = FONT_HGT_SMALL * 2 + 10
    self.list.font = UIFont.Small
    self.list.drawBorder = true
    self.list.doDrawItem = DLTraitChoiceWindow.drawOption
    self.list.selected = 1
    self.list:setOnMouseDoubleClick(self, DLTraitChoiceWindow.onDoubleClickOption)
    self:addChild(self.list)

    for _, id in ipairs(self.options) do
        local trait = TraitFactory.getTrait(id)
        if trait ~= nil then
            self.list:addItem(trait:getLabel(), trait)
        end
    end

    self.chooseButton = ISButton:new(self.width / 2 - buttonWidth - 5, self.height - padding - buttonHeight,
        buttonWidth, buttonHeight, getText("UI_Ok"), self, DLTraitChoiceWindow.onButton)
    self.chooseButton.internal = "CHOOSE"
    self.chooseButton.anchorTop = false
    self.chooseButton.anchorBottom = true
    self.chooseButton:initialise()
    self.chooseButton:instantiate()
    self.chooseButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.chooseButton)

    self.laterButton = ISButton:new(self.width / 2 + 5, self.height - padding - buttonHeight,
        buttonWidth, buttonHeight, getText("UI_Cancel"), self, DLTraitChoiceWindow.onButton)
    self.laterButton.internal = "LATER"
    self.laterButton.anchorTop = false
    self.laterButton.anchorBottom = true
    self.laterButton:initialise()
    self.laterButton:instantiate()
    self.laterButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.laterButton)
end

function DLTraitChoiceWindow:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre(self.title, self.width / 2, 8, 1, 1, 1, 1, UIFont.Small)
    self:drawTextCentre(self.text, self.width / 2, 8 + FONT_HGT_SMALL, 0.8, 0.8, 0.8, 1, UIFont.Small)
end

function DLTraitChoiceWindow:render()
end

function DLTraitChoiceWindow:close()
    if DLTraitChoiceWindow.instance == self then
        DLTraitChoiceWindow.instance = nil
    end
    self:setCapture(false)
    self:setVisible(false)
    self:removeFromUIManager()
    if self.joypadData ~= nil then
        self.joypadData.focus = self.prevFocus
        updateJoypadFocus(self.joypadData)
        self.joypadData = nil
    end
end

function DLTraitChoiceWindow:onButton(button)
    local screen = self.screen
    local group = self.group
    local picked = nil
    if button.internal == "CHOOSE" then
        local item = self.list.items[self.list.selected]
        if item == nil then return end
        picked = item.item:getType()
    end
    self:close()
    if picked ~= nil then
        O.setChoice(screen, group, picked)
        O.clearPostponed(screen)
    else
        O.postpone(screen, group)
    end
    O.updateChoices(screen)
end

function DLTraitChoiceWindow:onDoubleClickOption(trait)
    if trait == nil then return end
    self:onButton(self.chooseButton)
end

function DLTraitChoiceWindow:onGainJoypadFocus(joypadData)
    ISPanelJoypad.onGainJoypadFocus(self, joypadData)
    self:setISButtonForA(self.chooseButton)
    self:setISButtonForB(self.laterButton)
end

function DLTraitChoiceWindow:onLoseJoypadFocus(joypadData)
    ISPanelJoypad.onLoseJoypadFocus(self, joypadData)
    self.chooseButton:clearJoypadButton()
    self.laterButton:clearJoypadButton()
end

function DLTraitChoiceWindow:onJoypadDirUp(joypadData)
    if self.list.selected > 1 then
        self.list.selected = self.list.selected - 1
        self.list:ensureVisible(self.list.selected)
    end
end

function DLTraitChoiceWindow:onJoypadDirDown(joypadData)
    if self.list.selected < #self.list.items then
        self.list.selected = self.list.selected + 1
        self.list:ensureVisible(self.list.selected)
    end
end

function DLTraitChoiceWindow:new(screen, group)
    local width = 460
    local height = 10 + FONT_HGT_SMALL * 2 + 10 + (FONT_HGT_SMALL * 2 + 10) * #group.options + 10 + math.max(25, FONT_HGT_SMALL + 6) + 20
    local x = (getCore():getScreenWidth() - width) / 2
    local y = (getCore():getScreenHeight() - height) / 2
    local o = ISPanelJoypad.new(self, x, y, width, height)
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.moveWithMouse = true
    o.screen = screen
    o.group = group
    o.title = group.title
    o.text = group.text
    o.options = group.options
    return o
end

function O.groupOf(id)
    for _, group in ipairs(O.choiceGroups) do
        for _, option in ipairs(group.options) do
            if option == id then return group end
        end
    end
    return nil
end

function O.currentChoice(screen, group)
    for _, entry in ipairs(screen.listboxTraitSelected.items) do
        local id = entry.item:getType()
        for _, option in ipairs(group.options) do
            if option == id then return id end
        end
    end
    return nil
end

function O.hasParent(screen, group)
    for _, entry in ipairs(screen.listboxTraitSelected.items) do
        local id = entry.item:getType()
        for _, parent in ipairs(group.parents) do
            if parent == id then return true end
        end
    end
    return false
end

function O.clearChoice(screen, group)
    for _, option in ipairs(group.options) do
        local trait = TraitFactory.getTrait(option)
        if trait ~= nil then
            screen.listboxTraitSelected:removeItem(trait:getLabel())
        end
    end
end

function O.setChoice(screen, group, id)
    local trait = TraitFactory.getTrait(id)
    if trait == nil then return false end
    O.clearChoice(screen, group)
    if not O.hasParent(screen, group) then return false end
    local entry = screen.listboxTraitSelected:addItem(trait:getLabel(), trait)
    entry.tooltip = trait:getDescription()
    CharacterCreationMain.sort(screen.listboxTraitSelected.items)
    O.refreshTraitLists(screen)
    return true
end

function O.postpone(screen, group)
    screen.dlPostponed = screen.dlPostponed or {}
    screen.dlPostponed[group.key] = true
end

function O.clearPostponed(screen)
    screen.dlPostponed = nil
end

function O.pendingChoice(screen)
    for _, group in ipairs(O.choiceGroups) do
        local postponed = screen.dlPostponed ~= nil and screen.dlPostponed[group.key] == true
        if not postponed and O.hasParent(screen, group) and O.currentChoice(screen, group) == nil then
            return group
        end
    end
    return nil
end

function O.updateChoices(screen)
    if screen == nil or screen.listboxTraitSelected == nil then return end
    for _, group in ipairs(O.choiceGroups) do
        if not O.hasParent(screen, group) and O.currentChoice(screen, group) ~= nil then
            O.clearChoice(screen, group)
            O.refreshTraitLists(screen)
        end
    end
    local window = DLTraitChoiceWindow.instance
    if window ~= nil then
        if window.screen ~= screen or O.hasParent(screen, window.group) == false or O.currentChoice(screen, window.group) ~= nil then
            window:close()
        else
            return
        end
    end
    if screen.dlNoChoicePrompt then return end
    local group = O.pendingChoice(screen)
    if group == nil then return end
    local prompt = DLTraitChoiceWindow:new(screen, group)
    prompt:initialise()
    prompt:setCapture(true)
    prompt:addToUIManager()
    prompt:setAlwaysOnTop(true)
    local joypadData = JoypadState.getMainMenuJoypad() or CoopCharacterCreation.getJoypad()
    if joypadData then
        prompt.prevFocus = joypadData.focus
        prompt.joypadData = joypadData
        joypadData.focus = prompt
        updateJoypadFocus(joypadData)
    end
    DLTraitChoiceWindow.instance = prompt
end

function O.applyPresetChoices(screen, occupation, kept)
    if occupation ~= nil and occupation.choices ~= nil then
        for _, id in ipairs(occupation.choices) do
            local group = O.groupOf(id)
            if group ~= nil then
                O.setChoice(screen, group, id)
            end
        end
    end
    for _, group in ipairs(O.choiceGroups) do
        local previous = kept[group.key]
        if previous ~= nil and O.currentChoice(screen, group) == nil then
            O.setChoice(screen, group, previous)
        end
    end
end

local vanillaSetVisible = CharacterCreationProfession.setVisible
function CharacterCreationProfession:setVisible(visible, joypadData)
    vanillaSetVisible(self, visible, joypadData)
    if not visible then
        local window = DLTraitChoiceWindow.instance
        if window ~= nil and window.screen == self then
            window:close()
        end
    end
end

function O.captureChoices(screen)
    local kept = {}
    for _, group in ipairs(O.choiceGroups) do
        kept[group.key] = O.currentChoice(screen, group)
        O.clearChoice(screen, group)
    end
    return kept
end
