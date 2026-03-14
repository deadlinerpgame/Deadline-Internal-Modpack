



require "NPCDialogueShared"
require "AdminEditorWindow"

local NPCDialogueClientCommands = {}
NPCDialogue.clientZones = NPCDialogue.clientZones or {}


local activeZoneFloors = {}
local lastPlayerPos    = { x = 0, y = 0, z = 0 }


local function isAdminOrDebug(player)
    if not player then return false end
    local admin = (player.isAdmin and player:isAdmin()) or (player.getAccessLevel and player:getAccessLevel() ~= "None")
    local dbg   = (isDebugEnabled and isDebugEnabled()) or (getCore and getCore():getDebug())
    return admin or dbg
end


local ZONE_KEY = "NPCDialogueZone"

local function writeZoneToTile(zone)
    local cell = getCell()
    if not cell then return false end
    local sq = cell:getGridSquare(zone.x, zone.y, zone.z)
    if not sq then return false end

    
    local md = sq:getModData()
    md[ZONE_KEY] = zone
    if sq.transmitModData then
        sq:transmitModData()
    elseif sq.transmitModdata then
        sq:transmitModdata()
    end

    
    ModData.request(NPCDialogue.MODDATA_KEY)
    local modTable = ModData.getOrCreate(NPCDialogue.MODDATA_KEY)
    if not modTable.zones then modTable.zones = {} end
    modTable.zones[zone.id] = { id = zone.id, x = zone.x, y = zone.y, z = zone.z }
    ModData.add(NPCDialogue.MODDATA_KEY, modTable)
    ModData.transmit(NPCDialogue.MODDATA_KEY)
    ModData.request(NPCDialogue.MODDATA_KEY)

    print("[NPCDialogue CLIENT] Wrote zone: " .. zone.id)
    return true
end

local function clearZoneFromTile(x, y, z, id)
    local cell = getCell()
    if not cell then return end
    local sq = cell:getGridSquare(x, y, z)
    if sq then
        
        local md = sq:getModData()
        md[ZONE_KEY] = nil
        if sq.transmitModData then
            sq:transmitModData()
        elseif sq.transmitModdata then
            sq:transmitModdata()
        end
    end

    
    if id then
        ModData.request(NPCDialogue.MODDATA_KEY)
        local modTable = ModData.getOrCreate(NPCDialogue.MODDATA_KEY)
        if modTable.zones then modTable.zones[id] = nil end
        ModData.add(NPCDialogue.MODDATA_KEY, modTable)
        ModData.transmit(NPCDialogue.MODDATA_KEY)
        ModData.request(NPCDialogue.MODDATA_KEY)
    end

    print("[NPCDialogue CLIENT] Cleared zone: " .. x .. "," .. y .. "," .. z)
end

local function readZoneFromTile(x, y, z)
    local cell = getCell()
    if not cell then return nil end
    local sq = cell:getGridSquare(x, y, z)
    if not sq then return nil end
    return sq:getModData()[ZONE_KEY]
end






local function refreshClientZones()
    ModData.request(NPCDialogue.MODDATA_KEY)
    local modTable = ModData.getOrCreate(NPCDialogue.MODDATA_KEY)
    if not modTable.zones then return end
    local count = 0
    for id, pos in pairs(modTable.zones) do
        
        if not NPCDialogue.clientZones[id] then
            local zone = readZoneFromTile(pos.x, pos.y, pos.z)
            if zone and zone.id then
                NPCDialogue.clientZones[zone.id] = zone
                count = count + 1
            end
        end
    end
    if count > 0 then
        print("[NPCDialogue CLIENT] refreshClientZones added " .. count .. " zone(s)")
        
        lastPlayerPos = { x = -1, y = -1, z = -1 }
    end
end

function NPCDialogueClientCommands.SyncReady(args)
    print("[NPCDialogue CLIENT] SyncReady")
    NPCDialogue.clientZones = {}
    refreshClientZones()
end


function NPCDialogueClientCommands.SyncZone(args)
    if not (args and args.zone) then return end
    local zone = args.zone
    NPCDialogue.clientZones[zone.id] = zone
    writeZoneToTile(zone)
    print("[NPCDialogue CLIENT] SyncZone: " .. zone.id)
end


function NPCDialogueClientCommands.RemoveAck(args)
    if not (args and args.id) then return end
    NPCDialogue.clientZones[args.id] = nil
    if args.x and args.y and args.z then
        clearZoneFromTile(math.floor(args.x), math.floor(args.y), math.floor(args.z), args.id)
    end
    print("[NPCDialogue CLIENT] RemoveAck: " .. tostring(args.id))
end


local function onServerCommand(module, command, args)
    if module ~= "NPCDialogue" then return end
    print("[NPCDialogue CLIENT] onServerCommand: " .. tostring(command))
    if NPCDialogueClientCommands[command] then
        NPCDialogueClientCommands[command](args)
    end
end

Events.OnServerCommand.Add(onServerCommand)


local function onConnected()
    print("[NPCDialogue CLIENT] OnConnected - requesting sync")
    sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "RequestSync", {})
end

Events.OnConnected.Add(onConnected)



Events.EveryOneMinute.Add(refreshClientZones)


local function updateActiveZones()
    local p = getSpecificPlayer(0)
    if not p then return end

    local px = math.floor(p:getX())
    local py = math.floor(p:getY())
    local pz = math.floor(p:getZ())

    if px == lastPlayerPos.x and py == lastPlayerPos.y and pz == lastPlayerPos.z then return end
    lastPlayerPos = { x = px, y = py, z = pz }

    activeZoneFloors = {}
    if not isAdminOrDebug(p) then return end

    local cell = getCell()
    if not cell then return end

    local r = NPCDialogue.HIGHLIGHT_SCAN_RADIUS
    for _, zone in pairs(NPCDialogue.clientZones) do
        if zone.z == pz
           and math.abs(zone.x - px) <= r
           and math.abs(zone.y - py) <= r then
            local sq = cell:getGridSquare(zone.x, zone.y, zone.z)
            if sq then
                local floor = sq:getFloor()
                if floor then
                    activeZoneFloors[#activeZoneFloors + 1] = floor
                end
            end
        end
    end
end

local function onPostFloorLayerDraw(z)
    local p = getSpecificPlayer(0)
    if not p or not isAdminOrDebug(p) then return end
    if math.floor(p:getZ()) ~= z then return end
    for _, floor in ipairs(activeZoneFloors) do
        floor:setHighlightColor(
            NPCDialogue.HIGHLIGHT_R,
            NPCDialogue.HIGHLIGHT_G,
            NPCDialogue.HIGHLIGHT_B,
            NPCDialogue.HIGHLIGHT_A
        )
        floor:setHighlighted(true)
    end
end

Events.OnTick.Add(updateActiveZones)
Events.OnPostFloorLayerDraw.Add(onPostFloorLayerDraw)


local function getZoneAtTile(x, y, z)
    for _, zone in pairs(NPCDialogue.clientZones) do
        if zone.x == x and zone.y == y and zone.z == z then
            return zone
        end
    end
    return nil
end

local function onFillWorldObjectContextMenu(playerNum, context, worldObjects, x, y, z)
    local player = getSpecificPlayer(playerNum)
    if not isAdminOrDebug(player) then return end

    local sq = nil
    for _, o in ipairs(worldObjects) do
        if o and o.getSquare then
            sq = o:getSquare()
            if sq then break end
        end
    end
    if not sq then return end

    local tx, ty, tz = sq:getX(), sq:getY(), sq:getZ()

    
    local existingZone = getZoneAtTile(tx, ty, tz) or readZoneFromTile(tx, ty, tz)

    if existingZone then
        context:addOption("Edit NPC Zone: " .. existingZone.name, sq, function()
            print("[NPCDialogue CLIENT] Edit zone: " .. existingZone.id)
            if not AdminEditorWindow then
                print("[NPCDialogue CLIENT] AdminEditorWindow not loaded")
                return
            end
            local editor = AdminEditorWindow.getInstance()
            editor:openForZone(existingZone)
        end)
        context:addOption("Remove NPC Zone: " .. existingZone.name, sq, function()
            print("[NPCDialogue CLIENT] Removing zone: " .. existingZone.id)
            sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "RemoveZone", {
                id = existingZone.id,
                x  = existingZone.x,
                y  = existingZone.y,
                z  = existingZone.z,
            })
        end)
    else
        context:addOption("Place NPC Zone Here", sq, function()
            print("[NPCDialogue CLIENT] Placing zone at " .. tostring(tx) .. "," .. tostring(ty) .. "," .. tostring(tz))
            sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "PlaceZone", {
                name = "New NPC",
                x    = tx,
                y    = ty,
                z    = tz,
            })
        end)
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)





require "DialogueWindow"

local currentZoneInside = nil  



function NPCDialogueClientCommands.SessionGranted(args)
    if not (args and args.zoneId) then return end
    print("[NPCDialogue CLIENT] SessionGranted for " .. args.zoneId)

    
    local zone = NPCDialogue.clientZones[args.zoneId]
    if not zone then
        
        zone = readZoneFromTile(math.floor(args.x), math.floor(args.y), math.floor(args.z))
    end

    local npcName = (zone and zone.name) or args.name or "NPC"
    local portrait = zone and zone.portrait or nil
    local tree    = zone and zone.dialogueTree

    
    local nodes  = {}
    local rootId = nil

    local player = getSpecificPlayer(0)
    local zoneId = args.zoneId

    
    if player then
        player:getModData()["NPCTalked_" .. zoneId] = true
    end

    if tree and tree.nodeOrder and #tree.nodeOrder > 0 then
        rootId = tree.nodeOrder[1]
        for _, nid in ipairs(tree.nodeOrder) do
            local n = tree.nodes[nid]
            if n then
                
                local npcText = n.npcText or ""
                if player then
                    npcText = NPCDialogue.resolvePrompts(npcText, player)
                end

                
                local responses = {}
                for _, resp in ipairs(n.responses or {}) do
                    local state = "normal"
                    if player then
                        state = NPCDialogue.evalResponse(resp, player, zoneId)
                    end
                    if state ~= "hidden" then
                        local leadsTo = resp.leadsTo
                        if leadsTo == "(end)" then leadsTo = nil end

                        
                        local reqs = nil
                        if resp.conditions then
                            local hasAnyCond = false
                            for _ in pairs(resp.conditions) do hasAnyCond = true; break end
                            if hasAnyCond then
                                reqs = {}
                                for _, cond in pairs(resp.conditions) do
                                    local label = nil
                                    
                                    local c = {}
                                    for k,v in pairs(cond) do c[k] = v end
                                    c.zoneId = zoneId
                                    local met = NPCDialogue.evalCondition(c, player)

                                    if cond.type == "item" and cond.itemName and cond.itemName ~= "" then
                                        local displayName = cond.itemName
                                        local ok, scriptItem = pcall(function()
                                            return ScriptManager.instance:getItem(cond.itemName)
                                        end)
                                        if ok and scriptItem then displayName = scriptItem:getDisplayName() end
                                        local amt = tonumber(cond.amount) or 1
                                        label = (amt > 1) and (amt .. "x " .. displayName) or displayName
                                    elseif cond.type == "skill" and cond.skill then
                                        label = cond.skill .. " " .. tostring(cond.level or 1)
                                    elseif cond.type == "occupation" and cond.occupation and cond.occupation ~= "" then
                                        label = cond.occupation
                                    elseif cond.type == "talked" then
                                        label = "Talked before"
                                    end
                                    if label then
                                        reqs[#reqs+1] = { label = label, met = met }
                                    end
                                end
                                if #reqs == 0 then reqs = nil end
                            end
                        end

                        responses[#responses+1] = {
                            label   = resp.label or "",
                            state   = state,
                            leadsTo = leadsTo,
                            reqs    = reqs,
                        }
                    end
                end

                nodes[nid] = {
                    npcText   = npcText,
                    responses = responses,
                }
            end
        end
    end

    
    if not rootId then
        rootId = "root"
        nodes["root"] = {
            npcText   = npcName .. " has nothing to say yet.",
            responses = { { label = "Goodbye.", state = "normal", leadsTo = nil } }
        }
    end

    local dw = DialogueWindow.getInstance()
    dw:openForZone(args.zoneId, npcName, nodes, rootId, portrait)
end

function NPCDialogueClientCommands.SessionDenied(args)
    if not (args and args.message) then return end
    print("[NPCDialogue CLIENT] SessionDenied: " .. args.message)
    
    local p = getSpecificPlayer(0)
    if p then
        p:setHaloNote(args.message, 255, 200, 100, 200)
    end
end


local function onPlayerUpdate(p)
    if not p or p:getPlayerNum() ~= 0 then return end

    local px = p:getX()
    local py = p:getY()
    local pz = math.floor(p:getZ())

    currentZoneInside = nil
    for _, zone in pairs(NPCDialogue.clientZones) do
        if zone.z == pz then
            local dist = NPCDialogue.distanceTo(px, py, zone.x, zone.y)
            if dist <= (zone.radius or NPCDialogue.DEFAULT_RADIUS) then
                currentZoneInside = zone
                break
            end
        end
    end
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)


local function onKeyPressed(key)
    if key ~= Keyboard.KEY_F then return end
    local dw = DialogueWindow.getInstance()
    if dw:isVisible() then return end  
    if not currentZoneInside then return end

    local zone = currentZoneInside
    print("[NPCDialogue CLIENT] Requesting session for " .. zone.id)
    sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "StartSession", {
        zoneId = zone.id,
        name   = zone.name,
        x      = zone.x,
        y      = zone.y,
        z      = zone.z,
    })
end

Events.OnKeyPressed.Add(onKeyPressed)




local lastPromptZoneId = nil

local function updatePrompt()
    local p = getSpecificPlayer(0)
    if not p then return end

    if currentZoneInside then
        if lastPromptZoneId ~= currentZoneInside.id then
            lastPromptZoneId = currentZoneInside.id
            p:setHaloNote("Press F to interact with " .. currentZoneInside.name, 255, 255, 150, 300)
        end
    else
        lastPromptZoneId = nil
    end
end

Events.OnTick.Add(updatePrompt)
