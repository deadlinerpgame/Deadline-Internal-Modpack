ISAddRadiationZoneUI = ISPanel:derive("ISAddRadiationZoneUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
function ISAddRadiationZoneUI:initialise()
    ISPanel.initialise(self);
    local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local btnHgt2 = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10

    self.cancel = ISButton:new(self:getWidth() - btnWid - 10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_Cancel"), self, ISAddRadiationZoneUI.onClick);
    self.cancel.internal = "CANCEL";
    self.cancel.anchorTop = false
    self.cancel.anchorBottom = true
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = {r=1, g=1, b=1, a=0.1};
    self:addChild(self.cancel);

    self.ok = ISButton:new(10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_PvpZone_AddZone"), self, ISAddRadiationZoneUI.onClick);
    self.ok.internal = "OK";
    self.ok.anchorTop = false
    self.ok.anchorBottom = true
    self.ok:initialise();
    self.ok:instantiate();
    self.ok.borderColor = {r=1, g=1, b=1, a=0.1};
    self:addChild(self.ok);



    self.defineStartingPointBtn = ISButton:new(10, 10 - btnHgt, btnWid, btnHgt, getText("IGUI_PvpZone_RedefineStartingPoint"), self, ISAddRadiationZoneUI.onClick);
    self.defineStartingPointBtn.internal = "DEFINESTARTINGPOINT";
    self.defineStartingPointBtn.anchorTop = false
    self.defineStartingPointBtn.anchorBottom = true
    self.defineStartingPointBtn:initialise();
    self.defineStartingPointBtn:instantiate();
    self.defineStartingPointBtn.borderColor = {r=1, g=1, b=1, a=0.1};
    self:addChild(self.defineStartingPointBtn);

    local title = "Rename This!";
    local radtitle = "1";

    self.titleEntry = ISTextEntryBox:new(title, 10, 10, 100, FONT_HGT_SMALL + 2 * 2);
    self.titleEntry:initialise();
    self.titleEntry:instantiate();
    self:addChild(self.titleEntry);

    self.radEntry = ISTextEntryBox:new(radtitle, 10, 10, 100, FONT_HGT_SMALL + 2 * 2);
    self.radEntry:initialise();
    self.radEntry:instantiate();
    self:addChild(self.radEntry);
end

function ISAddRadiationZoneUI:prerender()
    local z = 20;
    local splitPoint = 200;
    local x = 10;
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self:drawText(getText("IGUI_PvpZone_AddZone"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_PvpZone_AddZone")) / 2), z, 1,1,1,1, UIFont.Medium);

    z = z + FONT_HGT_MEDIUM + 20;
    self:drawText(getText("IGUI_PvpZone_ZoneName"), x, z + 2,1,1,1,1,UIFont.Small);
    self.titleEntry:setY(z);
    self.titleEntry:setX(splitPoint);
    z = z + FONT_HGT_MEDIUM + 20;
    self:drawText(getText("Radiation Intensity (1 to 4)"), x, z + 3,1,1,1,1,UIFont.Small);
    self.radEntry:setY(z);
    self.radEntry:setX(splitPoint);
    z = z + FONT_HGT_SMALL + 15;
    self:drawText(getText("IGUI_PvpZone_StartingPoint"), x, z,1,1,1,1,UIFont.Small);
    self:drawText(luautils.round(self.startingX,0) .. " x " .. luautils.round(self.startingY,0), splitPoint, z,1,1,1,1,UIFont.Small);
    z = z + FONT_HGT_SMALL + 15;
    self:drawText(getText("IGUI_PvpZone_CurrentPoint"), x, z,1,1,1,1,UIFont.Small);
    self:drawText(luautils.round(self.player:getX(),0) .. " x " .. luautils.round(self.player:getY(),0), splitPoint, z,1,1,1,1,UIFont.Small);
    z = z + FONT_HGT_SMALL + 15;
    local startingX = luautils.round(self.startingX,0);
    local startingY = luautils.round(self.startingY,0);
    local endX = luautils.round(self.player:getX(),0);
    local endY = luautils.round(self.player:getY(),0);
    if startingX > endX then
        local x2 = endX;
        endX = startingX;
        startingX = x2;
    end
    if startingY > endY then
        local y2 = endY;
        endY = startingY;
        startingY = y2;
    end
    local width = math.abs(startingX - endX) * 2;
    local height = math.abs(startingY - endY) * 2;
    self:drawText(getText("IGUI_PvpZone_CurrentZoneSize"), x, z,1,1,1,1,UIFont.Small);
    self.size = math.max(luautils.round(width + height,0),1);
    self:drawText(self.size .. "", splitPoint, z,1,1,1,1,UIFont.Small);
    z = z + FONT_HGT_SMALL + 15;


    if self.size < 250 then
    for x2=startingX, endX do
        for y=startingY, endY do
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
    end
    self.defineStartingPointBtn:setY(z);
    self:updateButtons();
end

function ISAddRadiationZoneUI:updateButtons()
    self.ok.enable = self.size > 1;
end

function ISAddRadiationZoneUI:addModData(player, text, startingX, startingY, rads)
	ModData.request("RadiationZone")
	local modTable = ModData.getOrCreate("RadiationZone")
	local x1, y1, x2, y2, radlevel = startingX, startingY, player:getX(), player:getY(), rads;
	local newEntry = {startX=x1, startY=y1, endX=x2, endY=y2, radLevel=radlevel}
	modTable[text] = newEntry;
	ModData.add("RadiationZone", modTable)
	ModData.transmit("RadiationZone")
end

function ISAddRadiationZoneUI:onClick(button)
    if button.internal == "OK" then
        local doneIt = true;
        if doneIt then
            self:setVisible(false);
            ISAddRadiationZoneUI:addModData(self.player, self.titleEntry:getInternalText(), self.startingX, self.startingY, self.radEntry:getInternalText())
			self:removeFromUIManager();
        else
            return;
        end
    end
    if button.internal == "DEFINESTARTINGPOINT" then
        self.startingX = self.player:getX();
        self.startingY = self.player:getY();
        self.endX = self.player:getX();
        self.endY = self.player:getY();
        return;
    end
    if button.internal == "CANCEL" then
        self:setVisible(false);
        self:removeFromUIManager();
    end
    self.parentUI:populateList();
    self.parentUI:setVisible(true);
    self.player:setSeeNonPvpZone(false);
end

function ISAddRadiationZoneUI:new(x, y, width, height, player)
    local o = {}
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.width = width;
    o.height = height;
    o.player = player;
    o.startingX = player:getX();
    o.startingY = player:getY();
    o.endX = player:getX();
    o.endY = player:getY();
    player:setSeeNonPvpZone(true);
    o.moveWithMouse = true;
    ISAddRadiationZoneUI.instance = o;
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    return o;
end
