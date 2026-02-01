require "ISUI/ISPanel";
require "ISUI/ISScrollingListBox";
require "ISUI/ISResizeWidget";
require "defines";

DLLootTicketItemEditUI = ISPanel:derive("DLLootTicketItemEditUI");

function DLLootTicketItemEditUI:prerender()
    ISPanel.prerender(self);
end

function DLLootTicketItemEditUI:render()
    ISPanel.render(self);
end

function DLLootTicketItemEditUI:onEditItem()
    self.parent:updateItem(self.item, self.quantityBox:getText(), self.chanceBox:getText());
    self:onClose();
end

function DLLootTicketItemEditUI:onClose()
    ISPanel.close(self);
    self:removeFromUIManager();
end

function DLLootTicketItemEditUI:initialise()
    ISPanel.initialise(self);

    local width = getTextManager():MeasureStringX(UIFont.NewMedium, self.item.Name) / 2;
    local smallFontHeight = getTextManager():getFontHeight(UIFont.NewSmall);

    local closeWidth = getTextManager():MeasureStringX(UIFont.NewSmall, "Close");
    local editWidth = getTextManager():MeasureStringX(UIFont.NewSmall, "Edit Item");
    local closeHeight = getTextManager():MeasureStringY(UIFont.NewSmall, "Close");

    local quantityLabel = ISLabel:new(12, smallFontHeight * 2, smallFontHeight, "Quantity", 1, 1, 1, 1, UIFont.NewSmall, true);
    self:addChild(quantityLabel);

    local chanceLabel = ISLabel:new(quantityLabel:getRight() + closeWidth, smallFontHeight * 2, smallFontHeight, "Chance", 1, 1, 1, 1, UIFont.NewSmall, true);
    self:addChild(chanceLabel);

    local quantityBox = ISTextEntryBox:new(tostring(self.item.Quantity), 12, quantityLabel:getBottom() + smallFontHeight, 60, 25);
    quantityBox:initialise();
    quantityBox:instantiate();
    quantityBox.min = 0;
    quantityBox:setOnlyNumbers(true);
    self.quantityBox = quantityBox;
    self:addChild(quantityBox);

    local chanceBox = ISTextEntryBox:new(tostring(self.item.Chance), quantityLabel:getRight() + closeWidth, quantityLabel:getBottom() + smallFontHeight, 60, 25);
    chanceBox:initialise();
    chanceBox:instantiate();
    chanceBox.min = 0;
    chanceBox:setOnlyNumbers(true);
    self.chanceBox = chanceBox;
    self:addChild(chanceBox);

    -- Buttons
    self:setWidth(chanceBox:getRight() + closeHeight);

    self.editButton = ISButton:new((self:getWidth() / 2) - (editWidth / 2), chanceBox:getBottom() + closeHeight, closeWidth, closeHeight + 4, "Edit Item", self, self.onEditItem);
    self.editButton:initialise();
    self:addChild(self.editButton);

    self.closeButton = ISButton:new((self:getWidth() / 2) - (closeWidth / 2), self.editButton:getBottom() + (closeHeight * 1.5), closeWidth, closeHeight + 4, "Close", self, self.onClose);
    self.closeButton:initialise();
    self:addChild(self.closeButton);
    
    local itemNameLabel = ISLabel:new((self:getWidth() / 2) - width, 4, smallFontHeight, self.item.Name, 1, 1, 1, 1, UIFont.NewMedium, true);
    self:addChild(itemNameLabel);

    self:setHeight(self.closeButton:getBottom() + closeHeight);
    
    self:bringToTop();
end


function DLLootTicketItemEditUI:new(x, y, width, height, item, parent)
    local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 };
    o.width = width;
    o.height = height;
    o.item = item;
    o.parent = parent;
    o.moveWithMouse = true;
    return o;
end