RadiationZonePanel = ISPanel:derive("RadiationZonePanel");
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
function RadiationZonePanel:initialise()
    ISPanel.initialise(self);
    local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local btnHgt2 = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10

    local listY = 20 + FONT_HGT_MEDIUM + 20
    self.nonPvpList = ISScrollingListBox:new(10, listY, self.width - 20, (FONT_HGT_SMALL + 2 * 2) * 16);
    self.nonPvpList:initialise();
    self.nonPvpList:instantiate();
    self.nonPvpList.itemheight = FONT_HGT_SMALL + 2 * 2;
    self.nonPvpList.selected = 0;
    self.nonPvpList.joypadParent = self;
    self.nonPvpList.font = UIFont.NewSmall;
    self.nonPvpList.doDrawItem = self.drawList;
    self.nonPvpList.drawBorder = true;
    self:addChild(self.nonPvpList);

    self.removeZone = ISButton:new(self.nonPvpList.x + self.nonPvpList.width - 70, self.nonPvpList.y + self.nonPvpList.height + 5, 70, btnHgt2, getText("ContextMenu_Remove"), self, RadiationZonePanel.onClick);
    self.removeZone.internal = "REMOVEZONE";
    self.removeZone:initialise();
    self.removeZone:instantiate();
    self.removeZone.borderColor = self.buttonBorderColor;
    self:addChild(self.removeZone);
    self.removeZone.enable = false;

    self.teleportToZone = ISButton:new(self.nonPvpList.x + self.nonPvpList.width - 70, self.removeZone.y + btnHgt2 + 5, 70, btnHgt2, getText("IGUI_PvpZone_TeleportToZone"), self, RadiationZonePanel.onClick);
    self.teleportToZone:setX(self.nonPvpList.x + self.nonPvpList.width - self.teleportToZone.width)
    self.teleportToZone.internal = "TELEPORTTOZONE";
    self.teleportToZone:initialise();
    self.teleportToZone:instantiate();
    self.teleportToZone.borderColor = self.buttonBorderColor;
    self:addChild(self.teleportToZone);
    self.teleportToZone.enable = true;

    self.addZone = ISButton:new(self.nonPvpList.x, self.nonPvpList.y + self.nonPvpList.height + 5, 70, btnHgt2, getText("IGUI_PvpZone_AddZone"), self, RadiationZonePanel.onClick);
    self.addZone.internal = "ADDZONE";
    self.addZone:initialise();
    self.addZone:instantiate();
    self.addZone.borderColor = self.buttonBorderColor;
    self:addChild(self.addZone);

    self.seeZoneOnGround = ISButton:new(self.nonPvpList.x, self.addZone.y + btnHgt2 + 5, 70, btnHgt2, getText("IGUI_PvpZone_SeeZone"), self, RadiationZonePanel.onClick);
    self.seeZoneOnGround.internal = "SEEZONE";
    self.seeZoneOnGround:initialise();
    self.seeZoneOnGround:instantiate();
    self.seeZoneOnGround.borderColor = self.buttonBorderColor;
    self:addChild(self.seeZoneOnGround);

    self.no = ISButton:new(self:getWidth() - btnWid - 10, self.seeZoneOnGround:getBottom() + 20, btnWid, btnHgt, getText("IGUI_CraftUI_Close"), self, RadiationZonePanel.onClick);
    self.no.internal = "OK";
    self.no:initialise();
    self.no:instantiate();
    self.no.borderColor = {r=1, g=1, b=1, a=0.1};
    self:addChild(self.no);

    self:setHeight(self.no:getBottom() + padBottom)

    self:populateList();

end

function RadiationZonePanel:populateList()
    self.nonPvpList:clear();

    local zonesTable = RadiationZonePanel:requestModData()
    if zonesTable ~= nil then
    for i, w in pairs(zonesTable) do
        local zone = w;
        local newZone = {};
        newZone.title = i;
        newZone.zone = zone;
        self.nonPvpList:addItem(i, newZone);
    end
end
end

function RadiationZonePanel:requestModData()
	ModData.request("RadiationZone")
	self.RadiationZone = ModData.get("RadiationZone")
	return self.RadiationZone
end

function RadiationZonePanel:drawList(y, item, alt)
    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15);
    end

    self:drawText(item.item.title, 10, y + 2, 1, 1, 1, a, self.font);
    return y + self.itemheight;
end

function RadiationZonePanel:render()

end

function RadiationZonePanel:prerender()
    local z = 20;
    local splitPoint = 100;
    local x = 10;
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self:drawText(getText("Radiation Zones"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("Radiation Zones")) / 2), z, 1,1,1,1, UIFont.Medium);
end

function RadiationZonePanel:updateButtons()
end

function RadiationZonePanel:render()
    self:updateButtons();

    self.removeZone.enable = false;
    self.teleportToZone.enable = true;
    self.seeZoneOnGround.enable = false;
    if self.nonPvpList.selected > 0 then
        self.removeZone.enable = true;
        self.teleportToZone.enable = true;
    	self.seeZoneOnGround.enable = true;
        self.selectedZone = self.nonPvpList.items[self.nonPvpList.selected].item.zone;
		self.selectedZoneTitle = self.nonPvpList.items[self.nonPvpList.selected].item.title;
    else
        self.selectedZone = nil;
    end
end

function RadiationZonePanel:onClick(button)
    if button.internal == "OK" then
        self:setVisible(false);
        self:removeFromUIManager();
        --self.player:setSeeNonPvpZone(false);
    end
    if button.internal == "REMOVEZONE" then
        local modal = ISModalDialog:new(0,0, 350, 150, getText("Confirm Removal?", self.selectedZoneTitle), true, nil, RadiationZonePanel.onRemoveZone, self.player:getPlayerNum());
        modal:initialise()
        modal:addToUIManager()
        modal.ui = self;
        modal.selectedZone = self.selectedZone;
		modal.selectedTitle = self.selectedZoneTitle;
        modal.moveWithMouse = true;
    end
    if button.internal == "ADDZONE" then
        local addPvpZone = ISAddRadiationZoneUI:new(500, 500, 400, 450, self.player);
        addPvpZone:initialise()
        addPvpZone:addToUIManager()
        addPvpZone.parentUI = self;
        self:setVisible(false);
    end
    if button.internal == "SEEZONE" then
		local RadiationZone = RadiationZonePanel:requestModData();
        local startX = RadiationZone[self.selectedZoneTitle].startX
			print(startX)
			local startX = RadiationZone[self.selectedZoneTitle].startX
			local startY = RadiationZone[self.selectedZoneTitle].startY
			local endX = RadiationZone[self.selectedZoneTitle].endX
			local endY = RadiationZone[self.selectedZoneTitle].endY
			
		for x2=startX, endX do
			for y=startY, endY do
				local sq = getCell():getGridSquare(x2,y,0);
				if sq then
					for n = 0,sq:getObjects():size()-1 do
						local obj = sq:getObjects():get(n);
						obj:setHighlighted(true);
						obj:setHighlightColor(0.6,1,0.6,0.5);
					end
				end
			end
		end
		--end
    end
    if button.internal == "TELEPORTTOZONE" then
		local RadiationZone = RadiationZonePanel:requestModData();
		
			local startX = RadiationZone[self.selectedZoneTitle].startX
			local startY = RadiationZone[self.selectedZoneTitle].startY
			getPlayer():setX(startX)
            getPlayer():setY(startY)
            getPlayer():setLx(startX)
            getPlayer():setLy(startY)
		--end
    end
end


function RadiationZonePanel:onRemoveZone(button)
    if button.internal == "YES" then
		local zoneTable = RadiationZonePanel:requestModData()
		local index = tostring(button.parent.selectedTitle);
		print("TRYING TO REMOVE A TOXIC ZONE:  " .. index);
		zoneTable[index] = nil;
		ModData.remove("RadiationZone")
		ModData.getOrCreate("RadiationZone")
		ModData.add("RadiationZone", zoneTable)
		ModData.transmit("RadiationZone")
        button.parent.ui:populateList();
    end
end
function RadiationZonePanel:new(x, y, width, height, player)
    local o = {}
    x = getCore():getScreenWidth() / 2 - (width / 2);
    y = getCore():getScreenHeight() / 2 - (height / 2);
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.width = width;
    o.height = height;
    o.player = player;
    o.moveWithMouse = true;
    RadiationZonePanel.instance = o;
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    ModData.request("RadiationZone")
    o.RadiationZone = ModData.get("RadiationZone")
	o.startX = nil;
	o.endX = nil;
	o.startY = nil;
	o.endY = nil;
    return o;
end

Zoneslist = Zoneslist or {};
Zoneslist.Data = Zoneslist.Data or {}; -- storing modData tables in here
Zoneslist.ServerCommands = Zoneslist.ServerCommands or {}; -- storing server commands handlers here

--- handle initializing moddata
local function initGlobalModData(isNewGame)
    -- clear only if its a client, if it's single-player we dont need to clear
    if isClient() and ModData.exists("RadiationZone") then
        -- clear the current copy for a client cause it might be outdated
        ModData.remove("RadiationZone");
    end

    Zoneslist.Data.InfoStorageExample = ModData.getOrCreate("RadiationZone");
end
Events.OnInitGlobalModData.Add(initGlobalModData);