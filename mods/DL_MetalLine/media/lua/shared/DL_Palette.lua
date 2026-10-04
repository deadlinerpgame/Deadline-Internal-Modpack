DL = DL or {}
DL.Palette = {
    { id = "C01", rgb = {38, 38, 40} },
    { id = "C02", rgb = {70, 68, 66} },
    { id = "C03", rgb = {84, 84, 92} },
    { id = "C04", rgb = {150, 120, 80} },
    { id = "C05", rgb = {122, 124, 130} },
    { id = "C06", rgb = {184, 115, 51} },
    { id = "C07", rgb = {205, 127, 50} },
    { id = "C08", rgb = {140, 146, 152} },
    { id = "C09", rgb = {180, 150, 130} },
    { id = "C10", rgb = {210, 150, 90} },
    { id = "C11", rgb = {181, 166, 66} },
    { id = "C12", rgb = {164, 174, 180} },
    { id = "C13", rgb = {190, 170, 150} },
    { id = "C14", rgb = {232, 180, 150} },
    { id = "C15", rgb = {196, 190, 170} },
    { id = "C16", rgb = {240, 200, 70} },
    { id = "C17", rgb = {228, 210, 140} },
    { id = "C18", rgb = {209, 211, 214} },
    { id = "C19", rgb = {230, 228, 214} },
}

function DL.nearestBucket(rgb)
    if not rgb then return DL.Palette[1].id end
    local best, bestd = DL.Palette[1].id, math.huge
    for _, p in ipairs(DL.Palette) do
        local dr, dg, db = p.rgb[1]-rgb[1], p.rgb[2]-rgb[2], p.rgb[3]-rgb[3]
        local d = 0.30*dr*dr + 0.59*dg*dg + 0.11*db*db
        if d < bestd then bestd, best = d, p.id end
    end
    return best
end

function DL.bucketItemType(rgb)
    return (DL.MODULE or "DL_MetalLine") .. ".AlloyIngot_" .. DL.nearestBucket(rgb)
end

