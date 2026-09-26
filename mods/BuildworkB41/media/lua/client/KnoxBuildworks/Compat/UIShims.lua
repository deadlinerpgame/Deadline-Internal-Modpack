require "ISUI/ISComboBox"
require "ISUI/ISTextEntryBox"

local UIShims = {}

if ISComboBox and ISComboBox.getOptionCount == nil then
    function ISComboBox:getOptionCount()
        return self.options and #self.options or 0
    end
end

if ISTextEntryBox and ISTextEntryBox.setPlaceholderText == nil then
    function ISTextEntryBox:setPlaceholderText()
    end
end

function UIShims.applied()
    return ISComboBox ~= nil and ISComboBox.getOptionCount ~= nil
end

return UIShims
