require "Util/LuaList"

BSBook2Entries = {}

BSBook2Entries.list = LuaList:new();

BSBook2Entries.addBookEntry = function (title, text, moreInfo, openConditionMethod, completeConditionMethod, moreInfoText)
    local entry = {title = title, text = text, moreInfo = moreInfo};

    BSBook2Entries.list:add(entry);
end

BSBook2Entries.getEntry = function(num)
    return BSBook2Entries.list:get(num);
end

BSBook2Entries.getEntryCount = function()
    return BSBook2Entries.list:size();
end

BSBook2Entries.addBookEntry(getText("SurvivalGuide_BS2Entry1Title"), getText("SurvivalGuide_BS2Entry1txt"));