DL = DL or {}

local function onServerCommand(module, command, args)
    if module ~= DL.MODULE then return end
    if command == "AlloysReloaded" then
        print("[DL_MetalLine] server reload alloys.json -> " .. tostring(args and args.ok))
    end
end
Events.OnServerCommand.Add(onServerCommand)
