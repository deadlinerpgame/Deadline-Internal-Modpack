function Recipe.OnCreate.OneIngot(items, result, player)
    -- Identify the anvil (container)
    local anvil = nil
    for i=0, items:size()-1 do
        local item = items:get(i)
        if item:IsInventoryContainer() and item:getFullType() == "aerx.BenchAnvil" then

            anvil = item
            break
        end
    end

    -- Fail if no anvil is found
    if not anvil then
        player:Say("I need to use an anvil to craft this.")
        return
    end

    -- Get items inside the anvil
    local anvilContents = anvil:getItemContainer():getItems()
    local ingot = nil

    -- Find an ingot inside the anvil
    for i=0, anvilContents:size()-1 do
        local item = anvilContents:get(i)
        if item:getModData().AlloyType then
            ingot = item
            break
        end
    end

    -- Fail if no ingot is found
    if not ingot then
        player:Say("I need an ingot in the anvil to craft this.")
        return
    end

    -- Store the alloy type before removing the ingot
    local alloyType = ingot:getModData().AlloyType or "Unknown Metal"
    local cleanAlloyName = alloyType:gsub("%s*Bar$", "") -- Removes " Bar" at the end

    -- Remove the ingot from the anvil
    anvil:getItemContainer():Remove(ingot)
    local tooltip = "Made from " .. cleanAlloyName
    -- Assign the alloy name to the resulting item
    result:getModData().AlloyType = tooltip
    result:setName(cleanAlloyName .. " " .. result:getName()) -- Example: "Bronze Shortsword"

end
