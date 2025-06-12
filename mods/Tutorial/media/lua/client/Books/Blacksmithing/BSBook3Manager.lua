BSBook3Manager = ISBaseObject:derive("BSBook3Manager");

function BSBook3Manager:update()
     if self.panel == nil then
         self.panel = BSBook3Panel:new(0, 0, 440, 880);
         self.panel:initialise();
         self.panel:addToUIManager();
         self.panel.tutorialSetInfo = ISTutorialSetInfo:new();

         local entry = BSBook3Entries.getEntry(0);
         self.panel.tutorialSetInfo:addPage(entry.title, entry.text, entry.moreInfo);

         self.panel.tutorialSetInfo:applyPageToRichTextPanel(self.panel.richtext);
         self.panel.moreInfo = entry.moreInfo;

		 for i=1,BSBook3Entries.list:size() -1 do
			entry = BSBook3Entries.getEntry(i);
			self.panel.tutorialSetInfo:addPage(entry.title, entry.text, entry.moreInfo);
		 end

		ISLayoutManager.RegisterWindow('BSBook3', BSBook3Manager, self) 
     end
end

function BSBook3Manager:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.moreInfoVisible = false
    return o
end

function BSBook3Manager:RestoreLayout(name, layout)
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

function BSBook3Manager:SaveLayout(name, layout)
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

function doBS3Guide()
	if isServer() then return; end
	-- Disable with controller for now.
	if JoypadState[1] then return end
    -- hide it for tut
    if getCore():getGameMode() == "Tutorial" and not getCore():isTutorialDone() then
        return;
    end
    -- only happens on single player so no splitscreen support required.
    if BSBook3Manager.instance == nil then
        BSBook3Manager.instance = BSBook3Manager:new();
		--BSBook3Manager.instance.panel:setVisible(false);
    end

    BSBook3Manager.instance:update();

	local panel = BSBook3Manager.instance.panel

end

BSBook3Manager.OnNewGame = function()
	if isServer() then return; end
	Events.OnTick.Add(doBS3Guide);
end


BSBook3Manager.onKeyPressed = function()

		if BSBook3Manager.instance == nil then
			Events.OnTick.Add(doBS3Guide);
		else
			if BSBook3Manager.instance.panel:getIsVisible() == false then
				BSBook3Manager.instance.panel:setVisible(not BSBook3Manager.instance.panel:getIsVisible());
				local panel = BSBook3Manager.instance.panel
				if panel.moreinfo and panel:getIsVisible() then
					panel.moreinfo:setVisible(BSBook3Manager.instance.moreInfoVisible)
				elseif panel.moreinfo then
					BSBook3Manager.instance.moreInfoVisible = panel.moreinfo:getIsVisible()
					panel.moreinfo:setVisible(false)
				end
			end
		end
	--end
end

BSBook3Manager.OnGameStart = function()
	if getCore():isShowFirstTimeWeatherTutorial() then
		if BSBook3Manager.instance == nil then
			BSBook3Manager.instance = BSBook3Manager:new();
			BSBook3Manager.instance:update();
		end
		local panel = BSBook3Manager.instance.panel
		BSBook3Manager.instance.panel:setVisible(true);
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

Events.OnTick.Add(doBS3Guide);

