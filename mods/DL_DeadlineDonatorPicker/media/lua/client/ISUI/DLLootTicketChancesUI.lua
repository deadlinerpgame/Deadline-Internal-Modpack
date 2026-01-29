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

    local instructionLabels = 
    {
         "For each item in the container, set the quantity and the probability.",
         "Probability of all items must add up to 100.",
         "This is the likelihood of the item being picked. 30 = 30% chance."
    }

    local yOffsetEnd = 0;

    for i, _ in ipairs(instructionLabels) do
        local label = ISLabel:new(8, (yOffset + 8) * i, getTextManager():getFontHeight(UIFont.Small), instructionLabels[i] or "", 1, 1, 1, 1, UIFont.Small, true);
        label:initialise();
        label:instantiate();
        self:addChild(label);
        yOffsetEnd = (yOffset + 8) * i + getTextManager():MeasureStringY(UIFont.Small, instructionLabels[i]);
    end

    return yOffsetEnd + 8;
end

function DLLootTicketChancesUI:updateItem(item, newQuantity, newChance)
    if item and item.Chance then
        for i, v in ipairs(self.datas.items) do
            local retrievedItem = self.datas.items[i];
            if retrievedItem then
                if retrievedItem.text == item.Name then
                    retrievedItem.item.Quantity = newQuantity;
                    retrievedItem.item.Chance = newChance;
                    return;
                end
            end
        end
    end
end

function DLLootTicketChancesUI:doDrawItem(y, item, alt)
    if not item.height then item.height = self.itemheight end -- compatibililty
    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), item.height-1, 0.3, 0.7, 0.35, 0.15);
    end
	self:drawRectBorder(0, (y), self:getWidth(), item.height, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	local itemPadY = self.itemPadY or (item.height - self.fontHgt) / 2;

    self:drawText(item.item.Name, 5, (y)+itemPadY, 0.9, 0.9, 0.9, 0.9, self.font);
    self:drawText(tostring(item.item.Quantity), 205, (y) + itemPadY, 0.9, 0.9, 0.9, 0.9, self.font);
    self:drawText(tostring(item.item.Chance), 305, (y) + itemPadY, 0.9, 0.9, 0.9, 0.9, self.font);

    y = y + item.height;
	return y;
end

function DLLootTicketChancesUI:onDoubleClickItem(item)
    local halfScreenX = Math.ceil(getCore():getScreenWidth() / 2);
    local halfScreenY = Math.ceil(getCore():getScreenHeight() / 2);

    -- Show modal
    local itemEditUI = DLLootTicketItemEditUI:new(halfScreenX - 400, halfScreenY - 200, 400, 200, item, self);
    itemEditUI:initialise();
    itemEditUI:addToUIManager();
end

function DLLootTicketChancesUI:populateItemTable(startY)
    if not self.item or not self.itemTable then
        print("Error with the ticket item or the item table given. Terminating.");
        return;
    end

    local xOffset = 8 + getTextManager():MeasureStringX(UIFont.Small, "X");

    -- Add the table headers.
    self.datas = ISScrollingListBox:new(xOffset, startY + 32, 600, 200);
    self.datas:initialise();
    self.datas:instantiate();
    self.datas.itemheight = 32;
    self.datas.selected = 0;
    self.datas.joypadParent = self;
    self.datas.font = UIFont.NewSmall;
    self.datas.doDrawItem = self.doDrawItem;
    self.datas.drawBorder = true;
    self.datas:setOnMouseDoubleClick(self, self.onDoubleClickItem);
--    self.datas.parent = self;
    self.datas:addColumn("Name", 0);
    self.datas:addColumn("Quantity", 200);
    self.datas:addColumn("Chance (must add up to 100.00)", 300);
    self:addChild(self.datas);

    local itemCount = 0;

    for itemName, count in pairs(self.itemTable) do
        if itemName and count > 0 then
            self.datas:addItem(itemName, { Name = itemName, Quantity = count, Chance = 0});
            itemCount = itemCount + 1;
        end
    end

    if itemCount > 0 then
        -- Get evenly distributed chances.
        local evenChance = Math.floor(100 / itemCount);

        for i = 1, itemCount do
            local item = self.datas.items[i];
            if item then
                item.item.Chance = evenChance;
            end
        end
    end

    return self.datas:getBottom();
end

function DLLootTicketChancesUI:setTicketModData()
    local item = self.item;
    if not item then return end;

    local container = self.item:getContainer();

    container:DoRemoveItem(self.item);
    local setTicket = InventoryItemFactory.CreateItem("Deadline_DonatorClothes.DLDC_ItemLootTicket_Set");
    container:DoAddItem(setTicket);

    local modData = setTicket:getModData();
    modData.LootTicketTable = self.datas.items;
    modData.LootTicketCreated = getTimestamp();
    modData.LootTicketRestrictedTo = nil;

    ISCollapsableWindow.close(self);
    self:removeFromUIManager();

    getPlayer():setHaloNote("Loot ticket chances set successfully.", 100, 250, 100, 300);
end

function DLLootTicketChancesUI:onConfirmTicket()
    local totalChance = 0;
    self.errorLabel:setVisible(false);
    self.errorLabel:setName("ERROR: ");

    for _, itemData in ipairs(self.datas.items) do
        print("Item data: ");
        print(itemData);

        local chance = itemData.item.Chance;
        totalChance = totalChance + chance;
    end

    if totalChance > 99.00 and totalChance < 100.00 then
        totalChance = 100;
    end

    if totalChance > 100 or totalChance < 99 then
        self.errorLabel:setVisible(true);
        self.errorLabel:setName("ERROR: Your total chance is " .. tostring(totalChance) .. " - it must add up to 100.");
        return;
    end

    self:setTicketModData();
end

function DLLootTicketChancesUI:createErrorLabel(startY)
    local errorLabelStr = "ERROR: ";
    local labelHeight = getTextManager():MeasureStringY(UIFont.NewSmall, errorLabelStr);

    self.errorLabel = ISLabel:new(self.datas:getX(), startY + labelHeight, labelHeight, "errorLabelStr", 1, 0.2, 0.2, 1, UIFont.NewSmall, true);
    self.errorLabel:initialise();
    self.errorLabel:instantiate();
    self:addChild(self.errorLabel);
    self.errorLabel:setVisible(false);

    return self.errorLabel:getBottom() + labelHeight;
end

function DLLootTicketChancesUI:createButtons(startY)
    local confirmWidth = getTextManager():MeasureStringX(UIFont.NewSmall, "Confirm");
    local confirmHeight = getTextManager():MeasureStringY(UIFont.NewSmall, "Confirm");
    local confirmButton = ISButton:new((self:getWidth() / 2) - (confirmWidth / 2), startY + (confirmHeight * 2), confirmWidth, confirmHeight + 4, "Confirm", self, self.onConfirmTicket);
    confirmButton:initialise();
    confirmButton:instantiate();
    self:addChild(confirmButton);

    return confirmButton:getBottom() + confirmHeight;
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
    local buttonStart = self:populateItemTable(yOffsetStart);

    self:setWidth(self.datas:getRight() + (8 + getTextManager():MeasureStringX(UIFont.Small, "X")));

    local errorLabelY = self:createErrorLabel(buttonStart);

    local bottom = self:createButtons(errorLabelY);
    
    self:setHeight(bottom);
end

function DLLootTicketChancesUI:new(x, y, width, height, item, itemTable)
    local o = {};
    o = ISCollapsableWindow:new(x, y, width, height);
    o.width = width;
    o.height = height;
    o.x = x;
    o.y = y;
    o.backgroundColor = {r=0, g=0, b=0, a=0.9};
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