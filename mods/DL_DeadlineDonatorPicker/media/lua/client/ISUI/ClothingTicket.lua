DL_DonatorClothes = require("DCManager") or {};

local function OnFillInventoryObjectContextMenu(playerNum, context, items)

    if not playerNum then return end

    local playerObj = getSpecificPlayer(playerNum);
    if not playerObj then return end;

    items = ISInventoryPane.getActualItems(items)

    for i,item in ipairs(items) do
        if item:getType() == "DLDC_ClothingTicket" then
            context:addOption(getText("ContextMenu_OpenDonatorClothingTicket"), playerNum, DL_DonatorClothes.RequestSlotsFromServer, item) -- DL_DonatorClothes.RequestSlotsFromServer(playerNum, item)
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(OnFillInventoryObjectContextMenu)