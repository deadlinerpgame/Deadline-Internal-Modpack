BSBook1Manager = ISBaseObject:derive("BSBook1Manager");

function BSBook1Manager:update()
     if self.panel == nil then
         self.panel = BSBook1Panel:new(0, 0, 440, 880);
         self.panel:initialise();
         self.panel:addToUIManager();
         self.panel.tutorialSetInfo = ISTutorialSetInfo:new();

         local entry = BSBook1Entries.getEntry(0);
         self.panel.tutorialSetInfo:addPage(entry.title, entry.text, entry.moreInfo);

         self.panel.tutorialSetInfo:applyPageToRichTextPanel(self.panel.richtext);
         self.panel.moreInfo = entry.moreInfo;

		 for i=1,BSBook1Entries.list:size() -1 do
			entry = BSBook1Entries.getEntry(i);
			self.panel.tutorialSetInfo:addPage(entry.title, entry.text, entry.moreInfo);
		 end

		ISLayoutManager.RegisterWindow('bsbook1', BSBook1Manager, self) 
     end
end

function BSBook1Manager:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.moreInfoVisible = false
    return o
end

function BSBook1Manager:RestoreLayout(name, layout)
	-- Only save/restore visibility, the size/position is fixed
	if layout.visible == 'false' then
		self.panel:setVisible(false);
        self.panel.showOnStartup = false;
    else
        self.panel.showOnStartup = false;
    end

    -- always show the guide for beginner
    if getCore():getGameMode() == "Beginner" then
        self.panel:setVisible(true);
        self.panel.showOnStartup = false;
        self.panel:setX(getCore():getScreenWidth()/2 - self.panel.width / 2);
        self.panel:setY(getCore():getScreenHeight()/2 - self.panel.height / 2);
        --self.panel.tickBox:setVisible(false);
    end

    --if self.panel.tickBox then
    --    self.panel.tickBox:setSelected(1, self.panel.showOnStartup);
    --end
end

function BSBook1Manager:SaveLayout(name, layout)
	-- Only save/restore visibility, the size/position is fixed
    if self.panel then
        if not self.panel.showOnStartup then
            layout.visible = 'false';
            self.panel:setVisible(false);
        else
            layout.visible = 'true';
            self.panel:setVisible(true);
        end
        ISLayoutManager.SaveWindowVisible(self.panel, layout);
    end
end

function doBS1Guide()
	if isServer() then return; end
	-- Disable with controller for now.
	if JoypadState[1] then return end
    -- hide it for tut
    if getCore():getGameMode() == "Tutorial" and not getCore():isTutorialDone() then
        return;
    end
    -- only happens on single player so no splitscreen support required.
    if BSBook1Manager.instance == nil then
        BSBook1Manager.instance = BSBook1Manager:new();
		--BSBook1Manager.instance.panel:setVisible(false);
    end

    BSBook1Manager.instance:update();

	local panel = BSBook1Manager.instance.panel

end

BSBook1Manager.OnNewGame = function()
	if isServer() then return; end
	Events.OnTick.Add(doBS1Guide);
end


BSBook1Manager.onKeyPressed = function()

		if BSBook1Manager.instance == nil then
			Events.OnTick.Add(doBS1Guide);
		else
			if BSBook1Manager.instance.panel:getIsVisible() == false then
				BSBook1Manager.instance.panel:setVisible(not BSBook1Manager.instance.panel:getIsVisible());
				local panel = BSBook1Manager.instance.panel
				if panel.moreinfo and panel:getIsVisible() then
					panel.moreinfo:setVisible(BSBook1Manager.instance.moreInfoVisible)
				elseif panel.moreinfo then
					BSBook1Manager.instance.moreInfoVisible = panel.moreinfo:getIsVisible()
					panel.moreinfo:setVisible(false)
				end
			end
		end
	--end
end

BSBook1Manager.OnGameStart = function()
	if getCore():isShowFirstTimeWeatherTutorial() then
		if BSBook1Manager.instance == nil then
			BSBook1Manager.instance = BSBook1Manager:new();
			BSBook1Manager.instance:update();
		end
		local panel = BSBook1Manager.instance.panel
		BSBook1Manager.instance.panel:setVisible(true);
		if not panel.moreinfo then
			panel:initMoreInfoPanel();
		end
		panel.moreinfo:setVisible(true)
		panel.moreInfo = panel.tutorialSetInfo.pages[9].moreTextInfo;
		panel.tut.textDirty = true;
		panel.tut.text = panel.moreInfo;
		panel.tut:paginate();
		panel.tut:setYScroll(0);
		panel.tutorialSetInfo.currentPage = 9;
		panel.tutorialSetInfo:applyPageToRichTextPanel(panel.richtext);
		panel:reloadBtns();
	end
end

Events.OnTick.Add(doBS1Guide);

