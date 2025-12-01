require "recipecode"

function Recipe.OnCreate.Wallet(items, result, player)
    local rollGold = ZombRand(0, 10000) / 100
    local goldCount = 0
    if rollGold < 0.5 then
        goldCount = 3
    elseif rollGold < 1.5 then
        goldCount = 2
    elseif rollGold < 3.5 then
        goldCount = 1
    end
    for i = 1, goldCount do
        player:getInventory():AddItem("DLM.CrowCoinGold")
    end

    local rollSilver = ZombRand(0, 10000) / 100
    local silverCount = 0
    if rollSilver < 4.0 then
        silverCount = 3
    elseif rollSilver < 7.5 then
        silverCount = 2
    elseif rollSilver < 10.5 then
        silverCount = 1
    end
    for i = 1, silverCount do
        player:getInventory():AddItem("DLM.CrowCoinSilver")
    end

    local rollIron = ZombRand(0, 10000) / 100
    local ironCount = 0
    if rollIron < 7.5 then
        ironCount = 4
    elseif rollIron < 13.5 then
        ironCount = 3
    elseif rollIron < 18.5 then
        ironCount = 2
    elseif rollIron < 22.5 then
        ironCount = 1
    end
    for i = 1, ironCount do
        player:getInventory():AddItem("DLM.CrowCoinIron")
    end
end

function Recipe.GetItemTypes.Wallet(scriptItems)
    addExistingItemType(scriptItems, "Wallet")
    addExistingItemType(scriptItems, "Wallet2")
    addExistingItemType(scriptItems, "Wallet3")
    addExistingItemType(scriptItems, "Wallet4")
end