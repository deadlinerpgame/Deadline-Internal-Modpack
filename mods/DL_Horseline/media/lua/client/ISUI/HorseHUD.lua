require "ISUI/ISUIElement"

-- Bar settings
local barWidth = 80
local barHeight = getTextManager():getFontHeight(UIFont.Small) + 2
local spacing = 6
local totalWidth = (barWidth * 4) + (spacing * 3)
local totalHeight = barHeight
local textColor = { r = 1, g = 1, b = 1 }

HorseHud = ISUIElement:derive("HorseHud")

function HorseHud:initialise()
    ISUIElement.initialise(self)
end

function HorseHud:createChildren()
    ISUIElement.createChildren(self)
end

function HorseHud:prerender()
    self.player = getPlayer()
    self.item = self.player and self.player:getWornItem("Horse")
    if self.item and not isHorse(self.item) then
        self.item = nil
    end
    self:position()
end

function HorseHud:render()
    if not self.item then return end

    local data = self.item:getModData()
    if not data or not data._initialized then return end

    local health = (data.health or 0) / (data.maxHealth or 1)
    local stamina = (data.stamina or 0) / (data.maxStamina or 1)
    local hunger = (data.hunger or 0) / (data.maxHunger or 1)
    local thirst = (data.thirst or 0) / (data.maxThirst or 1)

    self:drawStatBar(0, "Health", health)
    self:drawStatBar(1, "Stamina", stamina)
    self:drawStatBar(2, "Hunger", hunger)
    self:drawStatBar(3, "Thirst", thirst)
end

function HorseHud:drawStatBar(index, label, value)
    local x = (barWidth + spacing) * index
    local width = barWidth * value
    local color = self:getColorForValue(value)

    self:drawRect(x, 0, barWidth, barHeight, 0.3, 0, 0, 0)
    self:drawRect(x, 0, width, barHeight, 0.7, color.r, color.g, color.b)
    self:drawTextCentre(label, x + barWidth / 2, 1, textColor.r, textColor.g, textColor.b, 1.0, UIFont.Small)
end

function HorseHud:getColorForValue(value)
    local color = {}

    if value <= 0.33 then
        color.r = 1
        color.g = value * 3
        color.b = 0
    elseif value <= 0.67 then
        local v = (value - 0.33) * 3
        color.r = 1
        color.g = 1 - (v * 0.5)
        color.b = 0
    else
        local v = (value - 0.67) * 3
        color.r = 1 - v
        color.g = 0.5
        color.b = 0
    end

    return color
end

function HorseHud:position()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local x = (screenWidth / 2) - (self.width / 2)
    local y = screenHeight - self.height - 80
    self:setX(x)
    self:setY(y)
end

function HorseHud:new()
    local o = ISUIElement:new(0, 0, totalWidth, totalHeight)
    setmetatable(o, self)
    self.__index = self
    o.width = totalWidth
    o.height = totalHeight
    o.anchorLeft = false
    o.anchorRight = false
    o.anchorTop = false
    o.anchorBottom = true
    o.visible = false
    return o
end

-- === Initialization & Visibility ===

local function createHorseHud()

    HorseHud.instance = HorseHud:new()
    HorseHud.instance:initialise()
    HorseHud.instance:addToUIManager()
end

local function updateHorseHudVisibility()
    if not HorseHud.instance then 

        return 
    end

    local player = getPlayer()
    local item = player and player:getWornItem("Horse")
    if item then

    else

    end

    if player and item and isHorse(item) then

        HorseHud.instance:setVisible(true)
    else

        HorseHud.instance:setVisible(false)
    end
end


Events.OnGameStart.Add(createHorseHud)
Events.OnTick.Add(updateHorseHudVisibility)


local validHorseTypes = {
    ["2TK_models.2TK_Horse"] = true,
    ["2TK_models.2TK_Horse_01"] = true,
    ["2TK_models.2TK_Horse_02"] = true,
    ["2TK_models.2TK_Horse_03"] = true,
    ["2TK_models.2TK_Horse_04"] = true,
}

function isHorse(item)
    if not item then return false end
    return validHorseTypes[item:getFullType()] == true
end