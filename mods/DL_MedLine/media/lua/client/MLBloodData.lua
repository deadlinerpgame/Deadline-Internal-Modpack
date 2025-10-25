require "ISBaseObject";
MLBloodData = ISBaseObject:derive("MLBloodData");

---Creates a new blood data object to store a player's medline blood data.
---@param player IsoPlayer The player to associate with the blood data. Used to cache so calls for getPlayer() are not costly as these typically run on the local client.
---@return table MLBloodData The created blood data object to be put into a player's getModData().Medline.BloodData;
function MLBloodData:new(player)
    local o = {};
    setmetatable(o, self);
    self.__index = self;

    o.character = player;
    return o;
end





--[[

--]]
