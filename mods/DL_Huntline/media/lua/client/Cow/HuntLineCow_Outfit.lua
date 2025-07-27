require "lua_timers"

HuntLineCow = HuntLineCow or {}

HuntLineCow.outfit0 = "AnimalCow"


function HuntLineCow.isCowAnimal(zed)
    if not (zed or instanceof(zed, "IsoZombie")) then return false end
    return HuntLineCow.isAnimalCow(zed)
end






function HuntLineCow.setOutfit(zed, outfitNum)
    local wearNum = HuntLineCow.getOutfitNum(zed)
    if wearNum ~= outfitNum then
        if outfitNum == 0 then
            zed:dressInNamedOutfit(HuntLineCow.outfit0)
        end
        zed:resetModelNextFrame()
		HuntLineCow.setTag(zed, outfitNum)
    end
end


----------------------- get*           ---------------------------
function HuntLineCow.getOutfitNum(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineCow.outfit0 then return 0 end

	return nil
end



function HuntLineCow.getOutfitName(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineCow.outfit0 then return "AnimalCow" end

	return nil
end

function HuntLineCow.getOutfitCrawlType(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineCow.outfit0 then return 1 end

	return nil
end






function HuntLineCow.isOutfitNum(zed, int)
	if not zed then return false end
	local fit = tostring(zed:getOutfitName())
	if int == 0 then
		if fit == HuntLineCow.outfit0 then return true end
	end
	return false
end

function HuntLineCow.isAnimalCow(zed)
	if not zed then return false end
	return tostring(zed:getOutfitName()) == HuntLineCow.outfit0
end


function HuntLineCow.setAnimalZed(zed, int)

	if not HuntLineCow.isCowAnimal(zed) then
		local outfit = HuntLineCow.outfit0
        if int == 1 then
            outfit = HuntLineCow.outfit1
		elseif int == 2 then
			outfit = HuntLineCow.outfit2
        elseif int == 0 then
            outfit = HuntLineCow.outfit0
		end
		zed:dressInNamedOutfit(outfit)
		--zed:DoZombieInventory()
		zed:resetModelNextFrame()
		HuntLineCow.setTag(zed, int)
		HuntLineCow.setStats(zed)
	end
end




function HuntLineCow.getFitGender(fit)
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
