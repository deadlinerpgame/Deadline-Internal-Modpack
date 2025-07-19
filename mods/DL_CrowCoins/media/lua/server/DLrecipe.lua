require "recipecode"

function Recipe.OnCreate.Wallet(items, result, player)
    local success = ZombRand(0, 100)
    print(success)
	
    if success < 40 then
        return;
		
    elseif success >= 99 then
        player:getInventory():AddItem("DLM.CrowCoinGold")
    elseif success >= 90 then

    elseif success >= 80 then
        player:getInventory():AddItem("DLM.CrowCoinSilver")
    elseif success >= 70 then

    elseif success >= 60 then
        player:getInventory():AddItem("DLM.CrowCoinIron")
    elseif success >= 50 then
        player:getInventory():AddItem("DLM.CrowCoinIron")
    elseif success >= 40 then

    end
end

function Recipe.GetItemTypes.Wallet(scriptItems)
    addExistingItemType(scriptItems, "Wallet")
    addExistingItemType(scriptItems, "Wallet2")
    addExistingItemType(scriptItems, "Wallet3")
    addExistingItemType(scriptItems, "Wallet4")
end