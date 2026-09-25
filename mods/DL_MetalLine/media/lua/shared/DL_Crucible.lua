DL = DL or {}
DL.Crucible = {}

function DL.Crucible.now()
    return getGameTime() and getGameTime():getWorldAgeHours() or 0
end

function DL.Crucible.new(now)
    return {
        phase       = "loading",
        comp        = {},
        solidUnits  = 0,
        temp        = 0,
        fuelMin     = 0,
        fuelMaxTemp = 0,
        lit         = false,
        lastUpdate  = now or DL.Crucible.now(),
        junk        = 0,
    }
end

local function approach(cur, target, delta)
    cur = cur or 0
    if cur < target then return math.min(cur + delta, target)
    elseif cur > target then return math.max(cur - delta, target)
    else return cur end
end

local function meltReady(state)
    return state.phase == "loading" and DL.hasMeltableMetal(state.comp)
        and (state.solidUnits or 0) >= 1.0 - 1e-9
        and (state.temp or 0) >= DL.requiredTemp(state.comp)
end
DL.Crucible.meltReady = meltReady

function DL.Crucible.advance(state, now, heatScale, refineScale)
    now = now or DL.Crucible.now()
    heatScale = heatScale or state.heatScale or 1
    refineScale = refineScale or state.refineScale or 1
    local last = state.lastUpdate or now
    if meltReady(state) then return true end
    local dtMin = (now - last) * 60
    if dtMin <= 0 then return false end

    local burn = 0
    if state.lit and (state.fuelMin or 0) > 0 then
        burn = math.min(state.fuelMin, dtMin)
        state.fuelMin = state.fuelMin - burn
        state.temp = approach(state.temp, math.min(state.fuelMaxTemp or 0, DL.MAX_TEMP), DL.HEAT_RATE * heatScale * burn)
        if state.phase == "slug" and state.alloy and state.temp >= (state.alloy.reTemp or 999) then
            state.phase = "molten"
        end
        if state.phase == "molten" and state.alloy and (state.alloy.maxQuality or 0) > (state.alloy.quality or 0) then
            state.alloy.quality = approach(state.alloy.quality or 0, state.alloy.maxQuality, DL.REFINE_RATE * refineScale * burn)
        end
        if state.fuelMin <= 0 then state.fuelMin = 0; state.fuelMaxTemp = 0; state.lit = false end
        if meltReady(state) then
            state.lastUpdate = last + burn / 60
            return true
        end
    else
        state.lit = false
    end

    local rest = dtMin - burn
    if rest > 0 then state.temp = approach(state.temp, DL.AMBIENT, DL.COOL_RATE * rest) end
    if (state.temp or 0) > DL.MAX_TEMP then state.temp = DL.MAX_TEMP end
    if state.phase == "molten" and (state.temp or 0) < DL.SOLIDUS then state.phase = "slug" end
    state.lastUpdate = now
    return false
end

local function deepcopy(t)
    if type(t) ~= "table" then return t end
    local r = {}
    for k, v in pairs(t) do r[k] = deepcopy(v) end
    return r
end
DL.Crucible.copy = deepcopy

function DL.Crucible.peek(st, now)
    if type(st) ~= "table" then return nil end
    local c = deepcopy(st)
    if DL.Crucible.advance(c, now) then c.meltPending = true end
    return c
end

function DL.Crucible.isHot(st)
    local p = DL.Crucible.peek(st)
    if not p then return false end
    return p.lit == true or p.meltPending == true or p.phase == "molten" or (p.temp or 0) > (DL.WARM_TEMP or 5)
end

function DL.Crucible.isCrucibleItem(item)
    return item ~= nil and item.hasTag ~= nil and item:hasTag(DL.CRUCIBLE_TAG or "DLCrucible")
end

function DL.Crucible.capacity(item)
    local ft = item and item.getFullType and item:getFullType()
    return (ft and DL.CrucibleCapacity and DL.CrucibleCapacity[ft]) or DL.CRUCIBLE_CAP or 4
end

function DL.Crucible.findWorldCrucible(sq, id)
    if not sq then return nil end
    local wos = sq:getWorldObjects()
    if not wos then return nil end
    local only, n = nil, 0
    for i = 0, wos:size() - 1 do
        local w = wos:get(i)
        local it = w and w:getItem()
        if DL.Crucible.isCrucibleItem(it) then
            if id ~= nil and it:getID() == id then return w end
            only, n = w, n + 1
        end
    end
    if n == 1 then return only end
    return nil
end

function DL.Crucible.spillToLoading(st)
    local a = st.alloy
    st.comp = {}
    if a and (a.units or 0) > 1e-6 and a.composition then
        for m, frac in pairs(a.composition) do st.comp[m] = (frac or 0) * a.units end
        st.solidUnits = a.units
    else
        st.solidUnits = 0
    end
    st.alloy = nil
    st.phase = "loading"
end

function DL.Crucible.metalCount(comp)
    local n = 0
    for _, f in pairs(comp or {}) do if (f or 0) > 0 then n = n + 1 end end
    return n
end

function DL.Crucible.hasFireSource(ch)
    local inv = ch:getInventory()
    for _, t in ipairs(DL.FIRE_SOURCES or {}) do
        if inv:getFirstTypeRecurse(t) then return true end
    end
    return false
end

function DL.Crucible.findKindling(ch)
    local inv = ch:getInventory()
    for _, t in ipairs(DL.KINDLING or {}) do
        local it = inv:getFirstTypeRecurse(t)
        if it then return it end
    end
    return nil
end

function DL.Crucible.findIngotMold(ch)
    local inv = ch and ch:getInventory()
    return inv and inv:getFirstTagRecurse("DLIngotMold") or nil
end

function DL.Crucible.unitsToScrap(comp)
    local out = {}
    for m, u in pairs(comp or {}) do
        local md = DL.Metals[m]
        if md and u and u > 0 then
            local rem = math.floor(u / 0.05 + 0.5) * 0.05
            local nL = math.floor(rem / 0.5 + 1e-9); rem = rem - nL * 0.5
            local nM = math.floor(rem / 0.25 + 1e-9); rem = rem - nM * 0.25
            local nS = math.floor(rem / 0.05 + 0.5)
            local base = "DL_MetalLine.Scrap_" .. md.name .. "_"
            if nL > 0 then out[#out + 1] = { type = base .. "L", count = nL } end
            if nM > 0 then out[#out + 1] = { type = base .. "M", count = nM } end
            if nS > 0 then out[#out + 1] = { type = base .. "S", count = nS } end
        end
    end
    return out
end
