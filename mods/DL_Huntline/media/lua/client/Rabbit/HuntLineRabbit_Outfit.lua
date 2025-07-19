require "lua_timers"

HuntLineRabbit = HuntLineRabbit or {}

HuntLineRabbit.outfit0 = "AnimalRabbit"


function HuntLineRabbit.isRabbitAnimal(zed)
    if not (zed or instanceof(zed, "IsoZombie")) then return false end
    return HuntLineRabbit.isAnimalRabbit(zed)
end






function HuntLineRabbit.setOutfit(zed, outfitNum)
    local wearNum = HuntLineRabbit.getOutfitNum(zed)
    if wearNum ~= outfitNum then
        if outfitNum == 0 then
            zed:dressInNamedOutfit(HuntLineRabbit.outfit0)
        end
        zed:resetModelNextFrame()
		HuntLineRabbit.setTag(zed, outfitNum)
    end
end


----------------------- get*           ---------------------------
function HuntLineRabbit.getOutfitNum(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineRabbit.outfit0 then return 0 end

	return nil
end



function HuntLineRabbit.getOutfitName(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineRabbit.outfit0 then return "AnimalRabbit" end

	return nil
end

function HuntLineRabbit.getOutfitCrawlType(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineRabbit.outfit0 then return 1 end

	return nil
end






function HuntLineRabbit.isOutfitNum(zed, int)
	if not zed then return false end
	local fit = tostring(zed:getOutfitName())
	if int == 0 then
		if fit == HuntLineRabbit.outfit0 then return true end
	end
	return false
end

function HuntLineRabbit.isAnimalRabbit(zed)
	if not zed then return false end
	return tostring(zed:getOutfitName()) == HuntLineRabbit.outfit0
end


function HuntLineRabbit.setAnimalZed(zed, int)

	if not HuntLineRabbit.isRabbitAnimal(zed) then
		local outfit = HuntLineRabbit.outfit0
        if int == 1 then
            outfit = HuntLineRabbit.outfit1
		elseif int == 2 then
			outfit = HuntLineRabbit.outfit2
        elseif int == 0 then
            outfit = HuntLineRabbit.outfit0
		end
		zed:dressInNamedOutfit(outfit)
		--zed:DoZombieInventory()
		zed:resetModelNextFrame()
		HuntLineRabbit.setTag(zed, int)
		HuntLineRabbit.setStats(zed)
	end
end




function HuntLineRabbit.getFitGender(fit)
    local maleOutfits = getAllOutfits(false)
    local femaleOutfits = getAllOutfits(true)
    local allOutfits = {}

    for i = 0, maleOutfits:size() - 1 do
        table.insert(allOutfits, maleOutfits:get(i))
    end
    for i = 0, femaleOutfits:size() - 1 do
        table.insert(allOutfits, femaleOutfits:get(i))
    end

    if not fit or fit == '' then
        fit = allOutfits[ZombRand(#allOutfits) + 1]
    end

    local outfitExists = false
    for _, outfit in ipairs(allOutfits) do
        if outfit == fit then
            outfitExists = true
            break
        end
    end

    if not outfitExists then
        return nil
    end
	local isFemale = false
    if maleOutfits:contains(fit) and femaleOutfits:contains(fit) then
		if 1 == ZombRand(0, 2) then
			isFemale = true
		end
    elseif femaleOutfits:contains(fit) and not maleOutfits:contains(fit) then
		isFemale = true
    elseif not femaleOutfits:contains(fit) and maleOutfits:contains(fit) then
		isFemale = false
    end
	return isFemale
end
