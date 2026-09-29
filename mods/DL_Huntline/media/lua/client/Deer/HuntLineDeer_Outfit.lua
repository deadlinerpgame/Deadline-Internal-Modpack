require "lua_timers"

HuntLineDeer = HuntLineDeer or {}

HuntLineDeer.outfit0 = "AnimalDeer"


function HuntLineDeer.isDeerAnimal(zed)
    if not (zed or instanceof(zed, "IsoZombie")) then return false end
    return HuntLineDeer.isAnimalDeer(zed)
end






function HuntLineDeer.setOutfit(zed, outfitNum)
    local wearNum = HuntLineDeer.getOutfitNum(zed)
    if wearNum ~= outfitNum then
        if outfitNum == 0 then
            zed:dressInNamedOutfit(HuntLineDeer.outfit0)
        end
        zed:resetModelNextFrame()
		HuntLineDeer.setTag(zed, outfitNum)
    end
end


----------------------- get*           ---------------------------
function HuntLineDeer.getOutfitNum(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineDeer.outfit0 then return 0 end

	return nil
end



function HuntLineDeer.getOutfitName(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineDeer.outfit0 then return "AnimalDeer" end

	return nil
end

function HuntLineDeer.getOutfitCrawlType(zed)
	if not zed then return nil end
	local fit = tostring(zed:getOutfitName())
	if fit == HuntLineDeer.outfit0 then return 1 end

	return nil
end






function HuntLineDeer.isOutfitNum(zed, int)
	if not zed then return false end
	local fit = tostring(zed:getOutfitName())
	if int == 0 then
		if fit == HuntLineDeer.outfit0 then return true end
	end
	return false
end

function HuntLineDeer.isAnimalDeer(zed)
	if not zed then return false end
	return tostring(zed:getOutfitName()) == HuntLineDeer.outfit0
end


function HuntLineDeer.setAnimalZed(zed, int)

	if not HuntLineDeer.isDeerAnimal(zed) then
		local outfit = HuntLineDeer.outfit0
        if int == 1 then
            outfit = HuntLineDeer.outfit1
		elseif int == 2 then
			outfit = HuntLineDeer.outfit2
        elseif int == 0 then
            outfit = HuntLineDeer.outfit0
		end
		zed:dressInNamedOutfit(outfit)
		--zed:DoZombieInventory()
		zed:resetModelNextFrame()
		HuntLineDeer.setTag(zed, int)
		HuntLineDeer.setStats(zed)
	end
end




function HuntLineDeer.getFitGender(fit)
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
