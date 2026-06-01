DL = DL or {}

local function actorName(ch)
    if ch == nil or ch.getUsername == nil then return nil end
    return ch:getUsername()
end

local function isStaff(ch)
    if ch == nil or ch.getAccessLevel == nil then return false end
    local lvl = ch:getAccessLevel()
    return lvl ~= nil and lvl ~= "" and lvl ~= "None"
end

local function lockedAgainst(item, character)
    if item == nil or item.getModData == nil then return false end
    local md = item:getModData()
    if md == nil or not md.dl_deathBag then return false end
    local lockUntil = md.dl_lockUntil
    if lockUntil == nil or getTimestampMs() >= lockUntil then return false end
    if DL.Config and DL.Config.lootLockTestLockEveryone then return true end
    if isStaff(character) then return false end
    local owner, me = md.dl_owner, actorName(character)
    if owner ~= nil and me ~= nil and owner == me then return false end
    return true
end

local function owningItem(container)
    if container == nil or container.getContainingItem == nil then return nil end
    return container:getContainingItem()
end

local _lastNote = 0
local function deny(character)
    local now = getTimestampMs()
    if character ~= nil and character.setHaloNote ~= nil and (now - _lastNote) > 1500 then
        _lastNote = now
        character:setHaloNote("These aren't your belongings", 255, 70, 70, 250.0)
    end
    return false
end

local function transferBlocked(character, item, src, dest)
    if lockedAgainst(item, character) then return true end
    local sb = owningItem(src)
    if sb ~= nil and lockedAgainst(sb, character) then return true end
    local db = owningItem(dest)
    if db ~= nil and lockedAgainst(db, character) then return true end
    return false
end

if ISInventoryTransferAction ~= nil then
    local _valid = ISInventoryTransferAction.isValid
    function ISInventoryTransferAction:isValid()
        if transferBlocked(self.character, self.item, self.srcContainer, self.destContainer) then
            return deny(self.character)
        end
        return _valid(self)
    end
else
    DL.warn("lootlock: ISInventoryTransferAction not found; transfer veto not installed")
end

if ISGrabItemAction ~= nil then
    local _gvalid = ISGrabItemAction.isValid
    function ISGrabItemAction:isValid()
        if lockedAgainst(self.item, self.character) then
            return deny(self.character)
        end
        return _gvalid(self)
    end
else
    DL.warn("lootlock: ISGrabItemAction not found; grab veto not installed")
end

local function resolveItem(entry)
    if entry == nil then return nil end
    if instanceof(entry, "InventoryItem") then return entry end
    if entry.items ~= nil and entry.items[1] ~= nil then return entry.items[1] end
    return nil
end

local function selectionTouchesLocked(character, items)
    if items == nil then return false end
    for i = 1, #items do
        local it = resolveItem(items[i])
        if it ~= nil then
            if lockedAgainst(it, character) then return true end
            local cont = it.getContainer and it:getContainer() or nil
            local bag  = owningItem(cont)
            if bag ~= nil and lockedAgainst(bag, character) then return true end
        end
    end
    return false
end

Events.OnFillInventoryObjectContextMenu.Add(function(playerIdx, context, items)
    local character = getSpecificPlayer(playerIdx)
    if character == nil then return end
    if not selectionTouchesLocked(character, items) then return end
    if context.options ~= nil then
        for _, opt in ipairs(context.options) do
            opt.notAvailable = true
            opt.onSelect     = nil
        end
    end
    local notice = context:addOption("Locked - not your belongings", nil, nil)
    notice.notAvailable = true
    deny(character)
end)

DL.log("lootlock client loaded (transfer + grab + menu veto)")
