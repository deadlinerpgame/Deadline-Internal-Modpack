DL = DL or {}
DL.ScrapRender = {}

local painted = {}

local function colorOf(it)
    local reg = DL.MetalContent[it:getFullType()]
    if not reg then return nil end
    local m = reg.metal or next(reg.composition)
    local md = DL.Metals[m]
    return md and md.color or nil
end

function DL.applyScrapVisual(it)
    local c = colorOf(it); if not c then return end
    it:setColor(Color.new(c[1]/255, c[2]/255, c[3]/255, 1.0))
    it:setCustomColor(true)
    painted[it:getID()] = true
end

local function paint(cont)
    if not cont then return end
    local items = cont:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:hasTag('DLScrap') then
            if not painted[it:getID()] then DL.applyScrapVisual(it) end
        elseif instanceof(it, 'InventoryContainer') and it:getInventory() then
            paint(it:getInventory())
        end
    end
end

local tick = 0
local function onPlayerUpdate(p)
    if not p or p ~= getPlayer() then return end
    tick = tick + 1
    if tick % 30 ~= 0 then return end
    paint(p:getInventory())
end
Events.OnPlayerUpdate.Add(onPlayerUpdate)

