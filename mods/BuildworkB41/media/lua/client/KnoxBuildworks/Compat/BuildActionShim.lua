require "BuildingObjects/TimedActions/ISBuildAction"

local Shim = {}

if type(ISBuildAction) == "table" and not ISBuildAction._kbwOnIsValidPatched then
    ISBuildAction._kbwOnIsValidPatched = true

    local baseIsValid = ISBuildAction.isValid

    function ISBuildAction:isValid()
        if baseIsValid and not baseIsValid(self) then return false end
        if self.onIsValid then
            local LuaCallback = require("KnoxBuildworks/Util/LuaCallback")
            return LuaCallback.callBool(self.onIsValid, {
                character = self.character,
                x = self.x, y = self.y, z = self.z,
                north = self.north,
                buildObject = self.item
            }, true)
        end
        return true
    end

    Shim.applied = true
else
    Shim.applied = type(ISBuildAction) == "table"
    if not Shim.applied then
        require("KnoxBuildworks/Log"):error(
            "ISBuildAction shim not applied: ISBuildAction is %s", type(ISBuildAction))
    end
end

return Shim
