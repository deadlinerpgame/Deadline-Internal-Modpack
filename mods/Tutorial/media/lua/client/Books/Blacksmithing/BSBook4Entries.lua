require "Util/LuaList"

BSBook4Entries = {}

BSBook4Entries.list = LuaList:new();

BSBook4Entries.addBookEntry = function (title, text, moreInfo, openConditionMethod, completeConditionMethod, moreInfoText)
    local entry = {title = title, text = text, moreInfo = moreInfo};

    BSBook4Entries.list:add(entry);
end

BSBook4Entries.getEntry = function(num)
    return BSBook4Entries.list:get(num);
end

BSBook4Entries.getEntryCount = function()
    return BSBook4Entries.list:size();
end

BSBook4Entries.addBookEntry(getText("SurvivalGuide_BS4Entry1Title"), getText("SurvivalGuide_BS4Entry1txt"));
BSBook4Entries.addBookEntry(getText("SurvivalGuide_BS4Entry1Title"), getText("SurvivalGuide_BS4Entry2txt"));