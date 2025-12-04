require "ISUI/ISContextMenu"
require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"

local function isAdminOrDebug(p)
    if not p then return false end
    local admin = (p.isAdmin and p:isAdmin()) or (p.getAccessLevel and p:getAccessLevel() ~= "None")
    local dbg   = (isDebugEnabled and isDebugEnabled()) or (getCore and getCore():getDebug())
    return admin or dbg
end

DDTransportBox = ISPanel:derive("DDTransportBox")

function DDTransportBox:new(square, pid, title)
    local w, h = 300, 190
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

    self.prev = {
        has  = md.ddTeleDest ~= nil,
        name = defName,
        x    = tonumber(dx) or dx or 0,
        y    = tonumber(dy) or dy or 0,
        z    = tonumber(dz) or dz or self.sq:getZ(),
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

    local btnW, btnH = 80, 24
    self.okBtn = ISButton:new(self.width - pad - btnW*2 - 6, y, btnW, btnH, "OK", self, DDTransportBox.onOK)
    self.okBtn:initialise(); self.okBtn:instantiate(); self:addChild(self.okBtn)

    self.cancelBtn = ISButton:new(self.width - pad - btnW, y, btnW, btnH, "Cancel", self, DDTransportBox.onCancel)
    self.cancelBtn:initialise(); self.cancelBtn:instantiate(); self:addChild(self.cancelBtn)

    self.nameEntry:focus()
end


function DDTransportBox:addModData( sx, sy, sz, x, y, z)
	ModData.request("TransportTile")
	local modTable = ModData.getOrCreate("TransportTile")
	local x1, y1, x2, y2, z1, x2 = sx, sy, sz, x, y, z
	local newEntry = {atX=x1, atY=y1, atZ=z1, toX=x2, toY=y2, toZ=z2}
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
    if not (name ~= "" and x and y and z) then
        if p then p:Say("Enter Name and valid X, Y, Z") end
        return
    end

    x, y, z = math.floor(x), math.floor(y), math.floor(z)

    -- write modData
    local md = self.sq:getModData()
    md.ddTeleName = name
    md.ddTeleDest = { x = x, y = y, z = z }

    if self.sq.transmitModData then
        self.sq:transmitModData()
    elseif self.sq.transmitModdata then
        self.sq:transmitModdata()
    end

    local who = (p and p.getDisplayName and p:getDisplayName())
             or (p and p.getUsername and p:getUsername())
    local sx, sy, sz = self.sq:getX(), self.sq:getY(), self.sq:getZ()

    local localtext
    DDTransportBox:addModData(sx, sy, sz, x, y, z)
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

