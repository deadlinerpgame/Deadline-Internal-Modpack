require "Util/LuaList"

BSBook3Entries = {}

BSBook3Entries.list = LuaList:new();

BSBook3Entries.addBookEntry = function (title, text, moreInfo, openConditionMethod, completeConditionMethod, moreInfoText)
    local entry = {title = title, text = text, moreInfo = moreInfo};

    BSBook3Entries.list:add(entry);
end

BSBook3Entries.getEntry = function(num)
    return BSBook3Entries.list:get(num);
end

BSBook3Entries.getEntryCount = function()
    return BSBook3Entries.list:size();
end

BSBook3Entries.addBookEntry(getText("SurvivalGuide_bs3Entry1Title"), getText("SurvivalGuide_BS3Entry1txt"));
BSBook3Entries.addBookEntry(getText("SurvivalGuide_bs3Entry1Title"), getText("SurvivalGuide_BS3Entry2txt"));
BSBook3Entries.addBookEntry(getText("SurvivalGuide_bs3Entry1Title"), getText("SurvivalGuide_BS3Entry3txt"));
BSBook3Entries.addBookEntry(getText("SurvivalGuide_bs3Entry1Title"), getText("SurvivalGuide_BS3Entry4txt"));