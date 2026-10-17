local _ISRemoveGlassPerform_original = ISRemoveGlass.perform;

function ISRemoveGlass:perform()
    sendClientCommand(self.character, "ISRemoveGlassPatch", "RemoveGlassFromBodyPart", { target = self.character, bodyPart = self.bodyPart });
     _ISRemoveGlassPerform_original(self);
end

local function ISRemoveGlassPatch_OnServerCommand(module, command, args)
    if module ~= "ISRemoveGlassPatch" then return end;
    if command ~= "RemoveGlassFromBodyPart" then return end;
    if not args.bodyPart then return end;

    local type = args.bodyPart:getType();
    if not type then return end;

    local clientPart = getPlayer():getBodyDamage():getBodyPart(type);
    if not clientPart then
        error("[ISRemoveGlass] Attempted to remove glass in body part " .. tostring(type) .. " but could not find it.");
        return;
    end

    if clientPart:haveGlass() then
        clientPart:setHaveGlass(false);
    end
end

Events.OnServerCommand.Add(ISRemoveGlassPatch_OnServerCommand);