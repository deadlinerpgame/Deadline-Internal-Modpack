require "ISUI/ISWorldObjectContextMenu"

local _orig_onTrade = ISWorldObjectContextMenu.onTrade

print("[PatchLine] Overriding ISWorldObjectContextMenu.onTrade");
ISWorldObjectContextMenu.onTrade = function(worldobjects, player, otherPlayer)
    local ui = ISTradingUI:new(50,50,500,500, player, otherPlayer)
    ui:initialise();
    ui:addToUIManager();
    ui.pendingRequest = true;
    ui.blockingMessage = getText("IGUI_TradingUI_WaitingAnswer", otherPlayer:getDescriptor():getForename());
    requestTrading(player, otherPlayer);
end