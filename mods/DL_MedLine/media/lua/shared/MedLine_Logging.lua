MedLine_Logging = {};

---Logs to both the client (if debug enabled) and DebugLog_MedLine.txt for ease of access.
---@param data string The text string to write to the log.
function MedLine_Logging.log(data)
    if not data then
        error("MedLine logging called with invalid data", 1);
        return;
    end

    writeLog("MedLine", data);

    if isDebugEnabled() then
        print("[MedLine] " .. data);
    end
end

function MedLine_Logging.dumpTables(data)
    if not data then
        error("MedLine dumpTables called with invalid data.", 1);
        return;
    end

    if type(data) ~= "table" then
        MedLine_Logging.log(data);
    else
        local dumpString = "";

        for k, v in pairs(data) do
            dumpString = dumpString .. "\n" .. k .. ": " .. MedLine_Logging.tableToString(v);
        end
    end
end

function MedLine_Logging.tableToString(table)
    if not table then return end;
    if type(table) ~= "table" then return tostring(table) end;

    local outputString = "TABLE STRING:\n";

    for k, v in pairs(table) do
        local iterString = string.format("\n[%s] | %s", k, type(v) ~= "table" and v or MedLineLogging.tableToString(v));
        outputString = outputString .. iterString;
    end

    return outputString;
end


return MedLine_Logging;