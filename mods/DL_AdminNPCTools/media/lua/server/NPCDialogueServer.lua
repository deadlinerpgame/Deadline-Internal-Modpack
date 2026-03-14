



require "NPCDialogueShared"

local NPCDialogueServerCommands = {}


local function isAdminOrDebug(player)
    if not player then return false end
    local lvl     = player:getAccessLevel()
    local isAdmin = lvl ~= nil and lvl ~= "" and lvl ~= "None"
    local isDebug = isDebugEnabled and isDebugEnabled()
    return isAdmin or isDebug
end





function NPCDialogueServerCommands.RequestSync(playerObj, args)
    
    
    print("[NPCDialogue SERVER] RequestSync from " .. tostring(playerObj:getUsername()))
    sendServerCommand(playerObj, "NPCDialogue", "SyncReady", {})
end

function NPCDialogueServerCommands.PlaceZone(playerObj, args)
    print("[NPCDialogue SERVER] PlaceZone received")
    if not isAdminOrDebug(playerObj) then
        print("[NPCDialogue SERVER] Rejected - access level: " .. tostring(playerObj:getAccessLevel()))
        return
    end

    
    local zoneId = args.existingId or NPCDialogue.generateId()
    local zone = NPCDialogue.newZone(
        zoneId,
        args.name or "Unnamed NPC",
        math.floor(args.x), math.floor(args.y), math.floor(args.z)
    )

    print("[NPCDialogue SERVER] Broadcasting SyncZone: " .. zone.id)
    sendServerCommand("NPCDialogue", "SyncZone", { zone = zone })
end

function NPCDialogueServerCommands.RemoveZone(playerObj, args)
    print("[NPCDialogue SERVER] RemoveZone received")
    if not isAdminOrDebug(playerObj) then return end
    if not args.id then return end

    print("[NPCDialogue SERVER] Broadcasting RemoveAck: " .. tostring(args.id))
    sendServerCommand("NPCDialogue", "RemoveAck", { id = args.id, x = args.x, y = args.y, z = args.z })
end


local function onClientCommand(module, command, playerObj, args)
    if module ~= "NPCDialogue" then return end
    print("[NPCDialogue SERVER] onClientCommand: " .. tostring(command))
    if NPCDialogueServerCommands[command] then
        NPCDialogueServerCommands[command](playerObj, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)



local activeSessions = {}

function NPCDialogueServerCommands.StartSession(playerObj, args)
    local zoneId = args.zoneId
    if not zoneId then return end

    local username = playerObj:getUsername()
    print("[NPCDialogue SERVER] StartSession: " .. username .. " -> " .. zoneId)

    
    local cell = getCell()
    local zone = nil
    if cell then
        local sq = cell:getGridSquare(math.floor(args.x), math.floor(args.y), math.floor(args.z))
        if sq then zone = sq:getModData()["NPCDialogueZone"] end
    end

    
    local zoneName   = (zone and zone.name)       or args.name or "NPC"
    local concurrent = (zone and zone.concurrent)
    if concurrent == nil then concurrent = true end

    
    if not concurrent and activeSessions[zoneId] then
        local occupant = activeSessions[zoneId]
        if occupant ~= username then
            print("[NPCDialogue SERVER] Session occupied by " .. occupant)
            sendServerCommand(playerObj, "NPCDialogue", "SessionDenied", {
                zoneId  = zoneId,
                message = zoneName .. " is already talking to someone.",
            })
            return
        end
    end

    activeSessions[zoneId] = username
    print("[NPCDialogue SERVER] Session granted: " .. username .. " -> " .. zoneId)
    sendServerCommand(playerObj, "NPCDialogue", "SessionGranted", {
        zoneId = zoneId,
        name   = zoneName,
        x      = math.floor(args.x),
        y      = math.floor(args.y),
        z      = math.floor(args.z),
    })
end

function NPCDialogueServerCommands.EndSession(playerObj, args)
    local zoneId = args.zoneId
    if not zoneId then return end
    local username = playerObj:getUsername()
    if activeSessions[zoneId] == username then
        activeSessions[zoneId] = nil
        print("[NPCDialogue SERVER] Session ended: " .. username .. " -> " .. zoneId)
    end
end

function NPCDialogueServerCommands.UpdateZone(playerObj, args)
    print("[NPCDialogue SERVER] UpdateZone received")
    if not isAdminOrDebug(playerObj) then return end
    if not args.zone or not args.zone.id then return end
    
    sendServerCommand("NPCDialogue", "SyncZone", { zone = args.zone })
    print("[NPCDialogue SERVER] UpdateZone broadcast: " .. args.zone.id)
end
