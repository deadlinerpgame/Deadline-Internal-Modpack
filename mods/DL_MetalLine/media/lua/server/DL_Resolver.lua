DL = DL or {}
DL.Resolver = {}

local ALLOY_FILES = { "DL_MetalLine_alloys.txt", "DL_MetalLine_alloys.json" }

local cfg = nil

local function readFile(name)
    local r = getFileReader(name, false)
    if not r then return nil end
    local lines, line = {}, r:readLine()
    while line ~= nil do lines[#lines+1] = line; line = r:readLine() end
    r:close()
    return table.concat(lines, "\n")
end

function DL.Resolver.load()
    local txt, used = nil, nil
    for i = 1, #ALLOY_FILES do
        txt = readFile(ALLOY_FILES[i])
        if txt then used = ALLOY_FILES[i] break end
    end
    if not txt then
        print("[DL_MetalLine] alloy table NOT FOUND in Zomboid/Lua/ (tried "
            .. table.concat(ALLOY_FILES, ", ") .. "). Melts will return slag until deployed.")
        cfg = nil
        return false
    end
    local data, perr = DL.JSON.decode(txt)
    if not data or not data.alloys then
        print("[DL_MetalLine] alloy table parse error in "..tostring(used)..": "..tostring(perr))
        cfg = nil
        return false
    end
    cfg = data
    print("[DL_MetalLine] loaded "..tostring(#cfg.alloys).." alloys from "..tostring(used))
    return true
end

local function matches(comp, a)
    local listed = 0
    for metal, rng in pairs(a.ranges) do
        local f = comp[metal] or 0
        if f < rng[1] or f > rng[2] then return false end
        listed = listed + f
    end
    if (1 - listed) > (a.impurityTolerance or 0) then return false end
    return true
end

local function specificity(a)
    local n = 0
    for _ in pairs(a.ranges) do n = n + 1 end
    return n
end

local function quality(comp, a)
    local sum, n = 0, 0
    for metal, rng in pairs(a.ranges) do
        local f    = comp[metal] or 0
        local mid  = (rng[1] + rng[2]) / 2
        local half = math.max((rng[2] - rng[1]) / 2, 1e-6)
        local closeness = 1 - math.min(math.abs(f - mid) / half, 1)
        sum = sum + closeness; n = n + 1
    end
    local center = (n > 0) and (sum / n) or 0
    local listed = 0
    for metal in pairs(a.ranges) do listed = listed + (comp[metal] or 0) end
    local impurity = math.max(0, 1 - listed)
    local q = (center * 0.85 + 0.15) * (1 - impurity)
    q = math.floor(q * 100 + 0.5)
    if q < 0 then q = 0 elseif q > 100 then q = 100 end
    return q
end

local function dominant(comp)
    local bm, bf = nil, 0
    for m, f in pairs(comp) do if f > bf then bm, bf = m, f end end
    return bm, bf
end

function DL.Resolver.resolve(comp, mwLevel)
    mwLevel = tonumber(mwLevel) or DL.MW.COMPLEX_LEVEL
    if not cfg then DL.Resolver.load() end
    if not cfg then
        return { id = "slag", name = "Slag Ingot", color = {70,68,66}, quality = 0, composition = comp, stats = {} }
    end

    local best, bestSpec, bestPrio = nil, -1, -1
    local gatedSeen = false
    for _, a in ipairs(cfg.alloys) do
        if matches(comp, a) then
            local sp, pr = specificity(a), (a.priority or 0)
            if sp >= 3 and mwLevel < DL.MW.COMPLEX_LEVEL then
                gatedSeen = true
            elseif sp > bestSpec or (sp == bestSpec and pr > bestPrio) then
                best, bestSpec, bestPrio = a, sp, pr
            end
        end
    end

    if best then
        return {
            id          = best.id,
            name        = best.name,
            color       = best.color or DL.blendColor(comp),
            quality     = quality(comp, best),
            composition = comp,
            stats       = best.stats or {},
        }
    end

    local dm, df = dominant(comp)

    local pure = (cfg.settings and cfg.settings.pureThreshold) or 0.98
    if dm and df >= pure and DL.Metals[dm] then
        return {
            id          = dm,
            name        = DL.Metals[dm].name .. " Ingot",
            color       = DL.blendColor(comp),
            quality     = 100,
            composition = comp,
            stats       = {},
            gated       = gatedSeen,
            gateLevel   = DL.MW.COMPLEX_LEVEL,
        }
    end

    local pt = (cfg.settings and cfg.settings.purityThreshold) or 0.85
    if dm and df >= pt and DL.Metals[dm] then
        local suffix = (cfg.settings and cfg.settings.impureSuffix) or " (Impure)"
        return {
            id          = dm .. "_impure",
            name        = DL.Metals[dm].name .. " Ingot" .. suffix,
            color       = DL.blendColor(comp),
            quality     = math.floor(df * 60),
            composition = comp,
            stats       = {},
            gated       = gatedSeen,
            gateLevel   = DL.MW.COMPLEX_LEVEL,
        }
    end

    local sl = (cfg.settings and cfg.settings.slag) or { id = "slag", name = "Slag Ingot", color = {70,68,66}, stats = {} }
    return { id = sl.id, name = sl.name, color = sl.color or {70,68,66}, quality = 0, composition = comp,
             stats = sl.stats or {}, gated = gatedSeen, gateLevel = DL.MW.COMPLEX_LEVEL }
end
