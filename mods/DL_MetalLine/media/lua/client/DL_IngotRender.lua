DL = DL or {}
DL.IngotRender = {}

local painted = {}

function DL.applyIngotVisual(item)
    if not item then return end
    local md = item:getModData().DL
    if not md then return end
    if md.name then item:setName(md.name) end
    painted[item:getID()] = true
end

local function paintContainer(cont)
    if not cont then return end
    local items = cont:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:hasTag("DLIngot") then
            if it:getModData().DL and not painted[it:getID()] then
                DL.applyIngotVisual(it)
            end
        elseif instanceof(it, "InventoryContainer") and it:getInventory() then
            paintContainer(it:getInventory())
        end
    end
end

local tick = 0
local function onPlayerUpdate(playerObj)
    if not playerObj or playerObj ~= getPlayer() then return end
    tick = tick + 1
    if tick % 30 ~= 0 then return end
    paintContainer(playerObj:getInventory())
end
Events.OnPlayerUpdate.Add(onPlayerUpdate)
