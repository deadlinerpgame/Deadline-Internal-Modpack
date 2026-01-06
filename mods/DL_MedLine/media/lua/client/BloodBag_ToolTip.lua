require "ISUI/ISToolTipInv";

local original_ISToolTipInv_render = ISToolTipInv.render;
function ISToolTipInv:render()

    original_ISToolTipInv_render(self);

    if not self.item:getModData().bloodBagInfo then return end;
        
    local bagData = self.item:getModData().bloodBagInfo;

    local timeStr = os.date("%Y-%m-%d", bagData.bloodData.takenDate);

    local tooltipStr = string.format("Blood Bag Info: [Taken from: %s] [Type: %s] [Taken: %s (real life days)]", bagData.bloodData.takenFromDisplay, bagData.bloodType.type, timeStr);
    if not self.item:getTooltip() or self.item:getTooltip() == "" then
        self.item:setTooltip(tooltipStr);
    end
end
