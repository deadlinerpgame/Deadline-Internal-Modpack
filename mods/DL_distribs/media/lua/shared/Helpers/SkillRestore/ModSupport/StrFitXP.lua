require "Helpers/SkillRestore/HookSetup";

-- Timer restore for Str/Fit XP Limiter

Events.OnGameBoot.Add(function()
    if getActivatedMods():contains("WastelandsRpChat")
    then
        PARP.Hooks:add("modifyRestoreConfigVars", function(mode, configVars)
            configVars["RestoreXPStrFit"] = true;
        end);

        PARP.Hooks:add("includeModDataEntryInRestoreDump", function(key, value, modData)
            return string.find(key, "^xpCooldown") ~= nil;
        end);

        PARP.Hooks:add("allowModDataEntryRestore", function(key, value, modData, configVars)
            return string.find(key, "^xpCooldown") ~= nil;
        end);
    end
end);