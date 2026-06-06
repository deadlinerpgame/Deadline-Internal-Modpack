if isClient() and not isServer() then return end
DL = DL or {}
DL.Config = DL.Config or {}
DL.Config.deathBagType = DL.Config.deathBagType or "Base.Bag_ALICEpack"

local function writeDeathLog(username, lines, moved, woundLog)
    local _ = (function()
        local dir = DL.Paths.accountDir(username) .. "/DeathItemLogs"
        local counterPath = dir .. "/next.txt"
        local n = tonumber(DL.Files.readString(counterPath)) or 1
        local out = {
            "Death drop -- user '" .. username .. "', entry #" .. tostring(n),
            "ts=" .. tostring(getTimestamp()),
            "items moved=" .. tostring(moved),
            "",
        }
        for _, l in ipairs(lines) do out[#out + 1] = l end
        out[#out + 1] = ""
        out[#out + 1] = "Wounds at death:"
        if woundLog and #woundLog > 0 then
            for _, wl in ipairs(woundLog) do out[#out + 1] = "  " .. tostring(wl) end
        else
            out[#out + 1] = "  (none recorded)"
        end
        if DL.Files.writeLines(dir .. "/death_" .. tostring(n) .. ".txt", out) then
            DL.Files.writeString(counterPath, tostring(n + 1))
            DL.log("death item log -> DeathItemLogs/death_" .. n .. ".txt")
            if DL.Players then DL.Players.touch(username) end
        end
    end)()
end

local function dumpOnDeath(character)
    local username = (function() return character:getUsername() end)() or "?"

    if not DL.Death.firstFire("dump", character) then
        DL.log("death dump: duplicate OnCharacterDeath for '" .. username .. "' ignored")
        return
    end

    local sq = (function() return character:getCurrentSquare() end)()
    if sq == nil then sq = (function() return character:getSquare() end)() end
    if sq == nil then DL.warn("death dump: no square; items not moved"); return end

    local isReal = (DL.Rescue and DL.Rescue.isRealDeath(username)) or false
    local rescue = (not (DL.Config and DL.Config.knockdownEnable == false)) and not isReal
    if DL.Rescue and isReal then DL.Rescue.clearRealDeath(username) end

    local bagType = DL.Config.deathBagType
    local bag = (function() return instanceItem(bagType) end)()
    if bag == nil then DL.warn("death dump: instanceItem('" .. bagType .. "') returned nil"); return end
    local bagCont = (function() return bag:getInventory() end)()
    if bagCont == nil then DL.warn("death dump: bag has no container"); return end

    local seen, moved = {}, 0
    local function bagAdd(it)
        if pcall(function() bagCont:addItem(it) end) then return true end
        if pcall(function() bagCont:AddItem(it) end) then return true end
        return false
    end
    local function moveInto(it)
        if it == nil or seen[it] then return end
        seen[it] = true
        local _ = (function()
            local cont = it.getContainer and it:getContainer()
            if cont then cont:Remove(it) end
            if bagAdd(it) then moved = moved + 1 end
        end)()
    end

    local _ = (function()
        local w = character:getWornItems()
        if w == nil then return end
        local wlist = {}
        for i = 0, w:size() - 1 do
            local e = w:get(i)
            local it = e and e:getItem()
            if it then wlist[#wlist + 1] = it end
        end
        for _, it in ipairs(wlist) do
            local _ = (function() character:removeWornItem(it) end)()
            moveInto(it)
        end
    end)()

    local _ = (function()
        local ph = character:getPrimaryHandItem()
        local sh = character:getSecondaryHandItem()
        character:setPrimaryHandItem(nil)
        character:setSecondaryHandItem(nil)
        moveInto(ph)
        moveInto(sh)
    end)()

    local _ = (function()
        local inv = character:getInventory()
        if inv == nil then return end
        local src = inv:getItems()
        local tmp = {}
        for i = 0, src:size() - 1 do tmp[#tmp + 1] = src:get(i) end
        for _, it in ipairs(tmp) do moveInto(it) end
    end)()

    if moved == 0 then
        local ok, err = pcall(function()
            local bodies = sq.getDeadBodys and sq:getDeadBodys()
            if bodies == nil then return end
            for bi = bodies:size() - 1, 0, -1 do
                local body = bodies:get(bi)
                local bc = body and body.getItemContainer and body:getItemContainer()
                if bc ~= nil then
                    local its = bc:getItems()
                    local tmp = {}
                    for i = 0, its:size() - 1 do tmp[#tmp + 1] = its:get(i) end
                    for _, it in ipairs(tmp) do
                        bc:Remove(it)
                        if bagAdd(it) then moved = moved + 1 end
                    end
                end
                if moved > 0 then break end
            end
        end)
        if not ok then DL.warn("death dump: corpse-fallback error: " .. tostring(err)) end
        DL.log("death dump: live inventory empty; corpse-fallback recovered " .. tostring(moved) .. " item(s)")
    end

    if rescue then
        local md = bag:getModData()
        md.dl_rescueOwner = username
        md.dl_rescueTs = getTimestamp()
        local _ = (function() sq:AddWorldInventoryItem(bag, 0, 0, 0) end)()
        DL.log("death: rescue '" .. username .. "' -> " .. moved .. " item(s) into tagged temp bag at "
            .. sq:getX() .. "," .. sq:getY() .. "," .. sq:getZ())
        if DL.Rescue and DL.Rescue.broadcastCorpseRemoval then DL.Rescue.broadcastCorpseRemoval(sq:getX(), sq:getY(), sq:getZ()) end
        return
    end

    local lines = DL.ItemTree.containerLines(bagCont)
    DL.log("==== DEATH DROP for '" .. username .. "'  (" .. moved .. " items into " .. bagType .. ") ====")
    for _, l in ipairs(lines) do DL.log("  " .. l) end
    DL.log("==== END DEATH DROP ====")
    writeDeathLog(username, lines, moved, character:getModData().dl_deathWoundLog)

    if DL.LootLock and DL.LootLock.onDrop then DL.LootLock.onDrop(bag, username, sq) end
    local _ = (function() sq:AddWorldInventoryItem(bag, 0, 0, 0) end)()
    DL.log("death dump placed bag at " .. tostring(sq:getX()) .. "," .. tostring(sq:getY()) .. "," .. tostring(sq:getZ()))
    if DL.Rescue and DL.Rescue.broadcastCorpseRemoval then DL.Rescue.broadcastCorpseRemoval(sq:getX(), sq:getY(), sq:getZ()) end
end

Events.OnCharacterDeath.Add(function(character)
    if character and instanceof(character, "IsoPlayer") then
        local _ = (function() dumpOnDeath(character) end)()
    end
end)

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLDeathWounds" or player == nil then return end
    if command == "set" then
        player:getModData().dl_deathWoundLog = (args and args.lines) or nil
    elseif command == "clear" then
        player:getModData().dl_deathWoundLog = nil
    end
end)

DL.log("death server wiring loaded (item dump + tree log + wounds)")
