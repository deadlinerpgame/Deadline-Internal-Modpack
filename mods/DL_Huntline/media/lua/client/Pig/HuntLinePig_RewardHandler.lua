
HuntLinePig = HuntLinePig or {}


function HuntLinePig.SpawnRewards(sq)
	local itemList = HuntLinePig.parseItems()
	if sq then
		for _, item in ipairs(itemList) do
			local roll = HuntLinePig.getRewardRoll()
			if roll then
				sq:AddWorldInventoryItem(item, ZombRand(0, 3), ZombRand(0, 3), 0)
			end
		end
	end
end

function HuntLinePig.getRewardRoll()
	local chance = 100
	if chance == 0 then return false end
	if chance == 100 then return true end
	return HuntLinePig.doRoll(chance)
end

function HuntLinePig.getDeathRewards()
	return 'Base.Pig_Dead'
end

function HuntLinePig.parseItems()
    local tab = {}
	local lootStr = HuntLinePig.getDeathRewards()
    for item in string.gmatch(lootStr, "([^;]+)") do
        table.insert(tab, item)
    end
    return tab
end

