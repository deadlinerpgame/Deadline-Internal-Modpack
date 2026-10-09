DL = DL or {}
DL.MODULE = "DL_MetalLine"

DL.Metals = {
    iron     = { name = "Iron",     color = {122,124,130}, tier = 3 },
    copper   = { name = "Copper",   color = {184,115, 51}, tier = 2 },
    aluminum = { name = "Aluminum", color = {209,211,214}, tier = 2 },
    tin      = { name = "Tin",      color = {188,193,199}, tier = 1 },
    zinc     = { name = "Zinc",     color = {164,174,180}, tier = 1 },
    lead     = { name = "Lead",     color = { 84, 84, 92}, tier = 1 },
    nickel   = { name = "Nickel",   color = {196,190,170}, tier = 3 },
    chromium = { name = "Chromium", color = {170,178,182}, tier = 3 },
    silver   = { name = "Silver",   color = {214,216,220}, tier = 2 },
    gold     = { name = "Gold",     color = {240,200, 70}, tier = 2 },
    titanium = { name = "Titanium", color = {140,146,152}, tier = 3 },
    carbon   = { name = "Carbon",   color = { 38, 38, 40}, tier = 0, additive = true },
}

local function s2l(c) c = c / 255; if c <= 0.04045 then return c / 12.92 else return ((c + 0.055) / 1.055) ^ 2.4 end end
local function l2s(c)
    if c <= 0.0031308 then c = c * 12.92 else c = 1.055 * (c ^ (1 / 2.4)) - 0.055 end
    local v = math.floor(c * 255 + 0.5)
    if v < 0 then v = 0 elseif v > 255 then v = 255 end
    return v
end

function DL.blendColor(comp)
    local r, g, b, tot = 0, 0, 0, 0
    for m, f in pairs(comp) do
        local md = DL.Metals[m]
        if md and f and f > 0 then
            r = r + s2l(md.color[1]) * f
            g = g + s2l(md.color[2]) * f
            b = b + s2l(md.color[3]) * f
            tot = tot + f
        end
    end
    if tot <= 0 then return {128,128,128} end
    return { l2s(r / tot), l2s(g / tot), l2s(b / tot) }
end

function DL.writeIngotData(item, result)
    local md = item:getModData()
    md.DL = {
        alloyId     = result.id,
        name        = result.name,
        rgb         = result.color,
        quality     = result.quality,
        composition = result.composition,
        stats       = result.stats or {},
    }
end
