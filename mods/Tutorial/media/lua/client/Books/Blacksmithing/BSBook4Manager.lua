BSBook4Manager = ISBaseObject:derive("BSBook4Manager");

function BSBook4Manager:update()
     if self.panel == nil then
         self.panel = BSBook4Panel:new(0, 0, 440, 880);
         self.panel:initialise();
         self.panel:addToUIManager();
         self.panel.tutorialSetInfo = ISTutorialSetInfo:new();

         local entry = BSBook4Entries.getEntry(0);
         self.panel.tutorialSetInfo:addPage(entry.title, entry.text, entry.moreInfo);

         self.panel.tutorialSetInfo:applyPageToRichTextPanel(self.panel.richtext);
         self.panel.moreInfo = entry.moreInfo;

		 for i=1,BSBook4Entries.list:size() -1 do
			entry = BSBook4Entries.getEntry(i);
			self.panel.tutorialSetInfo:addPage(entry.title, entry.text, entry.moreInfo);
		 end

		ISLayoutManager.RegisterWindow('BSBook4', BSBook4Manager, self) 
     end
end

function BSBook4Manager:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.moreInfoVisible = false
    return o
end

function BSBook4Manager:RestoreLayout(name, layout)
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

function BSBook4Manager:SaveLayout(name, layout)
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

function doBS4Guide()
	if isServer() then return; end
	-- Disable with controller for now.
	if JoypadState[1] then return end
    -- hide it for tut
    if getCore():getGameMode() == "Tutorial" and not getCore():isTutorialDone() then
        return;
    end
    -- only happens on single player so no splitscreen support required.
    if BSBook4Manager.instance == nil then
        BSBook4Manager.instance = BSBook4Manager:new();
		--BSBook4Manager.instance.panel:setVisible(false);
    end

    BSBook4Manager.instance:update();

	local panel = BSBook4Manager.instance.panel

end

BSBook4Manager.OnNewGame = function()
	if isServer() then return; end
	Events.OnTick.Add(doBS4Guide);
end


BSBook4Manager.onKeyPressed = function()

		if BSBook4Manager.instance == nil then
			Events.OnTick.Add(doBS4Guide);
		else
			if BSBook4Manager.instance.panel:getIsVisible() == false then
				BSBook4Manager.instance.panel:setVisible(not BSBook4Manager.instance.panel:getIsVisible());
				local panel = BSBook4Manager.instance.panel
				if panel.moreinfo and panel:getIsVisible() then
					panel.moreinfo:setVisible(BSBook4Manager.instance.moreInfoVisible)
				elseif panel.moreinfo then
					BSBook4Manager.instance.moreInfoVisible = panel.moreinfo:getIsVisible()
					panel.moreinfo:setVisible(false)
				end
			end
		end
	--end
end

BSBook4Manager.OnGameStart = function()
	if getCore():isShowFirstTimeWeatherTutorial() then
		if BSBook4Manager.instance == nil then
			BSBook4Manager.instance = BSBook4Manager:new();
			BSBook4Manager.instance:update();
		end
		local panel = BSBook4Manager.instance.panel
		BSBook4Manager.instance.panel:setVisible(true);
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

Events.OnTick.Add(doBS4Guide);

