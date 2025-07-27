
HuntLineDeer = HuntLineDeer or {}


function HuntLineDeer.SpawnRewards(sq)
	local itemList = HuntLineDeer.parseItems()
	if sq then
		for _, item in ipairs(itemList) do
			local roll = HuntLineDeer.getRewardRoll()
			if roll then
				sq:AddWorldInventoryItem(item, ZombRand(0, 3), ZombRand(0, 3), 0)
			end
		end
	end
end

function HuntLineDeer.getRewardRoll()
	local chance = 100
	if chance == 0 then return false end
	if chance == 100 then return true end
	return HuntLineDeer.doRoll(chance)
end

function HuntLineDeer.getDeathRewards()
	return 'Base.Deer_Dead'
end

function HuntLineDeer.parseItems()
    local tab = {}
	local lootStr = HuntLineDeer.getDeathRewards()
    for item in string.gmatch(lootStr, "([^;]+)") do
        table.insert(tab, item)
    end
    return tab
end

