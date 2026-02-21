require "ISUI/ISContextMenu"
require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"

local SOUND_TILE_SPRITE = 'media/ui/spritesoundtile.png'

local soundSquares = {}
local spriteCache = {}
local lastPlayerPos = { x = 0, y = 0, z = 0 }

local function getSprite(path)
    if not spriteCache[path] then
        local sprite = IsoSprite.new()
        sprite:LoadFramesNoDirPageSimple(path)
        spriteCache[path] = sprite
    end
    return spriteCache[path]
end

local function isAdminOrDebug(p)
if not p then return false end
local accessLevel = p:getAccessLevel()
    if accessLevel then
        return accessLevel == "Admin"
    end
end

DDSoundTileBox = ISPanel:derive("DDSoundTileBox")

function DDSoundTileBox:new(square, pid, title)
    local w, h = 300, 230
    local sx, sy = getCore():getScreenWidth(), getCore():getScreenHeight()
    local o = ISPanel.new(self, sx/2 - w/2, sy/2 - h/2, w, h)
    o.backgroundColor = { r=0, g=0, b=0, a=0.85 }
    o.borderColor = { r=1, g=1, b=1, a=0.9 }
    o.moveWithMouse = true
    o.sq = square
    o.pid = pid or 0
    o.title = title or "Make Sound Tile"
    return o
end

function DDSoundTileBox:initialise()
    ISPanel.initialise(self)

    local md = self.sq:getModData()
    local defSound = md.ddSoundName or ""
    local defRange = md.ddSoundRange or 0
    local defMessage = md.ddSoundMessage or ""

    self.prev = {
        has = md.ddSoundName ~= nil,
        sound = defSound,
        range = tonumber(defRange) or 0,
        message = defMessage,
    }

    local pad = 15
    local rowH = 24
    local labelW = 100
    local inputX = pad + labelW + 5
    local inputW = self.width - inputX - pad
    local y = 12

    local titleLabel = ISLabel:new(0, y, 20, self.title, 1, 1, 1, 1, UIFont.Medium, true)
    titleLabel:setX((self.width - getTextManager():MeasureStringX(UIFont.Medium, self.title)) / 2)
    self:addChild(titleLabel)
    y = y + 30

    local soundLabel = ISLabel:new(pad, y + 2, rowH, "Sound Name:", 1, 1, 1, 1, UIFont.Small, false)
    self:addChild(soundLabel)
    self.soundEntry = ISTextEntryBox:new(tostring(defSound), inputX, y, inputW - 45, rowH)
    self.soundEntry:initialise()
    self.soundEntry:instantiate()
    self:addChild(self.soundEntry)
    
    self.testBtn = ISButton:new(self.width - pad - 40, y, 40, rowH, "Test", self, DDSoundTileBox.onTestSound)
    self.testBtn:initialise()
    self.testBtn:instantiate()
    self:addChild(self.testBtn)
    y = y + rowH + 10

    local rangeLabel = ISLabel:new(pad, y + 2, rowH, "Range (0=self):", 1, 1, 1, 1, UIFont.Small, false)
    self:addChild(rangeLabel)
    self.rangeEntry = ISTextEntryBox:new(tostring(defRange), inputX, y, inputW, rowH)
    self.rangeEntry:initialise()
    self.rangeEntry:instantiate()
    self:addChild(self.rangeEntry)
    y = y + rowH + 10

    local messageLabel = ISLabel:new(pad, y + 2, rowH, "Message:", 1, 1, 1, 1, UIFont.Small, false)
    self:addChild(messageLabel)
    self.messageEntry = ISTextEntryBox:new(tostring(defMessage), inputX, y, inputW, rowH)
    self.messageEntry:initialise()
    self.messageEntry:instantiate()
    self:addChild(self.messageEntry)
    y = y + rowH + 6

    local infoText = "Message is optional"
    local infoLabel = ISLabel:new(0, y, 20, infoText, 0.6, 0.6, 0.6, 1, UIFont.Small, false)
    infoLabel:setX((self.width - getTextManager():MeasureStringX(UIFont.Small, infoText)) / 2)
    self:addChild(infoLabel)
    y = y + 28

    local btnW, btnH = 80, 24
    local btnSpacing = 10
    local totalBtnW = btnW * 2 + btnSpacing
    local btnStartX = (self.width - totalBtnW) / 2

    self.okBtn = ISButton:new(btnStartX, y, btnW, btnH, "OK", self, DDSoundTileBox.onOK)
    self.okBtn:initialise()
    self.okBtn:instantiate()
    self:addChild(self.okBtn)

    self.cancelBtn = ISButton:new(btnStartX + btnW + btnSpacing, y, btnW, btnH, "Cancel", self, DDSoundTileBox.onCancel)
    self.cancelBtn:initialise()
    self.cancelBtn:instantiate()
    self:addChild(self.cancelBtn)

    self.soundEntry:focus()
end

function DDSoundTileBox:onTestSound()
    local soundName = (self.soundEntry:getText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if soundName == "" then
        local p = getSpecificPlayer(self.pid) or getPlayer()
        if p then p:Say("Enter a sound name first") end
        return
    end
    
    local player = getSpecificPlayer(self.pid) or getPlayer()
    if player then
        local emitter = player:getEmitter()
        if emitter then
            emitter:playSound(soundName)
        end
    end
end

function DDSoundTileBox:onOK()
    local p = getSpecificPlayer(self.pid) or getPlayer()
    local soundName = (self.soundEntry:getText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local range = tonumber(self.rangeEntry:getText() or "0") or 0
    local message = (self.messageEntry:getText() or ""):gsub("^%s+", ""):gsub("%s+$", "")

    if soundName == "" then
        if p then p:Say("Enter a valid sound name") end
        return
    end

    if range < 0 then range = 0 end

    local md = self.sq:getModData()
    md.ddSoundName = soundName
    md.ddSoundRange = range
    md.ddSoundMessage = message ~= "" and message or nil

    if self.sq.transmitModData then
        self.sq:transmitModData()
    elseif self.sq.transmitModdata then
        self.sq:transmitModdata()
    end

    local who = (p and p.getDisplayName and p:getDisplayName())
            or (p and p.getUsername and p:getUsername())
            or "Unknown"
    local sx, sy, sz = self.sq:getX(), self.sq:getY(), self.sq:getZ()

    local localtext
    if self.prev and self.prev.has then
        localtext = string.format(
            "%s has edited Sound Tile at %d, %d, %d: sound '%s' -> '%s', range %d -> %d",
            who, sx, sy, sz,
            tostring(self.prev.sound or ""), soundName,
            tonumber(self.prev.range) or 0, range
        )
    else
        localtext = string.format(
            "%s has created Sound Tile at %d, %d, %d with sound '%s' and range %d",
            who, sx, sy, sz, soundName, range
        )
    end

    sendClientCommand(p, 'ISLogSystem', 'writeLog', { loggerName = "soundtile", logText = localtext })

    self:close()
end

function DDSoundTileBox:onCancel()
    self:close()
end

function DDSoundTileBox:close()
    self:removeFromUIManager()
end

local function DD_OpenSoundTileBox(square, pid, title)
    local dlg = DDSoundTileBox:new(square, pid, title)
    dlg:initialise()
    dlg:addToUIManager()
end

local function squareHasSoundTile(sq)
    local md = sq and sq:getModData()
    return md and md.ddSoundName ~= nil
end

local function clearSquareSoundTile(sq)
    local md = sq:getModData()
    md.ddSoundName = nil
    md.ddSoundRange = nil
    md.ddSoundMessage = nil
    if sq.transmitModData then
        sq:transmitModData()
    elseif sq.transmitModdata then
        sq:transmitModdata()
    end
end

local function addSoundTileMenu(playerIdx, context, worldObjects, test)
    local player = getSpecificPlayer(playerIdx)
    if not isAdminOrDebug(player) then return end

    local sq
    for _, o in ipairs(worldObjects) do
        if o and o.getSquare then
            sq = o:getSquare()
            if sq then break end
        end
    end
    if not sq or not sq:getFloor() then return end

    local parent = context:addOption("Sound Tile", sq, nil)
    local sub = ISContextMenu:getNew(context)
    context:addSubMenu(parent, sub)

    if squareHasSoundTile(sq) then
        sub:addOption("Edit Sound Tile", sq, function(square)
            DD_OpenSoundTileBox(square, playerIdx, "Edit Sound Tile")
        end)
        sub:addOption("Remove Sound Tile", sq, function(square)
            local md = square:getModData()
            local soundName = md.ddSoundName or "Unknown"
            local range = md.ddSoundRange or 0
            local sx, sy, sz = square:getX(), square:getY(), square:getZ()

            local player = getPlayer()
            local who = (player.getDisplayName and player:getDisplayName())
                    or (player.getUsername and player:getUsername())
                    or "Unknown"

            local localtext = string.format(
                "%s has deleted Sound Tile at %d, %d, %d (sound: '%s', range: %d)",
                who, sx, sy, sz, soundName, range
            )

            clearSquareSoundTile(square)

            sendClientCommand(player, 'ISLogSystem', 'writeLog', { loggerName = "soundtile", logText = localtext })
        end)
    else
        sub:addOption("Make Sound Tile", sq, function(square)
            DD_OpenSoundTileBox(square, playerIdx, "Make Sound Tile")
        end)
    end
end

Events.OnFillWorldObjectContextMenu.Add(addSoundTileMenu)

local function updateSoundSquares()
    local p = getSpecificPlayer(0)
    if not p then return end

    if not isAdminOrDebug(p) then
        soundSquares = {}
        return
    end

    local cell = getCell()
    if not cell then return end

    local px, py, pz = math.floor(p:getX()), math.floor(p:getY()), math.floor(p:getZ())

    if math.abs(px - lastPlayerPos.x) < 1
            and math.abs(py - lastPlayerPos.y) < 1
            and pz == lastPlayerPos.z then
        return
    end

    lastPlayerPos = { x = px, y = py, z = pz }
    soundSquares = {}

    local radius = 35
    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local sq = cell:getGridSquare(x, y, pz)
            if sq then
                local md = sq:getModData()
                if md and md.ddSoundName then
                    table.insert(soundSquares, {
                        x = x,
                        y = y,
                        z = pz,
                        sq = sq
                    })
                end
            end
        end
    end
end

local function DrawSoundSquares(z)
    local p = getSpecificPlayer(0)
    if not p or not isAdminOrDebug(p) then return end

    for _, t in ipairs(soundSquares) do
        if t.z == z then
            local sprite = getSprite(SOUND_TILE_SPRITE)
            sprite:RenderGhostTileColor(t.x, t.y, t.z, 0, 0.8, 1, 0.4)
        end
    end
end

Events.OnPostFloorLayerDraw.Add(DrawSoundSquares)
Events.OnTick.Add(updateSoundSquares)

local DD_lastTileKeyByPID = {}

local function DD_ReadSquareSound(sq)
    if not sq then return nil end
    local md = sq:getModData()
    if md and md.ddSoundName then
        return {
            sound = md.ddSoundName,
            range = tonumber(md.ddSoundRange) or 0,
            message = md.ddSoundMessage or nil,
        }
    end
    return nil
end

Events.OnPlayerUpdate.Add(function(p)
    if not p then return end

    local pid = p:getOnlineID() or 0
    local x, y, z = math.floor(p:getX()), math.floor(p:getY()), p:getZ()
    local key = x .. "," .. y .. "," .. z

    if DD_lastTileKeyByPID[pid] == key then return end
    DD_lastTileKeyByPID[pid] = key

    local sq = p:getSquare()
    local info = DD_ReadSquareSound(sq)
    if not info then return end

    local args = {
        playerID = pid,
        soundName = info.sound,
        range = info.range,
        message = info.message,
        tileX = x,
        tileY = y,
        tileZ = z,
    }

    sendClientCommand("DLSoundTile", "triggerSoundTile", args)
end)

local function OnDLSoundTileServerCommand(module, command, args)
    if module ~= "DLSoundTile" then return end

    if command == "playSound" then
        local soundName = args.soundName
        local message = args.message
        
        if soundName and soundName ~= "" then
            local player = getPlayer()
            if player then
                local emitter = player:getEmitter()
                if emitter then
                    emitter:playSound(soundName)
                end
                
                if message and message ~= "" then
                    player:setHaloNote(message, 255, 255, 255, 300)
                end
            end
        end
    elseif command == "logTrigger" then
        local player = getPlayer()
        if player and args.logText then
            sendClientCommand(player, 'ISLogSystem', 'writeLog', { loggerName = "soundtile", logText = args.logText })
        end
    end
end

Events.OnServerCommand.Add(OnDLSoundTileServerCommand)
