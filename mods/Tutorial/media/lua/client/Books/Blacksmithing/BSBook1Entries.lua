require "Util/LuaList"

BSBook1Entries = {}

BSBook1Entries.list = LuaList:new();

BSBook1Entries.addBookEntry = function (title, text, moreInfo, openConditionMethod, completeConditionMethod, moreInfoText)
    local entry = {title = title, text = text, moreInfo = moreInfo};

    BSBook1Entries.list:add(entry);
end

BSBook1Entries.getEntry = function(num)
    return BSBook1Entries.list:get(num);
end

BSBook1Entries.getEntryCount = function()
    return BSBook1Entries.list:size();
end

BSBook1Entries.addBookEntry(getText("SurvivalGuide_BS1Entry1Title"), getText("SurvivalGuide_BS1Entry1txt"));