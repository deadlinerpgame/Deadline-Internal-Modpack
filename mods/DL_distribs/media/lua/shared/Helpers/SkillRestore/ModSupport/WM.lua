require "Helpers/SkillRestore/HookSetup";

-- musicians of the wasteland stuff which isn't handled via proper skills

Events.OnGameBoot.Add(function()
    if getActivatedMods():contains("WastelandMusiciansDeadline")
    then
        PARP.Hooks:add("modifyRestoreConfigVars", function(mode, configVars)
            configVars["RestoreMOTWModData"] = PARP:getSandboxVar("RestoreMOTWModData") or false;
        end);

        PARP.Hooks:add("includeModDataEntryInRestoreDump", function(key, value, modData)
            return string.find(key, "^MOTW") ~= nil;
        end);

        PARP.Hooks:add("allowModDataEntryRestore", function(key, value, modData, configVars)
            return string.find(key, "^MOTW") ~= nil and configVars["RestoreMOTWModData"];
        end);
    end
end);