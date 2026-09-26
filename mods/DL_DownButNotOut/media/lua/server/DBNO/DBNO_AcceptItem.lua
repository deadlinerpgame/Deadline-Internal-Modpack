DBNO = DBNO or {}

AcceptItemFunction = AcceptItemFunction or {}

local function refuse(container, item)
    return false
end

AcceptItemFunction.DBNO_DeathCache = refuse

local function reassert()
    AcceptItemFunction.DBNO_DeathCache = refuse
end
Events.OnGameStart.Add(reassert)
Events.OnServerStarted.Add(reassert)
