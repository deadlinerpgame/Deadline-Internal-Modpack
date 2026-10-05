DLSalvage = DLSalvage or {}

DLSalvage.KEY = "DLSalvaged"

DLSalvage.REQUIRE = {
    metalworking = 4,
    mechanics = 2,
    weldingMask = true,
    torchUses = 5,
}

function DLSalvage.isTorch(item)
    return item ~= nil
        and (item:hasTag("BlowTorch") or item:getType() == "BlowTorch")
        and item:getDrainableUsesInt() >= DLSalvage.REQUIRE.torchUses
end

function DLSalvage.isMask(item)
    return item:hasTag("WeldingMask") or item:getType() == "WeldingMask"
end

function DLSalvage.isSalvaged(vehicle)
    return vehicle:getModData()[DLSalvage.KEY] == true
end

function DLSalvage.setSalvaged(vehicle)
    vehicle:getModData()[DLSalvage.KEY] = true
end

function DLSalvage.pick(pool)
    local total = 0
    for _, entry in ipairs(pool) do
        total = total + entry[2]
    end
    local roll = ZombRand(total)
    for _, entry in ipairs(pool) do
        roll = roll - entry[2]
        if roll < 0 then
            return entry[1]
        end
    end
    return pool[#pool][1]
end
