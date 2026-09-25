ZoneSync = ZoneSync or {};
ZoneSync.Data = ZoneSync.Data or {};
ZoneSync.ClientCommands = ZoneSync.ClientCommands or {};

Event = Event or {};
Event.Data = Event.Data or {};
Event.ClientCommands = Event.ClientCommands or {};


local function initGlobalModData(isNewGame)
    ZoneSync.Data.InfoStorageExample = ModData.getOrCreate("RadiationZone");
    Event.Data.InfoStorageExample = ModData.getOrCreate("eventLocations");
    print("Spawn")
end

Events.OnInitGlobalModData.Add(initGlobalModData);


local function handleReceiveGlobalModData(name, data)
    if name == "RadiationZone" then
        ModData.add(name, data) 
        print(data)
        print("Rads!")
        if isServer() then
            ModData.transmit("RadiationZone")
        end 
    end
    if name == "eventLocations" then
        ModData.add(name, data) 
        print(data)
        print("Events!")
        if isServer() then
            ModData.transmit("eventLocations")
        end 
    end
end

Events.OnReceiveGlobalModData.Add(handleReceiveGlobalModData)