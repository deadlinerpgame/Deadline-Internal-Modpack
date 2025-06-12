require "ISUI/UserPanel/ISSafehouseUI";
SafehouseClient = require("SafehouseClient");

Events.ReceiveSafehouseInvite.Remove(ISSafehouseUI.ReceiveSafehouseInvite);

if isServer() then return end;

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small);

local SANDBOX_OPTIONS = getSandboxOptions();

local ADD_LEN = getTextManager():MeasureStringX(UIFont.Small, "Add Manager") + 5;
local REMOVE_LEN = getTextManager():MeasureStringX(UIFont.Small, "Remove Manager") + 5;

function ISSafehouseUI:onClickAddManager(button)
    -- Find player and check if they are in game.
    local selected = self.playerList.selected;

    local selectedName = self.playerList.items[selected].item.name;
    if not selectedName then return end;

    -- Check if player is valid.
    local matchingPlayer = getPlayerFromUsername(selectedName);
    if not matchingPlayer then return end; -- They have likely DCed or crashed between selecting and clicking accept (rare edge case).

    SafehouseClient.AddSafehouseManager(self.safehouse, matchingPlayer);

    self:populateList();
    self.playerList:onMouseUp(getMouseX(), getMouseY());
    self:updateManagerButtons();
end 

function ISSafehouseUI:onClickRemoveManager(button)
    -- Find player and check if they are in game.
    local selected = self.playerList.selected;

    local selectedName = self.playerList.items[selected].item.name;
    if not selectedName then return end;

    -- Check if player is valid.
    local matchingPlayer = getPlayerFromUsername(selectedName);
    if not matchingPlayer then return end; -- They have likely DCed or crashed between selecting and clicking accept (rare edge case).

    SafehouseClient.RemoveSafehouseManager(self.safehouse, matchingPlayer);

    self:populateList();
    self.playerList:onMouseDown(getMouseX(), getMouseY());
    self:updateManagerButtons();
end

function ISSafehouseUI:onMouseDown_List(x, y) -- NOTE, the self of this is the playerList itself!
    local row = self:rowAt(x, y);
    if not row or row == -1 then return; end

    if not self:isMouseOverScrollBar() then
        self.selected = row;
    end

    local selected = self.selected;

    local selectedPlayer = self.items[selected].item;
    if not selectedPlayer then return end;

    if not self.parent:canAddManagers() then return end;
    self.parent:updateManagerButtons();
end

function ISSafehouseUI:canAddManagers()
    return self:isOwner() or self:hasPrivilegedAccessLevel();
end

local originalUpdateButtons = ISSafehouseUI.updateButtons;
function ISSafehouseUI:updateButtons()
    local isOwner = self:isOwner();
    local hasPrivilegedAccessLevel = self:hasPrivilegedAccessLevel();
    self.releaseSafehouse:setVisible(isOwner or hasPrivilegedAccessLevel);
    self.changeOwnership:setVisible(isOwner or hasPrivilegedAccessLevel);
    self.removePlayer.enable = isOwner or hasPrivilegedAccessLevel or SafehouseClient.IsManager(self.player, self.safehouse);
    self.addPlayer.enable = isOwner or hasPrivilegedAccessLevel or SafehouseClient.IsManager(self.player, self.safehouse);
    self.changeTitle.enable = isOwner or hasPrivilegedAccessLevel;
    self.quitSafehouse:setVisible(not isOwner and self.safehouse:getPlayers():contains(self.player:getUsername()));

end

function ISSafehouseUI:updateManagerButtons()
    -- 1. Is there a player selected?
    if not self.playerList.selected or self.playerList.selected == 0 then return end;

    local selected = self.playerList.selected;

    -- Get player from selected.
    if not self.playerList.items then return end;
    if not self.playerList.items[selected] then return end;

    local managerItem = self.playerList.items[selected].item or nil;
    if not managerItem then return end;

    -- 2. If selected, are they a manager?
    local isMgr = SafehouseClient.IsManagerEx(managerItem.name, self.safehouse);

    -- 3. If they're NOT a manager:
    if not isMgr or isMgr == false then
        local mgrSlotsLeft = SafehouseClient.GetRemainingManagerSlots(self.safehouse);
        if not mgrSlotsLeft then return end;
        -- a. If manager slots available, "add manager".
        if mgrSlotsLeft > 0 then
            self.mgrBtn.title = "Add Manager";
            self.mgrBtn:setWidth(ADD_LEN + 5);
            self.mgrBtn.onclick = ISSafehouseUI.onClickAddManager;

            if self:canAddManagers() then
                self.mgrBtn.enable = true;
            end
        -- b. If manager slots NOT available, keep button disabled.
        else
            self.mgrBtn.enable = false;
        end
        return;
    end

    -- 4. If they ARE a manager:
        -- a. Show remove manager button.
    self.mgrBtn.title = "Remove Manager";
    self.mgrBtn:setWidth(REMOVE_LEN + 5);
    self.mgrBtn.onclick = ISSafehouseUI.onClickRemoveManager;

    if self:canAddManagers() then
        self.mgrBtn.enable = true;
    end

    -- Now check if we can reactivate the add player for managers.
    if SafehouseClient.IsManager(getPlayer(), self.safehouse) then
        self.addPlayer.enable = true;
    end
end


function ISSafehouseUI:drawPlayers(y, item, alt)
    local a = 0.9;

    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15);
    end

    if item.item.isManager and item.item.isManager == true then
        self:drawText(item.text .. " - Manager", 10, y + 2, 1, 1, 1, a, self.font);
    else
        self:drawText(item.text, 10, y + 2, 1, 1, 1, a, self.font);
    end

    return y + self.itemheight;
end

--[[
    OVERRIDE DEFAULT SAFEHOUSE UI INIT FUNCTIONALITY
    Call initial functionality.
    Then inject our own features.
--]]
local vanillaSafehouseFunction = ISSafehouseUI.initialise;
function ISSafehouseUI:initialise()
    vanillaSafehouseFunction(self);
    ModData.request("SafehouseLine_Managers");

    local safehouse = self.safehouse;
    if not safehouse then return end;

    local mgrBtn = ISButton:new(self.addPlayer:getRight() + 5, self.playerList.y + self.playerList.height + 5, 70, FONT_HGT_SMALL, getText("IGUI_SafehouseUI_AddManager"), self, ISSafehouseUI.onClickAddManager);
    mgrBtn.internal = "ADDMGR";
    mgrBtn:initialise();
    mgrBtn:instantiate();
    mgrBtn.borderColor = self.buttonBorderColor;
    mgrBtn.tooltip = "Managers allow other players to add/remove from the safehouse, but not make other players managers themselves.";
    self:addChild(mgrBtn);

    self.mgrBtn = mgrBtn;
    self.mgrBtn.enable = false;

    -- Override vanilla functionality to allow managers to add players.
    self.addPlayer.enable = self:isOwner() or self:hasPrivilegedAccessLevel() or SafehouseClient.IsManager(getPlayer(), self.safehouse);
    self.playerList.onMouseDown = self.onMouseDown_List;
    self.playerList.doDrawItem = self.drawPlayers;

    self:populateList();
    self:updateManagerButtons();
end

local vanillaPlayerListFunction = ISSafehouseUI.populateList;
function ISSafehouseUI:populateList()

    local selected = self.playerList.selected;
    self.playerList:clear();

    for i = 0, self.safehouse:getPlayers():size() - 1 do

        local newPlayer = {};
        newPlayer.name = self.safehouse:getPlayers():get(i);

        local player = getPlayerFromUsername(newPlayer.name);
        if not player then return end;
        
        newPlayer.isManager = SafehouseClient.IsManager(player, self.safehouse);
            
        if newPlayer.name ~= self.safehouse:getOwner() then
            self.playerList:addItem(newPlayer.name, newPlayer);
        end;
    end;

    self.playerList.selected = math.min(selected, #self.playerList.items);
end


--[[
    OVERRIDE THE FUNCTION TO PREVENT SENDING IF HAS MULTIPLE SHs.
--]]



function SafehouseLine_ReceiveSafehouseInvite(safehouse, host)
    if ISSafehouseUI.inviteDialogs[host] then
        if ISSafehouseUI.inviteDialogs[host]:isReallyVisible() then return end
        ISSafehouseUI.inviteDialogs[host] = nil
    end

    local modal = ISModalDialog:new(getCore():getScreenWidth() / 2 - 175,getCore():getScreenHeight() / 2 - 75, 350, 150, getText("IGUI_SafehouseUI_Invitation", host), true, nil, ISSafehouseUI.onAnswerSafehouseInvite);
    modal:initialise()
    modal:addToUIManager()
    modal.safehouse = safehouse;
    modal.host = host;
    modal.moveWithMouse = true;
    ISSafehouseUI.inviteDialogs[host] = modal
end

Events.ReceiveSafehouseInvite.Add(SafehouseLine_ReceiveSafehouseInvite);