
local function saveGameDateOnStartup()
    local gameTime = getGameTime() -- Get GameTime instance
    local timeInMillis = gameTime:getCalender():getTimeInMillis() -- Get timestamp

    -- Get in-game time
    local timeOfDay = gameTime:getTimeOfDay() -- Time as float (e.g., 14.75 for 14:45)
    local hours = math.floor(timeOfDay)
    local minutes = math.floor((timeOfDay - hours) * 60)

    -- Get in-game month and day
    local month = gameTime:getCalender():get(2) + 1  -- Months are 0-based (convert in JavaScript)
    local day = gameTime:getCalender():get(5)

    -- Define static year
    local year = 1997

    -- Append in-game date/time as raw values to server_start_time.txt
    local filePath = "logs/" .. "server_start_time.txt";
    local file = getFileWriter(filePath, true, false)
    file:write(string.format(" | In-Game Date: %d-%02d-%02d %02d:%02d\n", year, month, day, hours, minutes))
    file:close()
end

Events.OnGameStart.Add(saveGameDateOnStartup) -- Runs only once on server start