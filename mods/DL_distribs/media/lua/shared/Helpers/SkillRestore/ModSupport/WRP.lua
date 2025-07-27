require "Helpers/SkillRestore/HookSetup";
require "WL_Utils"
-- Wasteland RP Languages

Events.OnGameBoot.Add(function()
    if getActivatedMods():contains("WastelandsRpChat")
    then
        PARP.Hooks:add("modifyRestoreConfigVars", function(mode, configVars)
            configVars["RestoreWLLangs"] = true;
        end);

        PARP.Hooks:add("includeModDataEntryInRestoreDump", function(key, value, modData)
            return string.find(key, "^WRC_KnownLanguage") ~= nil;
        end);

        PARP.Hooks:add("includeModDataEntryInRestoreDump", function(key, value, modData)
            return string.find(key, "^WRC_NumKnownLanguages") ~= nil;
        end);

        PARP.Hooks:add("allowModDataEntryRestore", function(key, value, modData, configVars)
            return string.find(key, "^WRC_KnownLanguage") ~= nil or string.find(key, "^WRC_NumKnownLanguages") ~= nil
        end);

        PARP.Hooks:add("allowModDataEntryRestore", function(key, value, modData, configVars)
            return string.find(key, "^WRC_NumKnownLanguages");
        end);
    end
end);