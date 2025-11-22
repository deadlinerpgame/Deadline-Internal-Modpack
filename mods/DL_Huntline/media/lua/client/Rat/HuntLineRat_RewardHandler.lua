
HuntLineRat = HuntLineRat or {}


function HuntLineRat.SpawnRewards(sq)
	local itemList = HuntLineRat.parseItems()
	if sq then
		for _, item in ipairs(itemList) do
			local roll = HuntLineRat.getRewardRoll()
			if roll then
				sq:AddWorldInventoryItem(item, ZombRand(0, 3), ZombRand(0, 3), 0)
			end
		end
	end
end

function HuntLineRat.getRewardRoll()
	local chance = 100
	if chance == 0 then return false end
	if chance == 100 then return true end
	return HuntLineRat.doRoll(chance)
end

function HuntLineRat.getDeathRewards()
	return 'Base.DeadRat'
end

function HuntLineRat.parseItems()
    local tab = {}
	local lootStr = HuntLineRat.getDeathRewards()
    for item in string.gmatch(lootStr, "([^;]+)") do
        table.insert(tab, item)
    end
    return tab
end

