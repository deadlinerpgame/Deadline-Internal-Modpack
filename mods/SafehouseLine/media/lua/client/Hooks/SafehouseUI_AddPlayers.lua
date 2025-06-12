require "ISUI/UserPanel/ISSafehouseUI";
require "ISUI/UserPanel/ISSafehouseAddPlayerUI";
SafehouseClient = require("SafehouseClient");

local populateList_original = ISSafehouseAddPlayerUI.populateList;
function ISSafehouseAddPlayerUI:populateList()

    self.playerList:clear();
    if not self.scoreboard then return end

    for i = 0, self.scoreboard.usernames:size() - 1 do
        local username = self.scoreboard.usernames:get(i)
        local displayName = self.scoreboard.displayNames:get(i)

        if self.safehouse:getOwner() ~= username then
            local newPlayer = {};
            newPlayer.username = username;

            self.playerList:addItem(displayName, newPlayer);
        end
    end
end 

