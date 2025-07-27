local function onOpenDeadlineDicePanel()
    if ISDeadlineDiceUI.instance then
        ISDeadlineDiceUI.instance:close()
    else
        local ui = ISDeadlineDiceUI:new(0, 0, getPlayer());
        ui:initialise();
        ui:addToUIManager();
    end

    if ISUserPanelUI.instance then
        ISUserPanelUI.instance:close()
    end
end

--Will show the "Deadline Dice" button in client Panel
require "ISUI/UserPanel/ISUserPanelUI"
local _ISUserPanelUI_create = ISUserPanelUI.create
function ISUserPanelUI:create()
    _ISUserPanelUI_create(self)
    local fontHeight = getTextManager():getFontHeight(UIFont.Small)
    local btnWid = 150
    local btnHgt = math.max(25, fontHeight + 3 * 2)
    local btnGapY = 5

    local lastButton = self.children[self.IDMax - 1]
    local serverOptionBtn = self.serverOptionBtn or lastButton

    self.deadlineDiceBtn = ISButton:new(serverOptionBtn.x, serverOptionBtn.y + btnHgt + btnGapY, btnWid, btnHgt,
        "Deadline Dice", self, onOpenDeadlineDicePanel)
    self.deadlineDiceBtn.internal = ""
    self.deadlineDiceBtn:initialise()
    self.deadlineDiceBtn:instantiate()
    self.deadlineDiceBtn.borderColor = self.buttonBorderColor
    self:addChild(self.deadlineDiceBtn)
end
