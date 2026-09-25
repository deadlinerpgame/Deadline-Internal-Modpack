DL = DL or {}
DL.CrucibleClient = {}
local CC = DL.CrucibleClient

function CC.state(wobj)
    local item = wobj and wobj:getItem()
    local st = item and item:getModData().DLCrucible
    return type(st) == "table" and st or nil
end

function CC.isPlaced(wobj)
    local sq = wobj and wobj:getSquare()
    return sq ~= nil and sq:getWorldObjects():contains(wobj)
end

function CC.send(player, wobj, command, extra)
    local sq, item = wobj:getSquare(), wobj:getItem()
    if not sq or not item then return end
    local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ(), id = item:getID() }
    if extra then for k, v in pairs(extra) do args[k] = v end end
    sendClientCommand(player, DL.MODULE, "Crucible" .. command, args)
end

local function findLocal(args)
    local cell = getCell()
    local sq = cell and args and cell:getGridSquare(args.x or -1, args.y or -1, args.z or 0)
    return sq and DL.Crucible.findWorldCrucible(sq, args.id) or nil
end

local function openUIFor(wobj)
    local ui = DL_CrucibleUI and DL_CrucibleUI.instance
    if ui and wobj and ui.wobj == wobj then return ui end
    return nil
end

local H = {}

function H.CrucibleState(args, player)
    local wobj = findLocal(args)
    if not wobj or type(args.st) ~= "table" then return end
    wobj:getItem():getModData().DLCrucible = args.st
    local ui = openUIFor(wobj)
    if ui then ui.syncSent = nil end
end

function H.CrucibleRefund(args, player)
    local inv = player:getInventory()
    for _ = 1, math.max(0, math.floor(args.count or 0)) do inv:AddItem(args.fullType) end
end

function H.CrucibleGive(args, player)
    local inv = player:getInventory()
    for _, e in ipairs(args.items or {}) do
        for _ = 1, (e.count or 0) do inv:AddItem(e.type) end
    end
end

function H.CruciblePoured(args, player)
    local item = player:getInventory():AddItem(DL.ingotItemType(args))
    if item then
        DL.writeIngotData(item, { id = args.id, name = args.name, color = args.color,
                                  quality = args.quality, composition = args.composition })
        DL.applyIngotVisual(item)
    end
    DL.MW.addXP(player, 12 + 6 * ((args.metals or 1) - 1))
end

function H.CrucibleGone(args, player)
    local ui = DL_CrucibleUI and DL_CrucibleUI.instance
    if ui and ui.sx == args.x and ui.sy == args.y and ui.sz == args.z then ui:close() end
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= DL.MODULE then return end
    local h = H[command]
    local player = getPlayer()
    if h and player then h(args or {}, player) end
end)
