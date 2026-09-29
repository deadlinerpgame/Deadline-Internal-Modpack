require "lua_timers"

HuntLineRat = HuntLineRat or {}

HuntLineRat.outfit0 = "AnimalRat"


function HuntLineRat.isRatAnimal(zed)
    if not (zed or instanceof(zed, "IsoZombie")) then return false end
    return HuntLineRat.isAnimalRat(zed)
end






function HuntLineRat.setOutfit(zed, outfitNum)
    local wearNum = HuntLineRat.getOutfitNum(zed)
    if wearNum ~= outfitNum then
        if outfitNum == 0 then
            zed:dressInNamedOutfit(HuntLineRat.outfit0)
        end
        zed:resetModelNextFrame()
		HuntLineRat.setTag(zed, outfitNum)
    end
end


----------------------- get*           ---------------------------
function HuntLineRat.getOutfitNum(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineRat.outfit0 then return 0 end

	return nil
end



function HuntLineRat.getOutfitName(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineRat.outfit0 then return "AnimalRat" end

	return nil
end

function HuntLineRat.getOutfitCrawlType(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineRat.outfit0 then return 1 end

	return nil
end






function HuntLineRat.isOutfitNum(zed, int)
	if not zed then return false end
	local fit = tostring(zed:getOutfitName())
	if int == 0 then
		if fit == HuntLineRat.outfit0 then return true end
	end
	return false
end

function HuntLineRat.isAnimalRat(zed)
	if not zed then return false end
	return tostring(zed:getOutfitName()) == HuntLineRat.outfit0
end


function HuntLineRat.setAnimalZed(zed, int)

	if not HuntLineRat.isRatAnimal(zed) then
		local outfit = HuntLineRat.outfit0
        if int == 1 then
            outfit = HuntLineRat.outfit1
		elseif int == 2 then
			outfit = HuntLineRat.outfit2
        elseif int == 0 then
            outfit = HuntLineRat.outfit0
		end
		zed:dressInNamedOutfit(outfit)
		--zed:DoZombieInventory()
		zed:resetModelNextFrame()
		HuntLineRat.setTag(zed, int)
		HuntLineRat.setStats(zed)
	end
end




function HuntLineRat.getFitGender(fit)
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
