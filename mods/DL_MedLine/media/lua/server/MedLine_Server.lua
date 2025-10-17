if isClient() then return end;

MedLine_Server = {};

--- BloodData - stores blood type and state of a player.
--- ["username"] = 
--- {
---     bloodType
--- }
MedLine_Server.BloodData = {};

function MedLine_Server.OnInitGlobalModData(newGame)

end


function MedLine_Server.OnReceiveGlobalModData(key, data)

end

Events.OnInitGlobalModData.Add(MedLine_Server.OnInitGlobalModData);
Events.OnReceiveGlobalModData.Add(MedLine_Server.OnReceiveGlobalModData);