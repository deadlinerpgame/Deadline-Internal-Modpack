local itemsToRemove = {
    "TheZapper",
    "MndoBrush",
    "MP5HK",
    "GhostTrap",
    "E11Blaster",
    "CyberPistol",
    "FutureRevolver",
    "M41APulseRifle",
    "FutureAssaultRifle",
    "StormTrooperGround",
    "FutureShotgun",
    "BuckRogersGun",
    "Boltgun",
    "DisrespectVest",
    "DisrespectMullet",
    "JeanBeanWand", 
    "BaseballBatTrelai",
    "Trelai.TrelaiGoldBar",
    "Mov.TrelaiGoldBar",
    "Base.Rusty",
    "Base.FluxBackPack",
    "Base.KleanBackPack",
    "Base.SheriffEliVest",
    "Base.SherrifEliBelt",
    "Base.StormTrooperBelt",
    "Fashionmancer-CroppedSweater",
    "Fashionmancer-CroppedTartanSweater",
    "Fashionmancer-Dresses",
    "Fashionmancer-Earrings",
    "Fashionmancer-Glasses",
    "Fashionmancer-Jacket",
    "Fashionmancer-JacketTartan",
    "Fashionmancer-Necklace",
    "Fashionmancer-Pants"
}

local itemsToRemoveP = {
    "Fashionmancer"
}

local function MarkItemsPAsObsolete()
    local allItems = ScriptManager.instance:getAllItems()
    for i = 0, allItems:size() - 1 do
        local item = allItems:get(i)
        local itemName = item:getName()
        for _, pattern in ipairs(itemsToRemoveP) do
            if string.find(itemName, pattern) then
                item:DoParam("OBSOLETE = true")
                print("Marked item " .. itemName .. " as obsolete.")
            end
        end
    end
end


local function MarkItemsAsObsolete()
    for _, itemName in ipairs(itemsToRemove) do
        local item = ScriptManager.instance:getItem(itemName)
        if item then
            item:DoParam("OBSOLETE = true")
        else
            print("Warning: Item " .. itemName .. " not found!")
        end
    end
end

Events.OnPreDistributionMerge.Add(MarkItemsAsObsolete)
Events.OnPreDistributionMerge.Add(MarkItemsPAsObsolete)