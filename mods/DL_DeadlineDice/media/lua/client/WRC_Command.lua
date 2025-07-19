if not isClient() then return end -- only in MP
WRC = WRC or {}
WRC.Commands = WRC.Commands or {}
WRC.TabHandlers = WRC.TabHandlers or {}
DeadlineDice = DeadlineDice

function WRC.Commands.Dice()
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

WRC.SpecialCommands["/dice"] = {
    handler = "Dice",
    tabHandlers = {},
    usage = "/dice",
    help = "Opens the Dice menu.",
    adminOnly = false,
}