require "ISUI/ISToolTip"

DL = DL or {}

local function worldCrucibles(worldobjects)
    local seen, found = {}, {}
    for _, o in ipairs(worldobjects) do
        local sq = o and o.getSquare and o:getSquare()
        if sq and not seen[sq] then
            seen[sq] = true
            local wos = sq:getWorldObjects()
            for i = 0, wos:size() - 1 do
                local w = wos:get(i)
                if DL.Crucible.isCrucibleItem(w and w:getItem()) then found[#found + 1] = w end
            end
        end
    end
    return found
end

local function onFillWorld(playerIdx, context, worldobjects, test)
    if test then return end
    local player = getSpecificPlayer(playerIdx)
    if not player then return end
    local found = worldCrucibles(worldobjects)
    for _, w in ipairs(found) do
        local label = (#found > 1) and ("Open " .. w:getItem():getDisplayName()) or "Open Crucible"
        context:addOption(label, player, DL.openCrucible, w)
    end
end
Events.OnFillWorldObjectContextMenu.Add(onFillWorld)

local function onFillInventory(playerIdx, context, items)
    local player = getSpecificPlayer(playerIdx)
    if not player then return end
    for _, v in ipairs(items) do
        local item = v
        if not instanceof(v, "InventoryItem") then item = v.items and v.items[1] end
        if DL.Crucible.isCrucibleItem(item) then
            local wobj = item:getWorldItem()
            if wobj then
                context:addOption("Open Crucible", player, DL.openCrucible, wobj)
            else
                local opt = context:addOption("Use Crucible", nil, nil)
                opt.notAvailable = true
                local tip = ISToolTip:new()
                tip:initialise()
                tip:setVisible(false)
                tip.description = "Put the crucible on the floor to use it."
                opt.toolTip = tip
            end
            return
        end
    end
end
Events.OnFillInventoryObjectContextMenu.Add(onFillInventory)
