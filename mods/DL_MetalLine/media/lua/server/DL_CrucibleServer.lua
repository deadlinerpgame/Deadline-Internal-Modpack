DL = DL or {}
DL.CrucibleServer = {}

local MAX_DIST_SQ = 16

local function recipients()
    local out = {}
    local ps = getOnlinePlayers and getOnlinePlayers()
    if ps and ps:size() > 0 then
        for i = 0, ps:size() - 1 do out[#out + 1] = ps:get(i) end
    elseif getPlayer and getPlayer() then
        out[1] = getPlayer()
    end
    return out
end

local function reply(player, command, args)
    sendServerCommand(player, DL.MODULE, command, args)
end

local function broadcast(sq, item)
    local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ(), id = item:getID(), st = item:getModData().DLCrucible }
    for _, p in ipairs(recipients()) do reply(p, "CrucibleState", args) end
end

local function resolveMelt(st)
    local total = st.solidUnits or 0
    local fr = {}
    for m, u in pairs(st.comp or {}) do fr[m] = (total > 0) and (u / total) or 0 end
    local lvl = st.mw or 0
    local r = DL.Resolver.resolve(fr, lvl)
    local ceiling = r.quality or 0
    local cap = math.floor(ceiling * DL.MW.capFrac(lvl) + 0.5)
    st.alloy = { id = r.id, name = r.name, color = r.color,
                 quality = math.min(math.floor(ceiling * DL.MW.startFrac(lvl)), cap), maxQuality = cap,
                 units = total, reTemp = DL.requiredTemp(st.comp), composition = fr,
                 gated = r.gated, gateLevel = r.gateLevel }
    st.phase = "molten"; st.comp = {}; st.solidUnits = 0
end

local function settle(st)
    for _ = 1, 4 do
        if not DL.Crucible.advance(st, DL.Crucible.now()) then return end
        resolveMelt(st)
    end
end

local function locate(player, args)
    if type(args) ~= "table" then return nil end
    local cell = getCell()
    local sq = cell and cell:getGridSquare(tonumber(args.x) or -1, tonumber(args.y) or -1, tonumber(args.z) or 0)
    if not sq then return nil end
    if math.floor(player:getZ()) ~= sq:getZ()
       or player:DistToSquared(sq:getX() + 0.5, sq:getY() + 0.5) > MAX_DIST_SQ then
        return nil
    end
    local wobj = DL.Crucible.findWorldCrucible(sq, tonumber(args.id))
    if not wobj then return nil end
    local item = wobj:getItem()
    local md = item:getModData()
    if type(md.DLCrucible) ~= "table" then md.DLCrucible = DL.Crucible.new() end
    return sq, item, md.DLCrucible
end

local H = {}

function H.Sync(player, args, item, st)
    settle(st)
end

function H.AddScrap(player, args, item, st)
    settle(st)
    local reg = DL.MetalContent[args.fullType]
    local count = math.max(0, math.floor(tonumber(args.count) or 0))
    local accepted = 0
    if reg and st.phase == "loading" then
        local room = DL.Crucible.capacity(item) - (st.solidUnits or 0)
        accepted = math.max(0, math.min(count, math.floor(room / reg.units + 1e-9)))
        if accepted > 0 then
            local units = accepted * reg.units
            for m, frac in pairs(reg.composition) do st.comp[m] = (st.comp[m] or 0) + units * frac end
            st.solidUnits = (st.solidUnits or 0) + units
        end
    end
    if accepted < count and args.fullType then
        reply(player, "CrucibleRefund", { fullType = args.fullType, count = count - accepted })
    end
    settle(st)
end

function H.AddFuel(player, args, item, st)
    settle(st)
    local f = DL.Fuel[args.fullType]
    if not f then return end
    st.fuelMin = math.min(DL.FUEL_CAP or 60, (st.fuelMin or 0) + f.minutes)
    st.fuelMaxTemp = math.max(st.fuelMaxTemp or 0, f.maxTemp)
end

function H.Light(player, args, item, st)
    settle(st)
    if st.lit or (st.fuelMin or 0) <= 0 then return end
    local lvl = math.max(0, math.min(DL.MW.MAX, math.floor(tonumber(args.mw) or 0)))
    st.lit = true
    st.mw = lvl
    st.heatScale = DL.MW.heatScale(lvl)
    st.refineScale = DL.MW.refineScale(lvl)
end

function H.Extinguish(player, args, item, st)
    settle(st)
    st.lit = false
end

function H.Retrieve(player, args, item, st)
    settle(st)
    if st.phase ~= "loading" or (st.solidUnits or 0) <= 0 then return end
    local out = DL.Crucible.unitsToScrap(st.comp)
    st.comp = {}; st.solidUnits = 0
    reply(player, "CrucibleGive", { items = out })
end

function H.Pour(player, args, item, st)
    settle(st)
    local a = st.alloy
    if st.phase ~= "molten" or not a or (a.units or 0) < 1 then return end
    a.units = a.units - 1
    reply(player, "CruciblePoured", { id = a.id, name = a.name, color = a.color, quality = a.quality,
                                      composition = a.composition,
                                      metals = DL.Crucible.metalCount(a.composition) })
    if (a.units or 0) < 1 then DL.Crucible.spillToLoading(st) end
end

local function onClientCommand(module, command, player, args)
    if module ~= DL.MODULE or not player then return end
    local name = string.match(command, "^Crucible(%a+)$")
    local handler = name and H[name]
    if not handler then return end
    local sq, item, st = locate(player, args)
    if not st then
        if name == "AddScrap" and type(args) == "table" and args.fullType and (tonumber(args.count) or 0) > 0 then
            reply(player, "CrucibleRefund", { fullType = args.fullType, count = math.floor(tonumber(args.count)) })
        end
        reply(player, "CrucibleGone", { x = args and args.x, y = args and args.y, z = args and args.z, id = args and args.id })
        return
    end
    handler(player, args, item, st)
    broadcast(sq, item)
end
Events.OnClientCommand.Add(onClientCommand)
