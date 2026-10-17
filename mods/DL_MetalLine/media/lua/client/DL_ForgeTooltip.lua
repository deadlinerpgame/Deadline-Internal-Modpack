require "ISUI/ISToolTipInv"

local previousRender = ISToolTipInv.render

function ISToolTipInv:render()
    local item = self.item
    if not item then return previousRender(self) end

    local md = item.getModData and item:getModData() or nil

    local isIngot = type(md and md.DL) == "table" and md.DL.alloyId ~= nil
    if not md or not (md.DLMade or isIngot) then return previousRender(self) end

    local lines = DL.Forge.describe(item)
    if #lines == 0 then return previousRender(self) end

    local mat = DL.Forge.materialOf(item)
    local rgb = mat and mat.rgb or nil
    local r = rgb and (rgb[1] / 255) or 0.68
    local g = rgb and (rgb[2] / 255) or 0.64
    local b = rgb and (rgb[3] / 255) or 0.96

    local lum = 0.30 * r + 0.59 * g + 0.11 * b
    if lum < 0.45 then
        local lift = 0.45 / math.max(lum, 0.01)
        r, g, b = math.min(r * lift, 1), math.min(g * lift, 1), math.min(b * lift, 1)
    end

    local lineSpacing = self.tooltip:getLineSpacing() + 0.5
    local stage, topY = 1, 0

    local oldSetHeight = self.setHeight
    self.setHeight = function (panel, height, ...)
        if stage == 1 then
            stage = 2
            topY = height
            height = height + #lines * lineSpacing
        else
            stage = -1
        end
        return oldSetHeight(panel, height, ...)
    end

    local oldDrawRectBorder = self.drawRectBorder
    self.drawRectBorder = function (panel, ...)
        if stage == 2 then
            local font = UIFont[getCore():getOptionTooltipFont()]
            for i = 1, #lines do
                panel.tooltip:DrawText(font, lines[i], 5, topY - 3 + (i - 1) * lineSpacing, r, g, b, 1)
            end
            stage = 3
        end
        return oldDrawRectBorder(panel, ...)
    end

    previousRender(self)

    self.setHeight = oldSetHeight
    self.drawRectBorder = oldDrawRectBorder
end

local named = {}

local function paintContainer(container)
    if not container then return end
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local md = item.getModData and item:getModData() or nil
        if md and md.DLMade then
            if not named[item:getID()] then
                DL.Forge.applyName(item)
                named[item:getID()] = true
            end
        elseif instanceof(item, "InventoryContainer") and item:getInventory() then
            paintContainer(item:getInventory())
        end
    end
end

local tick = 0
local function onPlayerUpdate(player)
    if not player or player ~= getPlayer() then return end
    tick = tick + 1
    if tick % 30 ~= 0 then return end
    paintContainer(player:getInventory())
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
