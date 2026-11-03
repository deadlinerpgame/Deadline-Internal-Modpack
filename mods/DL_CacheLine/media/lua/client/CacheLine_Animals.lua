require "CacheLine_AnimalsConfig"
local CacheLineLog = require "CacheLine_Log"

Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}

function Recipe.OnCreate.CacheLineFollowTracks(items, result, player)
    local pool = DLCacheLine.AnimalPool
    local total = 0
    for _, entry in ipairs(pool) do total = total + entry[2] end
    local roll = ZombRand(total)
    for _, entry in ipairs(pool) do
        roll = roll - entry[2]
        if roll < 0 then
            local animal = InventoryItemFactory.CreateItem(entry[1])
            local square = player:getCurrentSquare()
            if square:AddWorldInventoryItem(animal, 0.5, 0.5, 0) then
                if DLCacheLine.Config.debugPrints then
                    print("[DL_CacheLine] TRACKS_REDEEMED: player=" .. player:getUsername()
                        .. "; animal=" .. entry[1])
                end
                HaloTextHelper.addText(player, getText("IGUI_CacheLine_AnimalFound", animal:getDisplayName()))
                CacheLineLog.animal(player, square, animal)
            end
            return
        end
    end
end
