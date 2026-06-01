if isClient() and not isServer() then return end
DL = DL or {}

local ran = false

local function selfTest()
    if ran then return end
    ran = true

    local U = "DL SelfTest User"
    local pass, fail = 0, 0
    local function check(cond, label)
        if cond then pass = pass + 1; DL.log("SELFTEST PASS  " .. label)
        else        fail = fail + 1; DL.warn("SELFTEST FAIL  " .. label) end
    end

    DL.log("SELFTEST starting (account='" .. U .. "')")

    check(DL.Paths.safeName("Bad/..\\Name#1") == "BadName", "safeName strips unsafe chars")
    check(DL.Paths.safeName("  John Doe  ") == "John Doe", "safeName trims + keeps spaces")
    check(DL.Paths.accountDir(U) == DL.Config.dataRoot .. "/" .. U, "accountDir builds under dataRoot")

    DL.Wounds.set(U, 0)
    check(DL.Wounds.get(U) == 0, "wounds set/get 0")
    check(DL.Wounds.add(U, 1) == 1 and DL.Wounds.get(U) == 1, "wounds add ->1")
    DL.Wounds.add(U, 2)
    check(DL.Wounds.get(U) == 3, "wounds accumulate ->3")
    DL.Wounds.reset(U)
    check(DL.Wounds.get(U) == 0, "wounds reset ->0")

    local N = DL.Config.snapshotKeep
    for i = 1, N + 2 do
        DL.SnapStore.push(U, "RECORD#" .. i)
    end
    check(DL.SnapStore.count(U) == N, "snapstore count caps at N (" .. N .. ")")
    check(DL.SnapStore.newest(U) == "RECORD#" .. (N + 2), "snapstore newest = last pushed")

    DL.Flags.resetRestore(U)
    check(not DL.Flags.isRestoreUsed(U), "flag starts unset")
    DL.Flags.markRestoreUsed(U)
    check(DL.Flags.isRestoreUsed(U), "flag set after markRestoreUsed")
    DL.Flags.resetRestore(U)
    check(not DL.Flags.isRestoreUsed(U), "flag clears on respawn reset")

    if fail == 0 then
        DL.log("SELFTEST RESULT: ALL " .. pass .. " PASS — foundation is solid.")
    else
        DL.warn("SELFTEST RESULT: " .. fail .. " FAIL / " .. (pass + fail) .. " total — investigate above.")
    end
    DL.log("SELFTEST note: delete the '" .. DL.Config.dataRoot .. "/" .. U .. "' folder when done.")
end

Events.OnServerStarted.Add(function() local _ = (selfTest)() end)
Events.OnGameStart.Add(function() local _ = (selfTest)() end)
