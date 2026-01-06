MedLine_Logging = {};

---Logs to both the client (if debug enabled) and DebugLog_MedLine.txt for ease of access.
---@param data string The text string to write to the log.
function MedLine_Logging.log(data)
    if not data then
        error("MedLine logging called with invalid data", 1);
        return;
    end

    writeLog("MedLine", data);

    if isDebugEnabled() or isServer() then
        print("[MedLine] " .. data);
    end
end

return MedLine_Logging;