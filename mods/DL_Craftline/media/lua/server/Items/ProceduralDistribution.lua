require "Items/Distributions.lua"
require "Items/ProceduralDistributions.lua"
require "Items/SuburbsDistributions.lua"
require "Vehicles/VehicleDistributions.lua"

local itemsToRemove = {
    ["TheZapper"] = true,
    ["MndoBrush"] = true,
    ["MP5HK"] = true,
    ["GhostTrap"] = true,
    ["E11Blaster"] = true,
    ["CyberPistol"] = true,
    ["FutureRevolver"] = true,
    ["M41APulseRifle"] = true,
    ["FutureAssaultRifle"] = true,
    ["StormTrooperGround"] = true,
    ["FutureShotgun"] = true,
    ["BuckRogersGun"] = true,
    ["Boltgun"] = true,
    ["DisrespectVest"] = true,
    ["DisrespectMullet"] = true,
    ["JeanBeanWand"] = true, 
    ["BaseballBatTrelai"] = true,
    ["Mov.TrelaiGoldBar"] = true,
    ["Trelai.TrelaiGoldBar"] = true,
    ["Base.Rusty"] = true,
    ["Base.FluxBackPack"] = true,
    ["Base.KleanBackPack"] = true,
    ["Base.SheriffEliVest"] = true,
    ["Base.SherrifEliBelt"] = true,
    ["Base.StormTrooperBelt"] = true,
    ["Fashionmancer-CroppedSweater"] = true,
    ["Fashionmancer-CroppedTartanSweater"] = true,
    ["Fashionmancer-Dresses"] = true,
    ["Fashionmancer-Earrings"] = true,
    ["Fashionmancer-Glasses"] = true,
    ["Fashionmancer-Jacket"] = true,
    ["Fashionmancer-JacketTartan"] = true,
    ["Fashionmancer-Necklace"] = true,
    ["Fashionmancer-Pants"] = true,
}

local itemsToRemoveP = {
    ["Fashionmancer"] = true,
}

local function RemoveLootP(zoneKey, zone)
    for i = #zone.items, 1, -1 do
        local y = zone.items[i]
        for itemName in pairs(itemsToRemoveP) do
            if string.find(y, itemName) then
                table.remove(zone.items, i)
                break
            end
        end
    end
end



local function loopOnTableP(table)
    for zoneKey, zone in pairs(table) do
        if type(zone) == "table" then
            if zone and zone.items then
                RemoveLoot(zoneKey, zone)
                if zone.junk and zone.junk.items and zone.junk.items[1] then
                    RemoveLoot(zoneKey, zone.junk)
                end
            else
                if zone and not zone.procedural then
                    loopOnTable(zone)
                end
            end
        end
    end
end

local function RemoveLoot(zoneKey, zone)
    for i = #zone.items, 1, -1 do
        local y = zone.items[i]
        if itemsToRemove[y] then
            table.remove(zone.items, i)
        end
    end
end

local function loopOnTable(table)
    for zoneKey, zone in pairs(table) do
        if type(zone) == "table" then
            if zone and zone.items then
                RemoveLoot(zoneKey, zone)
                if zone.junk and zone.junk.items and zone.junk.items[1] then
                    RemoveLoot(zoneKey, zone.junk)
                end
            else
                if zone and not zone.procedural then
                    loopOnTable(zone)  -- Recursive call until we find zone.items or zone.procedural
                end
            end
        end
    end
end

local function modifyAllLootTables()
    ProceduralDistributions = ProceduralDistributions or {}
    VehicleDistributions = VehicleDistributions or {}
    SuburbsDistributions = SuburbsDistributions or {}
    Distributions = Distributions or {}
    loopOnTable(SuburbsDistributions)
    loopOnTable(Distributions)
    loopOnTable(ProceduralDistributions.list)
    loopOnTable(VehicleDistributions)
end

Events.OnPreDistributionMerge.Add(modifyAllLootTables)
