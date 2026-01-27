require "ISUI/colorBtnJoypad";
require "ISUI/ISCollapsableWindow";
require "ISUI/ISScrollingListBox";
require "ISUI/ISResizeWidget";
require "defines";

DLLootTicketChancesUI = ISCollapsableWindow:derive("DLLootTicketChancesUI");

function DLLootTicketChancesUI:createCloseButton()
    local th = math.max(16, self.titleFontHgt + 1);
    self.closeButton = ISButton:new(3, 0, th, th, "", self, function(self, button)
        if self.confirmUI then
            self.confirmUI:close()
        end
        self:close()
    end);
	self.closeButton:initialise();
	self.closeButton.borderColor.a = 0.0;
	self.closeButton.backgroundColor.a = 0;
	self.closeButton.backgroundColorMouseOver.a = 0;
	self.closeButton:setImage(self.closeButtonTexture);
	self:addChild(self.closeButton);
end

function DLLootTicketChancesUI:createInstructionsLabel()
    local yOffset = math.max(16, self.titleFontHgt + 1);
    local xOffset = 8 * getTextManager():MeasureStringX(UIFont.Small, "Label");

    local instructionLabels = 
    {
         "For each item in the container, set the quantity and the probability. Probability of all items must add up to 100.",
         "This is the likelihood of the item being picked. 30 = 30% chance."
    }

    local yOffsetEnd = 0;

    for i, v in ipairs(instructionLabels) do
        local label = ISLabel:new(8, (yOffset + 8) * i, getTextManager():getFontHeight(UIFont.Small), instructionLabels[i] or "", 1, 1, 1, 1, UIFont.Small, true);
        label:initialise();
        label:instantiate();
        self:addChild(label);
        yOffsetEnd = (yOffset + 8) * i + getTextManager():MeasureStringY(UIFont.Small, instructionLabels[i]);
    end

    return yOffsetEnd;
end

local function onCountChange(tgt, btn)
    
end

function DLLootTicketChancesUI:populateItemTable(startY)
    if not self.item or not self.itemTable then
        print("Error with the ticket item or the item table given. Terminating.");
        return;
    end

    local yOffset = startY or 32;
    local xOffset = 8 + getTextManager():MeasureStringX(UIFont.Small, "X");

    self.itemPanel = ISPanel:new(8, yOffset, self:getWidth() * 0.95, self:getHeight() * 0.95);
    self.itemPanel:initialise();
    self.itemPanel:setScrollChildren(true);
    self.itemPanel:addScrollBars();
    self:addChild(self.itemPanel);

    print("For each item...");

    local rowNum = 0;
    local lastY = 0;
    local startingY = 0;
    print("Starting Y is " .. tostring(startingY));
    for itemName, count in pairs(self.itemTable) do
        if itemName and count > 0 then

            local nameWidth = getTextManager():MeasureStringX(UIFont.Small, itemName);
            local nameHeight = getTextManager():MeasureStringY(UIFont.Small, itemName);

            local thisItemY = 8 + ((32 * rowNum) or 16);
            print("This item " .. itemName .. " should be starting at Y " .. tostring(thisItemY));

            -- Create 3 rows.
            local itemLabel = ISLabel:new(6, thisItemY, 16, itemName, 1, 1, 1, 1, UIFont.Small, true);
            self.itemPanel:addChild(itemLabel);
            rowNum = rowNum + 1;

            local itemQuantity = ISTextBox:new(6 + itemLabel:getRight(), thisItemY, getTextManager():MeasureStringX(UIFont.Small, "100"), 16, tostring(count), tostring(count), nil, onCountChange, getPlayer():getPlayerNum());
            self.itemPanel:addChild(itemQuantity);
        end
    end

    yOffset = lastY;

end

function DLLootTicketChancesUI:prerender() -- Call before render, it's for harder stuff that need init, ect
    ISCollapsableWindow.prerender(self);
end

function DLLootTicketChancesUI:render() -- Use to render text and other
    ISCollapsableWindow.render(self);
end

function DLLootTicketChancesUI:initialise()
    ISCollapsableWindow.initialise(self);
    self:createCloseButton();
    local yOffsetStart = self:createInstructionsLabel();
    self:populateItemTable(yOffsetStart);
end

function DLLootTicketChancesUI:new(x, y, width, height, item, itemTable)
    local o = {};
    o = ISCollapsableWindow:new(x, y, width, height);
    o.width = width;
    o.height = height;
    o.x = x;
    o.y = y;
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
	o.borderColor = {r=0.1, g=0.1, b=0.1, a=0.9};
	o.itemheightoverride = {};
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
    o.moveWithMouse = true;
    o.drawFrame = true;
    o.showBackground = false;
    o.showBorder = false;
    o.isCollapsed = false;
    o.tooltipForced = nil;
	o.colorPanel = {};
    o.item = item; -- The original ticket item to be updated.
    o.itemTable = itemTable;
    o.title = "Loot Ticket Chances Setting";
    o.playerNum = playerNum;
    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    o.closeButtonTexture = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png");
    o.titleFont = UIFont.Small
    o.titleFontHgt = getTextManager():getFontHeight(o.titleFont);
    setmetatable(o, self);
    self.__index = self;
    
    return o;
end