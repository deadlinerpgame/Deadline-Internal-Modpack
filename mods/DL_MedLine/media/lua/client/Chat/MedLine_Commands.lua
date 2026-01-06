require "WRC";

if isServer() then return end;

--[[
        Dependencies
--]]

WRC = WRC or {};
WRC.Meta = WRC.Meta or {};
WRC.SpecialCommands = WRC.SpecialCommands or {};
WRC.Commands = WRC.Commands or {};

WRC.SpecialCommands["/overridebloodloss"] = {
    handler = "OverrideBloodLoss",
    tabHandlers = {},
    usage = "/overridebloodloss [username] [time in hours (use 0 to cancel)]",
    help = "Overrides a player's blood loss in the case of bugs or other situations.",
    adminOnly = true,
}

function WRC.Commands.OverrideBloodLoss(args)
    local params = WRC.SplitString(args);

    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. /overridebloodloss [username] [time in hours (use 0 to cancel)]");
        return;
    end

    local username, hrs = params[1], params[2];

    if username == "" or hrs == "" then
        WL_Utils.addErrorToChat("Invalid format. /overridebloodloss [username] [time in hours (use 0 to cancel)]");
        return;
    end

    local hrsAsNumber = tonumber(hrs);
    if not hrsAsNumber or (hrsAsNumber < 0 or hrsAsNumber > 9999) then
        WL_Utils.addErrorToChat("Hours must be a number between 0 and 9999.");
        return;
    end

    local matchingPlayer = getPlayerFromUsername(username);
    if not matchingPlayer then
        WL_Utils.addErrorToChat("A player by that username is not currently connected to the server.");
        return;
    end

    sendClientCommand(getPlayer(), "MedLine", "ADMIN_OverrideBloodLoss", { username = username, time = hrsAsNumber });
    local queuedStr = string.format("[MedLine] Override request sent to server for player %s's blood loss time, new: %s hrs.", username, tostring(hrsAsNumber));
    WL_Utils.addInfoToChat(queuedStr);
end