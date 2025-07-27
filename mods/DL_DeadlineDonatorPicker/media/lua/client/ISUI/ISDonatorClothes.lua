require "ISUI/colorBtnJoypad"
require "ISUI/ISPanelJoypad"
require "ISUI/ISScrollingListBox"
require "ISUI/ISResizeWidget"
require "defines"

ISDonatorClothesUI = ISPanelJoypad:derive("ISDonatorClothesUI");
ISDonatorComboPanel = ISPanelJoypad:derive("ISDonatorComboPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_TITLE = getTextManager():getFontHeight(UIFont.Title)

local buffer = 25;

function ISDonatorClothesUI:initDescriptor()
    local desc = SurvivorFactory:CreateSurvivor();

    desc:setForename("DeadlineDonator");
    desc:setSurname("ClothesPicker");
    local f = getPlayer():isFemale();
    desc:setFemale(f);

    local v = desc:getHumanVisual();
    local tv = getPlayer():getHumanVisual();
    v:setSkinTextureIndex(tv:getSkinTextureIndex());
    v:setBeardModel(tv:getBeardModel());
    v:setBeardColor(tv:getBeardColor());
    v:setHairModel(tv:getHairModel());
    v:setHairColor(tv:getHairColor());

    desc:getWornItems():clear();
    self.desc = desc;
end

function ISDonatorClothesUI:initialise()
    ISPanelJoypad.initialise(self);
    self:create();

    -- Do corner x + y widget
	local rh = 8;
	local resizeWidget = ISResizeWidget:new(self.width-rh, self.height-rh, rh, rh, self);
	--resizeWidget:initialise();
	resizeWidget:setVisible(true)
	self:addChild(resizeWidget);

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

	self.resizeWidget = resizeWidget;

    self.previewPanel = ISCharacterScreenAvatar:new(25, 25, 256, self:getHeight() * 0.65);
    self.previewPanel:setVisible(false);
    if self.avatar then
        self.previewPanel:setSurvivorDesc(self.avatar:getDescriptor());
    end
    self.previewPanel:setVisible(true);
    self:addChild(self.previewPanel);

    self.previewPanel:setOutfitName("Foreman", false, false)
	self.previewPanel:setState("idle")
	self.previewPanel:setDirection(IsoDirections.S)
	self.previewPanel:setIsometric(false)
    

    self.turnLeftButton = ISButton:new(self.previewPanel.x, self.previewPanel:getBottom()-15, 15, 15, "", self, self.onTurnChar)
	self.turnLeftButton.internal = "TURNCHARACTERLEFT"
	self.turnLeftButton:initialise()
	self.turnLeftButton:instantiate()
	self.turnLeftButton:setImage(getTexture("media/ui/ArrowLeft.png"))
	self:addChild(self.turnLeftButton)

	self.turnRightButton = ISButton:new(self.previewPanel:getRight()-15, self.previewPanel:getBottom()-15, 15, 15, "", self, self.onTurnChar)
	self.turnRightButton.internal = "TURNCHARACTERRIGHT"
	self.turnRightButton:initialise()
	self.turnRightButton:instantiate()
	self.turnRightButton:setImage(getTexture("media/ui/ArrowRight.png"))
	self:addChild(self.turnRightButton)

    self.xOffset = self.previewPanel:getRight() + 25;
	self.yOffset = 25;
	self.comboWid = 200;

    local humanLocs = BodyLocations.getGroup("Human");
	local clothingLocs = humanLocs:getAllLocations();
    local comboLocs = {};

    for i = 0, clothingLocs:size() - 1 do
        local slotName = clothingLocs:get(i):getId();
        table.insert(comboLocs, slotName);
    end

    self:createTabList();

    self:createClothingList(comboLocs);
end

function ISDonatorClothesUI:createTabList()
    local upperBodyTab = ISPanel:new(0, 0, 600, 400);
    upperBodyTab:initialise();

    local lowerBodyTab = ISPanel:new(0, 0, 600, 400);
    lowerBodyTab:initialise();

    local headTab = ISPanel:new(0, 0, 600, 4);
    headTab:initialise();

    local accessoriesTab = ISPanel:new(0, 0, 600, 400);
    accessoriesTab:initialise();

    self.tabPanel = ISTabPanel:new(self.previewPanel:getRight() + 25, 25, self:getWidth() * 0.95, self:getHeight() * 0.95);
    self.tabPanel:initialise();
    self.tabPanel:setAnchorLeft(true)
    self.tabPanel:setAnchorBottom(false)
    self.tabPanel.borderColor = { r = 0, g = 0, b = 0, a = 0};
    self.tabPanel.onActivateView = self.onActivateView;
    self.tabPanel.target = self;
    self:addChild(self.tabPanel);



    self.tabCategories = {};
    self.tabCategories["UpperBody"] = upperBodyTab;
    self.tabCategories["LowerBody"] = lowerBodyTab;
    self.tabCategories["Head"] = headTab;
    self.tabCategories["Accessories"] = accessoriesTab;

    self.tabPanel:addView("Upper Body", upperBodyTab);
    self.tabPanel:addView("Lower Body", lowerBodyTab);
    self.tabPanel:addView("Head", headTab);
    self.tabPanel:addView("Accessories", accessoriesTab);
end

function ISDonatorClothesUI:onActivateView()
end

function ISDonatorClothesUI:resizeWidgetHeight()
    return 8;
end

function ISDonatorClothesUI:incrementRow(slotTab)
    self.tabCategories[slotTab].currentRow = self.tabCategories[slotTab].currentRow + 1

    local buffer = 15;

    if self.tabCategories[slotTab].currentRow > self.tabCategories[slotTab].rows then

        self.tabCategories[slotTab].xOffset = self.furthestRightThisCycle + buffer;
        self.tabCategories[slotTab].yOffset = self.tabCategories[slotTab].startY + buffer;
        self.tabCategories[slotTab].currentRow = 1
        self.tabCategories[slotTab].currentCol = self.tabCategories[slotTab].currentCol + 1
        self.furthestRightThisCycle = 150;
    end
end

function ISDonatorClothesUI:addComboOptions(combo, bodyLocation, fullType)
    local item = ScriptManager.instance:FindItem(fullType);

    local displayName = item:getDisplayName();

    combo:addOptionWithData(getText(displayName), item);
end

function ISDonatorClothesUI:createClothingList(definitions)
    -- First create the ISPanelJoypad
    local comboHgt = FONT_HGT_SMALL + 3 * 2;
    
    local selectionX = math.floor(self.previewPanel:getRight() + 10);
    local selectionY = 25;

    local selectionWidth = math.floor(self:getWidth() - self.previewPanel:getWidth() - 10);
    local selectionHeight = math.floor(self.previewPanel:getHeight());

    local furthestWidth = 150;
    local heightCmp = 0;
    self.furthestRightThisCycle = 50;
    
    if not self.clothingCombo then
        self.clothingWidgets = self.clothingWidgets or {};
        self.clothingCombo = {};
		self.clothingColorBtn = {};
		self.clothingTextureCombo = {};
		self.clothingComboLabel = {};
    end

    if not self.desc then
        self.refreshNeeded = true;
        self:updateAvatar();
    end

    -- Color Picker
    self.colorPicker = ISColorPicker:new(0, 0, {h=1,s=0.6,b=0.9});
	self.colorPicker:initialise();
	self.colorPicker.keepOnScreen = true;
	self.colorPicker.pickedTarget = self;
	self.colorPicker.resetFocusTo = self;

    self.desc:getWornItems():clear();
    -- --- Clear out the slots so the player is effectively naked - rather than mixing and matching between current items.
    
    for i, bodyLocation in ipairs(definitions) do
        self.desc:setWornItem(bodyLocation, nil);

        local slotTab = DL_DonatorClothes.GetSlotTab(self.slotTabs, bodyLocation);

        --if slotTab == nil and DL_DonatorClothes.IsSlotBlacklisted(slotTab) == false then
            --slotTab = "Accessories";
        --end

        if slotTab ~= nil then
            self.tabCategories[slotTab].startX = 25;
            self.tabCategories[slotTab].xOffset = self.tabCategories[slotTab].startX + buffer;
            self.tabCategories[slotTab].startY = 25;
            self.tabCategories[slotTab].yOffset = self.tabCategories[slotTab].startY + buffer;
            self.tabCategories[slotTab].rows = 6;
            
            if not self.tabCategories[slotTab].equalComboStart then
                self.tabCategories[slotTab].equalComboStart = 0
            end
    
            local locationStrX = getTextManager():MeasureStringX(UIFont.Small, bodyLocation);
            if locationStrX > self.tabCategories[slotTab].equalComboStart then
                self.tabCategories[slotTab].equalComboStart = locationStrX;
            end
        end

    end

    self.previewPanel:setSurvivorDesc(self.desc);

    self.largestTabHeight = 0;
    self.largestTabWidth = 0;
    
    for i, bodyLocation in ipairs(definitions) do

        local slotTab = DL_DonatorClothes.GetSlotTab(self.slotTabs, bodyLocation);
        if slotTab ~= nil and self.tabCategories[slotTab] then
        
            if not self.tabCategories[slotTab].currentRow then
                self.tabCategories[slotTab].currentRow = 1;
            end
            if not self.tabCategories[slotTab].currentCol then
                self.tabCategories[slotTab].currentCol = 1;
            end
        
            if self.tabCategories[slotTab].currentRow > self.tabCategories[slotTab].rows then
                self.tabCategories[slotTab].currentRow = 1
                self.tabCategories[slotTab].currentCol = self.tabCategories[slotTab].currentCol + 1
            end

            local startX = 450 * (self.tabCategories[slotTab].currentCol - 1);
            local startY = 75 * (self.tabCategories[slotTab].currentRow - 1);

            local label = ISLabel:new(175 + startX, 25 + startY, comboHgt, getText("UI_ClothingType_" .. bodyLocation), 1, 1, 1, 1, UIFont.Small, false)
            label:setAnchorRight(true);
            label:initialise()
            label:instantiate();

            local combo = ISComboBox:new(200 + startX, 25 + startY, 250, comboHgt, self, self.onClothingComboSelected, bodyLocation)
            combo:initialise();
            combo:instantiate();
            combo.bodyLocation = bodyLocation;
            combo.target = self;
            combo:setAlwaysOnTop(true);
            combo:createChildren();
            combo.selected = 1;

            local fontHgt = getTextManager():getFontHeight(label.font);

            local colorBtn = ISButton:new(200 + startX, 25 + startY + comboHgt + 2, 45, comboHgt, "", self)
            colorBtn:setOnClick(self.onClothingColorClicked, bodyLocation);
            colorBtn.internal = color;
            colorBtn:initialise();
            colorBtn.backgroundColor = {r = 1, g = 1, b = 1, a = 1};
            colorBtn:setVisible(false);
            self.tabCategories[slotTab]:addChild(colorBtn);
            
            local textureCombo = ISComboBox:new(colorBtn:getRight() + 10, 25 + startY + comboHgt + 2,  120, comboHgt, self, self.onTextureComboSelected, bodyLocation)
            textureCombo:initialise();
            textureCombo:instantiate();
            textureCombo.bodyLocation = bodyLocation;
            textureCombo.target = self;
            textureCombo:setAlwaysOnTop(true);
            textureCombo:createChildren();
            textureCombo:setVisible(false);
            textureCombo.selected = 1;
            self.tabCategories[slotTab]:addChild(textureCombo);

            combo.colorBtn = colorBtn;
            combo.textureCombo = textureCombo;

            -----
            self.lastX = textureCombo:getRight() or 0;
            self.lastCol = self.tabCategories[slotTab].currentCol;
            ----

            local preWornIndex = 1; -- This is so the clothing and textures are set the same as the player is currently wearing.

            --local clothingItems = ISDonatorClothesUI:getAllClothes();
            local items = getAllItemsForBodyLocation(bodyLocation);

            -- Automatically adds all items in the client's game based on the current slot iterating through.
            local comboWidth = 0;
            table.sort(items, function(a,b)
                local itemA = ScriptManager.instance:FindItem(a)
                local itemB = ScriptManager.instance:FindItem(b)
                return not string.sort(itemA:getDisplayName(), itemB:getDisplayName())
            end)

            -- Add the "none" option at the top.
            combo:addOptionWithData(getText("UI_characreation_clothing_none"), nil);

            local longestComboEntryLength = 0;

            for i,fullType in ipairs(items) do
                -- Check it can actually be worn.
                local item = InventoryItemFactory.CreateItem(fullType);
                if instanceof(item, "Clothing") then
                    local visual = item:getVisual();
                    if visual and visual:getClothingItem() then

                        local f = self.desc:isFemale();
                        if f then
                            if visual:getClothingItem():getFemaleModel() then
                                self:addComboOptions(combo, bodyLocation, fullType);
                                local textLen = getTextManager():MeasureStringX(UIFont.Small, item:getDisplayName());
                                if textLen > longestComboEntryLength then
                                    longestComboEntryLength = textLen;
                                end
                            end 
                        else
                            if visual:getClothingItem():getMaleModel() then
                                self:addComboOptions(combo, bodyLocation, fullType);
                                local textLen = getTextManager():MeasureStringX(UIFont.Small, item:getDisplayName());
                                if textLen > longestComboEntryLength then
                                    longestComboEntryLength = textLen;
                                end
                            end 
                        end
                    end
                end 
            end

            if self.tabCategories[slotTab] then
                self.tabCategories[slotTab]:addChild(label);
                self.tabCategories[slotTab]:addChild(combo);
            end

            self.clothingCombo = self.clothingCombo or {}
            self.clothingCombo[bodyLocation] = self.clothingCombo[bodyLocation] or {}

            self.clothingComboLabel = self.clothingComboLabel or {}
            self.clothingComboLabel[bodyLocation] = self.clothingComboLabel[bodyLocation] or {}

            self.clothingColorBtn = self.clothingColorBtn or {}
            self.clothingColorBtn[bodyLocation] = self.clothingColorBtn[bodyLocation] or {}

            self.clothingTextureCombo[bodyLocation] = self.clothingColorBtn or {}
            self.clothingTextureCombo[bodyLocation] = self.clothingColorBtn[bodyLocation] or {}
            
            self.clothingCombo[bodyLocation] = combo
            self.clothingComboLabel[bodyLocation] = label
            self.clothingColorBtn[bodyLocation] = colorBtn
            self.clothingTextureCombo[bodyLocation] = textureCombo

            table.insert(self.clothingWidgets, { combo, label, colorBtn, textureCombo })
            
            --self.yOffset = self.yOffset + comboHgt + 4
            -- Furthest width does not reset, whereas self.furthestRightThisCycle does.
            if combo:getRight() > furthestWidth then
                furthestWidth = colorBtn:getRight();
            end 

            if combo:getRight() > self.furthestRightThisCycle then
                self.furthestRightThisCycle = combo:getRight() + 35;
            end

            if combo:getBottom() > heightCmp then
                heightCmp = combo:getBottom();
            end

            self.tabCategories[slotTab]:setHeight(heightCmp + 50);
            self.tabCategories[slotTab]:setWidth(self.furthestRightThisCycle + 50);

            self:incrementRow(slotTab);
        end
    end

    self.confirmBtn = ISButton:new(self.previewPanel:getRight() + 50, self.previewPanel:getBottom(), 150, 25, "CONFIRM SELECTION >>>", self, self.onClickConfirm);
	self.confirmBtn.internal = "CONFIRM"
	self.confirmBtn:initialise();
	self.confirmBtn:instantiate();
	self:addChild(self.confirmBtn);

    --self:setHeight(self.confirmBtn:getBottom() + buffer);

    self.yOffset = self.yOffset + 20;

    -- Now we need to measure the size of the main window vs the tab panel, we can't count on doing this before the clothing items populate as this list will change all the time depending on mods etc.
    -- Go through all tab category pages, get the largest of them.
    for k, v in pairs(self.tabCategories) do
        local tabWidth = self.tabCategories[k]:getWidth();
        local tabHeight = self.tabCategories[k]:getHeight();

        if tabWidth > self.largestTabWidth then
            self.largestTabWidth = tabWidth;
        end

        if tabHeight > self.largestTabHeight then
            self.largestTabHeight = tabHeight;
        end
    end

    local bottomDiff = self:getHeight()
    self:setHeight(self.previewPanel:getBottom() + 50);
    self:setWidth(self.previewPanel:getWidth() + 50 + self.largestTabWidth);
end

function ISDonatorClothesUI:onClothingColorClicked(button, bodyLocation)
    local slotTab = DL_DonatorClothes.GetSlotTab(self.slotTabs, bodyLocation);

	self.colorPicker:setX(button:getX());
	self.colorPicker:setY(button:getY());
	self.colorPicker:setPickedFunc(ISDonatorClothesUI.onClothingColorPicked, bodyLocation)
	local color = button.backgroundColor
	self.colorPicker:setInitialColor(ColorInfo.new(color.r, color.g, color.b, 1))
	self:removeChild(self.colorPicker)
	self:addChild(self.colorPicker)
	if self.tabCategories[slotTab].joyfocus then
		button:setJoypadFocused(false);
		self.tabCategories[slotTab].joyfocus.focus = self.colorPicker
	end
end

function ISDonatorClothesUI:onClothingColorPicked(color, mouseUp, bodyLocation)
    local slotTab = DL_DonatorClothes.GetSlotTab(self.slotTabs, bodyLocation);

	self.clothingColorBtn[bodyLocation].backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
	local item = self.desc:getWornItem(bodyLocation);
	if item then
		local color2 = ImmutableColor.new(color.r, color.g, color.b, 1);
		item:getVisual():setTint(color2)
		self.previewPanel:setSurvivorDesc(self.desc);
	end
end

function ISDonatorClothesUI:onClickConfirm(button, x, y)
    if button.internal == "CONFIRM" then
        local x = self:getRight() - (self:getWidth() / 2)
        local y = self:getBottom() - (self:getHeight() / 2)
        self.confirmUI = ISDonatorClothesConfirmation:new(x, y, 600, 250);
        self.confirmUI:initialise();
        self.confirmUI:addToUIManager();
        self.confirmUI.clothingWidgets = self.clothingWidgets;
        self.confirmUI.parent = self;
    end
end

function ISDonatorClothesUI:onTextureComboSelected(combo, bodyLocation)
    local textureChoice = combo.options[combo.selected].data;

    local clothingCombo = self.clothingCombo[bodyLocation];
    local selectedItem = clothingCombo.options[clothingCombo.selected].data:getFullName();

    local clothingItem = InventoryItemFactory.CreateItem(selectedItem);

    if not clothingItem then
        return
    end

    local clothingVisual = clothingItem:getVisual();
    clothingVisual:setTextureChoice(textureChoice);

    self.desc:setWornItem(bodyLocation, clothingItem);
    self.desc:getHumanVisual():addBodyVisualFromClothingItemName(clothingItem:getName());
    self.previewPanel:setSurvivorDesc(self.desc);
end

function ISDonatorClothesUI:onClothingComboSelected(combo, bodyLocation)

    self.desc:setWornItem(bodyLocation, nil);

    if combo.selected == 1 then
        self.previewPanel:setSurvivorDesc(self.desc);
        return
    end

    local selectedItem = combo.options[combo.selected].data:getFullName();
    --local fullType = combo.options[combo.selected].data;

    if not selectedItem then
        return
    end

    local clothingItem = InventoryItemFactory.CreateItem(selectedItem);

    if not clothingItem then
        return
    end
    
    if instanceof(clothingItem, "Clothing") then
        local clothingVisual = clothingItem:getVisual();

        local textureChoices = clothingVisual:getClothingItem():getTextureChoices() or {}
        local baseTextures = clothingVisual:getClothingItem():getBaseTextures() or {}

        if textureChoices and textureChoices:size() > 1 then
            self.clothingTextureCombo[bodyLocation]:setVisible(true);

            for i = 0, textureChoices:size() - 1 do
                local texture = textureChoices:get(i);
                local textureString = string.format("Texture %d", i);

                self.clothingTextureCombo[bodyLocation]:addOptionWithData(textureString, i);
            end
        end
        

        if clothingItem:getClothingItem():hasModel() then
            clothingVisual:setTextureChoice(0);
        else
            clothingVisual:setBaseTexture(0);
        end

        if clothingVisual and clothingVisual:getClothingItem():getAllowRandomTint() then
            self.clothingColorBtn[bodyLocation]:setVisible(true);
            local color = clothingVisual:getTint(clothingVisual:getClothingItem());
            self.clothingColorBtn[bodyLocation].backgroundColor = {r = color:getRedFloat(), g = color:getGreenFloat(), b = color:getBlueFloat(), a = 1};
        end
    end

    self.desc:setWornItem(bodyLocation, clothingItem);
    self.desc:getHumanVisual():addBodyVisualFromClothingItemName(clothingItem:getName());
    self.previewPanel:setSurvivorDesc(self.desc);

    -- Update clothing combos based on worn items.
    self:updateCombosAfterClothingApplied();
end

function ISDonatorClothesUI:updateCombosAfterClothingApplied()
    if self.clothingCombo then
		for i,combo in pairs(self.clothingCombo) do
			combo.selected = 1;
			self.clothingColorBtn[combo.bodyLocation]:setVisible(false);
			-- we select the current clothing we have at this location in the combo
			local currentItem = self.desc:getWornItem(combo.bodyLocation);
			if currentItem then
				for j,v in ipairs(combo.options) do
					if v.text == currentItem:getDisplayName() then
						combo.selected = j;
						break
					end
				end
				self:updateColorButton(combo.bodyLocation, currentItem);
                self:updateTextureCombo(combo.bodyLocation, currentItem);
			end
		end
	end
end

function ISDonatorClothesUI:updateColorButton(bodyLocation, clothing)
	self.clothingColorBtn[bodyLocation]:setVisible(false);
	-- If the item can be colored, add the color picker.
	if clothing and clothing:getClothingItem():getAllowRandomTint() then
		self.clothingColorBtn[bodyLocation]:setVisible(true);
		-- update color of button
		local color = clothing:getVisual():getTint(clothing:getClothingItem())
		self.clothingColorBtn[bodyLocation].backgroundColor = {r = color:getRedFloat(), g = color:getGreenFloat(), b = color:getBlueFloat(), a = 1}
	end
end

function ISDonatorClothesUI:updateTextureCombo(bodyLocation, clothing)
    --self.clothingTextureCombo[bodyLocation]:setVisible(false);

    local clothingItem = clothing:getClothingItem();
    if not clothingItem then return end;

    local textureChoices = clothingItem:getTextureChoices();

    if textureChoices and textureChoices:size() > 1 then
        self.clothingTextureCombo[bodyLocation]:setVisible(true);

        -- Add all texture options.
        
    end
end

function ISDonatorClothesUI:onTurnChar(button, x, y)
	local direction = self.previewPanel:getDirection()
	if button.internal == "TURNCHARACTERLEFT" then
		direction = IsoDirections.RotLeft(direction)
		self.previewPanel:setDirection(direction)
	elseif button.internal == "TURNCHARACTERRIGHT" then
		direction = IsoDirections.RotRight(direction)
		self.previewPanel:setDirection(direction)
	end
end

function ISDonatorClothesUI:prerender()
    ISPanelJoypad.prerender(self);

    local height = self:getHeight();
	local th = math.max(16, self.titleFontHgt + 1);

	if self.isCollapsed then
		height = th;
    end
	if self.clearStentil then
		self:setStencilRect(0,0,self.width, height);
	end

	if self.title ~= nil and self.drawFrame then
		self:drawTextCentre(self.title, self:getWidth() / 2, 1, 1, 1, 1, 1, self.titleBarFont);
	end

    self:updateAvatar();
end

function ISDonatorClothesUI:updateAvatar()
    if not self.refreshNeeded then return end

    self.refreshNeeded = false;
    self.previewPanel:setCharacter(getPlayer());

    if not self.desc then
        self:initDescriptor();
    end
end

function ISDonatorClothesUI:render()
    ISPanelJoypad.render(self);
end

function ISDonatorClothesUI:create()
    local label = ISLabel:new(10, 10, 25, "", 1, 1, 1, 1, UIFont.Small)
    label:initialise()
    label:instantiate();
    self:addChild(label)
end

function ISDonatorClothesUI:new(x, y, width, height, playerNum, item, slotTabs)
    local o = {};
    o = ISPanelJoypad:new(x, y, width, height);
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
    o.item = item; -- The original ticket item to be used once redeemed.
    o.title = "Deadline Donator Clothes";
    o.slotTabs = slotTabs;
    o.playerNum = playerNum;
    local descToClone = getPlayerByOnlineID(playerNum):getDescriptor() or getPlayer():getDescriptor();
    o.avatar = IsoSurvivor.new(descToClone, nil, 0, 0, 0);
    o.refreshNeeded = true;
    o.bFemale = o.avatar:isFemale();
    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    o.closeButtonTexture = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png");
    o.titleFont = UIFont.Small
    o.titleFontHgt = getTextManager():getFontHeight(o.titleFont);
    setmetatable(o, self);
    self.__index = self;
    
    return o;
end

--[[----------------------------------------------------------------

ISDonatorClothesConfirmation
- Confirmation popup once outfit selected.

--]]----------------------------------------------------------------

ISDonatorClothesConfirmation = ISPanel:derive("ISDonatorClothesConfirmation");

function ISDonatorClothesConfirmation:initialise()
    ISPanel.initialise(self);

    local yIncr = getTextManager():getFontHeight(UIFont.Small) + buffer;
    local yOffset = 10;

    self.titleLabel = ISLabel:new(10, yOffset, 25, "Donator Clothes Confirmation", 1, 1, 1, 1, UIFont.Medium, true);
    self.titleLabel:initialise()
    self.titleLabel:instantiate();
    self:addChild(self.titleLabel)

    yOffset = yOffset + yIncr;

    self.line1 = ISLabel:new(10, yOffset, 25, "Are you sure you wish to confirm your selection?", 1, 1, 1, 1, UIFont.Small, true);
    self.line1:initialise()
    self.line1:instantiate();
    self:addChild(self.line1)

    yOffset = yOffset + yIncr;

    self.line2 = ISLabel:new(10, yOffset, 25, "This will use your donator ticket.", 1, 1, 1, 1, UIFont.Small, true)
    self.line2:initialise()
    self.line2:instantiate();
    self:addChild(self.line2)

    yOffset = yOffset + yIncr;
    self.confirmBtn = ISButton:new(10, yOffset, 150, 25, "YES", self, self.onSecondConfirm)
	self.confirmBtn.internal = "YES"
	self.confirmBtn:initialise()
	self.confirmBtn:instantiate()
	self:addChild(self.confirmBtn)

    self.noBtn = ISButton:new(self.confirmBtn:getRight() + 25, yOffset, 150, 25, "NO", self, self.onSecondConfirm)
	self.noBtn.internal = "NO"
	self.noBtn:initialise()
	self.noBtn:instantiate()
	self:addChild(self.noBtn)
end

function ISDonatorClothesConfirmation:onSecondConfirm(button, x, y)
    if button.internal == "NO" then
        self:close()
    elseif button.internal == "YES" then

        local clothesList = {};

        -- If we do this based on what the preview is wearing visually, less chance of the combo selection being abused.
        local wornItems = self.parent.desc:getWornItems();
        wornItems:addItemsToItemContainer(getPlayer():getInventory());

        self:setVisible(false);
        self:close(); 
        self:removeFromUIManager();
        self.parent:setVisible(false);
        self.parent:close();
        self.parent:removeFromUIManager();

        -- Now remove golden ticket from player's inventory.
        local ticketItem = getPlayer():getModData()["DeadlineDonatorClothes_Item"];
        local container = ticketItem:getContainer() or getPlayer():getInventory();
        container:DoRemoveItem(ticketItem);
        container:requestSync();
    end
end

function ISDonatorClothesConfirmation:prerender()
    ISPanel.prerender(self);
    --self:drawText("Are you sure you want to select this outfit?", 10 ,10, 1,1,1,1, UIFont.Small);
    --self:drawText("This will use your donator clothing ticket and place the items in your main inventory.", 10, 50, 1,1,1,1, UIFont.Small);
end

function ISDonatorClothesConfirmation:render()
    ISPanel.render(self);
end


function ISDonatorClothesConfirmation:new(x, y, width, height)
    local o = {};
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.width = width;
    o.height = height;
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=1};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.anchorTop = true;
    o.moveWithMouse = true;
    o.drawFrame = true;
    o.showBackground = true;
    o.showBorder = false;
    return o;
end