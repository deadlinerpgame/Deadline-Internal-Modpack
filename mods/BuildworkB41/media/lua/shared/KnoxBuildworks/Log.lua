local KBW = require("KnoxBuildworks/Core")
local Logger = require("ElyonLib/Core/Logger")

local Log = Logger:new(KBW.ID, KBW.VERSION)
Log:setLogLevel("WARNING")

function Log:setDebug(enabled)
    KBW.Runtime.debug = enabled == true
    self:setLogLevel(KBW.Runtime.debug and "DEBUG" or "ERROR")
end

function Log:validation(scope, messages)
    messages = messages or {}
    for messageIndex = 1, #messages do
        local message = messages[messageIndex]
        self:warning("%s: %s", scope, message)
    end
end

return Log
