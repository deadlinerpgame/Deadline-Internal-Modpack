
HuntLineSheep = HuntLineSheep or {}


function HuntLineSheep.SpawnRewards(sq)
	local itemList = HuntLineSheep.parseItems()
	if sq then
		for _, item in ipairs(itemList) do
			local roll = HuntLineSheep.getRewardRoll()
			if roll then
				sq:AddWorldInventoryItem(item, ZombRand(0, 3), ZombRand(0, 3), 0)
			end
		end
	end
end

function HuntLineSheep.getRewardRoll()
	local chance = 100
	if chance == 0 then return false end
	if chance == 100 then return true end
	return HuntLineSheep.doRoll(chance)
end

function HuntLineSheep.getDeathRewards()
	return 'Base.Sheep_Dead'
end

function HuntLineSheep.parseItems()
    local tab = {}
	local lootStr = HuntLineSheep.getDeathRewards()
    for item in string.gmatch(lootStr, "([^;]+)") do
        table.insert(tab, item)
    end
    return tab
end

