require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"

ISMannequinUI = ISCollapsableWindow:derive("ISMannequinUI");

function ISMannequinUI:initialise()
    ISCollapsableWindow.initialise(self);
    self:create();
end

function ISMannequinUI:loadMannequinData(data)
    self.mannequinData = data;

    self:addSkinPanel();
    self:addPosePanel();
    

    local nextX = (self.mannequinData.info.skin.maxX * 1.5 + 5) + (self.mannequinData.info.pose.maxX * 1.5 + 10);
    local height = getTextManager():getFontHeight(UIFont.Small) + 2 * 2
    self.button = ISButton:new(nextX, 25, (self.width - nextX) - 10, height, ">>> Spawn Mannequin", self, ISMannequinUI.onOptionMouseDown);
    
    self.button.internal = "SpawnMannequin";
    self.button:initialise();
    self.button:instantiate();
    self.button.borderColor = {r=0.7, g=0.7, b=0.7, a=0.5}; -- Optional
    self:addChild(self.button);

    self:addPreviewPanel();

    local newWidth = math.floor(nextX + self.button:getWidth() + 10);
    self:setWidth(newWidth);

    local selected = 0;
    for k, v in pairs(data.data) do
        self.skinPanel:addItem(k);

        -- Probably a better way to get the first element and manually select it but oh well.
        if selected == 0 then
            for i, v in pairs(data.data[k]) do
                self.posePanel:addItem(v);
            end
        end
        selected = selected + 1
    end


    
    self.firstInit = true;
end

function ISMannequinUI:renderPreview()
    --ISCollapsableWindow.render(self);

    if not self.parent.firstInit then return end;

    local poseSelected = self.parent.posePanel.selected;
    if not poseSelected then return end

    if not self.parent.posePanel.items[poseSelected] then return end

    local poseStr = self.parent.posePanel.items[poseSelected].text;
    if not poseStr then return end

    local poseImg = getTexture("media/ui/Poses/" .. poseStr .. ".png");
    if not poseImg then return end

    local width = poseImg:getWidthOrig();
    local height = poseImg:getHeightOrig();
    
    self:drawTextureScaled(poseImg, 2, 2, width / 2, height / 2, 1)
end

function ISMannequinUI:onOptionMouseDown(button, x, y)
    if button.internal == "SpawnMannequin" then
        local skinSelected = self.skinPanel.selected;
        local poseSelected = self.posePanel.selected;

        local skinStr = self.skinPanel.items[skinSelected].text;
        local poseStr = self.posePanel.items[poseSelected].text;

        local finalStr = string.format("DL_%s_%s", skinStr, poseStr);
        self:GiveMannequin(finalStr);
    end
end

function ISMannequinUI:addSkinPanel()
    if not self.mannequinData then return end

    self.skinPanel = ISScrollingListBox:new(0, 25, self.mannequinData.info.skin.maxX * 1.5, self.height - 30);
    self.skinPanel:initialise()
    self.skinPanel:instantiate()
    self.skinPanel.itemheight = self.mannequinData.info.skin.maxY;
    self.skinPanel.font = UIFont.Small
    self.skinPanel.drawBorder = true;
    self.skinPanel:setVisible(true)
    self.skinPanel.onMouseDown = self.SkinPanel_OnMouseDown
    self:addChild(self.skinPanel)
end

function ISMannequinUI:addPosePanel()
    if not self.mannequinData then return end

    self.posePanel = ISScrollingListBox:new(self.mannequinData.info.skin.maxX * 1.5 + 5, 25, self.mannequinData.info.pose.maxX * 1.5 + 5, self.height - 30);
    self.posePanel:initialise()
    self.posePanel:instantiate()
    self.posePanel.itemheight = self.mannequinData.info.pose.maxY;
    self.posePanel.font = UIFont.Small
    self.posePanel.drawBorder = true
    self.posePanel:setVisible(true)
    self.posePanel.onMouseDown = self.PosePanel_OnMouseDown
    self:addChild(self.posePanel)
end

function ISMannequinUI:addPreviewPanel()
    if not self.mannequinData then return end

    local btnX = self.button.x
    local btnY = self.button.y
    local btnW = self.button.width
    local btnH = self.button.height

    self.previewPanel = ISPanel:new(math.floor(btnX + 50), math.floor(btnY + btnH + 5), 155, 155);
    self.previewPanel:initialise()
    self.previewPanel:instantiate()
    self.previewPanel.font = UIFont.Small
    self.previewPanel.drawBorder = true
    self.previewPanel.render = self.renderPreview
    self.previewPanel:setVisible(true)
    self:addChild(self.previewPanel)
end


function ISMannequinUI:GiveMannequin(script)
    local gameScript =  getScriptManager():getMannequinScript(script);

    local spriteName = gameScript:isFemale() and "location_shop_mall_01_65" or "location_shop_mall_01_68"
    local obj = IsoMannequin.new(getCell(), nil, getSprite(spriteName))
	obj:setMannequinScriptName(script)
	local item = InventoryItemFactory.CreateItem("Moveables.Moveable")
	item:ReadFromWorldSprite(spriteName)
	obj:setCustomSettingsToItem(item)
	getSpecificPlayer(0):getInventory():AddItem(item)
    item:transmitCompleteItemToServer()
end

function ISMannequinUI:loadPosePanel(skin)
    if not self.mannequinData then return end

    self.posePanel:clear()

    -- Get the pose data for the given skin.
    local poseData = self.mannequinData.data[skin];

    if not poseData then
        return
    end

    for i,v in ipairs(poseData) do
        self.posePanel:addItem(v)
    end
end    
--

function ISMannequinUI.SkinPanel_OnMouseDown(self, x, y)
    local selected = self.selected

    local row = self:rowAt(x, y);
    if row == -1 then return; end

    self.selected = row;
    
    if self.selected ~= selected then -- Selection has changed, load new panel data.
        local selectedText = self.items[row].text
        self.parent:loadPosePanel(selectedText);
    end

end

function ISMannequinUI.PosePanel_OnMouseDown(self, x, y)
    local selected = self.selected

    local row = self:rowAt(x, y);
    if row == -1 then return; end

    self.selected = row;
    
    if self.selected ~= selected then -- Selection has changed, load new panel data.
        local selectedText = self.items[row].text
    end

end
---

function ISMannequinUI:prerender() -- Call before render, it's for harder stuff that need init, ect
    ISCollapsableWindow.prerender(self);
    
    --self:drawText("Hello world",0,0,1,1,1,1, UIFont.Small); -- You can put it in render() too
end

function ISMannequinUI:render() -- Use to render text and other
    ISCollapsableWindow.render(self);
end

function ISMannequinUI:create() -- Use to make the elements
end

function ISMannequinUI:new(x, y, width, height)
    local o = {};
    o = ISCollapsableWindow:new(x, y, width, height);
    o.showBackground = true;
    o.backgroundColor = { r = 0.2, g = 0.2, b = 0.2, a = 0.8};
    o.showBorder = true;
    o.borderColor = { r = 0.2, g = 0.2, b = 0.2, a = 0.8};
    o.moveWithMouse = true;
    o.title = "MannequinLine - Mannequin Spawner"
    o.mannequinData = {};
    o:setResizable(false);
    o:setDrawFrame(true);
    setmetatable(o, self);
    self.__index = self;

    return o;
end