require "ISUI/ISPanel"
require "ISUI/ISRichTextPanel"
require "ISUI/ISButton"

BSBook1Panel = ISPanel:derive("BSBook1Panel");


--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function BSBook1Panel:initialise()
	ISPanel.initialise(self);
end

--************************************************************************--
--** ISPanel:instantiate
--**
--************************************************************************--
function BSBook1Panel:createChildren()


	-- CREATE TUTORIAL PANEL
	local panel = ISRichTextPanel:new(0, 0, self.width, self.height - 50);
	panel.marginLeft, panel.marginRight, panel.marginTop, panel.marginBottom = 4,4,4,4
	panel:initialise();

	self:addChild(panel);
	--panel:paginate();
	self.richtext = panel;
	local panel2 = ISPanel:new(0, 0, self.width, 52);
	panel2:initialise();
	self:addChild(panel2);

	-- CREATE BUTTONS

	local previousButton = ISButton:new(3, (panel2.height / 2), 20, 20, "", self, BSBook1Panel.previousPage);

	previousButton:initialise();
	previousButton:setEnable(false);
	previousButton:setImage(self.prevBtnTxt);
	panel2:addChild(previousButton);
	self.previous = previousButton;

	local nextButton = ISButton:new(24, (panel2.height / 2), 20, 20, "", self, BSBook1Panel.nextPage);

	nextButton:initialise();
	nextButton:setImage(self.nextBtnTxt);
	panel2:addChild(nextButton);
	self.next = nextButton;

	local closeButton = ISButton:new(self.width - 23, (panel2.height / 2), 20, 20, "", self, BSBook1Panel.closePage);

	closeButton:initialise();
	closeButton:setImage(self.closeBtnTxt);
	panel2:addChild(closeButton);

	local textWid = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_Tutorial_MoreInfo"))
	local buttonWid = textWid + 24
    local moreInfo = ISButton:new(closeButton:getX() - buttonWid - 1, (panel2.height / 2), buttonWid, 20, getText("IGUI_Tutorial_MoreInfo"), self, BSBook1Panel.moreInfo);


    self.more = moreInfo;

    self.bottompanel = panel2;
end

function BSBook1Panel:reloadBtns()
	if not self.tutorialSetInfo:hasNext() then
        self.next:setEnable(false);
--		return;
    else
		self.next:setEnable(true);
	end

	if not self.tutorialSetInfo:hasPrevious() then
        self.previous:setEnable(false);
		return;
    else
		self.previous:setEnable(true);
	end
end

function BSBook1Panel:previousPage(button)
	self.tutorialSetInfo.currentPage = self.tutorialSetInfo.currentPage - 1;
    self.tutorialSetInfo:applyPageToRichTextPanel(self.richtext);
	if self.moreinfo == nil then
       self:initMoreInfoPanel();
	   self.moreinfo:setVisible(false);
	end
	self.moreInfo = self.tutorialSetInfo:getCurrent().moreTextInfo;
	if self.moreinfo:getIsVisible() then
		self.tut.textDirty = true;
		self.tut.text = self.moreInfo;
		self.tut:paginate();
		self.tut:setYScroll(0);
	end
	self:reloadBtns();
end

function BSBook1Panel:closePage(button)
	self:setVisible(false);
	if self.moreinfo then
		self.moreinfo:setVisible(false);
	end
end

--************************************************************************--
--** BSBook1Panel:nextPage
--**
--************************************************************************--
function BSBook1Panel:nextPage(button)
    self.tutorialSetInfo.currentPage = self.tutorialSetInfo.currentPage + 1;
    self.tutorialSetInfo:applyPageToRichTextPanel(self.richtext);
	if self.moreinfo == nil then
       self:initMoreInfoPanel();
	   self.moreinfo:setVisible(false);
	end
	self.moreInfo = self.tutorialSetInfo:getCurrent().moreTextInfo;
	if self.moreinfo:getIsVisible() then
		self.tut.textDirty = true;
		self.tut.text = self.moreInfo;
		self.tut:paginate();
		self.tut:setYScroll(0);
	end
	self:reloadBtns();
end

function BSBook1Panel:initMoreInfoPanel()
   self.tut = ISRichTextPanel:new(0, 0, 500, 500);
   self.tut:initialise();
   self.tut:setAnchorBottom(true);
   self.tut:setAnchorRight(true);
   self.moreinfo = self.tut:wrapInCollapsableWindow();
   if getCore():getGameMode() == "Beginner" then -- beginner have tutorial centered READ IT!
       self.moreinfo:setX(10);
       self.moreinfo:setY((getCore():getScreenHeight() / 2) - (self.tut.height / 2));
   else
       self.moreinfo:setX((getCore():getScreenWidth() / 2) - (self.tut.width / 2));
       self.moreinfo:setY((getCore():getScreenHeight() / 2) - (self.tut.height / 2));
   end
	 --self.moreinfo:addScrollBars();
   self.moreinfo:addToUIManager();
   self.tut:setWidth(self.moreinfo:getWidth());
   self.tut:setHeight(self.moreinfo:getHeight()-16);
   self.tut:setY(16);
   local scrollBarWid = 0
   self.tut.marginRight = self.tut.marginLeft + scrollBarWid
   self.tut.autosetheight = false;
   self.tut.clip = true
   self.tut:addScrollBars();
end

function BSBook1Panel:moreInfo(button)
    if self.moreinfo == nil then
       self:initMoreInfoPanel();
    else
		if self.moreinfo:getIsVisible() then
			self.moreinfo:setVisible(false);
		else
			self.moreinfo:setVisible(true);
		end
     --   self.tut =ISRichTextPanel:new(0, 0, 500, 500);
    end

	self.tut:setYScroll(0);

    local current = self.tut;
    current.textDirty = true;
    current.text = self.moreInfo;
    current:paginate();
end

--************************************************************************--
--** BSBook1Panel:render
--**
--************************************************************************--
function BSBook1Panel:prerender()
	self.backgroundColor.a = UIManager.isFBOActive() and 0.85 or 0.5
	if self.tut then -- created yet?
		self.tut.backgroundColor.a = UIManager.isFBOActive() and 0.8 or 0.5
	end
	self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
	self:drawRect(0, 0, self.width, 1, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	self:drawRect(0, self.height-1, self.width, 1, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	self:drawRect(0, 0, 1, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	self:drawRect(0+self.width-1, 0, 1, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	--self:setStencilRect(0,0,self.width-1, self.height-1);

--~     if self.tutorialSetInfo:hasNext() then
--~         self.next.title = ">";
--~     else
--~         self.next.title = "X";
--~     end
end

function BSBook1Panel:render()

	--self:clearStencilRect();

end


--************************************************************************--
--** BSBook1Panel:update
--**
--************************************************************************--
function BSBook1Panel:update()
	if self.tutorialSetInfo ~= nil then
		local currentPage = self.tutorialSetInfo:getCurrent();
		if currentPage ~= nil then
			if currentPage.nextcondition == nil then
				self.next:setVisible(true);
			else
				self.next:setVisible(false);
			end
		end
		self.tutorialSetInfo:update(self.richtext);
	end

	self.bottompanel:setY(self.richtext:getHeight());
	self.bottompanel:setX(0);
	local w = getCore():getScreenWidth();
	local h = getCore():getScreenHeight();

	self:setHeight(self.richtext:getHeight() + self.bottompanel:getHeight());

    if getCore():getGameMode() ~= "Beginner" then
        self:setY((getCore():getScreenHeight() / 2) - (self.height / 2));
        self:setX(w - self:getWidth() - 20);
    end
end


--************************************************************************--
--** ISPanel:new
--**
--************************************************************************--
function BSBook1Panel:new (x, y, width, height)
	local o = {}
	--o.data = {}
	o = ISPanel:new(x, y, width, height);
	setmetatable(o, self)
    self.__index = self
	o.x = x;
	o.y = y;
	o.borderColor = {r=1, g=1, b=1, a=0.7};
	o.backgroundColor = {r=0, g=0, b=0, a=0.5};
	o.width = width;
	o.height = height;
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.prevBtnTxt = getTexture("media/ui/sGuidePrevBtn.png");
	o.nextBtnTxt = getTexture("media/ui/sGuideNextBtn.png");
	o.closeBtnTxt = getTexture("media/ui/sGuideCloseBtn.png");
   return o
end
