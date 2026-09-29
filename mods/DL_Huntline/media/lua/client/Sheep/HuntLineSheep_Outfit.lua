require "lua_timers"

HuntLineSheep = HuntLineSheep or {}

HuntLineSheep.outfit0 = "AnimalSheep"


function HuntLineSheep.isSheepAnimal(zed)
    if not (zed or instanceof(zed, "IsoZombie")) then return false end
    return HuntLineSheep.isAnimalSheep(zed)
end






function HuntLineSheep.setOutfit(zed, outfitNum)
    local wearNum = HuntLineSheep.getOutfitNum(zed)
    if wearNum ~= outfitNum then
        if outfitNum == 0 then
            zed:dressInNamedOutfit(HuntLineSheep.outfit0)
        end
        zed:resetModelNextFrame()
		HuntLineSheep.setTag(zed, outfitNum)
    end
end


----------------------- get*           ---------------------------
function HuntLineSheep.getOutfitNum(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineSheep.outfit0 then return 0 end

	return nil
end



function HuntLineSheep.getOutfitName(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineSheep.outfit0 then return "AnimalSheep" end

	return nil
end

function HuntLineSheep.getOutfitCrawlType(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineSheep.outfit0 then return 1 end

	return nil
end






function HuntLineSheep.isOutfitNum(zed, int)
	if not zed then return false end
	local fit = tostring(zed:getOutfitName())
	if int == 0 then
		if fit == HuntLineSheep.outfit0 then return true end
	end
	return false
end

function HuntLineSheep.isAnimalSheep(zed)
	if not zed then return false end
	return tostring(zed:getOutfitName()) == HuntLineSheep.outfit0
end


function HuntLineSheep.setAnimalZed(zed, int)

	if not HuntLineSheep.isSheepAnimal(zed) then
		local outfit = HuntLineSheep.outfit0
        if int == 1 then
            outfit = HuntLineSheep.outfit1
		elseif int == 2 then
			outfit = HuntLineSheep.outfit2
        elseif int == 0 then
            outfit = HuntLineSheep.outfit0
		end
		zed:dressInNamedOutfit(outfit)
		--zed:DoZombieInventory()
		zed:resetModelNextFrame()
		HuntLineSheep.setTag(zed, int)
		HuntLineSheep.setStats(zed)
	end
end




function HuntLineSheep.getFitGender(fit)
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
