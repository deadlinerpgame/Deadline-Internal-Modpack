DeadlineDice = DeadlineDice or {}

ISDeadlineDiceUI = ISCollapsableWindow:derive("ISDeadlineDiceUI");


--************************************************************************--
--** ISDeadlineDiceUI:initialise
--**
--************************************************************************--
function ISDeadlineDiceUI:createLabelWithButton(yPos, labelText)
    local label = ISLabel:new(10, yPos, 10, labelText, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(label)

    local button = ISButton:new(label.x + 350, label.y - 10, 30, 30, "", self,
        function() self:getScore(labelText) end)
    button:initialise()
    button:instantiate()
    button:setImage(getTexture("media/ui/dice.png"))
    button.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    button.tooltip = "Roll dice for: " .. labelText
    self:addChild(button)

    table.insert(self.buttons, { label = label, button = button })
end



function ISDeadlineDiceUI:getEditedLabel(labelText)
    local editedLabel = string.gsub(labelText, "%s", "")   -- Remove spaces
    editedLabel = string.gsub(editedLabel, "[()%(%)]", "") -- Remove parentheses
    editedLabel = string.gsub(editedLabel, "-", "")        -- Remove hyphens
    editedLabel = string.gsub(editedLabel, "/", "")        -- Remove slashes
    return editedLabel
end

function ISDeadlineDiceUI:createChildren()
    self.buttons = {}
    self.healthButtons = {}
    self.sayQueue = {}
    local y = 40
    local f = 0.8

    ISCollapsableWindow.createChildren(self)

    -- Add hit points bars and buttons and labels

    self.minusButton = ISButton:new(27, 30, 30, 30, "-", self,
        function() self:decreaseHitPoints() end)
    self.minusButton:initialise()
    self.minusButton:instantiate()
    self.minusButton.tooltip = "Decrease Hit Points"
    self.minusButton:setBackgroundRGBA(0.5, 0, 0, 1)             -- Red background
    self.minusButton:setBorderRGBA(1, 0, 0, 1)                   -- Red border
    self.minusButton:setBackgroundColorMouseOverRGBA(1, 0, 0, 1) -- Light red background on mouse-over
    self:addChild(self.minusButton)
    table.insert(self.healthButtons, self.minusButton)

    self.plusButton = ISButton:new(self.minusButton.x + 258, 30, 30, 30, "+", self,
        function() self:increaseHitPoints() end)
    self.plusButton:initialise()
    self.plusButton:instantiate()
    self.plusButton.tooltip = "Increase Hit Points"
    self.plusButton:setBackgroundRGBA(0, 0.5, 0, 1)             -- Green background
    self.plusButton:setBorderRGBA(0, 1, 0, 1)                   -- Green border
    self.plusButton:setBackgroundColorMouseOverRGBA(0, 1, 0, 1) -- Light green background on mouse-over
    self:addChild(self.plusButton)
    table.insert(self.healthButtons, self.plusButton)

    -- Create hit points label
    self.hitPointsLabel = ISLabel:new(0, 40, 10, "Hit point tracker: ",
        1, 1, 1, 1, UIFont.NewLarge, true)
    self:addChild(self.hitPointsLabel)
    self:adjustHitPointsLabelPosition()

    self.resetButton = ISButton:new(322, 30, 30, 30, "Reset", self,
        function() self:resetHitPoints() end)
    self.resetButton:initialise()
    self.resetButton:instantiate()
    self.resetButton.tooltip = "Reset Hit Points"
    self.resetButton:setBackgroundRGBA(0.5, 0.5, 0.5, 1)                  -- Gray background
    self.resetButton:setBorderRGBA(0.5, 0.5, 0.5, 1)                      -- Gray border
    self.resetButton:setBackgroundColorMouseOverRGBA(0.75, 0.75, 0.75, 1) -- Light Gray background on mouse-over
    self:addChild(self.resetButton)
    table.insert(self.healthButtons, self.resetButton)

    -- Calculate position for hit points bars
    if getPlayer():HasTrait("Sturdy") then
        numBars = 14
        barWidth = 20
        barHeight = 10
        barSpacing = 5
    elseif getPlayer():HasTrait("Fragile") then
        numBars = 10
        barWidth = 30
        barHeight = 10
        barSpacing = 5
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") then
        numBars = 12
        barWidth = 25
        barHeight = 10
        barSpacing = 5
    end

    local totalWidth = numBars * (barWidth + barSpacing) - barSpacing
    local startX = (self.width - totalWidth) / 2
    local yPos = self.hitPointsLabel:getBottom() + 20

    self.hitPointsBars = {}
    for i = 1, numBars do
        local x = startX + (i - 1) * (barWidth + barSpacing)
        local progressBar = ISUIElement:new(x, yPos, barWidth, barHeight)
        progressBar:setAnchorLeft(true)
        progressBar:setAnchorRight(true)
        progressBar:setAnchorTop(true)
        progressBar:setAnchorBottom(true)
        progressBar:setVisible(true)
        self:addChild(progressBar)
        table.insert(self.hitPointsBars, progressBar)
    end

    y = yPos + barHeight + 40

    -- Calculate the height of the initiative tracker border based on the number of items
    local numInitiativeItems = 6                  -- Total number of initiative items
    local rows = math.ceil(numInitiativeItems / 3)
    local initiativeBorderHeight = rows * 30 + 40 -- 30 pixels per row + 40 pixels padding

    -- Initiative tracker border
    self.initiativeBorder = { x = 10, y = y, width = self.width - 20, height = initiativeBorderHeight }

    -- Create initiative label
    self.initiativeLabel = ISLabel:new(0, self.initiativeBorder.y - 20, 10, "Initiative", 1, 1, 1, 1, UIFont.NewLarge,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX((self.width - self.initiativeLabel:getWidth()) / 2)

    -- Create new initiative button inside the border
    self.initiativeButton = ISButton:new(self.initiativeBorder.x + 5, self.initiativeBorder.y + 5, 50, 50, "", self,
        function() self:getScore("Initiative") end)
    self.initiativeButton:initialise()
    self.initiativeButton:instantiate()
    self.initiativeButton:setImage(getTexture("media/ui/diceLarge.png"))
    self.initiativeButton:forceImageSize(40, 40)
    self.initiativeButton.tooltip = "Roll dice for: Initiative"
    self:addChild(self.initiativeButton)
    table.insert(self.buttons, { label = self.initiativeLabel, button = self.initiativeButton })
    y = y + self.initiativeBorder.height + 50

    -- Create initiative reset button below the initiative border
    self.initiativeResetButton = ISButton:new(self.initiativeBorder.x + 5,
        self.initiativeButton:getBottom() + 5, 50, 30, "Reset", self,
        function() self:resetInitiativeTracker() end)
    self.initiativeResetButton:initialise()
    self.initiativeResetButton:instantiate()
    self.initiativeResetButton.tooltip = "Reset Initiative Tracker"
    self.initiativeResetButton:setBackgroundRGBA(0.5, 0.5, 0.5, 1)                  -- Gray background
    self.initiativeResetButton:setBorderRGBA(0.5, 0.5, 0.5, 1)                      -- Gray border
    self.initiativeResetButton:setBackgroundColorMouseOverRGBA(0.75, 0.75, 0.75, 1) -- Light Gray background on mouse-over
    self:addChild(self.initiativeResetButton)
    table.insert(self.healthButtons, self.initiativeResetButton)

    -- Create loud mode button
    self.loudModeButton = ISButton:new((self:getWidth() / 2) - 100 + 10, self.initiativeResetButton.y + 45, 60, 25,
        "Loud", self, ISDeadlineDiceUI.onOptionMouseDown)
    self.loudModeButton.internal = "LOUD_MODE"
    self.loudModeButton:initialise()
    self.loudModeButton:instantiate()
    self.loudModeButton.tooltip = "Loud mode. Has a range of 30"
    self.loudModeButton:setBackgroundRGBA(0.0, 0.5, 0.0, 1)
    self.loudModeButton:setBackgroundColorMouseOverRGBA(0.0, 0.5, 0.0, 0.5)
    self.loudModeButton:setBorderRGBA(1, 1, 1, 1)
    self:addChild(self.loudModeButton)

    -- Create quiet mode button
    self.quietModeButton = ISButton:new((self:getWidth() / 2) + 100 - 70, self.initiativeResetButton.y + 45, 60, 25,
        "Quiet", self, ISDeadlineDiceUI.onOptionMouseDown)
    self.quietModeButton.internal = "QUIET_MODE"
    self.quietModeButton:initialise()
    self.quietModeButton:instantiate()
    self.quietModeButton.tooltip = "Quiet mode. Has a range of 10"
    self.quietModeButton:setBackgroundRGBA(0.3, 0.3, 0.3, 1)
    self.quietModeButton:setBackgroundColorMouseOverRGBA(0.3, 0.3, 0.3, 0.5)
    self.quietModeButton:setBorderRGBA(1, 1, 1, 1)
    self:addChild(self.quietModeButton)

    self:createLabelWithButton(y, "Attack")
    y = y + 35
    self:createLabelWithButton(y, "Defend (Close) / Agility Check")
    y = y + 35
    self:createLabelWithButton(y, "Defend (Ranged)")
    y = y + 35
    self:createLabelWithButton(y, "Escape")
    y = y + 35
    self:createLabelWithButton(y, "Critical Injury")
    y = y + 60

    self:createLabelWithButton(y, "Sneak")
    y = y + 35
    self:createLabelWithButton(y, "Notice")
    y = y + 60

    --self:createLabelWithButton(y, "Carpentry")
    --y = y + 35
    --self:createLabelWithButton(y, "Cooking")
    --y = y + 35
    self:createLabelWithButton(y, "Electrical")
    y = y + 35
    --self:createLabelWithButton(y, "Farming")
    --y = y + 35
    self:createLabelWithButton(y, "First Aid")
    y = y + 35
    --self:createLabelWithButton(y, "Mechanics")
    --y = y + 35
    self:createLabelWithButton(y, "Metalworking")
    --y = y + 35
    --self:createLabelWithButton(y, "Tailoring")
    y = y + 60

    self:createLabelWithButton(y, "Physical Endurance")
    y = y + 35
    self:createLabelWithButton(y, "Mental Endurance")


    self.closeButton = ISButton:new(self.width - 70 * f - 10, y + 40, 70 * f, 30, "Close", self,
        ISDeadlineDiceUI.close);
    self.closeButton.anchorTop = false
    self.closeButton.anchorBottom = true
    self.closeButton:initialise();
    self.closeButton:instantiate();
    self.closeButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.closeButton);
    y = y + 60
    self.initiativeLabel = ISLabel:new(0, y, 10, "Damage Outputs", 1, 1, 1, 1, UIFont.NewLarge,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX((self.width - self.initiativeLabel:getWidth()) / 2)
        y = y + 20
    self.initiativeLabel = ISLabel:new(0, y, 10, "Unarmed: 1", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
        y = y + 15
    self.initiativeLabel = ISLabel:new(0, y, 10, "Short Melee, Improvised and Thrown Melee: 1", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
        y = y + 15
    self.initiativeLabel = ISLabel:new(0, y, 10, "Long Melee: 2", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
        y = y + 15
    self.initiativeLabel = ISLabel:new(0, y, 10, "Handguns: 2 (Close Range)", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
        y = y + 15
    self.initiativeLabel = ISLabel:new(0, y, 10, "Shotguns: 3 (Close Range)", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
        y = y + 15
    self.initiativeLabel = ISLabel:new(0, y, 10, "Rifles, SMGs: 3", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
        y = y + 15
    self.initiativeLabel = ISLabel:new(0, y, 10, "Crossbows: 3 (Skip one turn for reloading)", 1, 1, 1, 1, UIFont.NewMedium,
        true)
    self:addChild(self.initiativeLabel)
    self.initiativeLabel:setX(15)
end



function ISDeadlineDiceUI:onOptionMouseDown(button, x, y)
    if button.internal == "LOUD_MODE" then
        if self.selectedMode ~= "loud" then
            self.loudModeButton.backgroundColor = { r = 0.0, g = 0.5, b = 0.0, a = 1 }
            self.loudModeButton.backgroundColorMouseOver = { r = 0.0, g = 0.5, b = 0.0, a = 0.5 }

            self.quietModeButton.backgroundColor = { r = 0.3, g = 0.3, b = 0.3, a = 1 }
            self.quietModeButton.backgroundColorMouseOver = { r = 0.3, g = 0.3, b = 0.3, a = 0.5 }
            self.selectedMode = "loud"
        end
    elseif button.internal == "QUIET_MODE" then
        if self.selectedMode ~= "quiet" then
            self.quietModeButton.backgroundColor = { r = 0.0, g = 0.5, b = 0.0, a = 1 }
            self.quietModeButton.backgroundColorMouseOver = { r = 0.0, g = 0.5, b = 0.0, a = 0.5 }

            self.loudModeButton.backgroundColor = { r = 0.3, g = 0.3, b = 0.3, a = 1 }
            self.loudModeButton.backgroundColorMouseOver = { r = 0.3, g = 0.3, b = 0.3, a = 0.5 }
            self.selectedMode = "quiet"
        end
    end
end

function ISDeadlineDiceUI:addOrUpdateInitiative(name, value)
    -- Check if the name is already in the initiativeTracker
    if DeadlineDice.initiativeTracker[name] then
        -- Update the value if the name exists
        DeadlineDice.initiativeTracker[name] = value
    else
        -- If the number of entries is 6 or more, remove the oldest entry
        if #DeadlineDice.orderTracker >= 6 then
            local oldestName = table.remove(DeadlineDice.orderTracker, 1)
            DeadlineDice.initiativeTracker[oldestName] = nil
        end
        -- Add the new name and value
        DeadlineDice.initiativeTracker[name] = value
        table.insert(DeadlineDice.orderTracker, name)
    end
end

function ISDeadlineDiceUI:tableKeys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

function ISDeadlineDiceUI:getLowestInitiative()
    local lowestName, lowestValue
    for name, value in pairs(DeadlineDice.initiativeTracker) do
        if not lowestValue or value < lowestValue then
            lowestName, lowestValue = name, value
        end
    end
    return lowestName, lowestValue
end

function ISDeadlineDiceUI:adjustHitPointsLabelPosition()
    -- To adjust label in center
    local labelWidth = self.hitPointsLabel:getWidth()
    local minusButtonRightEdge = self.minusButton:getRight()
    local plusButtonLeftEdge = self.plusButton:getX()
    local totalWidth = plusButtonLeftEdge - minusButtonRightEdge
    local centerX = minusButtonRightEdge + (totalWidth - labelWidth) / 2
    self.hitPointsLabel:setX(centerX)
end

function ISDeadlineDiceUI:initialise()
    ISPanel.initialise(self);
    DeadlineDice.lastRoll = 0
    DeadlineDice.lastHealthClick = 0

    if getPlayer():HasTrait("Sturdy") then
        DeadlineDice.hitPoints = 14
    elseif getPlayer():HasTrait("Fragile") then
        DeadlineDice.hitPoints = 10
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") then
        DeadlineDice.hitPoints = 12
    end
    
end

function ISDeadlineDiceUI:update()
    if #self.sayQueue > 0 then
        if not self.lastTimestamp then
            self.lastTimestamp = getTimestamp()
            -- Handle the first item in the queue immediately
            self:handleNextSay()
        else
            local currentTime = getTimestamp()
            local elapsedTime = currentTime - self.lastTimestamp

            -- Check if 3 seconds have passed since the last Say() call
            if elapsedTime >= self.delay then
                self.lastTimestamp = currentTime
                self:handleNextSay()
            end
        end
    end
end

function ISDeadlineDiceUI:handleNextSay()
    if #self.sayQueue > 0 then
        local message = table.remove(self.sayQueue, 1)

        self.character:addLineChatElement(message, 1, 1, 1, UIFont.Dialogue, 10, "default",
            true, true, true, true, true, true)

        local playerName = self.character:getDescriptor():getForename() or self.character:getUsername()
        DeadlineDice.addLineInChat(playerName .. ": " .. message)

        local args =
        {
            sourcePlayerID = self.character:getOnlineID(),
            message = message,
            coords =
            {
                x = self.character:getX(),
                y = self.character:getY(),
                z = self.character:getZ()
            },
            mode = self.selectedMode
        }
        sendClientCommand('DeadlineDice', 'requestSendMessage', args)

        self.lastTimestamp = getTimestamp() -- Update lastTimestamp after the first message
    else
        self:close()
    end
end

function ISDeadlineDiceUI:prerender()
    ISCollapsableWindow.prerender(self);
end

function ISDeadlineDiceUI:render()
    for _, pair in ipairs(self.buttons) do
        if getTimestamp() - DeadlineDice.lastRoll < self.cooldown then
            if pair.button:isEnabled() then
                pair.button:setEnable(false)
            end
        else
            if not pair.button:isEnabled() then
                pair.button:setEnable(true)
            end
        end
    end

    for _, button in ipairs(self.healthButtons) do
        if getTimestamp() - DeadlineDice.lastHealthClick < self.healthCooldown then
            if button:isEnabled() then
                button:setEnable(false)
            end
        else
            if not button:isEnabled() then
                button:setEnable(true)
            end
        end
    end

    if getPlayer():HasTrait("Sturdy") and DeadlineDice.hitPoints == 14  then
        self.plusButton:setEnable(false)
    elseif getPlayer():HasTrait("Fragile") and DeadlineDice.hitPoints == 10 then
        self.plusButton:setEnable(false)
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") and DeadlineDice.hitPoints == 12 then
        self.plusButton:setEnable(false)
    end


    if DeadlineDice.hitPoints == 0 then
        self.minusButton:setEnable(false)
    end

    -- Update hit points bars
    self:updateHitPointsBars()

    for _, pair in ipairs(self.buttons) do
        if pair.label:getName() ~= "Initiative" then
            local label = pair.label
            local button = pair.button
            if label then
                -- Calculate the combined width and height for the border
                local width = button:getRight() - label:getX() + 10
                local height = math.max(label.height, button.height) + 10

                -- Draw the border
                self:drawRectBorder(label.x - 5, label.y - 15, width, height - 4, 1, 0.5, 0.5, 0.5)
            end
        end
    end

    -- Draw initiative tracker border
    local borderX = self.initiativeBorder.x
    local borderY = self.initiativeBorder.y
    local borderWidth = self.initiativeBorder.width
    local borderHeight = self.initiativeBorder.height
    local borderColor = { r = 1, g = 1, b = 1, a = 1 }
    self:drawRectBorder(borderX, borderY, borderWidth, borderHeight, borderColor.a, borderColor.r, borderColor.g,
        borderColor.b)

    -- Draw border for initiative button
    -- self:drawRectBorder(10, borderY, self.initiativeButton.width + 10, borderHeight, borderColor.a, borderColor.r,
    -- borderColor.g, borderColor.b)

    -- Sort initiative tracker by value in descending order
    local sortedInitiative = {}
    for name, value in pairs(DeadlineDice.initiativeTracker) do
        table.insert(sortedInitiative, { name = name, value = value })
    end
    table.sort(sortedInitiative, function(a, b) return a.value > b.value end)

    -- Utility function to truncate text
    local function truncateText(text, maxLength)
        if string.len(text) > maxLength then
            return string.sub(text, 1, maxLength - 2) .. "..."
        else
            return text
        end
    end

    -- Display initiative tracker pairs inside the border in columns, adjusting for button width
    local textX = self.initiativeButton:getRight() + 20
    local textY = borderY + 5
    local namesPerColumn = 3
    local columnWidth = (borderWidth - (self.initiativeButton:getWidth() + 15)) /
        math.ceil(#sortedInitiative / namesPerColumn)
    local maxNameLength = math.floor((columnWidth - 20) / 13) -- Rough approximation of max characters that fit in columnWidth

    local playerName = self.character:getUsername()           -- Get the player's username

    for index, pair in ipairs(sortedInitiative) do
        local displayName = pair.name
        if displayName == playerName then
            displayName = "You"
        end
        local truncatedName = truncateText(displayName, maxNameLength)
        self:drawText(truncatedName .. ": " .. tostring(pair.value), textX, textY, 1, 1, 1, 1, UIFont.Medium)
        textY = textY + 20

        if (index % namesPerColumn) == 0 then
            textX = textX + columnWidth
            textY = borderY + 5
        end
    end

    ISCollapsableWindow.render(self);
end

function ISDeadlineDiceUI:getScore(labelText)
    DeadlineDice.lastRoll = getTimestamp()
    local editedLabel = self:getEditedLabel(labelText)
    local playerName = self.character:getUsername()           -- Get the player's username
    local diceScore = DeadlineDice.getDiceRoll()
    local modifiers = DeadlineDice.getModifiers(editedLabel, diceScore)
    local totalScore = diceScore

    table.insert(self.sayQueue, "Rolling for: " .. labelText)
    localtext = playerName .. " rolls for: " .. labelText
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    local resultString = "Rolled " .. tostring(diceScore)

    -- Construct the modifiers string
    local modifierString = ""
    for modifier, value in pairs(modifiers) do
        modifierString = modifierString ..
            (value >= 0 and " + " or " - ") .. tostring(math.abs(value)) .. " (" .. modifier .. ")"
        -- Add modifier value to total score
        totalScore = totalScore + value
    end
    if isAdmin() then
        localtext = self.character:getUsername()  .. " A "
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    end
    if isDebugEnabled() then
        localtext = self.character:getUsername()  .. " B "
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    end

        if diceScore < 11 and (editedLabel == "Escape") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " - Failure!"
        localtext = playerName .. " rolls for: " .. resultString
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    elseif diceScore > 10 and (editedLabel == "Escape") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " - Success!"
        localtext = playerName .. " rolls for: " .. resultString
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    end      

    -- Combine the strings
    if diceScore == 20 and (editedLabel == "Attack" or editedLabel == "AttackRanged") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " - Critical! Roll Critical Injury"
        localtext = playerName .. " rolls for: " .. resultString
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    elseif diceScore == 20 and (editedLabel == "DefendCloseAgilityCheck" or editedLabel == "DefendRanged") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " - Critical Dodge! Attack Missed."
        localtext = playerName .. " rolls for: " .. resultString
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    else
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore)
        localtext = playerName .. " rolls for: " .. resultString
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    end

        -- Combine the strings


    -- Insert the result into the sayQueue
    table.insert(self.sayQueue, resultString)

    if editedLabel == "Initiative" then
        --DeadlineDice.hitPoints = self.character:getPerkLevel(Perks.Fitness)
        table.insert(self.sayQueue, "Current Hit Points: " .. tostring(DeadlineDice.hitPoints))

        local args =
        {
            sourcePlayerID = self.character:getOnlineID(),
            name = self.character:getUsername(),
            value = totalScore,
            coords =
            {
                x = self.character:getX(),
                y = self.character:getY(),
                z = self.character:getZ()
            },
            mode = self.selectedMode
        }
        sendClientCommand('DeadlineDice', 'requestSendInitiativeData', args)
    end
end

function ISDeadlineDiceUI:close()
    ISDeadlineDiceUI.instance = nil
    self:setVisible(false);
    self:removeFromUIManager();
end

function ISDeadlineDiceUI:updateHitPointsBars()
    local hitPoints = DeadlineDice.hitPoints
    for i = 1, #self.hitPointsBars do
        local progressBar = self.hitPointsBars[i]
        if hitPoints >= i then
            -- Draw red bar
            self:drawProgressBar(progressBar.x, progressBar.y, progressBar.width, progressBar.height, 1.0,
                { r = 1, g = 0, b = 0, a = 1 })
        else
            if hitPoints > (i - 1) then
                -- Draw partially red bar and partially gray bar
                local remaining = hitPoints % 10
                local progress = remaining / 10
                self:drawProgressBar(progressBar.x, progressBar.y, progressBar.width, progressBar.height, progress,
                    { r = 1, g = 0, b = 0, a = 1 })
                self:drawProgressBar(progressBar.x + progressBar.width * progress, progressBar.y,
                    progressBar.width * (1 - progress), progressBar.height, 0, { r = 0.5, g = 0.5, b = 0.5, a = 1 })
            else
                -- Draw gray bar
                self:drawProgressBar(progressBar.x, progressBar.y, progressBar.width, progressBar.height, 0.0,
                    { r = 0.5, g = 0.5, b = 0.5, a = 1 })
            end
        end
    end
    self.hitPointsLabel.name = "Hit Point Tracker: " .. tostring(hitPoints)
end

function ISDeadlineDiceUI:increaseHitPoints()
        if getPlayer():HasTrait("Sturdy") then
        maxHitPoints = 14
    elseif getPlayer():HasTrait("Fragile") then
       maxHitPoints = 10
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") then
        maxHitPoints = 12
    end
    
    DeadlineDice.hitPoints = math.min(DeadlineDice.hitPoints + 1, maxHitPoints)

    local playerName = self.character:getDescriptor():getForename() or self.character:getUsername()
    table.insert(self.sayQueue, "Current Hit Points set at: " .. tostring(DeadlineDice.hitPoints))
    localtext = self.character:getUsername() .. " set Hit Points at: " .. tostring(DeadlineDice.hitPoints)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    DeadlineDice.lastHealthClick = getTimestamp()

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:decreaseHitPoints()
    DeadlineDice.hitPoints = math.max(DeadlineDice.hitPoints - 1, 0)

    local playerName = self.character:getDescriptor():getForename() or self.character:getUsername()
    table.insert(self.sayQueue, playerName .. " took damage. Current hit points: " .. tostring(DeadlineDice.hitPoints))
    local entry = {
        player = playerName,
        hp = tostring(DeadlineDice.hitPoints)
    }
    sendClientCommand("DiceLogging", "DecreaseHP", entry)
    localtext = self.character:getUsername() .. " took damage. Current hit points: " .. tostring(DeadlineDice.hitPoints)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    DeadlineDice.lastHealthClick = getTimestamp()

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:resetHitPoints()
    if getPlayer():HasTrait("Sturdy") then
    DeadlineDice.hitPoints = 14
    elseif getPlayer():HasTrait("Fragile") then
    DeadlineDice.hitPoints = 10
    else
    DeadlineDice.hitPoints = 12
    end

    local playerName = self.character:getDescriptor():getForename() or self.character:getUsername()
    table.insert(self.sayQueue, playerName .. " has reset their hit points to: " .. tostring(DeadlineDice.hitPoints))
    localtext = self.character:getUsername() .. " has reset their Hit Points to: " .. tostring(DeadlineDice.hitPoints)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})

    DeadlineDice.lastHealthClick = getTimestamp()

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:resetInitiativeTracker()
    -- Clear the initiative tracker and order tracker
    DeadlineDice.initiativeTracker = {}
    DeadlineDice.orderTracker = {}

    -- Add a message to the sayQueue to notify players
    local playerName = self.character:getDescriptor():getForename() or self.character:getUsername()
    table.insert(self.sayQueue, playerName .. " has reset the initiative tracker.")
    DeadlineDice.lastHealthClick = getTimestamp()
end

--]]

--************************************************************************--
--** ISDeadlineDiceUI:new
--**
--************************************************************************--
function ISDeadlineDiceUI:new(x, y, character)
    local width = 400
    local height = 940
    local o = ISCollapsableWindow.new(self, x, y, width, height);
    o.playerNum = character:getPlayerNum()
    if y == 0 then
        o.y = getPlayerScreenTop(o.playerNum) + (getPlayerScreenHeight(o.playerNum) - height) / 2
        o:setY(o.y)
    end

    --Right positioning
    if x == 0 then
        local screenWidth = getPlayerScreenWidth(o.playerNum)
        local width = o:getWidth()
        local offset = 100
        o.x = getPlayerScreenLeft(o.playerNum) + screenWidth - width - offset
        o:setX(o.x)
    end

    --Center Positioning
    -- if x == 0 then
    --     o.x = getPlayerScreenLeft(o.playerNum) + (getPlayerScreenWidth(o.playerNum) - width) / 2
    --     o:setX(o.x)
    -- end
    o.width = width;
    o.height = height;
    o.character = character;
    o.moveWithMouse = true;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;
    o.delay = 2
    o.cooldown = 10
    o.healthCooldown = 2
    o.selectedMode = "loud"
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.5 };
    o:setResizable(false)
    ISDeadlineDiceUI.instance = o;
    return o;
end

function simpleHash(data)
    local hash = 0
    for i = 1, #data do
        local byte = string.byte(data, i)
        hash = (hash * 31 + byte) % 2^32  -- Simple rolling hash
    end
    return hash
end

function hashFunctionContents(func)
    local info = debug.getinfo()  -- Get function source info
end
