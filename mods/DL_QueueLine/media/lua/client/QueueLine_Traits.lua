if isServer() then return end;

--[[
        Dependencies
--]]

QueueLine_Client = QueueLine_Client or {};

WRC = WRC or {};
WRC.Meta = WRC.Meta or {};
WRC.SpecialCommands = WRC.SpecialCommands or {};
WRC.Commands = WRC.Commands or {};

--[[
        In-Game Commands
--]]

WRC.SpecialCommands["/queuetrait"] = {
    handler = "QueueTrait",
    tabHandlers = {},
    usage = "/queuetrait [username] [trait name]",
    help = "Adds a trait to the offline action queue to be given to a player on their next connection.",
    adminOnly = true,
}

WRC.SpecialCommands["/queuetimedtrait"] = {
    handler = "QueueTimedTrait",
    tabHandlers = {},
    usage = "/queuetimedtrait [username] [real life hrs until added] [trait name]",
    help = "Gives the specified trait to a player after X real life hours have passed.",
    adminOnly = true,
}

--[[ 
        Command Handler Functions
--]]

function WRC.Commands.QueueTrait(args)

    local params = WRC.SplitString(args);

    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. /queuetrait [username] [trait]");
        return
    end

    local username, traitStr = params[1], params[2];

    if username == "" or traitStr == "" then
        WL_Utils.addErrorToChat("Invalid format. /queuetrait [username] [trait]");
        return
    end

    local trait = TraitFactory.getTrait(traitStr);
    if not trait then
        WL_Utils.addErrorToChat("Invalid trait name specified.");
        return
    end

    sendClientCommand(getPlayer(), "QueueLine", "AddTrait", { username = username, trait = traitStr });
    local queuedStr = string.format("[QueueLine] Added trait %s to the queue for player %s on their next connection.", trait, username);
    WL_Utils.addInfoToChat(queuedStr);
end

function WRC.Commands.QueueTimedTrait(args)

    local params = WRC.SplitString(args);

    if #params ~= 3 then
        WL_Utils.addErrorToChat("Invalid format. /queuetrait [username] [real life hrs until added] [trait]");
        return
    end

    local username, hrsStr, traitStr = params[1], params[2], params[3];

    if username == "" or traitStr == "" or hrsStr == "" then
        WL_Utils.addErrorToChat("Invalid format. /queuetrait [username] [trait]");
        return
    end

    local trait = TraitFactory.getTrait(traitStr);
    if not trait then
        WL_Utils.addErrorToChat("Invalid trait name specified.");
        return
    end

    local hrsVal = tonumber(hrsStr);
    if not hrsVal then
        WL_Utils.addErrorToChat("You must specify the hours until the trait takes effect.");
        return;
    end

    local hrsInSeconds = hrsVal --* 3600;
    local futureTimestamp = getTimestamp() + hrsInSeconds;

    sendClientCommand(getPlayer(), "QueueLine", "AddTrait", { username = username, trait = traitStr, timestamp = futureTimestamp });
    local queuedStr = string.format("[QueueLine] Added trait %s to the queue for player %s to be activated in %0d hours.", traitStr, username, hrsVal);
    WL_Utils.addInfoToChat(queuedStr);
end

--[[
            Returned queue item functions.
--]]
function QueueLine_Client.AddTrait(username, trait, timestamp)

    if not username or not trait then
        error("[QueueLine_Client] Received add trait queue item with no username or trait.", 1);
    end

    local currentTime = getTimestamp();
    if timestamp and (currentTime < getTimestamp()) then
        local errorStr = string.format("[QueueLine_Client] Received add trait queue item %s but timestamp is not yet passed: %0d - due: %0d.", trait, currentTime, timestamp);
        error(errorStr, 1);
    end

    -- Get trait.
    local matchingTrait = TraitFactory.getTrait(trait);
    if not matchingTrait then
        error("[QueueLine_Client] Received add trait queue item with invalid trait name: " .. tostring(trait), 1);
    end

    local playerFromUsername = getPlayerByUserName(username);
    if not playerFromUsername then
        error("[QueueLine_Client] Received add trait queue item with invalid username: " .. tostring(username), 1);
    end

    playerFromUsername:getTraits():add(matchingTrait);
    SyncXp(playerFromUsername);

    WL_Utils.addInfoToChat("You have been given trait " .. trait .. " from the offline actions queue.");
    return true;
end