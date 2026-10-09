require "ISUI/ISToolTipInv";
local original_ISDropWorldItemAction_perform = ISDropWorldItemAction.perform;

function ISDropWorldItemAction:perform()
    original_ISDropWorldItemAction_perform(self);
    if self.item:getDisplayCategory() ~= "TTRPDescriptors" then return end;

    if not self.item:getModData().descriptorPlacedTimestamp then
        self.item:getModData().descriptorPlacedTimestamp = getTimestamp();
    end
end


local original_ISToolTipInv_render = ISToolTipInv.render;
function ISToolTipInv:render()
    original_ISToolTipInv_render(self);

    if not self.item:getModData().descriptorPlacedTimestamp then return end;
        
    local timeStr = os.date("%Y-%m-%d", self.item:getModData().descriptorPlacedTimestamp);

    local tooltipStr = string.format("Scene placed on %s", timeStr);
    if not self.item:getTooltip() or self.item:getTooltip() == "" then
        self.item:setTooltip(tooltipStr);
    end
end
