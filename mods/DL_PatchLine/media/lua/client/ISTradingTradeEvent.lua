require "ISUI/ISWorldObjectContextMenu"

local _orig_onTrade = ISWorldObjectContextMenu.onTrade

ISWorldObjectContextMenu.onTrade = function(worldobjects, player, otherPlayer)
    _orig_onTrade(worldobjects, player, otherPlayer);
    ui.blockingMessage = getText("IGUI_TradingUI_WaitingAnswer", otherPlayer:getDescriptor():getForename());
end