if isClient() and not isServer() then return end
DL = DL or {}
DL.Rescue = DL.Rescue or {}
local R = DL.Rescue
R._realDeath = R._realDeath or {}

local REAL_WINDOW_MS = 60000

function R.markRealDeath(username) if username then R._realDeath[username] = getTimestampMs() end end
function R.clearRealDeath(username) if username then R._realDeath[username] = nil end end
function R.isRealDeath(username)
    local t = username and R._realDeath[username]
    return t ~= nil and (getTimestampMs() - t) < REAL_WINDOW_MS
end

local function findBag(username, x, y, z)
    local cell = getCell(); if cell == nil then return nil end
    for dx = -2, 2 do
        for dy = -2, 2 do
            local sq = cell:getGridSquare(x + dx, y + dy, z)
            local objs = sq and sq.getWorldObjects and sq:getWorldObjects()
            if objs then
                for i = objs:size() - 1, 0, -1 do
                    local wio = objs:get(i)
                    local it = wio and wio.getItem and wio:getItem()
                    local md = it and it.getModData and it:getModData()
                    if md and md.dl_rescueOwner == username then
                        return wio, it, sq
                    end
                end
            end
        end
    end
    return nil
end

function R.restoreFromBag(player, username, x, y, z)
    local wio, bag, sq = findBag(username, x, y, z)
    if wio == nil then
        DL.log("rescue: no tagged bag near " .. x .. "," .. y .. "," .. z .. " for '" .. tostring(username) .. "'")
        return false
    end
    local moved = 0
    pcall(function()
        local bc = bag:getInventory()
        if bc == nil then DL.log("rescue: temp bag has no container"); return end
        local its = bc:getItems()
        DL.log("rescue: temp bag holds " .. its:size() .. " item(s)")
        local list = {}
        for i = 0, its:size() - 1 do list[#list + 1] = its:get(i) end
        local inv = player:getInventory()
        for _, it in ipairs(list) do
            pcall(function() bc:Remove(it) end)
            local worn = false
            pcall(function()
                if it.IsClothing and it:IsClothing() then
                    local loc = it.getBodyLocation and it:getBodyLocation()
                    if loc and loc ~= "" then player:setWornItem(loc, it); worn = true end
                end
            end)
            if not worn then pcall(function() inv:AddItem(it) end) end
            moved = moved + 1
        end
    end)
    pcall(function() sq:transmitRemoveItemFromSquare(wio) end)
    DL.log("rescue: gave " .. moved .. " item(s) to '" .. tostring(username) .. "' and removed the temp bag")
    return true
end

function R.broadcastCorpseRemoval(x, y, z)
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p then sendServerCommand(p, "DLRescue", "removecorpse", { x = x, y = y, z = z }) end
    end
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLRescue" or player == nil then return end
    local u = player:getUsername()
    local x = (args and args.x) or math.floor(player:getX())
    local y = (args and args.y) or math.floor(player:getY())
    local z = (args and args.z) or player:getZ()
    x, y, z = math.floor(x), math.floor(y), math.floor(z or 0)
    if command == "restore" then
        local px, py, pz = math.floor(player:getX()), math.floor(player:getY()), math.floor(player:getZ() or 0)
        DL.log("rescue: RESTORE req '" .. tostring(u) .. "' deathXYZ=" .. x .. "," .. y .. "," .. z .. " playerXYZ=" .. px .. "," .. py .. "," .. pz)
        local ok = R.restoreFromBag(player, u, x, y, z)
        if not ok then R.restoreFromBag(player, u, px, py, pz) end
    end
end)

DL.log("rescue server loaded (tagged temp-bag reclaim)")
