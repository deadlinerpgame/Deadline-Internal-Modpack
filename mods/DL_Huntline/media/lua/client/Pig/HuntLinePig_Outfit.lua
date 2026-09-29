require "lua_timers"

HuntLinePig = HuntLinePig or {}

HuntLinePig.outfit0 = "AnimalPig"


function HuntLinePig.isPigAnimal(zed)
    if not (zed or instanceof(zed, "IsoZombie")) then return false end
    return HuntLinePig.isAnimalPig(zed)
end






function HuntLinePig.setOutfit(zed, outfitNum)
    local wearNum = HuntLinePig.getOutfitNum(zed)
    if wearNum ~= outfitNum then
        if outfitNum == 0 then
            zed:dressInNamedOutfit(HuntLinePig.outfit0)
        end
        zed:resetModelNextFrame()
		HuntLinePig.setTag(zed, outfitNum)
    end
end


----------------------- get*           ---------------------------
function HuntLinePig.getOutfitNum(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLinePig.outfit0 then return 0 end

	return nil
end



function HuntLinePig.getOutfitName(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLinePig.outfit0 then return "AnimalPig" end

	return nil
end

function HuntLinePig.getOutfitCrawlType(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLinePig.outfit0 then return 1 end

	return nil
end






function HuntLinePig.isOutfitNum(zed, int)
	if not zed then return false end
	local fit = tostring(zed:getOutfitName())
	if int == 0 then
		if fit == HuntLinePig.outfit0 then return true end
	end
	return false
end

function HuntLinePig.isAnimalPig(zed)
	if not zed then return false end
	return tostring(zed:getOutfitName()) == HuntLinePig.outfit0
end


function HuntLinePig.setAnimalZed(zed, int)

	if not HuntLinePig.isPigAnimal(zed) then
		local outfit = HuntLinePig.outfit0
        if int == 1 then
            outfit = HuntLinePig.outfit1
		elseif int == 2 then
			outfit = HuntLinePig.outfit2
        elseif int == 0 then
            outfit = HuntLinePig.outfit0
		end
		zed:dressInNamedOutfit(outfit)
		--zed:DoZombieInventory()
		zed:resetModelNextFrame()
		HuntLinePig.setTag(zed, int)
		HuntLinePig.setStats(zed)
	end
end




function HuntLinePig.getFitGender(fit)
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
