require "ISUI/ISPanel"

PDA_NotepadUI = ISPanel:derive("ISUIWriteJournal")

function PDA_NotepadUI:initialise()
    ISPanel.initialise(self)
    self:createChildren()
end

function PDA_NotepadUI:createChildren()
    -- Title label
    self.title = ISLabel:new((self.width - 200) / 2, 10, 20, "Z-Top PDA Notepad", 1, 1, 1, 1, UIFont.Medium)
    self.title:initialise()
    self:addChild(self.title)

    -- Multiline text area (simulated with text storage and input)
    self.textArea = ISTextEntryBox:new("", 10, 40, self.width - 20, self.height - 110)
    self.textArea:initialise();
    self.textArea:instantiate();
    self.textArea:setMultipleLine(true);

    self.textArea.javaObject:setMaxLines(35);

    self.textArea:setText(self.itemModData["journalText"] or "Thank you for purchasing our Z-Top PDA!")
    self:addChild(self.textArea)

    -- Save button
    self.saveButton = ISButton:new(10, self.height - 60, 100, 30, "Save", self, PDA_NotepadUI.onSave)
    self.saveButton:initialise()
    self:addChild(self.saveButton)

    -- Close button
    self.closeButton = ISButton:new(self.width - 110, self.height - 60, 100, 30, "Close", self, PDA_NotepadUI.onClose)
    self.closeButton:initialise()
    self:addChild(self.closeButton)
end

function PDA_NotepadUI:onSave()
    self.itemModData["journalText"] = self.textArea:getText()
    print("Saved Journal Text:", self.itemModData["journalText"])
    self:removeFromUIManager()
end

function PDA_NotepadUI:onClose()
    self:removeFromUIManager()
end

function PDA_NotepadUI:prerender()
    ISPanel.prerender(self)
    self:drawRect(0, 0, self.width, self.height, 0.8, 0, 0, 0) -- Background
end

function PDA_NotepadUI:render()
    ISPanel.render(self)
end

function PDA_NotepadUI:new(x, y, width, height, itemModData)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.itemModData = itemModData
    return o
end