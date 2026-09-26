require "BuildingObjects/ISBuildingObject"

local KBW = require("KnoxBuildworks/Core")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local Resolver = require("KnoxBuildworks/Definitions/Resolver")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local Placement = require("KnoxBuildworks/Validation/Placement")
local FinishActions = require("KnoxBuildworks/Validation/FinishActions")
local Log = require("KnoxBuildworks/Log")
local Integrity = require("KnoxBuildworks/Network/Integrity")
local LuaCallback = require("KnoxBuildworks/Util/LuaCallback")
local Matrix = require("KnoxBuildworks/Geometry/Matrix")
local Properties = require("KnoxBuildworks/Definitions/Properties")
local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local NativeObjectFactory = require("KnoxBuildworks/BuildingObjects/NativeObjectFactory")
local Mannequins = require("KnoxBuildworks/World/Mannequins")
local Durability = require("KnoxBuildworks/Definitions/Durability")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

KBWBuildingObject = ISBuildingObject:derive("KBWBuildingObject")

local function faceName(nSprite)
    return ({ "W", "N", "E", "S" })[nSprite or 1] or "W"
end

local function wallEdgeDirection(direction)
    direction = tonumber(direction) or 1
    return (direction == 2 or direction == 4) and 2 or 1
end

local function isStandingAtWallEdge(character, square, north)
    local current = character and character:getCurrentSquare() or nil
    if not current or not square or current:getZ() ~= square:getZ() then return false end
    if current == square then return true end
    local acrossEdge = square:getAdjacentSquare(north and IsoDirections.N or IsoDirections.W)
    if acrossEdge ~= nil and current == acrossEdge then return true end
    local approach = square:getAdjacentSquare(north and IsoDirections.S or IsoDirections.E)
    return approach ~= nil and current == approach and KBWB41.call(current, "canReachTo", square)
end

local function configuredBoolean(value, default)
    if value == nil then return default == true end
    return value == true
end

local CONNECTION_IDENTITY_FIELDS = { "buildableId", "stageId", "variantId", "materialId" }

local function connectionData(object)
    local data = object and object.getModData and object:getModData() or nil
    return data and data.KBW or nil
end

local function sameConnectionIdentity(left, right)
    if not left or not right or left.connectionRole ~= nil or right.connectionRole ~= nil then return false end
    for fieldIndex = 1, #CONNECTION_IDENTITY_FIELDS do
        local field = CONNECTION_IDENTITY_FIELDS[fieldIndex]
        if tostring(left[field] or "") ~= tostring(right[field] or "") then return false end
    end
    return true
end

local function findMatchingWallEdge(square, identity, north, excluded)
    if not square or not identity then return nil end
    for objectIndex = 0, square:getSpecialObjects():size() - 1 do
        local object = square:getSpecialObjects():get(objectIndex)
        if object ~= excluded and instanceof(object, "IsoThumpable") and object:getNorth() == (north == true)
            and sameConnectionIdentity(identity, connectionData(object)) then
            return object
        end
    end
    return nil
end

local function wallRunContinues(square, identity, north)
    if not square then return false end
    local x, y, z = square:getX(), square:getY(), square:getZ()
    local beforeX, beforeY, afterX, afterY = x - 1, y, x + 1, y
    if not north then beforeX, beforeY, afterX, afterY = x, y - 1, x, y + 1 end
    local before = getCell():getGridSquare(beforeX, beforeY, z)
    local after = getCell():getGridSquare(afterX, afterY, z)
    return findMatchingWallEdge(before, identity, north, nil) ~= nil
        or findMatchingWallEdge(after, identity, north, nil) ~= nil
end

local function squareHasSprite(square, spriteName)
    if not square or not spriteName then return false end
    for objectIndex = 0, square:getObjects():size() - 1 do
        local object = square:getObjects():get(objectIndex)
        local sprite = object and object:getSprite() or nil
        if sprite and sprite:getName() == spriteName then return true end
    end
    return false
end

local function isGarageDoorSprite(spriteName)
    if not spriteName then return false end
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    return properties and KBWB41.hasProperty(properties, "GARAGE_DOOR") == true
end

local function isFloorAttachmentSprite(spriteName)
    if not spriteName then return false end
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    if not properties then return false end
    return (KBWB41.propIs(properties, "MoveType") and KBWB41.propVal(properties, "MoveType") == "FloorRug") or KBWB41.propIs(properties, IsoFlagType.attachedFloor) or KBWB41.propIs(properties, IsoFlagType.FloorOverlay)
end

local function isWallDecorationSprite(spriteName)
    if not spriteName then return false end
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    if not properties then return false end
    local attached = KBWB41.propIs(properties, IsoFlagType.attachedN) or KBWB41.propIs(properties, IsoFlagType.attachedW)
        or KBWB41.propIs(properties, IsoFlagType.attachedE) or KBWB41.propIs(properties, IsoFlagType.attachedS)
    if not attached then return false end
    return not (KBWB41.propIs(properties, IsoFlagType.solid) or KBWB41.propIs(properties, IsoFlagType.solidtrans)
        or KBWB41.propIs(properties, IsoFlagType.collideN) or KBWB41.propIs(properties, IsoFlagType.collideW)
        or KBWB41.propIs(properties, IsoFlagType.WallN) or KBWB41.propIs(properties, IsoFlagType.WallNTrans)
        or KBWB41.propIs(properties, IsoFlagType.WallW) or KBWB41.propIs(properties, IsoFlagType.WallWTrans)
        or KBWB41.propIs(properties, IsoFlagType.WallNW) or KBWB41.propIs(properties, IsoFlagType.WindowN)
        or KBWB41.propIs(properties, IsoFlagType.WindowW) or KBWB41.propIs(properties, IsoFlagType.windowN)
        or KBWB41.propIs(properties, IsoFlagType.windowW) or KBWB41.propIs(properties, IsoFlagType.doorN)
        or KBWB41.propIs(properties, IsoFlagType.doorW) or KBWB41.propIs(properties, IsoFlagType.DoorWallN)
        or KBWB41.propIs(properties, IsoFlagType.DoorWallW))
end

local function isRoofObjectSprite(spriteName)
    if not spriteName then return false end
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    if not properties or KBWB41.propIs(properties, IsoFlagType.solidfloor) then return false end
    if KBWB41.propIs(properties, IsoFlagType.WallN) or KBWB41.propIs(properties, IsoFlagType.WallNTrans) or KBWB41.propIs(properties, IsoFlagType.WallW)
        or KBWB41.propIs(properties, IsoFlagType.WallWTrans) or KBWB41.propIs(properties, IsoFlagType.WallNW) then
        return false
    end
    return KBWB41.propIs(properties, "RoofGroup") or KBWB41.propIs(properties, "WestRoofB")
        or KBWB41.propIs(properties, "WestRoofM") or KBWB41.propIs(properties, "WestRoofT")
        or KBWB41.propIs(properties, "isEave")
end

local function isPassableWallOpeningSprite(spriteName, north)
    local sprite = spriteName and getSprite(spriteName) or nil
    local props = sprite and sprite:getProperties() or nil
    if not props then return false end
    if north then
        return KBWB41.propIs(props, IsoFlagType.cutN) and not (
            KBWB41.propIs(props, IsoFlagType.collideN) or KBWB41.propIs(props, IsoFlagType.WallN)
                or KBWB41.propIs(props, IsoFlagType.WallNW) or KBWB41.propIs(props, IsoFlagType.WindowN)
                or KBWB41.propIs(props, IsoFlagType.DoorWallN) or KBWB41.propIs(props, IsoFlagType.HoppableN)
        )
    end
    return KBWB41.propIs(props, IsoFlagType.cutW) and not (
        KBWB41.propIs(props, IsoFlagType.collideW) or KBWB41.propIs(props, IsoFlagType.WallW)
            or KBWB41.propIs(props, IsoFlagType.WallNW) or KBWB41.propIs(props, IsoFlagType.WindowW)
            or KBWB41.propIs(props, IsoFlagType.DoorWallW) or KBWB41.propIs(props, IsoFlagType.HoppableW)
    )
end

local function isPassableWallOpening(stage)
    local sprites = (stage and stage.sprites) or {}
    local found = false
    if sprites.W then
        found = true
        if not isPassableWallOpeningSprite(sprites.W, false) then return false end
    end
    if sprites.N then
        found = true
        if not isPassableWallOpeningSprite(sprites.N, true) then return false end
    end
    return found
end

local function nativeContainerType(spriteName)
    if not spriteName then return nil end
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    local containerType = properties and KBWB41.propVal(properties, "container") or nil
    if containerType == "" then return nil end
    return containerType
end

local function addCarriedContainers(container, containers, depth)
    if not container or depth > 4 then return end
    containers:add(container)
    local nested = container.getItemsFromCategory and container:getItemsFromCategory("Container") or nil
    if not nested then return end
    for nestedIndex = 0, nested:size() - 1 do
        local item = nested:get(nestedIndex)
        local inventory = item and item.getInventory and item:getInventory() or nil
        if inventory then addCarriedContainers(inventory, containers, depth + 1) end
    end
end

local function listedBuildContainers(character)
    local containers = ArrayList.new()
    if not character then return containers end
    local playerNum = character.getPlayerNum and character:getPlayerNum() or -1
    if playerNum >= 0 and ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.getContainers then
        local listed = ISInventoryPaneContextMenu.getContainers(character)
        if listed then
            for listedIndex = 0, listed:size() - 1 do containers:add(listed:get(listedIndex)) end
        end
    end
    if character.getInventory then addCarriedContainers(character:getInventory(), containers, 0) end
    return containers
end

local function accessibleBuildContainers(character, containers)
    local accessible = ArrayList.new()
    if not character then return accessible end
    local checker = BuildLogic and BuildLogic.new(character, nil, nil) or nil
    local candidate = ArrayList.new()
    local seen = {}

    local function add(container)
        if not container then return end
        local key = tostring(container)
        if seen[key] then return end
        seen[key] = true
        if checker then
            candidate:clear()
            candidate:add(container)
            if not checker:isContainersAccessible(candidate) then return end
        end
        accessible:add(container)
    end

    add(character:getInventory())
    if containers then
        for containerIndex = 0, containers:size() - 1 do
            add(containers:get(containerIndex))
        end
    end
    return accessible
end

local function currentBuildContainers(character)
    return accessibleBuildContainers(character, listedBuildContainers(character))
end

local function applyNativeInputChoices(logic, recipe, choices, containers)
    if not logic or not recipe or not choices then return end
    local inputs = recipe:getInputs()
    local hasSelection = false
    for inputIndex = 0, inputs:size() - 1 do
        if choices["input_" .. tostring(inputIndex + 1)] then
            hasSelection = true
            break
        end
    end
    if not hasSelection then return end
    logic:setManualSelectInputs(true)
    for inputIndex = 0, inputs:size() - 1 do
        local fullType = choices["input_" .. tostring(inputIndex + 1)]
        if fullType then
            local selected = ArrayList.new()
            local seen = {}
            for containerIndex = 0, containers:size() - 1 do
                local container = containers:get(containerIndex)
                if container then
                    local items = container:getAllTypeRecurse(fullType)
                    for itemIndex = 0, items:size() - 1 do
                        local item = items:get(itemIndex)
                        local key = tostring(item)
                        if not seen[key] then
                            seen[key] = true
                            selected:add(item)
                        end
                    end
                end
            end
            logic:setManualInputsFor(inputs:get(inputIndex), selected)
        end
    end
    logic:autoPopulateInputs()
end

local function newNativeBuildLogic(character, recipe, choices, containers)
    if not BuildLogic or not character or not recipe or not containers then return nil end
    local logic = BuildLogic.new(character, nil, nil)
    logic:setManualSelectInputs(false)
    logic:setContainers(containers)
    logic:setRecipe(recipe)
    applyNativeInputChoices(logic, recipe, choices, containers)
    return logic
end

function KBWBuildingObject:refreshPlayerContext()
    local runtimePlayer = self.player
    if type(runtimePlayer) == "number" then runtimePlayer = getSpecificPlayer(runtimePlayer) end
    if runtimePlayer and runtimePlayer ~= self.character then
        self.character = runtimePlayer
        self.buildPanelLogic = nil
        self.buildLogicCharacter = nil
    end
    if self.character and self.craftRecipe and EntityCompat.usesNativeRecipeInputs(self.stage) and BuildLogic
        and self.buildLogicCharacter ~= self.character then
        self.containers = currentBuildContainers(self.character)
        self.buildPanelLogic = newNativeBuildLogic(
            self.character, self.craftRecipe, self.inputChoices, self.containers
        )
        self.buildLogicCharacter = self.character
    end
    return self.character
end

local function nativeInputFailure(logic, recipe, containers)
    if not logic then return "native build logic unavailable" end
    if not containers or containers:size() == 0 then return "no construction containers available" end
    if not logic:isContainersAccessible(containers) then return "construction container is no longer accessible" end
    local missing = {}
    local inputs = recipe and recipe:getInputs() or nil
    if inputs then
        for inputIndex = 0, inputs:size() - 1 do
            local input = inputs:get(inputIndex)
            if not logic:isInputSatisfied(input) then
                local label = input:getOriginalLine()
                if not label or label == "" then label = "input_" .. tostring(inputIndex + 1) end
                missing[#missing + 1] = label
            end
        end
    end
    if #missing > 0 then return "native recipe inputs unavailable: " .. table.concat(missing, "; ") end
    return "native recipe rejected the current items or character state"
end

local function snapshotXp(character, awards)
    local xp = character and character:getXp() or nil
    for awardIndex = 1, #awards do
        local award = awards[awardIndex]
        award.before = xp and xp:getXP(award.perk) or 0
    end
end

local function nativeXpWasGranted(character, awards)
    local xp = character and character:getXp() or nil
    if not xp or #awards == 0 then return #awards == 0 end
    for awardIndex = 1, #awards do
        local award = awards[awardIndex]
        if xp:getXP(award.perk) > (tonumber(award.before) or 0) then return true end
    end
    return false
end

local function showConfiguredXpHalo(character, perk, gained)
    if not character or not perk or not gained or gained <= 0 then return end
    if KBWB41.call(getCore(), "getOptionShowCraftingXP") == false then return end
    if not HaloTextHelper then return end
    local rounded = math.floor(gained * 10 + 0.5) / 10
    local amountText = rounded == math.floor(rounded) and tostring(math.floor(rounded)) or tostring(rounded)
    KBWB41.halo(character, getText(perk:getName()) .. " XP: " .. amountText, false)
end

local function awardConfiguredXp(character, perk, amount)
    if not character or not perk or not amount or amount <= 0 then return 0 end
    local before = KBWB41.getXp(character, perk)
    KBWB41.addXp(character, perk, amount)
    local gained = KBWB41.getXp(character, perk) - before
    showConfiguredXpHalo(character, perk, gained)
    return gained
end

local FACE_KEYS = {
    "W",
    "N",
    "E",
    "S"
}

local function explicitDirections(stage)
    local directions = {}
    local cells = stage and stage.cellsByFace or {}
    local sprites = stage and stage.sprites or {}
    for direction = 1, #FACE_KEYS do
        local key = FACE_KEYS[direction]
        if cells[key] ~= nil or sprites[key] ~= nil then directions[#directions + 1] = direction end
    end
    if #directions == 0 then directions[1] = 1 end
    return directions
end

local function normalizedDirection(stage, direction)
    direction = tonumber(direction) or 1
    local directions = explicitDirections(stage)
    for index = 1, #directions do
        if directions[index] == direction then return direction end
    end
    local _, resolvedFace = Matrix.getFaceCells(stage, direction)
    for index = 1, #FACE_KEYS do
        if FACE_KEYS[index] == resolvedFace then return index end
    end
    return directions[1]
end

local function nextDirection(stage, direction)
    local directions = explicitDirections(stage)
    direction = normalizedDirection(stage, direction)
    for index = 1, #directions do
        if directions[index] == direction then return directions[(index % #directions) + 1] end
    end
    return directions[1]
end

local function applySprites(object, sprites)
    object:setSprite(sprites.W or sprites.S or sprites.N or sprites.E)
    object:setNorthSprite(sprites.N or sprites.S or object.sprite)
    object:setEastSprite(sprites.E or sprites.W)
    object:setSouthSprite(sprites.S or sprites.N)
end

function KBWBuildingObject:new(player, buildableId, stageId, variantId, materialId, direction, inputChoices, containers)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o.player = type(player) == "number" and player or player:getPlayerNum()
    if type(player) == "number" then
        o.character = getSpecificPlayer(player)
    else
        o.character = player
    end
    o.buildableId, o.stageId, o.variantId, o.materialId = buildableId, stageId, variantId or "", materialId or ""
    o.inputChoices = inputChoices or {}
    o.nSprite = tonumber(direction) or 1
    o.direction = o.nSprite
    o.definition, o.stage = Resolver.resolveStage(buildableId, o.variantId, o.materialId, stageId)
    if not o.definition or not o.stage then
        o.blockBuild = true
        return o
    end
    applySprites(o, o.stage.sprites)
    local placement = StageConfig.placement(o.definition, o.stage)
    local kind = placement.kind
    if kind == "wall" or placement.needWindowFrame == true then
        o.nSprite = wallEdgeDirection(o.nSprite)
        o.direction = o.nSprite
    else
        o.nSprite = normalizedDirection(o.stage, o.nSprite)
        o.direction = o.nSprite
    end
    local entityMetadata = EntityCompat.metadata(o.stage)
    local spriteConfig = StageConfig.sprite(o.definition, o.stage)
    local construction = StageConfig.construction(o.definition, o.stage)
    local objectConfig = o.stage.object or {}
    o.objectName = (type(objectConfig.objectName) == "string" and objectConfig.objectName ~= "")
        and objectConfig.objectName or nil
    o.name = o.objectName or entityMetadata.entity or (o.definition.id .. ":" .. o.stage.id)
    o.dragNilAfterPlace = false
    o.blockAfterPlace = false
    o.noNeedHammer = true
    o.isWallLike = kind == "wall" or kind == "wallCovering" or placement.needWindowFrame == true
    o.isFloor = kind == "floor"
    o.canBeAlwaysPlaced = kind == "overlay"
    local passableWallOpening = kind == "wall" and isPassableWallOpening(o.stage)
    o.canPassThrough = configuredBoolean(objectConfig.canPassThrough, kind == "overlay" or passableWallOpening)
    o.isDoorFrame = objectConfig.isDoorFrame == true
    o.isCorner = objectConfig.isCorner == true
    o.isProp = objectConfig.isProp == true or spriteConfig.isProp == true
        or (objectConfig.canPassThrough == true and kind ~= "overlay" and kind ~= "floor")
    o.isThumpable = configuredBoolean(objectConfig.isThumpable, spriteConfig.isThumpable ~= false and kind ~= "overlay")
    o.dismantable = objectConfig.dismantable ~= false
    o.blockAllTheSquare = configuredBoolean(objectConfig.blockAllSquare, kind == "object")
    o.hoppable = not passableWallOpening and (objectConfig.hoppable == true or o.stage.hoppable == true)
    o.dontNeedFrame = spriteConfig.dontNeedFrame == true
    o.needWindowFrame = spriteConfig.needWindowFrame == true
    o.needToBeAgainstWall = spriteConfig.needToBeAgainstWall == true
    o.isPole = spriteConfig.isPole == true
    o.canBeLockedByPadlock = spriteConfig.canBePadlocked == true
    o.corner = spriteConfig.corner
    o.pillar = spriteConfig.pillar
    o.baseHealth, o.bonusHealth, o.skillBaseHealth = Durability.resolve(o.definition, o.stage, spriteConfig)
    o.breakSound = spriteConfig.breakSound
    o.thumpDmg = objectConfig.thumpDamage or o.thumpDmg
    o.canBarricade = not passableWallOpening and objectConfig.canBarricade == true
    o.buildLow = objectConfig.buildLow == true
    o.drawFloorGrid = objectConfig.drawFloorGrid ~= false
    o.objectConfig = objectConfig
    o.spriteCache = {}
    o.canBePlastered = WallFinishes.isPlasterable(o.definition, o.stage)
    local craftRecipe = StageConfig.recipe(o.definition, o.stage)
    o.craftRecipe = EntityCompat.craftRecipeObject(o.stage)
    if o.character and o.craftRecipe and EntityCompat.usesNativeRecipeInputs(o.stage) and BuildLogic then
        o.containers = containers or currentBuildContainers(o.character)
        o.buildPanelLogic = newNativeBuildLogic(o.character, o.craftRecipe, o.inputChoices, o.containers)
        o.buildLogicCharacter = o.character
    end
    o.maxTime = craftRecipe.time or 200
    o.xpAward = craftRecipe.xpAward
    o.useNativeXpAward = o.craftRecipe ~= nil and (o.stage.xp == nil and construction.xp == nil)
    local actionScript = craftRecipe.timedAction and KBWB41.timedAction(craftRecipe.timedAction) or nil
    if actionScript then
        if actionScript:getSound() then o.craftingBank = actionScript:getSound() end
        if actionScript:getCompletionSound() then o.completionSound = actionScript:getCompletionSound() end
    end
    o.craftingBank = construction.sound or o.craftingBank
    o.completionSound = construction.completionSound or o.completionSound
    o.actionAnim = construction.actionAnim or o.actionAnim
    o.modData = {
        KBW = {
            buildableId = buildableId,
            stageId = o.stage.id,
            variantId = o.variantId,
            materialId = o.materialId,
            entity = entityMetadata.entity,
            schemaVersion = KBW.SCHEMA_VERSION,
            providesWindowFrame = placement.providesWindowFrame == true and true or nil,
            wallType = ((o.stage.finishes or o.definition.finishes) and WallFinishes.wallType(o.definition, o.stage))
                or nil
        }
    }
    Properties.applyToCursor(o)
    return o
end

function KBWBuildingObject:rotateKey(key)
    if KBWB41.isKey("Rotate building", key) then
        if self.isWallLike then
            self.nSprite = wallEdgeDirection(self.nSprite) == 1 and 2 or 1
        else
            self.nSprite = nextDirection(self.stage, self.nSprite)
        end
        self.direction = self.nSprite
        self:getSprite()
        return
    end
    ISBuildingObject.rotateKey(self, key)
    self.direction = self.nSprite
end

function KBWBuildingObject:rotateMouse(x, y)
    ISBuildingObject.rotateMouse(self, x, y)
    if self.isWallLike then
        self.nSprite = wallEdgeDirection(self.nSprite)
    else
        self.nSprite = normalizedDirection(self.stage, self.nSprite)
    end
    self.direction = self.nSprite
    self:getSprite()
end

function KBWBuildingObject:tryBuild(x, y, z)
    if self.isWallLike then
        self.nSprite = wallEdgeDirection(self.nSprite)
    else
        self.nSprite = normalizedDirection(self.stage, self.nSprite)
    end
    self.direction = self.nSprite
    self:getSprite()
    if self.modData and self.modData.KBW then self.modData.KBW.direction = self.nSprite end
    if self.buildPanelLogic and EntityCompat.usesNativeRecipeInputs(self.stage) then
        self.containers = currentBuildContainers(self.character)
        self.buildPanelLogic:setContainers(self.containers)
        applyNativeInputChoices(self.buildPanelLogic, self.craftRecipe, self.inputChoices, self.containers)
    end
    local buildAction = ISBuildingObject.tryBuild(self, x, y, z)
    local construction = StageConfig.construction(self.definition, self.stage)
    local timedActionOnIsValid = StageConfig.sprite(self.definition, self.stage).timedActionOnIsValid
    if buildAction and timedActionOnIsValid then buildAction.onIsValid = timedActionOnIsValid end
    if buildAction and construction.canWalk == true then
        buildAction.stopOnWalk = false
        buildAction.stopOnRun = false
    end
    if not isServer() and WallFinishes.isWallFinish(self.finish) then
        local FinishQueue = require("KnoxBuildworks/Planning/FinishQueue")
        FinishQueue.watch(
            self.character, self.buildableId, x, y, z, self.north == true, self.finish, self.definition, self.stage
        )
    end
    return buildAction
end

function KBWBuildingObject:onActionComplete()
    if ISBuildingObject.onActionComplete then
        ISBuildingObject.onActionComplete(self)
    end
    self.blockBuild = false
end

function KBWBuildingObject:onTimedActionStart(action)
    self:refreshPlayerContext()
    ISBuildingObject.onTimedActionStart(self, action)
    local construction = StageConfig.construction(self.definition, self.stage)
    local craftRecipe = StageConfig.recipe(self.definition, self.stage)
    local actionScript = craftRecipe.timedAction and KBWB41.timedAction(craftRecipe.timedAction) or nil
    if actionScript then
        if actionScript:getActionAnim() then action:setActionAnim(actionScript:getActionAnim()) end
        if actionScript:getAnimVarKey() then
            action:setAnimVariable(actionScript:getAnimVarKey(), actionScript:getAnimVarVal())
        end
    end
    if construction.actionAnim then action:setActionAnim(construction.actionAnim) end
    local animVariable = construction.animVariable or {}
    if animVariable.key and animVariable.value then action:setAnimVariable(animVariable.key, animVariable.value) end
    local square = self.square
    local prop1, prop2 = Requirements.handModels(self.character, self.definition, self.stage, square, self.inputChoices)
    if prop1 ~= nil or prop2 ~= nil then
        action:setOverrideHandModels(prop1, prop2)
    elseif actionScript and (actionScript:getProp1() or actionScript:getProp2()) then
        action:setOverrideHandModels(actionScript:getProp1(), actionScript:getProp2())
    end
end

function KBWBuildingObject:haveMaterial(square)
    if not self:refreshPlayerContext() then return false end
    return Requirements.evaluate(self.character, self.definition, self.stage, square, self.inputChoices).ok
end

function KBWBuildingObject:getFootprint()
    local direction = faceName(self.nSprite)
    return Matrix.getFaceCells(self.stage, direction)
end

function KBWBuildingObject:getFace()
    local name = string.lower(faceName(self.nSprite))
    return { getFaceName = function () return name end }
end

function KBWBuildingObject:ensureSquareExists(x, y, z)
    if not getWorld():isValidSquare(x, y, z) then return nil end
    local square = getCell():getGridSquare(x, y, z)
    if not square then
        square = IsoGridSquare.new(getCell(), nil, x, y, z)
        getCell():ConnectNewSquare(square, false)
    end
    KBWB41.call(square, "EnsureSurroundNotNull")
    return square
end

function KBWBuildingObject:ensureSquaresExist(x, y, z)
    local footprint = self:getFootprint()
    if footprint then
        for tileIndex = 1, #footprint do
            local tile = footprint[tileIndex]
            if tile.sprite or tile.blocks then
                self:ensureSquareExists(x + (tile.dx or 0), y + (tile.dy or 0), z + (tile.dz or 0))
            end
        end
    else
        self:ensureSquareExists(x, y, z)
    end
end

function KBWBuildingObject:getCachedSprite(spriteName)
    if not spriteName then return nil end
    local sprite = self.spriteCache and self.spriteCache[spriteName]
    if sprite then return sprite end
    sprite = getSprite(spriteName)
    if not sprite then
        sprite = IsoSprite.new()
        KBWB41.loadSpriteTexture(sprite, spriteName)
    end
    self.spriteCache[spriteName] = sprite
    return sprite
end

function KBWBuildingObject:walkTo(x, y, z)
    local square = getCell():getGridSquare(x, y, z)
    local occupied = {}
    local footprint = self:getFootprint() or {}
    for cellIndex = 1, #footprint do
        local cell = footprint[cellIndex]
        local target = getCell():getGridSquare(x + cell.dx, y + cell.dy, z + (cell.dz or 0))
        if target and (cell.blocks or cell.sprite) then
            occupied[#occupied + 1] = target
        end
    end
    local isStairs = (self.definition.placement or {}).kind == "stairs"
        or string.find(string.lower(tostring(self.buildableId or "")), "stairs", 1, true) ~= nil
    if isStairs then
        local bottom = nil
        for cellIndex = 1, #footprint do
            local cell = footprint[cellIndex]
            local stairSprite = cell.sprite and getSprite(cell.sprite) or nil
            local stairType = stairSprite and stairSprite:getType() or nil
            if stairType == IsoObjectType.stairsBW or stairType == IsoObjectType.stairsBN then
                bottom = getCell():getGridSquare(x + (cell.dx or 0), y + (cell.dy or 0), z + (cell.dz or 0))
                break
            end
        end
        if bottom then return luautils.walkAdj(self.character, bottom, false, occupied) end
    end
    if #occupied > 1 then return KBWB41.walkAdjSquares(self.character, occupied) end
    if self.isWallLike then
        local previousStage = Placement.previousStageOf(self.stage)
        local frame = square and previousStage
            and Placement.findPrevious(square, self.definition.id, previousStage, self.north == true) or nil
        if frame and isStandingAtWallEdge(self.character, square, self.north == true) then
            ISTimedActionQueue.clear(self.character)
            return true
        end
        return luautils.walkAdjWall(self.character, square, self.north)
    end
    return ISBuildingObject.walkTo(self, x, y, z)
end

function KBWBuildingObject:isValid(square)
    if not self:refreshPlayerContext() then return false end
    if self.blockBuild or not self.definition or not self.stage then return false end
    if not Integrity.isAllowed(self.character) then
        self.validationReason = "definition integrity mismatch"
        return false
    end
    self:getSprite()
    local ok, reason, previous = Placement.validate(self, square)
    if not ok then
        self.validationReason = reason
        return false
    end
    if not self:haveMaterial(square) then
        self.validationReason = "requirements not met"
        return false
    end
    if WallFinishes.isWallFinish(self.finish) then
        local finishOk, finishReason = FinishActions.validate(
            self.character, self.definition, self.stage, self.finish, true
        )
        if not finishOk then
            self.validationReason = finishReason or "finish materials missing"
            return false
        end
    end
    if previous then return true end
    local footprint = self:getFootprint()
    if footprint then return true end
    if (self.definition.placement or {}).kind == "floor" then
        if square:getZ() > 0 then
            local below = getCell():getGridSquare(square:getX(), square:getY(), square:getZ() - 1)
            if below and below:HasStairs() then return false end
        end
        for i = 0, square:getObjects():size() - 1 do
            local object = square:getObjects():get(i)
            if object:getTextureName() == self:getSprite() or object:getSpriteName() == self:getSprite() then
                return false
            end
        end
        return square:connectedWithFloor()
    end
    if (self.definition.placement or {}).kind == "overlay" then return true end
    return ISBuildingObject.isValid(self, square)
end

function KBWBuildingObject:getStackRenderOffset(spriteName, square)
    if not spriteName or not square then return 0 end
    local sharedSprite = getSprite(spriteName)
    if not sharedSprite then return 0 end
    local properties = sharedSprite:getProperties()
    if not KBWB41.propIs(properties, "IsStackable") and not KBWB41.propIs(properties, "IsTableTop") then return 0 end
    local props = ISMoveableSpriteProps.new(sharedSprite)
    local offset = props:getTotalTableHeight(square)
    if KBWB41.propIs(properties, "IsTableTop") and props.surface and props.surfaceIsOffset then
        offset = offset - props.surface
    end
    return offset
end

function KBWBuildingObject:getFloorCursorSprite()
    return KBWB41.floorCursorSprite()
end

function KBWBuildingObject:render(x, y, z, square)
    local previewSquareKey = string.format("%d:%d:%d:%d", x, y, z, self.nSprite or 1)
    if self.previewSquareKey ~= previewSquareKey then
        self.previewSquareKey = previewSquareKey
        self:ensureSquaresExist(x, y, z)
    end
    local footprint = self:getFootprint()
    if not footprint then
        ISBuildingObject.render(self, x, y, z, square)
        return
    end
    local valid = self:isValid(square)
    local floorSprite = self:getFloorCursorSprite()
    for tileIndex = 1, #footprint do
        local tile = footprint[tileIndex]
        local tileX, tileY, tileZ = x + (tile.dx or 0), y + (tile.dy or 0), z + (tile.dz or 0)
        if tile.blocks and floorSprite then
            floorSprite:RenderGhostTileColor(
                tileX, tileY, tileZ, valid and 0.25 or 0.8, valid and 0.9 or 0.15, valid and 0.9 or 0.15, 0.35
            )
        end
        local spriteName = tile.sprite
        if spriteName and WallFinishes.isWallFinish(self.finish) then
            spriteName = WallFinishes.previewSprite(
                self.finish, self.north == true, self.definition, self.stage, tile.sprite
            ) or spriteName
        end
        if Mannequins.renderPreview(spriteName, tileX, tileY, tileZ, self.nSprite) then
            spriteName = nil
        end
        local sprite = spriteName and self:getCachedSprite(spriteName) or nil
        if sprite then
            local tileSquare = getCell():getGridSquare(tileX, tileY, tileZ)
            local offsetY = self:getStackRenderOffset(tile.sprite, tileSquare)
            if offsetY ~= 0 then
                sprite:RenderGhostTileColor(
                    tileX, tileY, tileZ, 0, offsetY * Core.getTileScale(), valid and 1.0 or 0.65, valid and 1.0 or 0.2,
                    valid and 1.0 or 0.2, 0.6
                )
            else
                sprite:RenderGhostTileColor(
                    tileX, tileY, tileZ, valid and 1.0 or 0.65, valid and 1.0 or 0.2, valid and 1.0 or 0.2, 0.6
                )
            end
        end
    end
end

function KBWBuildingObject:getBuildHealth()
    local base = self.baseHealth or 0
    local req = (self.stage.requirements or {}).skills or {}
    local highest = 0
    for perkName in pairs(req) do
        if Perks[perkName] then highest = math.max(highest, self.character:getPerkLevel(Perks[perkName])) end
    end
    local bonus = self.bonusHealth or 0
    local option = getSandboxOptions() and getSandboxOptions():getOptionByName("ConstructionBonusPoints")
    if option then
        local value = option:getValue()
        if value == 1 then
            bonus = bonus * .5
        elseif value == 2 then
            bonus = bonus * .7
        elseif value == 4 then
            bonus = bonus * 1.3
        elseif value == 5 then
            bonus = bonus * 1.5
        end
    end
    return base + bonus + (highest * (self.skillBaseHealth or 0))
end

function KBWBuildingObject:runOnCreate(part, context)
    local onCreate = StageConfig.sprite(self.definition, self.stage).onCreate
    if not onCreate or not part then return nil end
    local square = part:getSquare()
    return LuaCallback.callObject(onCreate, {
        thumpable = part,
        craftRecipeData = self.craftRecipeData,
        character = self.character,
        facing = string.lower(faceName(self.nSprite)),
        north = self.north == true,
        square = square,
        definition = self.definition,
        stage = self.stage,
        buildObject = self,
        buildableId = self.buildableId,
        stageId = self.stage and self.stage.id or nil,
        tile = context and context.tile or nil,
        tileIndex = context and context.tileIndex or nil,
        x = square and square:getX() or nil,
        y = square and square:getY() or nil,
        z = square and square:getZ() or nil
    })
end

local function consumedKeyId(recipeData)
    if not recipeData or not recipeData.getAllRecordedConsumedItems then return nil end
    local items = recipeData:getAllRecordedConsumedItems()
    if not items then return nil end
    local fallback = nil
    for itemIndex = 0, items:size() - 1 do
        local usedItem = items:get(itemIndex)
        local keyId = usedItem and usedItem.getKeyId and usedItem:getKeyId() or nil
        if keyId and keyId ~= -1 then
            if usedItem:getFullType() == "Base.Doorknob" then return keyId end
            if fallback == nil then fallback = keyId end
        end
    end
    return fallback
end

function KBWBuildingObject:consumeConstructionRequirements(square)
    local usesNativeInputs = EntityCompat.usesNativeRecipeInputs(self.stage)
    if usesNativeInputs and not self.craftRecipe then
        self.craftRecipe = EntityCompat.craftRecipeObject(self.stage)
    end
    if not usesNativeInputs or not self.craftRecipe or not BuildLogic then
        local consumed, recipeData = Requirements.consume(
            self.character, self.stage, square, self.definition, self.inputChoices
        )
        self.craftRecipeData = recipeData
        return consumed, consumed and nil or "Knox recipe inputs changed before consumption"
    end

    local containers = currentBuildContainers(self.character)
    self.containers = containers
    local logic = newNativeBuildLogic(self.character, self.craftRecipe, self.inputChoices, containers)
    if not logic then return false, "native build logic unavailable" end
    local nativeAwards = self.stage._kbwAdminXpOverride and {} or EntityCompat.xpAwards(self.stage)
    Log:info(
        "Entity XP check for %s uses recipe %s with %d award(s)", tostring(self.buildableId),
        tostring(self.craftRecipe:getName()), #nativeAwards
    )
    snapshotXp(self.character, nativeAwards)
    logic:startCraftAction(nil)
    self.craftRecipeData = logic:getRecipeData()
    self.nativeRecipeHandled = true
    if self.character:isBuildCheat() then return true end
    if not logic:performCurrentRecipe() then
        return false, nativeInputFailure(logic, self.craftRecipe, containers)
    end
    local inProgress = logic:getRecipeDataInProgress()
    inProgress:luaCallOnCreate(self.character)
    inProgress:processDestroyAndUsedItems(self.character)
    self.nativeXpPending = #nativeAwards > 0 and not nativeXpWasGranted(self.character, nativeAwards)
    if #nativeAwards > 0 and not self.nativeXpPending then
        Log:info("Entity recipe XP credited during native completion for %s", tostring(self.buildableId))
    elseif #nativeAwards == 0 then
        Log:info(
            "Entity recipe %s has no configured XP award for %s", tostring(self.craftRecipe:getName()),
            tostring(self.buildableId)
        )
    end
    return true
end

function KBWBuildingObject:transmitPart(part, result)
    if self.objectName then
        if part and part.setName then part:setName(self.objectName) end
        if result and result.object and result.object.setName then
            result.object:setName(self.objectName)
        end
    end
    if result ~= nil then
        if result.objectAlreadyTransmitted then return end
        if result.replaceObject and result.object ~= nil then
            local sourceModData = part and part.getModData and part:getModData() or nil
            local replacementModData = result.object.getModData and result.object:getModData() or nil
            if sourceModData and sourceModData.KBW and replacementModData then
                replacementModData.KBW = sourceModData.KBW
            end
            result.object:transmitCompleteItemToClients()
            return
        end
    end
    if part and part.transmitCompleteItemToClients then part:transmitCompleteItemToClients() end
end

function KBWBuildingObject:verifyAuthoritative(x, y, z)
    if not Integrity.isAllowed(self.character) then return false, "definition integrity mismatch" end
    if self.blueprintId then
        local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return false, "unknown blueprint" end
        if not Blueprints.canBuild(self.character, blueprint) then
            return false, "no build access on blueprint"
        end
    end
    local definition, stage, reason = Resolver.resolveStage(
        self.buildableId, self.variantId, self.materialId, self.stageId or (self.stage and self.stage.id)
    )
    if not definition or not stage then return false, reason or "unknown buildable" end
    self.definition, self.stage = definition, stage
    local spriteConfig = StageConfig.sprite(definition, stage)
    if spriteConfig.onIsValid and not LuaCallback.resolve(spriteConfig.onIsValid) then
        return false, "OnIsValid callback is unavailable: " .. tostring(spriteConfig.onIsValid)
    end
    if spriteConfig.onCreate and not LuaCallback.resolve(spriteConfig.onCreate) then
        return false, "OnCreate callback is unavailable: " .. tostring(spriteConfig.onCreate)
    end
    if self.nativeObject and self.nativeObject.type == "generator" then
        local itemType = self.nativeObject.item
        if not getScriptManager() or not getScriptManager():getItem(itemType) then
            return false, "native generator item is unavailable: " .. tostring(itemType)
        end
    end
    if LuaCallback.requiresNativeRecipe(spriteConfig.onCreate) and not EntityCompat.usesNativeRecipeInputs(stage) then
        return false,
            "OnCreate callback requires an entity-backed native CraftRecipe: " .. tostring(spriteConfig.onCreate)
    end
    local finishOk, finishReason = FinishActions.validate(self.character, definition, stage, self.finish, true)
    if not finishOk then return false, finishReason or "invalid finish" end
    local choicesOk, choicesReason = Resolver.validateChoices(definition, stage, self.inputChoices)
    if not choicesOk then return false, choicesReason or "invalid ingredient choices" end
    if self.character and self.character.isBuildCheat and self.character:isBuildCheat() then return true end
    local bounds = Matrix.getBounds(self:getFootprint() or {})
    local slack = math.max(bounds.width or 1, bounds.height or 1) + 2
    local dx = self.character:getX() - (x + 0.5)
    local dy = self.character:getY() - (y + 0.5)
    if dx * dx + dy * dy > slack * slack then return false, "too far from build site" end
    local dz = math.abs(math.floor(self.character:getZ()) - z)
    if dz > math.max(1, (bounds.depth or 1)) then return false, "wrong level for build site" end
    return true
end

local function alwaysTrue(item)
    return item ~= nil
end

function KBWBuildingObject:findLightSourceItem(spriteConfig)
    if not spriteConfig.lightRadius or not self.character then return nil end
    local inventory = self.character:getInventory()
    if not inventory then return nil end
    if spriteConfig.lightsourceItem then
        local item = inventory:getFirstTypeRecurse(spriteConfig.lightsourceItem)
        if item then return item end
    end
    local tags = spriteConfig.lightsourceTags or {}
    for tagIndex = 1, #tags do
        if KBWB41 then
            local tag = KBWB41.tagName(tags[tagIndex])
            if tag then
                local item = inventory:getFirstTagEvalRecurse(tag, alwaysTrue)
                if item then return item end
            end
        end
    end
    if self.character:isBuildCheat() and spriteConfig.debugItem then
        return instanceItem(spriteConfig.debugItem)
    end
    return nil
end

function KBWBuildingObject:attachLightSource(part, spriteConfig, torchItem)
    if not spriteConfig.lightRadius or not torchItem then return end
    local offsets = (spriteConfig.lightOffsets or {})[faceName(self.nSprite)] or {}
    part:createLightSource(
        spriteConfig.lightRadius, offsets.x or 0, offsets.y or 0, offsets.z or 0, 0, spriteConfig.lightsourceFuel,
        torchItem, self.character
    )
end

function KBWBuildingObject:applyPartFlags(part)
    local props = part:getProperties()
    if not props then return end
    local spriteType = part:getType()
    self.blockAllTheSquare = KBWB41.hasProperty(props, "BLOCKS_PLACEMENT") == true
    self.canPassThrough = not (KBWB41.propIs(props, IsoFlagType.solid) or KBWB41.propIs(props, IsoFlagType.solidtrans)
        or KBWB41.propIs(props, IsoFlagType.doorN) or KBWB41.propIs(props, IsoFlagType.doorW)
        or KBWB41.propIs(props, IsoFlagType.collideN) or KBWB41.propIs(props, IsoFlagType.collideW)
        or KBWB41.propIs(props, IsoFlagType.WindowN) or KBWB41.propIs(props, IsoFlagType.WindowW)
        or KBWB41.propIs(props, IsoFlagType.windowN) or KBWB41.propIs(props, IsoFlagType.windowW)
        or KBWB41.propIs(props, IsoFlagType.DoorWallN) or KBWB41.propIs(props, IsoFlagType.DoorWallW)
        or KBWB41.propIs(props, IsoFlagType.HoppableN) or KBWB41.propIs(props, IsoFlagType.HoppableW)
        or KBWB41.propIs(props, IsoFlagType.WallN) or KBWB41.propIs(props, IsoFlagType.WallNTrans)
        or KBWB41.propIs(props, IsoFlagType.WallW) or KBWB41.propIs(props, IsoFlagType.WallWTrans)
        or KBWB41.propIs(props, IsoFlagType.WallNW))
    self.hoppable = (KBWB41.propIs(props, IsoFlagType.HoppableN) or KBWB41.propIs(props, IsoFlagType.HoppableW)
        or KBWB41.propIs(props, IsoFlagType.TallHoppableN) or KBWB41.propIs(props, IsoFlagType.TallHoppableW)) == true
    self.isStairs = spriteType ~= nil
        and (spriteType == IsoObjectType.stairsTW or spriteType == IsoObjectType.stairsTN
            or spriteType == IsoObjectType.stairsMW or spriteType == IsoObjectType.stairsMN
            or spriteType == IsoObjectType.stairsBW or spriteType == IsoObjectType.stairsBN)
    self.isDoorFrame = spriteType ~= nil
        and (spriteType == IsoObjectType.doorFrN or spriteType == IsoObjectType.doorFrW)
    self.isDoor = spriteType ~= nil and (spriteType == IsoObjectType.doorN or spriteType == IsoObjectType.doorW)
    self.isFloor = KBWB41.propIs(props, IsoFlagType.solidfloor) == true
    if self.isDoor then self.thumpDmg = 5 end
    self.canBarricade = (self.isDoor or KBWB41.propIs(props, IsoFlagType.WindowN)
        or KBWB41.propIs(props, IsoFlagType.WindowW) or KBWB41.propIs(props, IsoFlagType.windowN)
        or KBWB41.propIs(props, IsoFlagType.windowW))
        and not (KBWB41.hasProperty(props, "DOUBLE_DOOR") or KBWB41.hasProperty(props, "GARAGE_DOOR"))
    self.canBarricade = self.canBarricade == true
    local objectConfig = self.objectConfig or {}
    if objectConfig.blockAllSquare ~= nil then self.blockAllTheSquare = objectConfig.blockAllSquare == true end
    if objectConfig.canPassThrough ~= nil then self.canPassThrough = objectConfig.canPassThrough == true end
    if objectConfig.isDoorFrame ~= nil then self.isDoorFrame = objectConfig.isDoorFrame == true end
    if objectConfig.isCorner ~= nil then self.isCorner = objectConfig.isCorner == true end
    if objectConfig.hoppable ~= nil then self.hoppable = objectConfig.hoppable == true end
    if objectConfig.thumpDamage ~= nil then self.thumpDmg = objectConfig.thumpDamage end
    if objectConfig.canBarricade ~= nil then self.canBarricade = objectConfig.canBarricade == true end
    local sprite = part:getSprite()
    if isPassableWallOpeningSprite(sprite and sprite:getName() or nil, self.north == true) then
        self.canPassThrough = true
        self.hoppable = false
        self.canBarricade = false
    end
end

function KBWBuildingObject:connectWallParts(square, part, north)
    local identity = connectionData(part)
    if not identity or (not self.corner and not self.pillar) then return part end
    local matchIdentity = copyTable(identity)
    matchIdentity.connectionRole = nil

    if self.corner then
        local perpendicular = findMatchingWallEdge(square, matchIdentity, not north, part)
        local finishesMatch = WallFinishes.objectFinishSignature(perpendicular)
            == WallFinishes.plannedFinishSignature(self.finish)
        if perpendicular
            and finishesMatch
            and not wallRunContinues(square, matchIdentity, north)
            and not wallRunContinues(square, matchIdentity, not north) then
            local cornerMaxHealth = math.max(
                tonumber(part:getMaxHealth()) or 0,
                tonumber(perpendicular:getMaxHealth()) or 0
            )
            local cornerHealth = math.max(
                tonumber(part:getHealth()) or 0,
                tonumber(perpendicular:getHealth()) or 0
            )
            square:transmitRemoveItemFromSquare(perpendicular)
            square:RemoveTileObject(part)

            local corner = IsoThumpable.new(getCell(), square, self.corner, false, self)
            self:applyPartFlags(corner)
            buildUtil.setInfo(corner, self)
            corner:setMaxHealth(cornerMaxHealth)
            corner:setHealth(cornerHealth)
            corner:setBreakSound(self.breakSound or KBWB41.breakSound(self.corner))
            corner:setCanBePlastered(self.canBePlastered == true
                and WallFinishes.vanillaPaintable(self.corner))
            corner:setCorner(true)
            corner:setCanBarricade(false)
            corner:getModData().KBW = copyTable(matchIdentity)
            corner:getModData().KBW.direction = 1
            corner:getModData().KBW.connectionRole = "corner"
            square:AddSpecialObject(corner)
            square:RecalcAllWithNeighbours(true)
            return corner
        end
    end

    if not self.pillar then return part end
    local otherX, otherY = square:getX() + 1, square:getY() - 1
    local pillarX, pillarY = square:getX() + 1, square:getY()
    if not north then
        otherX, otherY = square:getX() - 1, square:getY() + 1
        pillarX, pillarY = square:getX(), square:getY() + 1
    end
    local otherSquare = getCell():getGridSquare(otherX, otherY, square:getZ())
    if not findMatchingWallEdge(otherSquare, matchIdentity, not north, nil) then return part end

    local pillarSquare = self:ensureSquareExists(pillarX, pillarY, square:getZ())
    if not pillarSquare or pillarSquare:getWallFull() or squareHasSprite(pillarSquare, self.pillar) then return part end
    local pillar = IsoThumpable.new(getCell(), pillarSquare, self.pillar, false, self)
    buildUtil.setInfo(pillar, self)
    pillar:setName(self.name)
    pillar:setMaxHealth(part:getMaxHealth())
    pillar:setHealth(part:getHealth())
    pillar:setCorner(true)
    pillar:setCanPassThrough(true)
    pillar:setCanBarricade(false)
    pillar:setCanBePlastered(self.canBePlastered == true)
    pillar:getModData().KBW = copyTable(matchIdentity)
    pillar:getModData().KBW.connectionRole = "pillar"
    pillarSquare:AddSpecialObject(pillar)
    pillarSquare:RecalcAllWithNeighbours(true)
    pillar:transmitCompleteItemToClients()
    buildUtil.setHaveConstruction(pillarSquare, true)
    return part
end

function KBWBuildingObject:create(x, y, z, north, sprite)
    if not self:refreshPlayerContext() then
        Log:warning("Server rejected build %s: authoritative player is unavailable", tostring(self.buildableId))
        return false
    end
    if self.isWallLike then
        self.nSprite = north == true and 2 or 1
        self.direction = self.nSprite
    end
    self:getSprite()
    north = self.north == true
    if self.modData and self.modData.KBW then self.modData.KBW.direction = self.nSprite end
    local verified, verifyReason = self:verifyAuthoritative(x, y, z)
    if not verified then
        Log:warning(
            "Server rejected build %s at %d,%d,%d: %s", tostring(self.buildableId), x, y, z, tostring(verifyReason)
        )
        return false
    end
    self.craftRecipe = EntityCompat.craftRecipeObject(self.stage)
    local craftRecipeConfig = StageConfig.recipe(self.definition, self.stage)
    local construction = StageConfig.construction(self.definition, self.stage)
    self.xpAward = craftRecipeConfig.xpAward
    self.useNativeXpAward = self.craftRecipe ~= nil and (self.stage.xp == nil and construction.xp == nil)
    self:ensureSquaresExist(x, y, z)
    local square = getCell():getGridSquare(x, y, z)
    local footprint = self:getFootprint() or { { dx = 0, dy = 0, dz = 0, sprite = sprite } }
    local hasPlacedSprite = false
    local hasAnchorSprite = false
    for footprintIndex = 1, #footprint do
        local footprintTile = footprint[footprintIndex]
        if footprintTile.sprite then
            hasPlacedSprite = true
            if not getSprite(footprintTile.sprite) then
                Log:error(
                    "Server rejected build %s at %d,%d,%d: footprint sprite %s is unavailable",
                    tostring(self.buildableId), x, y, z, tostring(footprintTile.sprite)
                )
                return false
            end
            if (footprintTile.dx or 0) == 0 and (footprintTile.dy or 0) == 0
                and (footprintTile.dz or 0) == 0 then
                hasAnchorSprite = true
            end
            local target = getCell():getGridSquare(
                x + (footprintTile.dx or 0), y + (footprintTile.dy or 0), z + (footprintTile.dz or 0)
            )
            if not target then
                Log:warning(
                    "Server rejected build %s at %d,%d,%d: footprint square is unavailable",
                    tostring(self.buildableId), x, y, z
                )
                return false
            end
        end
    end
    if not hasPlacedSprite then
        Log:error(
            "Server rejected build %s at %d,%d,%d: resolved face has no buildable sprites",
            tostring(self.buildableId), x, y, z
        )
        return false
    end
    local ok, reason, previous = Placement.validate(self, square)
    if not ok or not Requirements.evaluate(self.character, self.definition, self.stage, square, self.inputChoices).ok then
        Log:warning("Server rejected build %s at %d,%d,%d: %s", self.buildableId, x, y, z, reason or "requirements")
        return false
    end
    if previous and not hasAnchorSprite then
        Log:error(
            "Server rejected replacement %s at %d,%d,%d: resolved face has no anchor sprite",
            tostring(self.buildableId), x, y, z
        )
        return false
    end
    local spriteConfig = StageConfig.sprite(self.definition, self.stage)
    local torchItem = self:findLightSourceItem(spriteConfig)
    local consumed, consumptionReason = self:consumeConstructionRequirements(square)
    if not consumed then
        Log:warning(
            "Server rejected build %s at %d,%d,%d during consumption: %s", tostring(self.buildableId), x, y, z,
            tostring(consumptionReason or "requirements changed")
        )
        return false
    end
    self.keyId = consumedKeyId(self.craftRecipeData)
    local replacedIndex = -1
    local previousRemoved = false
    local function removePrevious(target)
        if previous and not previousRemoved and target == square then
            replacedIndex = square:transmitRemoveItemFromSquare(previous) or -1
            previousRemoved = true
        end
        return replacedIndex
    end
    local groupId = string.format("%s:%d:%d:%d:%d", self.buildableId, x, y, z, getTimestampMs())
    local placement = StageConfig.placement(self.definition, self.stage)
    for index = 1, #footprint do
        local tile = footprint[index]
        if tile.sprite then
            local target = self:ensureSquareExists(x + (tile.dx or 0), y + (tile.dy or 0), z + (tile.dz or 0))
            local nativeObjectType = nil
            if not spriteConfig.lightRadius then
                nativeObjectType = NativeObjectFactory.resolve(self.nativeObject, tile.sprite)
            end
            self.modData.KBW.groupId, self.modData.KBW.partIndex, self.modData.KBW.partCount = groupId,
                index, #footprint
            if placement.kind == "floor" and not isRoofObjectSprite(tile.sprite) then
                local part = target:addFloor(tile.sprite)
                part:getModData().KBW = copyTable(self.modData.KBW)
                EntityCompat.attach(part, self.stage, true)
                local objects = target:getObjects()
                for objectIndex = objects:size() - 1, 0, -1 do
                    local existing = objects:get(objectIndex)
                    local existingProps = existing and existing:getProperties() or nil
                    if existing ~= part and existingProps
                        and KBWB41.propIs(existingProps, IsoFlagType.canBeRemoved) then
                        target:transmitRemoveItemFromSquare(existing)
                        target:RemoveTileObject(existing)
                        break
                    end
                end
                target:disableErosion()
                sendServerCommand(
                    "erosion", "disableForSquare", { x = target:getX(), y = target:getY(), z = target:getZ() }
                )
                Properties.applyToObject(
                    part, self, { square = target, spriteConfig = spriteConfig, tileIndex = index, isFloor = true }
                )
                target:RecalcAllWithNeighbours(true)
                buildUtil.setHaveConstruction(target, true)
                self:transmitPart(part, self:runOnCreate(part, { tile = tile, tileIndex = index }))
            elseif nativeObjectType then
                local part, nativeState, nativeError = NativeObjectFactory.create(
                    nativeObjectType, self.nativeObject, target, tile.sprite, { direction = self.nSprite }
                )
                if not part then
                    Log:error(
                        "Failed to create native %s for %s: %s", tostring(nativeObjectType), tostring(self.buildableId),
                        tostring(nativeError)
                    )
                    return false
                end
                part:getModData().KBW = copyTable(self.modData.KBW)
                EntityCompat.attach(part, self.stage, true)
                removePrevious(target)
                local nativeInsertIndex = previousRemoved and target == square and replacedIndex >= 0 and replacedIndex or nil
                NativeObjectFactory.insert(part, nativeState, target, nativeInsertIndex)
                Properties.applyToObject(
                    part, self, { square = target, spriteConfig = spriteConfig, tileIndex = index, isFloor = false }
                )
                KBWB41.setExplored(part)
                local callbackResult = self:runOnCreate(part, { tile = tile, tileIndex = index })
                NativeObjectFactory.finalize(part, nativeState, target)
                if callbackResult and callbackResult.replaceObject then
                    self:transmitPart(part, callbackResult)
                elseif nativeState.alreadyTransmitted then
                    if part.transmitModData then part:transmitModData() end
                else
                    self:transmitPart(part, callbackResult)
                end
                buildUtil.setHaveConstruction(target, true)
            elseif not spriteConfig.lightRadius and (self.isProp or isFloorAttachmentSprite(tile.sprite)
                or isWallDecorationSprite(tile.sprite) or isRoofObjectSprite(tile.sprite)) then
                removePrevious(target)
                local props = ISMoveableSpriteProps.new(IsoObject.new(target, tile.sprite):getSprite())
                props.rawWeight = 10
                local part = props:placeMoveableInternal(target, instanceItem("Base.Plank"), tile.sprite)
                local plainProp = false
                if not part then
                    part = IsoObject.new(target, tile.sprite)
                    target:AddTileObject(part)
                    plainProp = true
                end
                if part then
                    part:getModData().KBW = copyTable(self.modData.KBW)
                    Properties.applyToObject(part, self, {
                        square = target,
                        spriteConfig = spriteConfig,
                        tileIndex = index,
                        isFloor = isFloorAttachmentSprite(tile.sprite)
                    })
                    self:runOnCreate(part, { tile = tile, tileIndex = index })
                    if plainProp and part.transmitCompleteItemToClients then
                        part:transmitCompleteItemToClients()
                    elseif part.transmitModData then
                        part:transmitModData()
                    end
                end
            elseif isGarageDoorSprite(tile.sprite) then
                local part = IsoDoor.new(getCell(), target, tile.sprite, north)
                local health = math.max(tonumber(self:getBuildHealth()) or 0, tonumber(part:getHealth()) or 0)
                part:setHealth(health)
                if self.keyId then part:setKeyId(self.keyId) end
                part:getModData().KBW = copyTable(self.modData.KBW)
                EntityCompat.attach(part, self.stage, true)
                removePrevious(target)
                if previousRemoved and target == square and replacedIndex >= 0 then
                    target:AddSpecialObject(part, replacedIndex)
                else
                    target:AddSpecialObject(part)
                end
                Properties.applyToObject(
                    part, self, { square = target, spriteConfig = spriteConfig, tileIndex = index, isFloor = false }
                )
                KBWB41.setExplored(part)
                target:RecalcAllWithNeighbours(true)
                self:transmitPart(part, self:runOnCreate(part, { tile = tile, tileIndex = index }))
                buildUtil.setHaveConstruction(target, true)
            else
                local faceKey = faceName(self.nSprite)
                local openSprite = (self.stage.sprites and self.stage.sprites[faceKey .. "_open"])
                    or spriteConfig.openSprite
                local part = openSprite and IsoThumpable.new(getCell(), target, tile.sprite, openSprite, north, self)
                    or IsoThumpable.new(getCell(), target, tile.sprite, north, self)
                self:applyPartFlags(part)
                local configuredIsContainer = self.isContainer
                local configuredContainerType = self.containerType
                local tileContainerType = nativeContainerType(tile.sprite)
                if tileContainerType then
                    self.isContainer = true
                    self.containerType = tileContainerType
                elseif self.stage.container == nil then
                    self.isContainer = false
                    self.containerType = nil
                end
                buildUtil.setInfo(part, self)
                self.isContainer = configuredIsContainer
                self.containerType = configuredContainerType
                if self.isDoor and self.keyId then part:setKeyId(self.keyId) end
                part:setCanBePlastered(self.canBePlastered == true)
                local health = self:getBuildHealth()
                part:setMaxHealth(health)
                part:setHealth(health)
                part:setBreakSound(self.breakSound or KBWB41.breakSound(tile.sprite))
                if self.canBeLockedByPadlock then part:setCanBeLockByPadlock(true) end
                local stackOffset = self:getStackRenderOffset(tile.sprite, target)
                if stackOffset ~= 0 then part:setRenderYOffset(stackOffset) end
                part:getModData().KBW = copyTable(self.modData.KBW)
                EntityCompat.attach(part, self.stage, true)
                removePrevious(target)
                if previousRemoved and target == square and replacedIndex >= 0 then
                    target:AddSpecialObject(part, replacedIndex)
                else
                    target:AddSpecialObject(part)
                end
                part = self:connectWallParts(target, part, north)
                Properties.applyToObject(
                    part, self, { square = target, spriteConfig = spriteConfig, tileIndex = index, isFloor = false }
                )
                KBWB41.setExplored(part)
                self:attachLightSource(part, spriteConfig, torchItem)
                target:RecalcAllWithNeighbours(true)
                self:transmitPart(part, self:runOnCreate(part, { tile = tile, tileIndex = index }))
                buildUtil.setHaveConstruction(target, true)
            end
        end
    end
    if self.character and self.nativeXpPending and self.craftRecipe then
        Log:warning(
            "Native recipe XP was not credited during %s; applying the B42.20 CraftRecipe fallback",
            tostring(self.buildableId)
        )
        self.craftRecipe:addXP(self.character, true)
        self.nativeXpPending = false
    elseif self.character and self.craftRecipe and self.useNativeXpAward and not self.nativeRecipeHandled then
        local nativeAwards = EntityCompat.xpAwards(self.stage)
        Log:info(
            "Entity XP completion for %s uses recipe %s with %d award(s) outside BuildLogic", tostring(self.buildableId),
            tostring(self.craftRecipe:getName()), #nativeAwards
        )
        if #nativeAwards > 0 then
            self.craftRecipe:addXP(self.character, true)
        else
            Log:info(
                "Entity recipe %s has no configured XP award for %s", tostring(self.craftRecipe:getName()),
                tostring(self.buildableId)
            )
        end
    elseif self.character and self.xpAward and (not self.nativeRecipeHandled or self.stage._kbwAdminXpOverride) then
        local multiplier = tonumber(KBW.sandboxValue("KnoxBuildworks.BuildXPMultiplier", 1.0)) or 1.0
        for perkName, amount in pairs(self.xpAward) do
            local perk = Perks[perkName]
            local xp = tonumber(amount)
            if perk and xp then
                local requested = xp * multiplier
                local gained = awardConfiguredXp(self.character, perk, requested)
                Log:info(
                    "Awarded %s/%s %s XP (requested %s) for %s", tostring(perkName), tostring(perk:getId()),
                    tostring(gained), tostring(requested), tostring(self.buildableId)
                )
            end
        end
    end
    Log:info("Built %s:%s at %d,%d,%d", self.buildableId, self.stage.id, x, y, z)
    return true
end

return KBWBuildingObject
