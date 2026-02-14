require "ISUI/ISCollapsableWindow";
require "ISUI/ISScrollingListBox";
require "ISUI/ISResizeWidget";
require "defines";

require "LogLineUtils";
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

local randInstance = newrandom();

DLLootTicketChancesUI = ISCollapsableWindow:derive("DLLootTicketChancesUI");

local function sortOnChance(a, b)
    return tonumber(a.item.Chance) > tonumber(b.item.Chance);
end

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
         "For each item in the container, set the quantity and the chance it is rolled.",
         "Probability is weighted based on the number of items.",
    }

    local yOffsetEnd = 0;

    for i, _ in ipairs(instructionLabels) do
        local label = ISLabel:new(8, (yOffset + 8) * i, getTextManager():getFontHeight(UIFont.NewSmall), instructionLabels[i] or "", 1, 1, 1, 1, UIFont.NewSmall, true);
        label:initialise();
        label:instantiate();
        self:addChild(label);
        yOffsetEnd = (yOffset + 8) * i + getTextManager():MeasureStringY(UIFont.NewSmall, instructionLabels[i]);
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
                    table.sort(self.datas.items, sortOnChance);
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

function DLLootTicketChancesUI:onToggleAllowDups(clickedOption, enabled)
    if not clickedOption then return end;

    self.allowDuplicateItems = enabled or false;
end 

function DLLootTicketChancesUI:createTotalItemsRow(startY)
    local xOffset = 8 + getTextManager():MeasureStringX(UIFont.NewSmall, "X");

    local label = ISLabel:new(8, startY + 8, getTextManager():getFontHeight(UIFont.NewSmall), "Max Rolled Items (excluding guaranteed):", 1, 1, 1, 1, UIFont.NewSmall, true);
    label:initialise();
    label:instantiate();
    self:addChild(label);

    self.maxRolledItems = ISTextEntryBox:new("5", label:getRight() + getTextManager():MeasureStringX(UIFont.NewSmall, "X"), startY + 8, 60, 25);
    self.maxRolledItems:initialise();
    self.maxRolledItems:instantiate();
    self.maxRolledItems.min = 0;
    self.maxRolledItems:setOnlyNumbers(true);
    self:addChild(self.maxRolledItems);

    self.allowDuplicatesTickbox = ISTickBox:new(self.maxRolledItems:getRight() + (xOffset * 2), startY + 8, getTextManager():MeasureStringX(UIFont.NewSmall, "XX"), getTextManager():getFontHeight(UIFont.NewSmall) + 4, "", self, DLLootTicketChancesUI.onToggleAllowDups);
    
    self.allowDuplicatesTickbox:initialise();
    self.allowDuplicatesTickbox:instantiate();

    self.allowDuplicatesTickbox:addOption("Allow Duplicates");
    self:addChild(self.allowDuplicatesTickbox);

    return label:getBottom() + getTextManager():getFontHeight(UIFont.NewSmall);
end

function DLLootTicketChancesUI:populateItemTable(startY)
    if not self.item or not self.itemTable then
        print("Error with the ticket item or the item table given. Terminating.");
        return;
    end

    local xOffset = 8 + getTextManager():MeasureStringX(UIFont.NewSmall, "X");

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
    self.datas:addColumn("Quantity", 350);
    self.datas:addColumn("Chance", 450);
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
    modData.LootTicket = {};
    modData.LootTicket.ID = randInstance:random(999,999999);
    modData.LootTicket.CreatedBy = getPlayer():getUsername();
    modData.LootTicket.CreatedTimestamp = getTimestamp();
    modData.LootTicket.Items = self.datas.items;
    modData.LootTicket.RestrictedTo = nil;
    modData.LootTicket.MaxRolls = tonumber(self.maxRolledItems:getText());
    modData.LootTicket.AllowDuplicates = self.allowDuplicateItems;

    local logStr = string.format("Staff %s has created loot ticket with ID %0d with %0d max rolls and %s - items: ", getPlayer():getUsername(), modData.LootTicket.ID, modData.LootTicket.MaxRolls, (modData.LootTicket.AllowDuplicates and "duplicates") or "no duplicates");
    for _, itemData in ipairs(modData.LootTicket.Items) do
        logStr = logStr .. string.format("%s, quantity: %0d, chance: %0d | ", itemData.item.Name, tonumber(itemData.item.Quantity), tonumber(itemData.item.Chance));
    end

    print("LogString");
    print(logStr);

    LogLineUtils.LogFromClient("LootTicket", logStr);

    self:close();
    self:removeFromUIManager();

    getPlayer():setHaloNote("Loot ticket chances set successfully.", 100, 250, 100, 300);
end

function DLLootTicketChancesUI:onConfirmTicket()
    self.errorLabel:setVisible(false);
    self.errorLabel:setName("ERROR: ");

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
    self:setInfo(getText("UI_Info_LootTicketChances"));
    local yOffsetStart = self:createInstructionsLabel();
    local tableStart = self:createTotalItemsRow(yOffsetStart);
    local buttonStart = self:populateItemTable(tableStart);

    self:setWidth(self.datas:getRight() + (8 + getTextManager():MeasureStringX(UIFont.NewSmall, "X")));
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
    o.resizable = false;
    o.item = item; -- The original ticket item to be updated.
    o.itemTable = itemTable;
    o.title = "Loot Ticket Chances Setting";
    o.playerNum = playerNum;
    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    o.closeButtonTexture = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png");
    o.titleFont = UIFont.NewSmall
    o.titleFontHgt = getTextManager():getFontHeight(o.titleFont);
    setmetatable(o, self);
    self.__index = self;
    return o;
end