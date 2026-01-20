if not isClient() then return end;
WRC = WRC or {};
WRC.Parsing = WRC.Parsing or {};

local original_parsing = WRC.Parsing.ParseMessage;
function WRC.Parsing.ParseMessage(message)
    local returnedMessage = original_parsing(message);
    if not returnedMessage.playerUsername then return returnedMessage end;

    if returnedMessage and returnedMessage.chatType ~= "shout" and returnedMessage.chatType ~= "whisper" then

        local username = returnedMessage.playerUsername;
        if username == getPlayer():getUsername() then return returnedMesssage end; -- Only dim if not your own message.
        local sourcePlayer = getPlayerFromUsername(returnedMessage.playerUsername);

        local defaultRadius = WRC.ChatTypes[returnedMessage.chatType].xyRange;
        local currentDifference = getPlayer():getDistanceSq(sourcePlayer);

        if currentDifference / defaultRadius > 0.45 then
            for i, v in ipairs(returnedMessage.parts) do
                returnedMessage.parts[i].type = "textmuted";
            end
        end
    end

    return returnedMessage;
end