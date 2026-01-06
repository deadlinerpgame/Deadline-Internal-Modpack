require "Helpers/SkillRestore/HookSetup";

-- Timer restore for Loot Counter

Events.OnGameBoot.Add(function()

        PARP.Hooks:add("modifyRestoreConfigVars", function(mode, configVars)
            configVars["RestoreLootCounter"] = true;
        end);

        PARP.Hooks:add("includeModDataEntryInRestoreDump", function(key, value, modData)
            return string.find(key, "^lootcounter") ~= nil;
        end);

        PARP.Hooks:add("includeModDataEntryInRestoreDump", function(key, value, modData)
            return string.find(key, "^lootcountertimer") ~= nil;
        end);

        PARP.Hooks:add("allowModDataEntryRestore", function(key, value, modData, configVars)
            return string.find(key, "^lootcounter") ~= nil;
        end);

        PARP.Hooks:add("allowModDataEntryRestore", function(key, value, modData, configVars)
            return string.find(key, "^lootcountertimer") ~= nil;
        end);
end);