
HuntLineRabbit = HuntLineRabbit or {}


function HuntLineRabbit.SpawnRewards(sq)
	local itemList = HuntLineRabbit.parseItems()
	if sq then
		for _, item in ipairs(itemList) do
			local roll = HuntLineRabbit.getRewardRoll()
			if roll then
				sq:AddWorldInventoryItem(item, ZombRand(0, 3), ZombRand(0, 3), 0)
			end
		end
	end
end

function HuntLineRabbit.getRewardRoll()
	local chance = 100
	if chance == 0 then return false end
	if chance == 100 then return true end
	return HuntLineRabbit.doRoll(chance)
end

function HuntLineRabbit.getDeathRewards()
	return 'Base.Rabbit_Dead'
end

function HuntLineRabbit.parseItems()
    local tab = {}
	local lootStr = HuntLineRabbit.getDeathRewards()
    for item in string.gmatch(lootStr, "([^;]+)") do
        table.insert(tab, item)
    end
    return tab
end

