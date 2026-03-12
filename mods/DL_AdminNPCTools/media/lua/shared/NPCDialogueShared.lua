




NPCDialogue = NPCDialogue or {}





NPCDialogue.CMD = {
    
    PLACE_ZONE    = "PlaceZone",
    REMOVE_ZONE   = "RemoveZone",
    REQUEST_SYNC  = "RequestSync",
    START_SESSION = "StartSession",
    END_SESSION   = "EndSession",

    
    SYNC_READY      = "SyncReady",
    SYNC_ZONE       = "SyncZone",
    REMOVE_ACK      = "RemoveAck",
    SESSION_GRANTED = "SessionGranted",
    SESSION_DENIED  = "SessionDenied",
}


function NPCDialogue.distanceTo(px, py, zx, zy)
    local dx = px - zx
    local dy = py - zy
    return math.sqrt(dx * dx + dy * dy)
end


NPCDialogue.MODDATA_KEY = "NPCDialogueZones"


NPCDialogue.DEFAULT_RADIUS     = 2
NPCDialogue.DEFAULT_CONCURRENT = true


NPCDialogue.HIGHLIGHT_R           = 0
NPCDialogue.HIGHLIGHT_G           = 1
NPCDialogue.HIGHLIGHT_B           = 0
NPCDialogue.HIGHLIGHT_A           = 0.5
NPCDialogue.HIGHLIGHT_SCAN_RADIUS = 20


function NPCDialogue.newZone(id, name, x, y, z)
    return {
        id             = id,
        name           = name,
        x              = x,
        y              = y,
        z              = z,
        radius         = NPCDialogue.DEFAULT_RADIUS,
        concurrent     = NPCDialogue.DEFAULT_CONCURRENT,
        portrait       = "",
        dialogueTreeId = "",
    }
end


function NPCDialogue.generateId()
    local a = ZombRand(99999)
    local b = ZombRand(99999)
    return "npc_" .. tostring(a) .. "_" .. tostring(b)
end


NPCDialogue.SKILLS = {
    "Axe", "Blunt", "LongBlunt", "SmallBlade", "LongBlade",
    "Spear", "Maintenance", "Aiming", "Reloading",
    "Carpentry", "Cooking", "Farming", "FirstAid",
    "Electricity", "MetalWelding", "Mechanics",
    "Tailoring", "Trapping", "Fishing", "Forage",
    "Lightfoot", "Nimble", "Sprinting", "Strength", "Fitness",
}


NPCDialogue.SKILL_PERK_NAME = {
    Axe         = "Axe",
    Blunt       = "Blunt",
    LongBlunt   = "LongBlunt",
    SmallBlade  = "SmallBlade",
    LongBlade   = "LongBlade",
    Spear       = "Spear",
    Maintenance = "Maintenance",
    Aiming      = "Aiming",
    Reloading   = "Reloading",
    Carpentry   = "Carpentry",
    Cooking     = "Cooking",
    Farming     = "Farming",
    FirstAid    = "FirstAid",
    Electricity = "Electricity",
    MetalWelding = "MetalWelding",
    Mechanics   = "Mechanics",
    Tailoring   = "Tailoring",
    Trapping    = "Trapping",
    Fishing     = "Fishing",
    Forage      = "Forage",
    Lightfoot   = "Lightfoot",
    Nimble      = "Nimble",
    Sprinting   = "Sprinting",
    Strength    = "Strength",
    Fitness     = "Fitness",
}



function NPCDialogue.evalCondition(cond, player)
    if not cond or not cond.type then return true end
    local t = cond.type

    if t == "item" then
        if not cond.itemName or cond.itemName == "" then return true end
        local inv    = player:getInventory()
        local needed = tonumber(cond.amount) or 1
        
        local name   = cond.itemName
        local short  = name:match("^[^%.]+%.(.+)$") or name
        if needed <= 1 then
            return inv:containsTypeRecurse(name) or inv:containsTypeRecurse(short)
        else
            local count = inv:getCountTypeRecurse(name)
            if count < needed then count = inv:getCountTypeRecurse(short) end
            return count >= needed
        end

    elseif t == "skill" then
        if not cond.skill or cond.skill == "" then return true end
        if not cond.level then return false end
        local perk = Perks[cond.skill]
        if not perk then return false end
        local lvl = player:getPerkLevel(perk)
        return lvl >= (tonumber(cond.level) or 1)

    elseif t == "occupation" then
        if not cond.occupation or cond.occupation == "" then return true end
        local descr = player:getDescriptor()
        if not descr then return false end
        local profId = descr:getProfession()
        
        if profId:lower() == cond.occupation:lower() then return true end
        
        local ok, prof = pcall(function() return ProfessionFactory.getProfession(profId) end)
        if ok and prof then
            local displayName = prof:getName()
            if displayName and displayName:lower() == cond.occupation:lower() then return true end
        end
        return false

    elseif t == "talked" then
        local md = player:getModData()
        return md["NPCTalked_" .. (cond.zoneId or "")] == true

    end
    return true
end



function NPCDialogue.evalResponse(resp, player, zoneId)
    
    local condCount = 0
    if resp.conditions then
        for _ in pairs(resp.conditions) do condCount = condCount + 1 end
    end
    if condCount == 0 then return "normal" end

    local mode   = resp.conditionMode or "AND"
    local failOn = resp.conditionFail or "hide"

    local results = {}
    for _, cond in pairs(resp.conditions) do
        local c = {}
        for k,v in pairs(cond) do c[k] = v end
        c.zoneId = zoneId
        results[#results+1] = NPCDialogue.evalCondition(c, player)
    end

    local passed
    if mode == "OR" then
        passed = false
        for _, r in pairs(results) do if r then passed = true; break end end
    else 
        passed = true
        for _, r in pairs(results) do if not r then passed = false; break end end
    end

    if passed then return "normal" end
    return (failOn == "grey") and "greyed" or "hidden"
end


function NPCDialogue.resolvePrompts(text, player)
    if not text or text == "" then return text end

    
    local firstName = player:getUsername() or "Survivor"
    local desc = player:getDescriptor()
    if desc and desc.getForename then
        local fn = desc:getForename()
        if fn and fn ~= "" then firstName = fn end
    end
    text = text:gsub("@PlayerName", firstName)

    
    local occ = "Unemployed"
    if desc then
        local p = desc:getProfession()
        if p and p ~= "" then occ = p end
    end
    text = text:gsub("@Occupation", occ)

    
    local hour = 12
    local gt = getGameTime and getGameTime()
    if gt then
        hour = math.floor(gt:getTimeOfDay() * 24)
    end
    local timeStr
    if     hour >= 5  and hour < 12 then timeStr = "morning"
    elseif hour >= 12 and hour < 17 then timeStr = "afternoon"
    elseif hour >= 17 and hour < 21 then timeStr = "evening"
    else                                  timeStr = "night"
    end
    text = text:gsub("@TimeOfDay", timeStr)

    
    local weatherStr = "clear"
    local climate = getClimaticRegion and getClimaticRegion()
    if climate then
        local rain = climate.getRainIntensity and climate:getRainIntensity() or 0
        local fog  = climate.getFogIntensity  and climate:getFogIntensity()  or 0
        local snow = climate.getSnowIntensity and climate:getSnowIntensity() or 0
        if     snow > 0.1 then weatherStr = "snowing"
        elseif fog  > 0.3 then weatherStr = "foggy"
        elseif rain > 0.1 then weatherStr = "raining"
        end
    end
    text = text:gsub("@Weather", weatherStr)

    return text
end
