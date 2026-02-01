require "ISUI/ISPanel";
require "ISUI/ISScrollingListBox";
require "ISUI/ISResizeWidget";
require "defines";

DLLootResultsUI = ISPanel:derive("DLLootResultsUI");

function DLLootResultsUI:prerender()
    ISPanel.prerender(self);
end

function DLLootResultsUI:render()
    ISPanel.render(self);
end

function DLLootResultsUI:prerender() -- Call before render, it's for harder stuff that need init, ect
    ISPanel.prerender(self);
end

function DLLootResultsUI:render() -- Use to render text and other
    ISPanel.render(self);
end

function DLLootResultsUI:initialise()
    ISPanel.initialise(self);

    local smallFontHeight = getTextManager():getFontHeight(UIFont.NewSmall);

    local closeWidth = getTextManager():MeasureStringX(UIFont.NewSmall, "Continue");

    local infoLabel = ISLabel:new(12, smallFontHeight * 2, smallFontHeight, "You have received the following items from the loot ticket:", 1, 1, 1, 1, UIFont.NewSmall, true);
    infoLabel:initialise();
    infoLabel:instantiate();
    self:addChild(infoLabel);

    local itemY = infoLabel:getBottom() + smallFontHeight;
    for _, item in ipairs(self.items) do
        local itemLabel = ISLabel:new(12, itemY, smallFontHeight, "   - " .. item.item.Name .. " [amount: " .. tostring(item.item.Quantity) .. "]", 1, 1, 1, 1, UIFont.NewSmall, true);
        itemY = itemY + (smallFontHeight * 1.25);
        itemLabel:initialise();
        itemLabel:instantiate();
        self:addChild(itemLabel);
    end

    self:setWidth(infoLabel:getRight() + 16);

    local titleWidth = getTextManager():MeasureStringX(UIFont.NewMedium, "Loot Ticket Results!");
    local titleLabel = ISLabel:new((self:getWidth() / 2) - (titleWidth / 2), 4, smallFontHeight, "Loot Ticket Results!", 1, 1, 1, 1, UIFont.NewMedium, true);
    self:addChild(titleLabel);

    self.closeButton = ISButton:new((self:getWidth() / 2) - (closeWidth / 2), itemY + (smallFontHeight * 1.5), closeWidth, smallFontHeight + 4, "Continue", self, DLLootResultsUI.close);
    self.closeButton:initialise();
    self:addChild(self.closeButton);

    self:setHeight(self.closeButton:getBottom() + smallFontHeight);

    self:bringToTop();
end


function DLLootResultsUI:new(x, y, width, height, items)
    local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 };
    o.width = width;
    o.height = height;
    o.items = items;
    o.title = "Loot Ticket Results";
    o.moveWithMouse = true;
    return o;
end