require "ISUI/ISWorldObjectContextMenu"

-- This already seems to exist in Craftline?
--[[local _orig_onTrade = ISWorldObjectContextMenu.onTrade

ISWorldObjectContextMenu.onTrade = function(worldobjects, player, otherPlayer)
    _orig_onTrade(worldobjects, player, otherPlayer);
    ISWorldObjectContextMenu.instance.blockingMessage = getText("IGUI_TradingUI_WaitingAnswer", otherPlayer:getDescriptor():getForename());
end--]]