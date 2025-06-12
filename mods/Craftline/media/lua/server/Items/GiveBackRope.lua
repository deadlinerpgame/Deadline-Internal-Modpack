function Recipe.OnCreate.GiveRope(items, result, player)
    player:getInventory():AddItem("SheetRope");
    player:getInventory():AddItem("SheetRope");
end

function Recipe.OnCreate.GiveEmptyMethaneTank(items, result, player)
    player:getInventory():AddItem("EmptyMethaneTank");
end

function Recipe.OnCreate.GiveEmptyPot(items, result, player)
    player:getInventory():AddItem("Pot");
end

function Recipe.OnCreate.CreatePlankStack(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType ~= "Base.Plank" then
                table.insert(ropeItems, itemType);
            end;
        end;
    end;
    result:getModData().ropeItems = ropeItems;
end

function Recipe.OnCreate.CreateBranchStack(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType ~= "Base.TreeBranch" then
                table.insert(ropeItems, itemType);
            end;
        end;
    end;
    result:getModData().ropeItems = ropeItems;
end

function Recipe.OnCreate.CreateTwigStack(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType ~= "Base.Twigs" then
                table.insert(ropeItems, itemType);
            end;
        end;
    end;
    result:getModData().ropeItems = ropeItems;
end


function Recipe.OnCreate.ReturnOliveJar(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType == "Base.OilOlive" then
                player:getInventory():AddItem("Base.EmptyJar");
                player:getInventory():AddItem("Base.JarLid");
            end;
        end;
    end;
end

function Recipe.OnCreate.TransferIngotToBars(items, result, player)
    local ingotItems = {
        ["Smithing.IngotA"] = true, ["Smithing.IngotB"] = true, ["Smithing.IngotC"] = true, ["Smithing.IngotD"] = true,
        ["Smithing.IngotE"] = true, ["Smithing.IngotF"] = true, ["Smithing.IngotG"] = true, ["Smithing.IngotH"] = true,
        ["Smithing.IngotI"] = true, ["Smithing.IngotJ"] = true, ["Smithing.IngotK"] = true, ["Smithing.IngotL"] = true,
        ["Smithing.IngotM"] = true, ["Smithing.IngotN"] = true, ["Smithing.IngotO"] = true, ["Smithing.IngotP"] = true,
        ["Smithing.IngotQ"] = true, ["Smithing.IngotR"] = true, ["Smithing.IngotS"] = true, ["Smithing.IngotT"] = true,
        ["Smithing.IngotU"] = true, ["Smithing.IngotV"] = true, ["Smithing.IngotW"] = true, ["Smithing.IngotX"] = true,
        ["Smithing.IngotY"] = true, ["Smithing.IngotZ"] = true,
    }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if ingotItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 4 do
                local bar = player:getInventory():AddItem("aerx.IronBar")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferIngotToAnvil(items, result, player)
    local ingotItems = {
        ["Smithing.IngotA"] = true, ["Smithing.IngotB"] = true, ["Smithing.IngotC"] = true, ["Smithing.IngotD"] = true,
        ["Smithing.IngotE"] = true, ["Smithing.IngotF"] = true, ["Smithing.IngotG"] = true, ["Smithing.IngotH"] = true,
        ["Smithing.IngotI"] = true, ["Smithing.IngotJ"] = true, ["Smithing.IngotK"] = true, ["Smithing.IngotL"] = true,
        ["Smithing.IngotM"] = true, ["Smithing.IngotN"] = true, ["Smithing.IngotO"] = true, ["Smithing.IngotP"] = true,
        ["Smithing.IngotQ"] = true, ["Smithing.IngotR"] = true, ["Smithing.IngotS"] = true, ["Smithing.IngotT"] = true,
        ["Smithing.IngotU"] = true, ["Smithing.IngotV"] = true, ["Smithing.IngotW"] = true, ["Smithing.IngotX"] = true,
        ["Smithing.IngotY"] = true, ["Smithing.IngotZ"] = true,
    }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if ingotItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.BenchAnvil")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferCShortBladeToCShortSword(items, result, player)
    local barItems = { ["aerx.CrudeShortSwordBlade"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.CrudeShortSword")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferMaceheadToMace(items, result, player)
    local barItems = { ["aerx.MaceHead"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.Mace")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferMaceheadToLongMace(items, result, player)
    local barItems = { ["aerx.MaceHead"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.LongMace")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end



function Recipe.OnCreate.TransferCBladeToCSword(items, result, player)
    local barItems = { ["aerx.CrudeSwordBlade"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.CrudeSword")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end



function Recipe.OnCreate.TransferBarsToCoins(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 25 do
                local bar = player:getInventory():AddItem("DLM.CrCoin")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarToMaceHead(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.MaceHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarToSimpleShortSword(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.CrudeShortSwordBlade")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarToSimpleSword(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("aerx.CrudeSwordBlade")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarsToPipes(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("base.MetalPipe")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarsToVBar(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("base.MetalBar")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarsToSheetMetal(items, result, player)
    local barItems = { ["aerx.IronBar"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("base.SheetMetal")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferSheetToSmall(items, result, player)
    local barItems = { ["Base.SheetMetal"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 4 do
                local bar = player:getInventory():AddItem("Base.SmallSheetMetal")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferSmallToSheet(items, result, player)
    local barItems = { ["Base.SmallSheetMetal"] = true, }

    -- Get the first item used in the recipe
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()

        if barItems[itemType] then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or " "
            local cleanAlloyName = alloyType:gsub("^Made from%s*", ""):gsub("%s*Ingot$", "")
            print("First recipe item type: " .. itemType)
            print("Alloy type: " .. cleanAlloyName)

            -- Add metadata to result
            for i = 1, 1 do
                local bar = player:getInventory():AddItem("Base.SheetMetal")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.ReturnMetalFromWeapon(items, result, player)
    local item = items:get(0)
    if item then
        local itemType = item:getFullType()
        local fragmentCount = 0

        if itemType == "aerx.CrudeShortSwordBlade" then
            fragmentCount = 12
        elseif itemType == "aerx.CrudeSwordBlade" then
            fragmentCount = 24
        end

        if fragmentCount > 0 then
            local modData = item:getModData()
            local alloyType = modData.AlloyType or "Unknown"

            local metal = alloyType:lower()
            metal = metal:gsub("^made from", "")
            metal = metal:gsub("%f[%a]pure%f[%A]", "") 
            metal = metal:gsub("^%s*(.-)%s*$", "%1")

            local metalToItem = {
                tin = "aerx.TinFragments",
                copper = "aerx.CopperFragments",
                nickel = "aerx.NickelFragments",
                lead = "aerx.LeadFragments",
                iron = "aerx.IronFragments",
                gold = "aerx.GoldFragments",
                silver = "aerx.SilverFragments",
                zinc = "aerx.ZincFragments",
                aluminum = "aerx.AluminumFragments"
            }


            local fragmentItem = metalToItem[metal] or "aerx.IronFragments"

            for i = 1, fragmentCount do
                player:getInventory():AddItem(fragmentItem)
            end
        end
    end
end


function Recipe.OnCreate.GetFragsFromUnusableMetal(items, result, player)
    for i = 1, 10 do
        local roll = ZombRand(8)
        local itemType = nil

        if roll == 0 then
            itemType = "aerx.AluminumFragments"
        elseif roll == 1 then
            itemType = "aerx.TinFragments"
        elseif roll == 2 then
            itemType = "aerx.CopperFragments"
        elseif roll == 3 then
            itemType = "aerx.NickelFragments"
        elseif roll == 4 then
            itemType = "aerx.LeadFragments"
        elseif roll == 5 then
            itemType = "aerx.IronFragments"
        elseif roll == 6 then
            itemType = "aerx.ZincFragments"
        end

        if itemType then
            player:getInventory():AddItem(itemType)
        end
    end
end


function Recipe.OnCreate.ReturnSmallCrucible(items, result, player)
    player:getInventory():AddItem("aerx.CeramicCrucibleSmall");
end

function Recipe.OnCreate.GiveOneAluFrag(items, result, player)
    player:getInventory():AddItem("aerx.AluminumFragments");
end

function Recipe.OnCreate.GiveFourAluFrag(items, result, player)
    player:getInventory():AddItem("aerx.AluminumFragments");
    player:getInventory():AddItem("aerx.AluminumFragments");
    player:getInventory():AddItem("aerx.AluminumFragments");
    player:getInventory():AddItem("aerx.AluminumFragments");
end


function Recipe.OnCreate.GiveFourCopFrag(items, result, player)
    player:getInventory():AddItem("aerx.CopperFragments");
    player:getInventory():AddItem("aerx.CopperFragments");
    player:getInventory():AddItem("aerx.CopperFragments");
    player:getInventory():AddItem("aerx.CopperFragments");
end

function Recipe.OnCreate.GiveFourTinFrag(items, result, player)
    player:getInventory():AddItem("aerx.TinFragments");
    player:getInventory():AddItem("aerx.TinFragments");
    player:getInventory():AddItem("aerx.TinFragments");
    player:getInventory():AddItem("aerx.TinFragments");
end

function Recipe.OnCreate.GiveFiveIroFragTwoZTwoN(items, result, player)
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    local random = ZombRand(2)
    if random == 1 then
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
    end
    if random == 0 then
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
    end
end

function Recipe.OnCreate.GiveSixteenIronEightZEightN(items, result, player)
    player:getInventory():AddItem("aerx.IronScrap");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    player:getInventory():AddItem("aerx.IronFragments");
    local random = ZombRand(2)
    if random == 1 then
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
        player:getInventory():AddItem("aerx.ZincFragments");
    end
    if random == 0 then
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
        player:getInventory():AddItem("aerx.NickelFragments");
    end
end
