require "ISUI/ISContextMenu"
require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"



local spriteOptions = {
    { name = "None", path = nil },
    { name = "Ladder Down", path = 'media/ui/spriteladderdown.png' },
    { name = "Ladder Up", path = 'media/ui/spriteladderup.png' },
    { name = "Stairs Down", path = 'media/ui/spritestairsdown.png' },
    { name = "Stairs Up", path = 'media/ui/spritestairsup.png' },
    { name = "Tunnel", path = 'media/ui/spritetunnel.png' },
}


local transportSquares = {}
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
    local admin = (p.isAdmin and p:isAdmin()) or (p.getAccessLevel and p:getAccessLevel() ~= "None")
    local dbg   = (isDebugEnabled and isDebugEnabled()) or (getCore and getCore():getDebug())
    return admin or dbg
end

DDTransportBox = ISPanel:derive("DDTransportBox")

function DDTransportBox:new(square, pid, title)
    local w, h = 250, 310
    local sx, sy = getCore():getScreenWidth(), getCore():getScreenHeight()
    local o = ISPanel.new(self, sx/2 - w/2, sy/2 - h/2, w, h)
    o.backgroundColor = { r=0, g=0, b=0, a=0.85 }
    o.borderColor     = { r=1, g=1, b=1, a=0.9  }
    o.moveWithMouse   = true
    o.sq  = square
    o.pid = pid or 0
    o.title = title or "Make Transport Tile"
    return o
end

function DDTransportBox:initialise()
    ISPanel.initialise(self)

    local md  = self.sq:getModData()
    local defName = md.ddTeleName or ""
    local dx = (md.ddTeleDest and md.ddTeleDest.x) or 0
    local dy = (md.ddTeleDest and md.ddTeleDest.y) or 0
    local dz = (md.ddTeleDest and md.ddTeleDest.z) or 0
    local dr = md.ddTeleR or 0
    local dg = md.ddTeleG or 1
    local db = md.ddTeleB or 0
    local sprite = md.ddTeleSprite or nil

    self.prev = {
        has  = md.ddTeleDest ~= nil,
        name = defName,
        x    = tonumber(dx) or dx or 0,
        y    = tonumber(dy) or dy or 0,
        z    = tonumber(dz) or dz or self.sq:getZ(),
        r    = tonumber(dr) or dr or 0,
        g    = tonumber(dg) or dg or 1,
        b    = tonumber(db) or db or 0,
        sprite = md.ddTeleSprite or nil,
    }

    local pad, rowH = 10, 24
    local y = 8

    self:addChild(ISLabel:new(pad, y, 20, self.title, 1,1,1,1, UIFont.Small, true))
    y = y + 22

    self:addChild(ISLabel:new(pad + 35, y, rowH, "Name:", 1,1,1,1, UIFont.Small, false))
    self.nameEntry = ISTextEntryBox:new(tostring(defName), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.nameEntry:initialise(); self.nameEntry:instantiate(); self:addChild(self.nameEntry)
    y = y + rowH + 6

    self:addChild(ISLabel:new(pad + 35, y, rowH, "X:", 1,1,1,1, UIFont.Small, false))
    self.xEntry = ISTextEntryBox:new(tostring(dx), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.xEntry:initialise(); self.xEntry:instantiate(); self:addChild(self.xEntry)
    y = y + rowH + 6

    self:addChild(ISLabel:new(pad + 35, y, rowH, "Y:", 1,1,1,1, UIFont.Small, false))
    self.yEntry = ISTextEntryBox:new(tostring(dy), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.yEntry:initialise(); self.yEntry:instantiate(); self:addChild(self.yEntry)
    y = y + rowH + 6

    self:addChild(ISLabel:new(pad + 35, y, rowH, "Z:", 1,1,1,1, UIFont.Small, false))
    self.zEntry = ISTextEntryBox:new(tostring(dz), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.zEntry:initialise(); self.zEntry:instantiate(); self:addChild(self.zEntry)
    y = y + rowH + 10

    -- SPRITE DROPDOWN
    self:addChild(ISLabel:new(pad + 35, y, rowH, "Sprite:", 1,1,1,1, UIFont.Small, false))

    self.spriteCombo = ISComboBox:new(pad + 60, y, self.width - pad*2 - 60, rowH, self, nil)
    self.spriteCombo:initialise()
    self.spriteCombo:instantiate()

    -- Populate dropdown
    local selectedIndex = 1
    local currentSprite = md.ddTeleSprite

    for i, opt in ipairs(spriteOptions) do
        self.spriteCombo:addOption(opt.name)
        if currentSprite == opt.path then
            selectedIndex = i
        end
    end

    self.spriteCombo.selected = selectedIndex
    self:addChild(self.spriteCombo)

    y = y + rowH + 6

    self:addChild(ISLabel:new(pad + 35, y, rowH, "R (0-1):", 1,1,1,1, UIFont.Small, false))
    self.rEntry = ISTextEntryBox:new(tostring(dr), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.rEntry:initialise(); self.rEntry:instantiate(); self:addChild(self.rEntry)
    y = y + rowH + 6

    self:addChild(ISLabel:new(pad + 35, y, rowH, "G (0-1):", 1,1,1,1, UIFont.Small, false))
    self.gEntry = ISTextEntryBox:new(tostring(dg), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.gEntry:initialise(); self.gEntry:instantiate(); self:addChild(self.gEntry)
    y = y + rowH + 6

    self:addChild(ISLabel:new(pad + 35, y, rowH, "B (0-1):", 1,1,1,1, UIFont.Small, false))
    self.bEntry = ISTextEntryBox:new(tostring(db), pad+50, y-2, self.width - pad*2 - 50, rowH)
    self.bEntry:initialise(); self.bEntry:instantiate(); self:addChild(self.bEntry)
    y = y + rowH + 10

    local btnW, btnH = 80, 24
    self.okBtn = ISButton:new(self.width - pad - btnW*2 - 6, y, btnW, btnH, "OK", self, DDTransportBox.onOK)
    self.okBtn:initialise(); self.okBtn:instantiate(); self:addChild(self.okBtn)

    self.cancelBtn = ISButton:new(self.width - pad - btnW, y, btnW, btnH, "Cancel", self, DDTransportBox.onCancel)
    self.cancelBtn:initialise(); self.cancelBtn:instantiate(); self:addChild(self.cancelBtn)

    self.nameEntry:focus()
end


function DDTransportBox:addModData( sx, sy, sz, x, y, z, r, g, b, sprite)
	ModData.request("TransportTile")
	local modTable = ModData.getOrCreate("TransportTile")
	local x1, y1, x2, y2, z1, z2 = sx, sy, sz, x, y, z
    local r1, g1, b1 = r, g, b
    local nsprite = sprite
	local newEntry = {atX=x1, atY=y1, atZ=z1, toX=x2, toY=y2, toZ=z2, R=r1, G=g1, B=b1, sprite=sprite}
	modTable[text] = newEntry;
	ModData.add("TransportTile", modTable)
	ModData.transmit("TransportTile")
    ModData.request("TransportTile")
end


function DDTransportBox:onOK()
    local p   = getSpecificPlayer(self.pid) or getPlayer()
    local name= (self.nameEntry:getText() or ""):gsub("^%s+",""):gsub("%s+$","")
    local x   = tonumber(self.xEntry:getText() or "")
    local y   = tonumber(self.yEntry:getText() or "")
    local z   = tonumber(self.zEntry:getText() or "")
    local r   = tonumber(self.rEntry:getText() or "")
    local g   = tonumber(self.gEntry:getText() or "")
    local b   = tonumber(self.bEntry:getText() or "")
    if not (name ~= "" and x and y and z) then
        if p then p:Say("Enter Name and valid X, Y, Z") end
        return
    end

    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    
    -- write modData
    local md = self.sq:getModData()
    md.ddTeleName = name
    md.ddTeleDest = { x = x, y = y, z = z }
    md.ddTeleR = r
    md.ddTeleG = g
    md.ddTeleB = b

    local chosen = self.spriteCombo:getOptionText(self.spriteCombo.selected)
    
    for _, opt in ipairs(spriteOptions) do
        if opt.name == chosen then
            md.ddTeleSprite = opt.path
            break
        end
    end

    if self.sq.transmitModData then
        self.sq:transmitModData()
    elseif self.sq.transmitModdata then
        self.sq:transmitModdata()
    end

    local who = (p and p.getDisplayName and p:getDisplayName())
             or (p and p.getUsername and p:getUsername())
    local sx, sy, sz = self.sq:getX(), self.sq:getY(), self.sq:getZ()

    local localtext
    DDTransportBox:addModData(sx, sy, sz, x, y, z, r, g, b)
            print(sx)
        print(sy)
    if self.prev and self.prev.has then

        localtext = string.format(
            "%s has edited the Transport Tile at Location %d, %d, %d: name '%s' -> '%s', leads %d, %d, %d -> %d, %d, %d",
            who, sx, sy, sz,
            tostring(self.prev.name or ""), tostring(name),
            tonumber(self.prev.x) or 0, tonumber(self.prev.y) or 0, tonumber(self.prev.z) or sz,
            x, y, z
        )
    else

        localtext = string.format(
            "%s has created the Transport Tile with name: %s at Location %d, %d, %d that leads to %d, %d, %d",
            who, tostring(name), sx, sy, sz, x, y, z
        )
    end

    sendClientCommand(p, 'ISLogSystem', 'writeLog', { loggerName = "admin", logText = localtext })

    self:close()
end

function DDTransportBox:onCancel() self:close() end
function DDTransportBox:close() self:removeFromUIManager() end

local function DD_OpenTransportBox(square, pid, title)
    local dlg = DDTransportBox:new(square, pid, title)
    dlg:initialise()
    dlg:addToUIManager()
end

local function squareHasTransport(sq)
    local md = sq and sq:getModData()
    return md and md.ddTeleDest ~= nil
end

local function clearSquareTransport(sq)
    local md = sq:getModData()
    md.ddTeleName = nil
    md.ddTeleDest = nil
    md.ddTeleSprite = nil
    if sq.transmitModData then
        sq:transmitModData()
    elseif sq.transmitModdata then
        sq:transmitModdata()
    end
end

local function addTransportMenu(playerIdx, context, worldObjects, test)
    local player = getSpecificPlayer(playerIdx)
    if not isAdminOrDebug(player) then return end

    local sq
    for _, o in ipairs(worldObjects) do
        if o and o.getSquare then sq = o:getSquare(); if sq then break end end
    end
    if not sq or not sq:getFloor() then return end

    local parent = context:addOption("Transport", sq, nil)
    local sub    = ISContextMenu:getNew(context)
    context:addSubMenu(parent, sub)

    if squareHasTransport(sq) then
        sub:addOption("Edit Transport Tile", sq, function(square)
            DD_OpenTransportBox(square, playerIdx, "Edit Transport Tile")
        end)
        sub:addOption("Remove Transport Tile", sq, function(square)
            local md = square:getModData()

            local name = md.ddTeleName or "Transport"
            local dest = md.ddTeleDest or {}
            local dx = tonumber(dest.x) or dest.x or 0
            local dy = tonumber(dest.y) or dest.y or 0
            local dz = tonumber(dest.z) or dest.z or square:getZ()

            local sx, sy, sz = square:getX(), square:getY(), square:getZ()

            local player = getPlayer()
            local who = (player.getDisplayName and player:getDisplayName()) or (player.getUsername and player:getUsername()) or "Unknown"

            local localtext = string.format(
                "%s has deleted the Transport Tile with name: %s at Location %d, %d, %d that leads to %d, %d, %d",
                who, tostring(name), sx, sy, sz, dx, dy, dz
            )

            clearSquareTransport(square)

            sendClientCommand(player, 'ISLogSystem', 'writeLog', { loggerName = "admin", logText = localtext })
        end)
    else
        sub:addOption("Make Transport Tile", sq, function(square)
            DD_OpenTransportBox(square, playerIdx, "Make Transport Tile")
        end)
    end
end

Events.OnFillWorldObjectContextMenu.Add(addTransportMenu)



local function requestModData()
	local TransportTile = ModData.getOrCreate("TransportTile")
	if TransportTile == nil then 
		ModData.request("TransportTile")
		TransportTile = ModData.get("TransportTile")
	end
end

local function syncTiles()
    ModData.request("TransportTile")
end

Events.EveryOneMinute.Add(requestModData)
Events.OnConnected.Add(syncTiles)


local function updateTransportSquares()
    local p = getSpecificPlayer(0)
    if not p then return end
    
    local cell = getCell()
    if not cell then return end
    
    local px, py, pz = math.floor(p:getX()), math.floor(p:getY()), math.floor(p:getZ())
    
    if math.abs(px - lastPlayerPos.x) < 1 
       and math.abs(py - lastPlayerPos.y) < 1
       and pz == lastPlayerPos.z then
        return
    end
    
    lastPlayerPos = { x = px, y = py, z = pz }
    transportSquares = {}
    
    local radius = 35
    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local sq = cell:getGridSquare(x, y, pz)
            if sq then
                local md = sq:getModData()
                if md and md.ddTeleDest then
                    table.insert(transportSquares, {
                        x = x, y = y, z = pz,
                        sprite = md.ddTeleSprite,
                        r = md.ddTeleR or 0,
                        g = md.ddTeleG or 1,
                        b = md.ddTeleB or 0,
                        sq = sq
                    })
                end
            end
        end
    end
end

local function DrawTeleportSquares(z)
    for _, t in ipairs(transportSquares) do
        if t.z == z then
            if t.sprite then
                local sprite = getSprite(t.sprite)
                sprite:RenderGhostTileColor(t.x, t.y, t.z, t.r, t.g, t.b, 0.2)
            else
                local floor = t.sq:getFloor()
                if floor then
                    floor:setHighlightColor(0, 1, 0, 0.5)
                    floor:setHighlighted(true)
                end
            end
        end
    end
end

Events.OnPostFloorLayerDraw.Add(DrawTeleportSquares)
Events.OnTick.Add(updateTransportSquares)