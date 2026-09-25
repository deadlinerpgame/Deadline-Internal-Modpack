require "recipecode"

Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.GetItemTypes = Recipe.GetItemTypes or {}

function Recipe.GetItemTypes.DLIngot(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("DLIngot"))
end

function Recipe.OnCreate.DLForge(items, result, player)
    DL.Forge.transfer(items, result)
end

function Recipe.OnCreate.DLForgeQuiet(items, result, player)
    DL.Forge.transfer(items, result, false)
end

function Recipe.OnCreate.DLForgeWeapon(items, result, player)
    local mat = DL.Forge.transfer(items, result)
    if not result then return end

    if instanceof(result, "HandWeapon") and player then
        DL.Smithing.adjustFromLevel(result, player:getPerkLevel(Perks.MetalWelding), player)
    end
    if mat and (instanceof(result, "HandWeapon") or instanceof(result, "Clothing")) then
        DL.Smithing.adjustFromAlloy(result, mat)
    end
end

function DL.Forge.giveMade(items, player, fullType, count)
    if not player then return end
    local mat = DL.Forge.sourceMaterial(items)
    local inv = player:getInventory()
    for _ = 1, (count or 1) do
        local made = inv:AddItem(fullType)
        if made and mat then
            DL.Forge.stamp(made, mat)
            DL.Forge.applyName(made, mat)
        end
    end
end

local function counted(n)
    return function (items, result, player)
        if not result then return end
        DL.Forge.giveMade(items, player, result:getFullType(), n)
    end
end

Recipe.OnCreate.DLForgeX2  = counted(2)
Recipe.OnCreate.DLForgeX4  = counted(4)
Recipe.OnCreate.DLForgeX10 = counted(10)
Recipe.OnCreate.DLForgeX25 = counted(25)

local function payOut(player, comp, units, tier)
    local inv, rows, total = player:getInventory(), {}, 0
    for metal, frac in pairs(comp) do
        local type = DL.scrapItem(metal, tier)
        if type and type ~= "" and (frac or 0) > 0 then
            rows[#rows + 1] = { type = type, frac = frac }
            total = total + frac
        end
    end
    if #rows == 0 then return false end

    local given, best, bestFrac = 0, rows[1].type, -1
    for i = 1, #rows do
        local share = rows[i].frac / total
        local n = math.floor(units * share)
        for _ = 1, n do inv:AddItem(rows[i].type) end
        given = given + n
        if share > bestFrac then best, bestFrac = rows[i].type, share end
    end
    for _ = 1, (units - given) do inv:AddItem(best) end
    return true
end

function Recipe.OnCreate.DLMeltIngot(items, result, player)
    if not player then return end
    local mat = DL.Forge.sourceMaterial(items)
    if not (mat and mat.composition) then return end
    if not payOut(player, mat.composition, 6, "scrap") then
        player:getInventory():AddItem("aerx.IronScrap")
    end
end

local WEAPON_VALUE = {
    ["aerx.ShortSword_Scrap"] = 10, ["aerx.Sword_Scrap"] = 20,
    ["aerx.CrudeShortSword"]  = 10, ["aerx.CrudeSword"]  = 20,
    ["aerx.ShortSword"]       = 15, ["aerx.Sword"]       = 30,
    ["aerx.Mace"]             = 10, ["aerx.LongMace"]    = 10,
    ["aerx.ClubHammerForged"] = 5,  ["aerx.HammerForged"] = 5,
    ["aerx.BallPeenHammerForged"] = 5, ["base.Pickaxe"]  = 5,
    ["aerx.HandAxeForged"]    = 5,  ["aerx.WarAxeForged"] = 5,
    ["aerx.WoodAxeForged"]    = 5,  ["aerx.CrowbarForged"] = 10,
}

function Recipe.OnCreate.DLReclaimMetal(items, result, player)
    if not player then return end
    local source = items and items:get(0) or nil
    if not source then return end

    local units = WEAPON_VALUE[source:getFullType()]
    if not units then
        if player.Say then player:Say(getText("IGUI_DLM_NothingToReclaim")) end
        return
    end
    units = math.floor(units / 2)

    local mat = DL.Forge.materialOf(source)

    if not (mat and mat.composition and payOut(player, mat.composition, units, "fragments")) then
        local inv = player:getInventory()
        for _ = 1, units do inv:AddItem("aerx.IronFragments") end
    end
end

function Recipe.OnCreate.DLScrap(items, result, player)
    local source = items and items:get(0) or nil
    if not (source and player) then return end
    local yield = DL.ScrapYields[source:getFullType()]
    if not yield then return end

    local inv = player:getInventory()
    for i = 1, #yield do
        local row = yield[i]
        if row.item then
            for _ = 1, (row.n or 1) do inv:AddItem(row.item) end
        elseif row.choice then
            local pick = row.choice[ZombRand(#row.choice) + 1]
            for _ = 1, (row.n or 1) do inv:AddItem(pick) end
        elseif row.from then
            for _ = 1, (row.rolls or 1) do
                local pick = row.from[ZombRand(#row.from) + 1]
                if pick then inv:AddItem(pick) end
            end
        end
    end
end
