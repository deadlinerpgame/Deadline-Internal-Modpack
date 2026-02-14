require "ISUI/ISPanel";
require "defines";

DLLootTicketInspectionUI = ISPanel:derive("DLLootTicketInspectionUI");

function DLLootTicketInspectionUI:prerender()
    ISPanel.prerender(self);
end

function DLLootTicketInspectionUI:render()
    ISPanel.render(self);
end

function DLLootTicketInspectionUI:prerender() -- Call before render, it's for harder stuff that need init, ect
    ISPanel.prerender(self);
end

function DLLootTicketInspectionUI:render() -- Use to render text and other
    ISPanel.render(self);
end

function DLLootTicketInspectionUI:initialise()
    ISPanel.initialise(self);

    local smallFontHeight = getTextManager():getFontHeight(UIFont.NewSmall);

    local closeWidth = getTextManager():MeasureStringX(UIFont.NewSmall, "Continue");

    local infoLabel = ISLabel:new(12, smallFontHeight * 2, smallFontHeight, "This loot ticket has the following items", 1, 1, 1, 1, UIFont.NewSmall, true);
    infoLabel:initialise();
    infoLabel:instantiate();
    self:addChild(infoLabel);

    local statsStr = string.format("Rolls: %0d | Allow Duplicates: %s", self.maxRolls, self.allowDuplicates);
    local statsLabel = ISLabel:new(12, infoLabel:getBottom() + smallFontHeight, smallFontHeight, statsStr);
    statsLabel:initialise();
    statsLabel:instantiate();
    self:addChild(statsLabel);

    local itemY = statsLabel:getBottom() + smallFontHeight;

    
    local largestX = getTextManager():MeasureStringX(UIFont.NewSmall, "This loot ticket has the following items:");
    local thisWidth = 0;
    for _, item in ipairs(self.items) do
        local itemString = string.format("   - %s [amount: %0d] [chance: %0d]", item.item.Name, item.item.Quantity, item.item.Chance);

        local itemLabel = ISLabel:new(12, itemY, smallFontHeight, itemString, 1, 1, 1, 1, UIFont.NewSmall, true);
        itemY = itemY + (smallFontHeight * 1.25);
        itemLabel:initialise();
        itemLabel:instantiate();
        self:addChild(itemLabel);

        thisWidth = getTextManager():MeasureStringX(UIFont.NewSmall, itemString);
        if thisWidth > largestX then
            largestX = thisWidth;
        end
    end

    self:setWidth(largestX + 16);

    local titleWidth = getTextManager():MeasureStringX(UIFont.NewMedium, "Loot Ticket Data");
    local titleLabel = ISLabel:new((self:getWidth() / 2) - (titleWidth / 2), 4, smallFontHeight, "Loot Ticket Data", 1, 1, 1, 1, UIFont.NewMedium, true);
    self:addChild(titleLabel);

    self.closeButton = ISButton:new((self:getWidth() / 2) - (closeWidth / 2), itemY + (smallFontHeight * 1.5), closeWidth, smallFontHeight + 4, "Continue", self, DLLootTicketInspectionUI.close);
    self.closeButton:initialise();
    self:addChild(self.closeButton);

    self:setHeight(self.closeButton:getBottom() + smallFontHeight);

    self:bringToTop();
end


function DLLootTicketInspectionUI:new(x, y, width, height, items, maxRolls, allowDuplicates)
    local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 };
    o.width = width;
    o.height = height;
    o.items = items;
    o.maxRolls = maxRolls;
    o.allowDuplicates = allowDuplicates;
    o.title = "Loot Ticket Data";
    o.moveWithMouse = true;
    return o;
end