DL = DL or {}
DL.OverkillRescue = DL.OverkillRescue or {}
local R = DL.OverkillRescue
R.pending = R.pending or false

local function isRescueDeath(player)
    if player == nil or player ~= getPlayer() then return false end
    if DL.Config and DL.Config.knockdownEnable == false then return false end
    local K = DL.Knockdown
    if K and K._dyingForReal then return false end
    local md = player:getModData()
    if md and md.dl_downed then return false end
    return true
end

Events.OnCharacterDeath.Add(function(character)
    if not isRescueDeath(character) then return end
    R.pending  = true
    R.coords   = { x = character:getX(), y = character:getY(), z = character:getZ() }
    R.snapshot = (DL.Snap and DL.Snap.build) and DL.Snap.build(character) or nil
    if DL.DeathWounds and DL.DeathWounds.capture then
        pcall(function() DL.DeathWounds.capture(character) end)
        R.wounds = DL.DeathWounds._captured
    end
    R._autoAt  = getTimestampMs() + 1000
    DL.log("overkill rescue: unintended death detected -> auto-revive + knockdown")
end)

function R.triggerRespawn()
    if not R.pending then return end
    local p = getPlayer()
    local pnum = (p and p:getPlayerNum()) or 0
    local panel = ISPostDeathUI and ISPostDeathUI.instance and ISPostDeathUI.instance[pnum]
    if panel and panel.onRespawn then
        panel:onRespawn()
    else
        DL.warn("overkill rescue: no post-death panel to respawn from")
    end
end

function R.startLoot(player)
    if player == nil or R.coords == nil then return false end
    local cell = getCell(); if cell == nil then return false end
    local user = player:getUsername()
    local cx, cy, cz = math.floor(R.coords.x), math.floor(R.coords.y), R.coords.z or 0
    local bag, bsq, wio
    for dx = -2, 2 do
        for dy = -2, 2 do
            local sq = cell:getGridSquare(cx + dx, cy + dy, cz)
            local objs = sq and sq.getWorldObjects and sq:getWorldObjects()
            if objs then
                for i = objs:size() - 1, 0, -1 do
                    local w = objs:get(i)
                    local it = w and w.getItem and w:getItem()
                    local md = it and it.getModData and it:getModData()
                    if md and md.dl_rescueOwner == user then wio, bag, bsq = w, it, sq; break end
                end
            end
            if bag then break end
        end
        if bag then break end
    end
    if bag == nil then return false end
    local bagInv = bag:getInventory()
    if bagInv == nil then return false end
    local playerInv = player:getInventory()
    local batch = {}
    local src = bagInv:getItems()
    for i = 0, src:size() - 1 do
        local it = src:get(i)
        local isCloth = false
        pcall(function() isCloth = (it.IsClothing and it:IsClothing()) or false end)
        pcall(function() createItemTransaction(it, bagInv, playerInv) end)
        batch[#batch + 1] = { item = it, wear = isCloth }
    end
    R._takeBatch = batch
    R._takeSrc = bagInv
    R._bagWio, R._bagSq = wio, bsq
    R._takeMoveAt = getTimestampMs() + 50
    DL.log("overkill rescue: registered " .. #batch .. " transaction(s)")
    return true
end

function R.finishLoot(player)
    local playerInv = player:getInventory()
    local src = R._takeSrc
    local n = 0
    for _, t in ipairs(R._takeBatch or {}) do
        local it = t.item
        pcall(function()
            if isItemTransactionConsistent(it, src, playerInv) then
                removeItemTransaction(it, src, playerInv)
            end
            if isClient() then src:removeItemOnServer(it) end
            src:DoRemoveItem(it)
            playerInv:AddItem(it)
            if t.wear then
                local loc = it.getBodyLocation and it:getBodyLocation()
                if loc and loc ~= "" then player:setWornItem(loc, it) end
            end
            n = n + 1
        end)
    end
    pcall(function() triggerEvent("OnClothingUpdated", player) end)
    ISInventoryPage.renderDirty = true
    pcall(function() if src then src:setDrawDirty(true) end end)
    pcall(function() playerInv:setDrawDirty(true) end)
    pcall(function() player:resetModelNextFrame() end)
    pcall(function()
        if R._bagSq and R._bagWio then
            local bg = R._bagWio.getItem and R._bagWio:getItem()
            local bi = bg and bg:getInventory()
            if (bi == nil) or (bi:getItems():size() == 0) then
                R._bagSq:transmitRemoveItemFromSquare(R._bagWio)
            end
        end
    end)
    R._takeBatch, R._takeSrc, R._bagWio, R._bagSq = nil, nil, nil, nil
    DL.log("overkill rescue: moved " .. n .. " item(s) at once")
end

Events.OnCreatePlayer.Add(function(idx, player)
    if not R.pending then return end
    player = player or getSpecificPlayer(idx)
    if player == nil or player ~= getPlayer() then return end
    R.pending = false
    if DL.DeathWounds then DL.DeathWounds._applyPending = false end
    if R.snapshot and DL.Snap and DL.Snap.apply then
        pcall(function() DL.Snap.apply(player, R.snapshot) end)
    end
    R.snapshot = nil
    if DL.DeathWounds and DL.DeathWounds.applyRaw then
        pcall(function() DL.DeathWounds.applyRaw(player, R.wounds) end)
    end
    R.wounds = nil
    if DL.DeathWounds then DL.DeathWounds._captured = nil end
    pcall(function() player:setInvincible(true) end)
    R._lootAt = getTimestampMs() + 1200
end)

Events.OnTick.Add(function()
    if R._autoAt and getTimestampMs() >= R._autoAt then
        R._autoAt = nil
        R.triggerRespawn()
    end
    if R._lootAt and getTimestampMs() >= R._lootAt then
        R._lootAt = nil
        local p = getPlayer()
        if not (p and R.startLoot(p)) then R._lootAt = getTimestampMs() + 1000 end
    end
    if R._takeMoveAt and getTimestampMs() >= R._takeMoveAt then
        R._takeMoveAt = nil
        local p = getPlayer()
        if p then
            R.finishLoot(p)
            if DL.Knockdown then
                DL.Knockdown._dyingForReal = false
                if DL.Knockdown.enter then DL.Knockdown.enter(p, "rescue") end
            end
            DL.log("overkill rescue: loot done -> entered knockdown")
        end
    end
    if #R._corpseJobs > 0 then
        local now = getTimestampMs()
        local cell = getCell()
        local kept = {}
        for _, job in ipairs(R._corpseJobs) do
            local removed = false
            if cell then
                for dx = -1, 1 do for dy = -1, 1 do
                    local sq = cell:getGridSquare(math.floor(job.x) + dx, math.floor(job.y) + dy, job.z or 0)
                    local sobs = sq and sq:getStaticMovingObjects()
                    if sobs then
                        for i = sobs:size() - 1, 0, -1 do
                            local so = sobs:get(i)
                            if so and instanceof(so, "IsoDeadBody") then
                                local zombie = false
                                pcall(function() if so.isZombie then zombie = so:isZombie() end end)
                                if not zombie then pcall(function() sq:removeCorpse(so, false) end); removed = true end
                            end
                        end
                    end
                end end
            end
            if (not removed) and now < (job.until_ or 0) then kept[#kept + 1] = job end
        end
        R._corpseJobs = kept
    end
end)

R._corpseJobs = R._corpseJobs or {}
Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DLRescue" then return end
    if command == "removecorpse" and args then
        R._corpseJobs[#R._corpseJobs + 1] = { x = args.x, y = args.y, z = args.z or 0, until_ = getTimestampMs() + 4000 }
    end
end)

if ISPostDeathUI ~= nil then
    local _create = ISPostDeathUI.createChildren
    function ISPostDeathUI:createChildren()
        _create(self)
        local b = ISButton:new(0, -52, 250, 40, "KNOCKDOWN", self, ISPostDeathUI.onKnockdownRescue)
        self:configButton(b)
        self:addChild(b)
        self.buttonKnockdown = b
    end

    function ISPostDeathUI:onKnockdownRescue()
        DL.OverkillRescue.triggerRespawn()
    end

    local _prerender = ISPostDeathUI.prerender
    function ISPostDeathUI:prerender()
        _prerender(self)
        if self.buttonKnockdown then
            self.buttonKnockdown:setVisible(DL.OverkillRescue.pending and true or false)
        end
    end
end

DL.log("overkill rescue loaded (auto-revive + knockdown on unintended death; step 1)")
