local SafeLayout = {}

function SafeLayout.calculate(playerNum, height)
    playerNum = playerNum or 0
    local left = getPlayerScreenLeft(playerNum) + 4
    local top = getPlayerScreenTop(playerNum) + 4
    local right = getPlayerScreenLeft(playerNum) + getPlayerScreenWidth(playerNum) - 4
    local bottom = getPlayerScreenTop(playerNum) + getPlayerScreenHeight(playerNum) - 4
    local y = bottom - height
    return { x = left, y = math.max(top, y), width = math.max(1, right - left), height = height, bottom = bottom }
end

return SafeLayout
