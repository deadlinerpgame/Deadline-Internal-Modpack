
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

function Recipe.OnCreate.MeltIngot(items, result, player)
    local item = items:get(0)
    local modData = item:getModData()
    local alloyType = modData.AlloyType
    if not alloyType then return end

    local words = {}
    for word in alloyType:gmatch("%S+") do
        table.insert(words, word)
    end
    local metal = words[2]
    if not metal then return end

    local validMetals = {
        Copper = true,
        Tin = true,
        Aluminum = true,
        Iron = true,
        Lead = true,
        Silver = true,
        Gold = true,
        Zinc = true,
        Nickel = true
    }
    if validMetals[metal] then
        local itemType = "aerx." .. metal .. "Scrap"
        for i = 1, 6 do
            player:getInventory():AddItem(itemType)
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

function Recipe.OnCreate.TransferBladeToSword(items, result, player)
    local barItems = { ["aerx.SwordBlade"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.Sword")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBladeToShortsword(items, result, player)
    local barItems = { ["aerx.ShortSwordBlade"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.ShortSword")
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

function Recipe.OnCreate.TransferBarToCrowbar(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.CrowbarForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarToSledgehammerHead5(items, result, player)
    local barItems = { ["aerx.SledgehammerHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.SledgehammerForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end


function Recipe.OnCreate.TransferBarToSledgehammerHead4(items, result, player)
    local barItems = { ["aerx.BallPeenHammerHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.BallPeenHammerForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToSledgehammerHead3(items, result, player)
    local barItems = { ["aerx.ClawhammerHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.HammerForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToSledgehammerHead2(items, result, player)
    local barItems = { ["aerx.ClubHammerHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.ClubHammerForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToSledgehammerHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.SledgehammerHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToBallPeenHammerHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.BallPeenHammerHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToClawHammerHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.ClawhammerHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToClubHammerHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.ClubHammerHead")
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

function Recipe.OnCreate.TransferBarToHatchetHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.HandAxeHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToWoodAxeHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.WoodAxeHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToPickaxeHead(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.PickAxeHead")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferWAHeadtoWA(items, result, player)
    local barItems = { ["aerx.WoodAxeHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.WoodAxeForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferHHeadtoHatchet(items, result, player)
    local barItems = { ["aerx.HandAxeHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.HandAxeForged")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferPHeadtoPickaxe(items, result, player)
    local barItems = { ["aerx.PickAxeHead"] = true, }

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
                local bar = player:getInventory():AddItem("base.PickAxe")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferWAHeadtoWA2(items, result, player)
    local barItems = { ["aerx.WoodAxeHead"] = true, }

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
                local bar = player:getInventory():AddItem("aerx.WarAxeForged")
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

function Recipe.OnCreate.TransferBarToFShortSword(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.ShortSwordBlade")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToFSword(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.SwordBlade")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToScrapShortsword(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.ShortSword_Scrap")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToHandguardDagger(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.HandguardDagger")
                bar:getModData().AlloyType = "Made from " .. cleanAlloyName
                bar:setName(cleanAlloyName .. " " .. bar:getName())
            end
        else
            print("Not recognized ingot: " .. itemType)
        end
    end
end

function Recipe.OnCreate.TransferBarToScrapSword(items, result, player)
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
                local bar = player:getInventory():AddItem("aerx.Sword_Scrap")
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
    local type = item:getFullType()
    local modData = item:getModData()
    local alloyType = modData.AlloyType
    if not alloyType then return end

    metalValues = {
        ["aerx.CrudeShortSword"] = 10,
        ["aerx.CrudeSword"] = 20,
        ["aerx.Mace"] = 10,
        ["aerx.LongMace"] = 10,
    }

    local itemID = type
    local metalValue = metalValues[itemID]
    if not metalValue then
        player:Say("Unknown weapon type for melting.")
        return
    end

    local cleanAlloy = alloyType:gsub("Made from", ""):gsub("Bar", ""):gsub("^%s*(.-)%s*$", "%1")

    local metalMap = {
        ["Pure Copper"] = { Copper = 1 },
        ["Pure Tin"] = { Tin = 1 },
        ["Pure Aluminum"] = { Aluminum = 1 },
        ["Pure Iron"] = { Iron = 1 },
        ["Pure Lead"] = { Lead = 1 },
        ["Pure Silver"] = { Silver = 1 },
        ["Pure Gold"] = { Gold = 1 },
        ["Pure Zinc"] = { Zinc = 1 },
        ["Pure Nickel"] = { Nickel = 1 },
        ["Abyssinian Gold"] = { Copper = 1 },
        ["Constantan Gold"] = { Copper = 0.5, Nickel = 0.5 },
        ["Duralumin"] = { Aluminum = 1 },
        ["Electrum"] = { Silver = 0.5, Gold = 0.5 },
        ["Nordic Gold"] = { Copper = 1 },
        ["Prince's Metal"] = { Copper = 0.8, Zinc = 0.2 },
        ["Molybdochalkos"] = { Lead = 1 },
        ["Panchaloha"] = { Copper = 0.2, Zinc = 0.2, Iron = 0.2, Silver = 0.2, Gold = 0.2 },
        ["Sterling Silver"] = { Silver = 1 },
        ["White Bronze"] = { Copper = 0.7, Tin = 0.3 },
        ["Pinchbeck"] = { Copper = 1 },
        ["Bronze"] = { Copper = 0.7, Tin = 0.3 },
        ["Brass"] = { Copper = 0.7, Zinc = 0.3 },
        ["Shakudo"] = { Copper = 1 },
        ["Invar"] = { Iron = 0.7, Nickel = 0.3 },
        ["Orichalcum"] = { Copper = 0.7, Zinc = 0.3 },
        ["Pewter"] = { Copper = 0.7, Tin = 0.3 },
    }

    local metalComposition = metalMap[cleanAlloy]
    if not metalComposition then
        return
    end

    local totalScrap = math.floor(metalValue / 2)
    local given = 0

    for metal, ratio in pairs(metalComposition) do
        local count = math.floor(totalScrap * ratio)
        for i = 1, count do
            player:getInventory():AddItem("aerx." .. metal .. "Fragments")
            given = given + 1
        end
    end

    if given < totalScrap then
        local maxMetal, maxRatio = nil, 0
        for metal, ratio in pairs(metalComposition) do
            if ratio > maxRatio then
                maxMetal = metal
                maxRatio = ratio
            end
        end
        for i = 1, (totalScrap - given) do
            player:getInventory():AddItem("aerx." .. maxMetal .. "Fragments")
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
