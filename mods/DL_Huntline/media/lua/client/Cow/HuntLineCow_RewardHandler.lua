
HuntLineCow = HuntLineCow or {}


function HuntLineCow.SpawnRewards(sq)
	local itemList = HuntLineCow.parseItems()
	if sq then
		for _, item in ipairs(itemList) do
			local roll = HuntLineCow.getRewardRoll()
			if roll then
				sq:AddWorldInventoryItem(item, ZombRand(0, 3), ZombRand(0, 3), 0)
			end
		end
	end
end

function HuntLineCow.getRewardRoll()
	local chance = 100
	if chance == 0 then return false end
	if chance == 100 then return true end
	return HuntLineCow.doRoll(chance)
end

function HuntLineCow.getDeathRewards()
	return 'Base.Cow_Dead'
end

function HuntLineCow.parseItems()
    local tab = {}
	local lootStr = HuntLineCow.getDeathRewards()
    for item in string.gmatch(lootStr, "([^;]+)") do
        table.insert(tab, item)
    end
    return tab
end

