function DeadlineDice_BuildCircleTilesFlat(cx, cy, r)
    local tiles = {}
    local inner = (r - 0.5) * (r - 0.5)
    local outer = (r + 0.5) * (r + 0.5)

    for x = cx - r, cx + r do
        for y = cy - r, cy + r do
            local dx = x - cx
            local dy = y - cy
            local d2 = dx*dx + dy*dy
            if d2 >= inner and d2 <= outer then
                tiles[#tiles+1] = x
                tiles[#tiles+1] = y
            end
        end
    end
    return tiles
end