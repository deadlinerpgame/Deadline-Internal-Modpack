DLSalvage = DLSalvage or {}

DLSalvage.KEY = "DLSalvaged"

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
