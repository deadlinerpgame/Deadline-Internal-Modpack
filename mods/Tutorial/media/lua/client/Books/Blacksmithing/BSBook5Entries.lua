require "Util/LuaList"

BSBook5Entries = {}

BSBook5Entries.list = LuaList:new();

BSBook5Entries.addBookEntry = function (title, text, moreInfo, openConditionMethod, completeConditionMethod, moreInfoText)
    local entry = {title = title, text = text, moreInfo = moreInfo};

    BSBook5Entries.list:add(entry);
end

BSBook5Entries.getEntry = function(num)
    return BSBook5Entries.list:get(num);
end

BSBook5Entries.getEntryCount = function()
    return BSBook5Entries.list:size();
end

BSBook5Entries.addBookEntry(getText("SurvivalGuide_BS5Entry1Title"), getText("SurvivalGuide_BS5Entry1txt"));