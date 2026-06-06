DL = DL or {}
DL.DeathWounds = DL.DeathWounds or {}
local DW = DL.DeathWounds

local function cfg() return DL.Config or {} end
local function partCount() return BodyPartType.ToIndex(BodyPartType.MAX) end

local function try(fn)
    local ok, err = pcall(fn)
    if not ok and DL.warn then DL.warn("deathwounds: " .. tostring(err)) end
end

local function setGeneralHealth(player, target)
    local parts = player:getBodyDamage():getBodyParts()
    local n = partCount()
    local totalMod = 0
    for i = 0, n - 1 do totalMod = totalMod + BodyPartType.getDamageModifyer(i) end
    if totalMod <= 0 then return end
    local targetDamage = 100.0 - target
    if targetDamage < 0 then targetDamage = 0 end
    for i = 0, n - 1 do
        local mod = BodyPartType.getDamageModifyer(i)
        local h = 100.0 - (((mod / totalMod) * targetDamage) / mod)
        if h < 0 then h = 0 end
        if h > 100 then h = 100 end
        parts:get(i):SetHealth(h)
    end
end

local function captureWounds(player)
    local out = {}
    try(function()
        local bd = player:getBodyDamage()
        local parts = bd:getBodyParts()
        for i = 0, partCount() - 1 do
            local bp = parts:get(i)
            local w = {}
            if bp.haveBullet and bp:haveBullet() then w.bullet = true end
            if bp.haveGlass and bp:haveGlass() then w.glass = true end
            if bp.getFractureTime and bp:getFractureTime() > 0 then w.fracture = bp:getFractureTime() end
            if bp.getBiteTime and bp:getBiteTime() > 0 then w.bite = true end
            if bp.isCut and bp:isCut() then w.cut = true end
            if bp.isDeepWounded and bp:isDeepWounded() then w.deep = true end
            if bp.getScratchTime and bp:getScratchTime() > 0 then w.scratch = bp:getScratchTime() end
            if bp.isBurnt and bp:isBurnt() then w.burn = (bp.getBurnTime and bp:getBurnTime()) or 1 end
            if bp.getBleedingTime and bp:getBleedingTime() > 0 then w.bleed = true end
            local any = false
            for _ in pairs(w) do any = true break end
            if any then out[i] = w end
        end
    end)
    return out
end

local function countWounds(captured)
    local c = 0
    for _, w in pairs(captured or {}) do
        for k, _ in pairs(w) do
            if k ~= "bleed" then c = c + 1 end
        end
    end
    return c
end

local function applyTreated(player, captured)
    if captured == nil then return end
    local C = cfg()
    local bd = player:getBodyDamage()
    local parts = bd:getBodyParts()

    if C.reviveCureInfection ~= false then
        try(function() if bd.setInfected then bd:setInfected(false) end end)
        try(function() if bd.setInfectionLevel then bd:setInfectionLevel(0) end end)
        try(function() if bd.setInfectionMortalityDuration then bd:setInfectionMortalityDuration(-1) end end)
    end

    for i, w in pairs(captured) do
        local bp = parts:get(i)

        if w.bullet then try(function() bp:setHaveBullet(false, 5) end) end
        if w.glass  then try(function() bp:setHaveGlass(false) end) end
        if w.bite then
            try(function() bd:SetBitten(i, false) end)
            try(function() bp:setCut(true) end)
        end
        if w.fracture then
            try(function() bp:setFractureTime(w.fracture) end)
            try(function() bp:setSplint(true, 1.0) end)
            try(function() if bp.setSplintFactor then bp:setSplintFactor(1.0) end end)
        end
        if w.deep    then try(function() bp:setDeepWounded(true) end) end
        if w.cut     then try(function() bp:setCut(true) end) end
        if w.scratch then try(function() bp:setScratchTime(w.scratch) end) end
        if w.burn    then try(function() if bp.setNeedBurnWash then bp:setNeedBurnWash(false) end end) end

        if w.bullet or w.glass or w.deep or w.cut or w.bite then
            try(function() if bp.setStitched then bp:setStitched(true) end end)
        end
        try(function() bp:setBandaged(true, 100.0, false, "Base.Bandage") end)
        try(function() if bp.setBleeding then bp:setBleeding(false) end end)
        try(function() if bp.setBleedingTime then bp:setBleedingTime(0) end end)
        try(function() if bp.setWoundInfectionLevel then bp:setWoundInfectionLevel(0) end end)
        try(function() if bp.setInfectedWound then bp:setInfectedWound(false) end end)
    end

    for i = 0, partCount() - 1 do
        try(function() local bp = parts:get(i); if bp.setBleeding then bp:setBleeding(false) end end)
        try(function() local bp = parts:get(i); if bp.setBleedingTime then bp:setBleedingTime(0) end end)
    end

    local count = countWounds(captured)
    local hp = 100 - (C.reviveWoundHpPenalty or 5) * count
    local floor = C.reviveWoundHpFloor or 50
    if hp < floor then hp = floor end
    setGeneralHealth(player, hp)
    if player.setHealth then try(function() player:setHealth(hp) end) end
    DL.log("deathwounds: revived with " .. count .. " treated wound(s) at " .. hp .. "% HP")
end

local function partName(i)
    local nm
    pcall(function()
        local bpt = BodyPartType.FromIndex(i)
        if BodyPartType.getDisplayName then nm = BodyPartType.getDisplayName(bpt) end
        if (nm == nil or nm == "") and BodyPartType.ToString then nm = BodyPartType.ToString(bpt) end
    end)
    if nm == nil or nm == "" then nm = "Body part " .. tostring(i) end
    return tostring(nm)
end

local function summaryLines(captured)
    local lines = {}
    for i, w in pairs(captured or {}) do
        local inj = {}
        if w.bullet  then inj[#inj + 1] = "gunshot (bullet)" end
        if w.glass   then inj[#inj + 1] = "glass shard" end
        if w.fracture then inj[#inj + 1] = "fracture" end
        if w.bite    then inj[#inj + 1] = "bite" end
        if w.deep    then inj[#inj + 1] = "deep wound" end
        if w.cut     then inj[#inj + 1] = "laceration" end
        if w.scratch then inj[#inj + 1] = "scratch" end
        if w.burn    then inj[#inj + 1] = "burn" end
        if w.bleed   then inj[#inj + 1] = "bleeding" end
        lines[#lines + 1] = partName(i) .. ": " .. table.concat(inj, ", ")
    end
    return lines
end

function DL.DeathWounds.capture(player)
    DW._captured = captureWounds(player)
    if isClient() then
        sendClientCommand(player, "DLDeathWounds", "set", { lines = summaryLines(DW._captured) })
    end
end
function DL.DeathWounds.clear()
    DW._captured = nil
    if isClient() then
        local p = getPlayer()
        if p then sendClientCommand(p, "DLDeathWounds", "clear", {}) end
    end
end

function DL.DeathWounds.applyRaw(player, captured)
    captured = captured or DW._captured
    if player == nil or captured == nil then return end
    local bd = player:getBodyDamage()
    local parts = bd:getBodyParts()
    for i, w in pairs(captured) do
        local bp = parts:get(i)
        if w.bullet   then try(function() bp:setHaveBullet(true, 1) end) end
        if w.glass    then try(function() bp:setHaveGlass(true) end) end
        if w.fracture then try(function() bp:setFractureTime(w.fracture) end) end
        if w.bite     then try(function() bd:SetBitten(i, true) end) end
        if w.deep     then try(function() bp:setDeepWounded(true) end) end
        if w.cut      then try(function() bp:setCut(true) end) end
        if w.scratch  then try(function() bp:setScratchTime(w.scratch) end) end
        if w.burn     then try(function() if bp.setBurnTime then bp:setBurnTime(w.burn) end end) end
        if w.bleed then
            try(function() if bp.setBleeding then bp:setBleeding(true) end end)
            try(function() if bp.setBleedingTime then bp:setBleedingTime(20) end end)
        end
    end
    DL.log("deathwounds: re-applied raw (untreated) wounds for rescue")
end

Events.OnPlayerUpdate.Add(function(player)
    if player ~= getPlayer() then return end
    if DW._applyPending then
        DW._applyPending = false
        applyTreated(player, DW._captured)
        DW._captured = nil
    end
end)

Events.OnPlayerDeath.Add(function(player)
    if player ~= getPlayer() then return end
    if DW._captured == nil then DL.DeathWounds.capture(player) end
end)

Events.OnCreatePlayer.Add(function(playerNum, player)
    if player ~= getPlayer() then return end

    if DW._captured and not (DL.Wounds and DL.Wounds.pendingToCell) then
        DW._applyPending = true
    else
        DW._captured = nil
    end
end)

DL.log("death-wounds loaded (capture at death, treated re-apply on revive)")
