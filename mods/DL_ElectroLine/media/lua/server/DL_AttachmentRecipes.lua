-- A manufactured light contains no battery
require "recipecode"

function Recipe.OnCreate.DLEmptyGunLight(items, result, player)
    local md = result:getModData()
    md.JFA = md.JFA or {}
    md.JFA.Battery = 0
end
