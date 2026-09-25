require "NPCDialogueShared"
require "AdminEditorWindow"
require "DialogueWindow"

local MODULE = NPCDialogue.MODULE
local CMD    = NPCDialogue.CMD

local Handlers = {}
NPCDialogue.clientZones = NPCDialogue.clientZones or {}

local activeZoneFloors = {}
local lastPlayerPos    = { x = 0, y = 0, z = 0 }

local function rescanSoon()
    lastPlayerPos = { x = -1, y = -1, z = -1 }
end

local function isAdminOrDebug(player)
    if not player then return false end
    local admin = (player.isAdmin and player:isAdmin()) or (player.getAccessLevel and player:getAccessLevel() ~= "None")
    local dbg   = (isDebugEnabled and isDebugEnabled()) or (getCore and getCore():getDebug())
    return admin or dbg
end

local function send(command, args)
    local p = getSpecificPlayer(0)
    if not p then return false end
    sendClientCommand(p, MODULE, command, args or {})
    return true
end

local READY_DELAY_MS = 1000
local RETRY_MS       = 10000
local MAX_REQUESTS   = 6

local synced     = false
local nextSyncAt = nil
local syncTries  = 0

local function queueSync()
    synced     = false
    syncTries  = 0
    nextSyncAt = getTimestampMs() + READY_DELAY_MS
end

local function pumpSync()
    if synced or not nextSyncAt or getTimestampMs() < nextSyncAt then return end
    if syncTries >= MAX_REQUESTS then
        nextSyncAt = nil
        return
    end
    if send(CMD.REQUEST_SYNC) then syncTries = syncTries + 1 end
    nextSyncAt = getTimestampMs() + RETRY_MS
end

Events.OnGameStart.Add(queueSync)
Events.OnCreatePlayer.Add(function(playerIndex)
    if playerIndex == 0 then queueSync() end
end)
Events.OnTick.Add(pumpSync)

function Handlers.SyncAll(args)
    local fresh = {}
    for _, zone in ipairs(args.zones or {}) do
        if zone.id then fresh[zone.id] = zone end
    end
    NPCDialogue.clientZones = fresh
    synced = true
    rescanSoon()
end

function Handlers.ZoneUpdated(args)
    local zone = args.zone
    if not (zone and zone.id) then return end
    NPCDialogue.clientZones[zone.id] = zone
    rescanSoon()
end

function Handlers.ZoneRemoved(args)
    local id = args.id
    if not id then return end
    NPCDialogue.clientZones[id] = nil
    rescanSoon()
    local dw = DialogueWindow._instance
    if dw and dw.active and dw.zoneId == id then dw:endSession() end
    AdminEditorWindow.closeFor(id, "This NPC was removed.")
end

function Handlers.ZoneData(args)
    local zone = args.zone
    if not (zone and zone.id) then return end
    AdminEditorWindow.getInstance():openForZone(zone)
end

function Handlers.SaveResult(args)
    AdminEditorWindow.onSaveResult(args)
end

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

local function onFillWorldObjectContextMenu(playerNum, context, worldObjects)
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
    local existingZone = getZoneAtTile(tx, ty, tz)

    if existingZone then
        context:addOption("Edit NPC Zone: " .. existingZone.name, sq, function()
            send(CMD.REQUEST_ZONE, { id = existingZone.id })
        end)
        context:addOption("Remove NPC Zone: " .. existingZone.name, sq, function()
            send(CMD.REMOVE_ZONE, { id = existingZone.id })
        end)
    else
        context:addOption("Place NPC Zone Here", sq, function()
            send(CMD.PLACE_ZONE, { name = "New NPC", x = tx, y = ty, z = tz })
        end)
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)

local currentZoneInside = nil

local function buildNodes(tree, player, zoneId)
    local nodes  = {}
    local rootId = nil
    if not (tree and tree.nodeOrder and #tree.nodeOrder > 0) then return nodes, rootId end

    rootId = tree.nodeOrder[1]
    for _, nid in ipairs(tree.nodeOrder) do
        local n = tree.nodes and tree.nodes[nid]
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
                                for k, v in pairs(cond) do c[k] = v end
                                c.zoneId = zoneId
                                local met = NPCDialogue.evalCondition(c, player)

                                if cond.type == "item" and cond.itemName and cond.itemName ~= "" then
                                    local displayName = cond.itemName
                                    local scriptItem = ScriptManager.instance:getItem(cond.itemName)
                                    if scriptItem then displayName = scriptItem:getDisplayName() end
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
                                    reqs[#reqs + 1] = { label = label, met = met }
                                end
                            end
                            if #reqs == 0 then reqs = nil end
                        end
                    end

                    responses[#responses + 1] = {
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
    return nodes, rootId
end

function Handlers.SessionGranted(args)
    local zoneId = args.zoneId
    if not zoneId then return end

    local npcName = args.name or "NPC"
    local player  = getSpecificPlayer(0)
    if player then
        player:getModData()["NPCTalked_" .. zoneId] = true
    end

    local nodes, rootId = buildNodes(args.tree, player, zoneId)
    if not rootId then
        rootId = "root"
        nodes["root"] = {
            npcText   = npcName .. " has nothing to say yet.",
            responses = { { label = "Goodbye.", state = "normal", leadsTo = nil } }
        }
    end

    DialogueWindow.getInstance():openForZone(zoneId, npcName, nodes, rootId, args.portrait)
end

function Handlers.SessionDenied(args)
    if not args.message then return end
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
    if key ~= Keyboard.KEY_E then return end
    local dw = DialogueWindow.getInstance()
    if dw:isVisible() then return end
    if not currentZoneInside then return end
    send(CMD.START_SESSION, { zoneId = currentZoneInside.id })
end

Events.OnKeyPressed.Add(onKeyPressed)

local lastPromptZoneId = nil

local function updatePrompt()
    local p = getSpecificPlayer(0)
    if not p then return end

    if currentZoneInside then
        if lastPromptZoneId ~= currentZoneInside.id then
            lastPromptZoneId = currentZoneInside.id
            p:setHaloNote("Press E to interact with " .. currentZoneInside.name, 255, 255, 150, 300)
        end
    else
        lastPromptZoneId = nil
    end
end

Events.OnTick.Add(updatePrompt)

local function onServerCommand(module, command, args)
    if module ~= MODULE then return end
    local fn = Handlers[command]
    if fn then fn(args or {}) end
end

Events.OnServerCommand.Add(onServerCommand)
