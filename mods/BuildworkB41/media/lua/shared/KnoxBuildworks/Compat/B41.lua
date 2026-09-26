local B41 = {}

local missingMethods = {}
local missingEvents = {}

local function flag(name)
    if not IsoFlagType then return nil end
    return IsoFlagType[name]
end

local function usableKey(key)
    local t = type(key)
    return t == "string" or t == "userdata"
end

function B41.propIs(props, key)
    if props == nil or not usableKey(key) then return false end
    local fn = props.Is or props.has
    if type(fn) ~= "function" then return false end
    return fn(props, key) == true
end

function B41.propVal(props, key)
    if props == nil or not usableKey(key) then return nil end
    local fn = props.Val or props.get
    if type(fn) ~= "function" then return nil end
    return fn(props, key)
end

function B41.propSet(props, key, value)
    if props == nil or not usableKey(key) then return false end
    local fn = props.Set or props.set
    if type(fn) ~= "function" then
        if not missingMethods["PropertyContainer.Set"] then
            missingMethods["PropertyContainer.Set"] = true
            local Log = require("KnoxBuildworks/Log")
            Log:warning("Sprite properties cannot be written in this build; '%s' not set", tostring(key))
        end
        return false
    end
    fn(props, key, value == nil and "" or tostring(value))
    return true
end

function B41.propUnset(props, key)
    if props == nil or not usableKey(key) then return false end
    local fn = props.UnSet or props.unset
    if type(fn) ~= "function" then return false end
    fn(props, key)
    return true
end

function B41.squareIs(square, key)
    if square == nil or not usableKey(key) then return false end
    local fn = square.Is or square.has
    if type(fn) ~= "function" then return false end
    return fn(square, key) == true
end

local function hasFlag(props, flagName)
    return B41.propIs(props, flag(flagName))
end

local function hasString(props, key)
    return B41.propIs(props, key)
end

local PROPERTY_MAP = {
    WALL_N          = { flags = { "WallN", "WallNTrans" },  strings = { "WallN" } },
    WALL_W          = { flags = { "WallW", "WallWTrans" },  strings = { "WallW" } },
    WALL_NW         = { flags = { "WallNW" },               strings = { "WallNW" } },
    WINDOW_N        = { flags = { "WindowN", "windowN" },   strings = { "WindowN" } },
    WINDOW_W        = { flags = { "WindowW", "windowW" },   strings = { "WindowW" } },
    WINDOW_FRAME_N  = { flags = { "WindowN", "windowN" },   strings = { "WindowN" } },
    WINDOW_FRAME_W  = { flags = { "WindowW", "windowW" },   strings = { "WindowW" } },
    DOOR_WALL_N     = { flags = { "DoorWallN" },            strings = { "DoorWallN" } },
    DOOR_WALL_W     = { flags = { "DoorWallW" },            strings = { "DoorWallW" } },
    GARAGE_DOOR     = { flags = {},                          strings = { "GarageDoor" } },
    DOUBLE_DOOR     = { flags = {},                          strings = { "DoubleDoor" } },
    BLOCKS_PLACEMENT = { flags = {},                         strings = { "BlocksPlacement" } }
}

function B41.hasProperty(props, name)
    local entry = PROPERTY_MAP[name]
    if not props or not entry then return false end
    for index = 1, #entry.flags do
        if hasFlag(props, entry.flags[index]) then return true end
    end
    for index = 1, #entry.strings do
        if hasString(props, entry.strings[index]) then return true end
    end
    return false
end

function B41.call(object, method, ...)
    if object == nil then return nil end
    local fn = object[method]
    if type(fn) ~= "function" then
        local key = tostring(method)
        if not missingMethods[key] then
            missingMethods[key] = true
            local Log = require("KnoxBuildworks/Log")
            Log:info("Engine method '%s' is not available in Build 41; call skipped", key)
        end
        return nil
    end
    return fn(object, ...)
end

function B41.wrapTextLines(font, text, width)
    text = tostring(text or "")
    width = math.max(1, math.floor(tonumber(width) or 1))
    if text == "" then return {} end

    local tm = getTextManager and getTextManager() or nil
    if not tm or not tm.MeasureStringX or font == nil then return { text } end

    if tm.WrapText then
        local wrapped = tm:WrapText(font, text, width)
        if type(wrapped) == "string" then
            local out = {}
            for line in string.gmatch(wrapped, "[^\r\n]+") do out[#out + 1] = line end
            if #out > 0 then return out end
        end
    end

    local function measure(s)
        return tonumber(tm:MeasureStringX(font, s)) or 0
    end

    local function splitWord(word, out)
        while #word > 0 do
            if measure(word) <= width then
                out[#out + 1] = word
                return
            end
            local hi, lo = 1, 1
            while hi < #word and measure(string.sub(word, 1, hi * 2)) <= width do
                lo = hi * 2
                hi = hi * 2
            end
            hi = math.min(#word, hi * 2)
            while lo < hi do
                local mid = math.floor((lo + hi + 1) / 2)
                if measure(string.sub(word, 1, mid)) <= width then lo = mid else hi = mid - 1 end
            end
            if lo < 1 then lo = 1 end
            out[#out + 1] = string.sub(word, 1, lo)
            word = string.sub(word, lo + 1)
        end
    end

    local lines, current = {}, ""
    for word in string.gmatch(text, "%S+") do
        local candidate = current == "" and word or (current .. " " .. word)
        if measure(candidate) <= width then
            current = candidate
        else
            if current ~= "" then
                lines[#lines + 1] = current
                current = ""
            end
            if measure(word) <= width then
                current = word
            else
                splitWord(word, lines)
                current = ""
            end
        end
    end
    if current ~= "" then lines[#lines + 1] = current end
    if #lines == 0 then lines[1] = text end
    return lines
end

function B41.maximumWorldLevel()
    if getMaximumWorldLevel then return getMaximumWorldLevel() end
    return 8
end

function B41.invalidateLighting()
    if invalidateLighting then invalidateLighting() end
end

function B41.loadSpriteTexture(sprite, name)
    if not sprite or not name then return false end
    if sprite.LoadFramesNoDirPageSimple then
        sprite:LoadFramesNoDirPageSimple(name)
        return true
    end
    if sprite.LoadSingleTexture then
        sprite:LoadSingleTexture(name)
        return true
    end
    return false
end

function B41.scriptItem(fullType)
    if not fullType then return nil end
    if getItem then
        local script = getItem(fullType)
        if script then return script end
    end
    local manager = getScriptManager and getScriptManager() or nil
    if not manager and ScriptManager then manager = ScriptManager.instance end
    if not manager then return nil end
    for _, name in ipairs({ "getItem", "FindItem" }) do
        if manager[name] then
            local script = manager[name](manager, fullType)
            if script then return script end
        end
    end
    return nil
end

function B41.addXp(character, perk, amount)
    if not character or not perk or not amount then return false end
    if addXp then
        addXp(character, perk, amount)
        return true
    end
    local xp = character.getXp and character:getXp() or nil
    if not xp or not xp.AddXP then return false end
    xp:AddXP(perk, amount)
    return true
end

function B41.getXp(character, perk)
    if not character or not perk or not character.getXp then return 0 end
    local xp = character:getXp()
    if not xp or not xp.getXP then return 0 end
    return tonumber(xp:getXP(perk)) or 0
end

function B41.removeFromContainer(container, item)
    if not container or not item then return false end
    if sendRemoveItemFromContainer then
        sendRemoveItemFromContainer(container, item)
        return true
    end
    if not container.Remove then return false end
    container:Remove(item)
    return true
end

local FACING_ORDER = { "N", "NW", "W", "SW", "S", "SE", "E", "NE" }

function B41.setObjectFacing(object, index)
    if not object then return false end
    index = tonumber(index) or 0
    if object.setForwardIsoDirection then
        object:setForwardIsoDirection(index)
        return true
    end
    if not object.setDir or not IsoDirections then return false end
    local name = FACING_ORDER[(index % 8) + 1]
    local direction = name and IsoDirections[name] or nil
    if direction == nil then return false end
    object:setDir(direction)
    return true
end

function B41.setExplored(object)
    if not object then return false end
    if object.setExplored then
        object:setExplored(true)
        return true
    end
    local marked = false
    local single = object.getContainer and object:getContainer() or nil
    if single and single.setExplored then
        single:setExplored(true)
        marked = true
    end
    if object.getContainerCount and object.getContainerByIndex then
        local count = tonumber(object:getContainerCount()) or 0
        for index = 0, count - 1 do
            local container = object:getContainerByIndex(index)
            if container and container.setExplored then
                container:setExplored(true)
                marked = true
            end
        end
    end
    return marked
end

function B41.halo(player, text, bad)
    if not player or not text or not HaloTextHelper then return end
    if bad and HaloTextHelper.addBadText then
        HaloTextHelper.addBadText(player, text)
        return
    end
    if not bad and HaloTextHelper.addGoodText then
        HaloTextHelper.addGoodText(player, text, "[br/]")
        return
    end
    if not HaloTextHelper.addText then return end
    local colour = nil
    if bad and HaloTextHelper.getColorRed then
        colour = HaloTextHelper.getColorRed()
    elseif not bad and HaloTextHelper.getColorGreen then
        colour = HaloTextHelper.getColorGreen()
    end
    if colour then
        HaloTextHelper.addText(player, text, colour)
    else
        HaloTextHelper.addText(player, text)
    end
end

function B41.breakSound(spriteName)
    if spriteName and IsoThumpable and IsoThumpable.GetBreakFurnitureSound then
        local sound = IsoThumpable.GetBreakFurnitureSound(spriteName)
        if sound then return sound end
    end
    return "BreakObject"
end

local floorCursorSprite = nil

function B41.floorCursorSprite()
    if floorCursorSprite then return floorCursorSprite end
    if not IsoSprite or not IsoSprite.new then return nil end
    local sprite = IsoSprite.new()
    if sprite.LoadFramesNoDirPageSimple then
        sprite:LoadFramesNoDirPageSimple("media/ui/FloorTileCursor.png")
    elseif sprite.LoadSingleTexture then
        sprite:LoadSingleTexture("media/ui/FloorTileCursor.png")
    else
        return nil
    end
    floorCursorSprite = sprite
    return floorCursorSprite
end

local MAX_HIGHLIGHT_TILES = 4096
local highlightCapWarned = false

function B41.addAreaHighlight(playerNum, x1, y1, x2, y2, z, r, g, b, a)
    if addAreaHighlightForPlayer then
        return addAreaHighlightForPlayer(playerNum, x1, y1, x2, y2, z, r, g, b, a)
    end
    local sprite = B41.floorCursorSprite()
    if not sprite then return end

    local minX, maxX = math.min(x1, x2), math.max(x1, x2)
    local minY, maxY = math.min(y1, y2), math.max(y1, y2)
    local width, height = maxX - minX, maxY - minY
    if width <= 0 or height <= 0 then return end
    if width * height > MAX_HIGHLIGHT_TILES then
        if not highlightCapWarned then
            highlightCapWarned = true
            local Log = require("KnoxBuildworks/Log")
            Log:warning(
                "Area highlight of %dx%d tiles exceeds the %d-tile cap and was skipped",
                width, height, MAX_HIGHLIGHT_TILES
            )
        end
        return
    end

    r, g, b = r or 1, g or 1, b or 1
    a = a or 0.24
    for tileX = minX, maxX - 1 do
        for tileY = minY, maxY - 1 do
            sprite:RenderGhostTileColor(tileX, tileY, z, r, g, b, a)
        end
    end
end

function B41.isKey(bindingName, key)
    local core = getCore and getCore() or nil
    if not core then return false end
    if core.isKey then return core:isKey(bindingName, key) == true end
    if core.getKey then return core:getKey(bindingName) == key end
    return false
end

function B41.isRecipeKnown(character, recipe)
    if not character or not recipe then return false end
    if character.isRecipeActuallyKnown then
        return character:isRecipeActuallyKnown(recipe) == true
    end
    if character.isRecipeKnown then return character:isRecipeKnown(recipe) == true end
    return false
end

function B41.displayName(scriptItem)
    if not scriptItem then return nil end
    if scriptItem.getTranslationName then return scriptItem:getTranslationName() end
    if scriptItem.getDisplayName then return scriptItem:getDisplayName() end
    if scriptItem.getName then return scriptItem:getName() end
    return nil
end

function B41.isDrainable(item)
    if not item then return false end
    if item.getDrainableUsesInt then return true end
    return instanceof(item, "DrainableComboItem")
end

function B41.usesLeft(item)
    if not item then return 0 end
    if item.getDrainableUsesInt then
        return math.max(0, tonumber(item:getDrainableUsesInt()) or 0)
    end
    if item.getCurrentUses then return math.max(0, tonumber(item:getCurrentUses()) or 0) end
    return 0
end

function B41.usesLeftFloat(item)
    if not item then return 0 end
    if item.getCurrentUsesFloat then return tonumber(item:getCurrentUsesFloat()) or 0 end
    if item.getUsedDelta and item.getUseDelta then
        local perUse = tonumber(item:getUseDelta()) or 0
        if perUse <= 0 then return 0 end
        local remaining = 1 - (tonumber(item:getUsedDelta()) or 0)
        return math.max(0, remaining / perUse)
    end
    return B41.usesLeft(item)
end

function B41.maxUses(item)
    if not item then return 0 end
    if item.getMaxUses then return tonumber(item:getMaxUses()) or 0 end
    if item.getUseDelta then
        local perUse = tonumber(item:getUseDelta()) or 0
        if perUse > 0 then return math.floor(1 / perUse + 0.5) end
    end
    return 0
end

function B41.useItem(item)
    if not item then return false end
    if item.UseAndSync then
        item:UseAndSync()
        return true
    end
    if item.Use then
        item:Use()
        return true
    end
    return false
end

function B41.addEvent(name, fn)
    local event = Events and Events[name]
    if type(event) ~= "table" or type(event.Add) ~= "function" then
        if not missingEvents[name] then
            missingEvents[name] = true
            local Log = require("KnoxBuildworks/Log")
            Log:info("Event '%s' does not exist in Build 41; handler not attached", tostring(name))
        end
        return false
    end
    event.Add(fn)
    return true
end

function B41.removeEvent(name, fn)
    local event = Events and Events[name]
    if type(event) ~= "table" or type(event.Remove) ~= "function" then return false end
    event.Remove(fn)
    return true
end

function B41.hasEvent(name)
    local event = Events and Events[name]
    return type(event) == "table" and type(event.Add) == "function"
end

function B41.squareHasAny(square, names)
    if not square then return false end
    for index = 1, #names do
        local entry = PROPERTY_MAP[names[index]]
        if entry then
            for flagIndex = 1, #entry.flags do
                if B41.squareIs(square, flag(entry.flags[flagIndex])) then return true end
            end
        end
    end
    return false
end

local FINISH_ITEMS = {
    paintbrush     = "Paintbrush",
    plasterbucket  = "BucketPlasterFull",
    plastertrowel  = "Paintbrush"
}

function B41.findFinishItem(inventory, logicalName, predicate)
    if not inventory or not logicalName then return nil end
    local itemType = FINISH_ITEMS[string.lower(tostring(logicalName))]
    if not itemType then return nil end
    if predicate and inventory.getFirstTypeEvalRecurse then
        return inventory:getFirstTypeEvalRecurse(itemType, predicate)
    end
    return inventory:getFirstTypeRecurse(itemType)
end

function B41.finishItemType(logicalName)
    if not logicalName then return nil end
    return FINISH_ITEMS[string.lower(tostring(logicalName))]
end

local TAG_MAP = {
    ["base:hammer"]           = "Hammer",
    ["base:screwdriver"]      = "Screwdriver",
    ["base:saw"]              = "Saw",
    ["base:crudesaw"]         = "Saw",
    ["base:scissors"]         = "Scissors",
    ["base:sharpknife"]       = "SharpKnife",
    ["base:sewingneedle"]     = "SewingNeedle",
    ["base:weldingmask"]      = "WeldingMask",
    ["base:digplow"]          = "DigPlow",
    ["base:iscutting"]        = "CutPlant",
    ["base:paintbrush"]       = "Paintbrush",
    ["base:thread"]           = "Thread",
    ["base:twine"]            = "Twine",
    ["base:awl"]              = "Awl",
    ["base:masonstrowel"]     = "MasonsTrowel",
    ["base:concrete"]         = "Concrete",
    ["base:carpentrychisel"]  = "CarpentryChisel",
    ["base:crudechisel"]      = "CrudeChisel",
    ["base:masonschisel"]     = "MasonsChisel",
    ["base:isseed"]           = "isSeed"
}

function B41.tagName(name)
    if name == nil then return nil end
    local value = tostring(name)
    local mapped = TAG_MAP[string.lower(value)]
    if mapped then return mapped end
    local suffix = string.match(value, "^[%w_]+:(.+)$")
    return suffix or value
end

function B41.registerTag(name, b41Tag)
    if type(name) ~= "string" or type(b41Tag) ~= "string" then return false end
    TAG_MAP[string.lower(name)] = b41Tag
    return true
end

local TIMED_ACTIONS = {
    BuildWallHammer = {
        actionAnim = "Build", completionSound = "BuildWoodenStructureLarge" },
    BuildLowHammer = {
        actionAnim = "BuildLow", completionSound = "BuildWoodenStructureMedium" },
    BuildWallNoTool = {
        actionAnim = "Loot", sound = "BuildingGeneric",
        completionSound = "BuildWoodenStructureLarge",
        animVarKey = "LootPosition", animVarVal = "High" },
    BuildLowNoTool = {
        actionAnim = "Loot", sound = "BuildingGeneric",
        completionSound = "BuildWoodenStructureLarge",
        animVarKey = "LootPosition", animVarVal = "Low" },
    BuildWallMetal = {
        actionAnim = "BlowTorch", sound = "BlowTorch",
        completionSound = "BuildMetalStructureWallFrame", prop1 = "Base.BlowTorch" },
    BuildLowMetal = {
        actionAnim = "BlowTorch", sound = "BlowTorch",
        completionSound = "BuildMetalStructureSmallScrap", prop1 = "Base.BlowTorch" },
    BuildWoodenStructureSmall = {
        actionAnim = "Build", completionSound = "BuildWoodenStructureSmall" },
    BuildWoodenStructureMedium = {
        actionAnim = "Build", completionSound = "BuildWoodenStructureMedium" },
    BuildMetalStructureMedium = {
        actionAnim = "BlowTorch", sound = "BlowTorch",
        completionSound = "BuildMetalStructureMedium", prop1 = "Base.BlowTorch" },
    BuildCairn = {
        actionAnim = "BuildLow", sound = "BuildingGeneric",
        completionSound = "BuildFenceCairn", prop1 = "Base.MasonsTrowel" },
    BuildSandbagWall = {
        actionAnim = "Loot", sound = "BuildFenceSandbagFoley",
        completionSound = "BuildFenceSandbag",
        animVarKey = "LootPosition", animVarVal = "Low" }
}

local TimedActionScript = {}
TimedActionScript.__index = TimedActionScript

local function getter(field)
    return function (self) return self._data[field] end
end

TimedActionScript.getSound           = getter("sound")
TimedActionScript.getCompletionSound = getter("completionSound")
TimedActionScript.getActionAnim      = getter("actionAnim")
TimedActionScript.getAnimVarKey      = getter("animVarKey")
TimedActionScript.getAnimVarVal      = getter("animVarVal")
TimedActionScript.getProp1           = getter("prop1")
TimedActionScript.getProp2           = getter("prop2")

function TimedActionScript:getName()
    return self._name
end

local scriptCache = {}

function B41.timedAction(name)
    if not name then return nil end
    local key = tostring(name)
    local cached = scriptCache[key]
    if cached ~= nil then return cached or nil end
    local data = TIMED_ACTIONS[key]
    if not data then
        scriptCache[key] = false
        return nil
    end
    local script = setmetatable({ _name = key, _data = data }, TimedActionScript)
    scriptCache[key] = script
    return script
end

function B41.registerTimedAction(name, config)
    if type(name) ~= "string" or type(config) ~= "table" then return false end
    TIMED_ACTIONS[name] = config
    scriptCache[name] = nil
    return true
end

function B41.hasWallpaper()
    return WallPaper ~= nil and ISWallpaperAction ~= nil
end

function B41.walkAdjSquares(character, squares)
    if not character or not squares or #squares == 0 then return false end
    if luautils and luautils.walkAdjSquares then
        return luautils.walkAdjSquares(character, squares, true, true)
    end
    local current = character:getCurrentSquare()
    local best, bestDistance = nil, nil
    for index = 1, #squares do
        local square = squares[index]
        if square then
            if current and current:getZ() == square:getZ() then
                local dx = current:getX() - square:getX()
                local dy = current:getY() - square:getY()
                local distance = dx * dx + dy * dy
                if bestDistance == nil or distance < bestDistance then
                    best, bestDistance = square, distance
                end
            elseif best == nil then
                best = square
            end
        end
    end
    if not best then return false end
    return luautils.walkAdj(character, best, false)
end

return B41
