local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local KBWB41 = require("KnoxBuildworks/Compat/B41")
local WallFinishes = {}

local registeredWallTypes = {}
local registeredSpriteTypes = {}
local registeredSpriteDirections = {}

local function translated(key, fallback)
    if not getText then return fallback or key end
    local text = getText(key)
    if text == key then return fallback or key end
    return text
end

local function scriptFor(fullType)
    if not fullType then return nil end
    if getItem then
        local script = KBWB41.scriptItem(fullType)
        if script then return script end
    end
    return ScriptManager and ScriptManager.instance and ScriptManager.instance:FindItem(fullType) or nil
end

local function normalizeFullType(itemType)
    if not itemType then return nil end
    local value = tostring(itemType)
    if string.find(value, ".", 1, true) then return value end
    if scriptFor("Base." .. value) then return "Base." .. value end
    return value
end

local function scriptFullType(scriptItem)
    if not scriptItem then return nil end
    if scriptItem.getFullName then return scriptItem:getFullName() end
    if scriptItem.getFullType then return scriptItem:getFullType() end
    if scriptItem.getName then return "Base." .. tostring(scriptItem:getName()) end
    return nil
end

local function itemLabel(itemType)
    local fullType = normalizeFullType(itemType)
    if fullType and string.find(fullType, ".", 1, true) and getItemNameFromFullType then
        return getItemNameFromFullType(fullType)
    end
    return tostring(itemType or "?")
end

local function addUnique(result, seen, fullType)
    if not fullType or fullType == "" or seen[fullType] then return end
    seen[fullType] = true
    result[#result + 1] = fullType
end

local function possibleItemsForTag(tag)
    local result = {}
    local seen = {}
    if tag and getScriptManager then
        local manager = getScriptManager()
        local scriptItems = manager and manager.getItemsTag and manager:getItemsTag(tag) or nil
        if scriptItems then
            for scriptIndex = 0, scriptItems:size() - 1 do
                addUnique(result, seen, scriptFullType(scriptItems:get(scriptIndex)))
            end
        end
    end
    table.sort(result)
    return result
end

local function preferPossibleItem(items, preferred)
    if not preferred then return items end
    local foundIndex = nil
    for itemIndex = 1, #items do
        if items[itemIndex] == preferred then
            foundIndex = itemIndex
            break
        end
    end
    if not foundIndex or foundIndex == 1 then return items end
    table.remove(items, foundIndex)
    table.insert(items, 1, preferred)
    return items
end

local function preferredForTag(tag)
    if tag == "PlasterTrowel" then return "Base.PlasterTrowel" end
    if tag == "PlasterBucket" then return "Base.BucketPlasterFull" end
    if tag == "Paintbrush" then return "Base.Paintbrush" end
    if tag == "WallpaperPaste" then return "Base.BucketWallpaperPaste" end
    if tag == "Scissors" then return "Base.Scissors" end
    return nil
end

local function predicateAnyUsable(item)
    if not item then return false end
    if item.isDestroyed and item:isDestroyed() then return false end
    return true
end

local function predicateNotBroken(item)
    if not predicateAnyUsable(item) then return false end
    if item.isBroken and item:isBroken() then return false end
    return true
end

local function predicateEnoughDrain(item)
    if not predicateAnyUsable(item) then return false end
    if KBWB41.isDrainable(item) then return KBWB41.usesLeftFloat(item) >= 0.1 end
    return true
end

local function amountForItem(item, countUses)
    if countUses and instanceof and instanceof(item, "DrainableComboItem") then
        if KBWB41.isDrainable(item) then return KBWB41.usesLeft(item) end
    end
    return 1
end

local function addAvailable(result, seen, seenItems, item, countUses)
    if not item then return 0 end
    local itemKey = tostring(item)
    if seenItems[itemKey] then return 0 end
    seenItems[itemKey] = true
    local fullType = item.getFullType and item:getFullType()
        or normalizeFullType(item.getType and item:getType() or nil)
    if not fullType then return 0 end
    local amount = amountForItem(item, countUses)
    local entry = seen[fullType]
    if not entry then
        entry = { fullType = fullType, count = 0, uses = 0, available = 0, item = item, items = {} }
        seen[fullType] = entry
        result[#result + 1] = entry
    end
    entry.items[#entry.items + 1] = item
    entry.count = entry.count + 1
    entry.uses = entry.uses + amountForItem(item, true)
    entry.available = entry.available + amount
    return amount
end

local function scanTag(inventory, tag, predicate)
    if not inventory or not tag then return nil end
    if predicate then return inventory:getFirstTagEvalRecurse(tag, predicate) end
    return inventory:getFirstTagRecurse(tag)
end

local function allByTag(inventory, tag, predicate, countUses)
    local result, total = {}, 0
    if not inventory or not tag then return result, total end
    local seen, seenItems = {}, {}
    local items = inventory:getAllTagEvalRecurse(tag, predicate or predicateAnyUsable, ArrayList.new())
    if items then
        for itemIndex = 0, items:size() - 1 do
            total = total + addAvailable(result, seen, seenItems, items:get(itemIndex), countUses)
        end
    end
    return result, total
end

local function allByTypes(inventory, itemTypes, predicate, countUses)
    local result, total = {}, 0
    if not inventory then return result, total end
    local seen, seenItems = {}, {}
    for typeIndex = 1, #itemTypes do
        local items = inventory:getAllTypeEvalRecurse(itemTypes[typeIndex], predicate or predicateAnyUsable)
        if items then
            for itemIndex = 0, items:size() - 1 do
                total = total + addAvailable(result, seen, seenItems, items:get(itemIndex), countUses)
            end
        end
    end
    return result, total
end

local function typeAliases(itemType)
    local aliases = {}
    local seen = {}
    local raw = itemType and tostring(itemType) or nil
    local fullType = normalizeFullType(raw)
    addUnique(aliases, seen, fullType)
    if raw and raw ~= fullType then addUnique(aliases, seen, raw) end
    return aliases
end

local function firstType(inventory, itemType)
    if not inventory or not itemType then return nil end
    local aliases = typeAliases(itemType)
    for aliasIndex = 1, #aliases do
        local item = inventory:getFirstTypeRecurse(aliases[aliasIndex])
        if item then return item end
    end
    return nil
end

function WallFinishes.paintComponents(paintType)
    local out = {}
    local value = tostring(paintType or "")
    if value == "" then return out end
    local from = 1
    while true do
        local at = string.find(value, "+", from, true)
        local piece = at and string.sub(value, from, at - 1) or string.sub(value, from)
        piece = string.match(piece, "^%s*(.-)%s*$") or piece
        if piece ~= "" then
            local name, parts = string.match(piece, "^(.-)%*(%d+)$")
            out[#out + 1] = { item = name or piece, parts = tonumber(parts) or 1 }
        end
        if not at then break end
        from = at + 1
    end
    return out
end

function WallFinishes.isPaintMix(paintType)
    return #WallFinishes.paintComponents(paintType) > 1
end

function WallFinishes.paintItemsIn(inventory, paintType)
    local parts = WallFinishes.paintComponents(paintType)
    if #parts == 0 or not inventory then return nil end
    local draws = {}
    for index = 1, #parts do
        local part = parts[index]
        local entries = allByTypes(inventory, typeAliases(part.item), predicateEnoughDrain, true)
        local remaining = part.parts
        for entryIndex = 1, #entries do
            local items = entries[entryIndex].items
            for itemIndex = 1, #items do
                if remaining > 0 then
                    local item = items[itemIndex]
                    local has = amountForItem(item, true)
                    local take = (has < remaining) and has or remaining
                    if take > 0 then
                        draws[#draws + 1] = { item = item, uses = take }
                        remaining = remaining - take
                    end
                end
            end
        end
        if remaining > 0 then return nil end
    end
    return draws
end

function WallFinishes.paintDraw(paintType)
    return WallFinishes.paintComponents(paintType)
end

local function finishConfig(definition, stage)
    return (stage and stage.finishes) or (definition and definition.finishes) or {}
end

function WallFinishes.registerWallType(id, mapping)
    if id == nil or type(mapping) ~= "table" then return end
    registeredWallTypes[tostring(id)] = {
        plaster = mapping.plaster,
        paints = mapping.paints or {},
        wallpapers = mapping.wallpapers or {},
        directPaints = mapping.directPaints or mapping.barePaints or {},
        directWallpapers = mapping.directWallpapers or mapping.bareWallpapers or {},
        surface = mapping.surface or mapping.capabilities or {}
    }
    local sprites = mapping.sprites or mapping.baseSprites or {}
    for spriteIndex = 1, #sprites do
        registeredSpriteTypes[tostring(sprites[spriteIndex])] = tostring(id)
    end
end

WallFinishes.registerSurface = WallFinishes.registerWallType

function WallFinishes.registerSpriteWallType(spriteName, wallType)
    if not spriteName or not wallType then return end
    registeredSpriteTypes[tostring(spriteName)] = tostring(wallType)
end

local function cornerForPlaster(painting)
    if not painting or not painting.plasterTile then return nil end
    if painting.plasterTileCorner then return painting.plasterTileCorner end
    for key, sprite in pairs(painting) do
        if sprite == painting.plasterTile and painting[key .. "Corner"] then
            return painting[key .. "Corner"]
        end
    end
    return nil
end

local function vanillaMapping(wallType)
    local painting = Painting and Painting[wallType] or nil
    local customColors = OtherPainting and OtherPainting[wallType] or nil
    if not painting and not customColors then return nil end
    local mapping = {
        plaster = painting and painting.plasterTile
            and {
                W = painting.plasterTile,
                N = painting.plasterTileNorth or painting.plasterTile,
                Corner = cornerForPlaster(painting)
            } or nil,
        paints = {},
        wallpapers = {},
        directPaints = {},
        directWallpapers = {},
        surface = {
            canPaint = customColors and true or nil,
            paintRequiresPlaster = customColors and false or true,
            wallpaperRequiresPlaster = true
        }
    }
    local paintItems = ISPaintMenu and ISPaintMenu.PaintMenuItems or {}
    for itemIndex = 1, #paintItems do
        local name = paintItems[itemIndex].paint
        if painting and painting[name] then
            mapping.paints[name] = {
                W = painting[name],
                N = painting[name .. "North"] or painting[name],
                Corner = painting[name .. "Corner"]
            }
        end
    end
    local paper = WallPaper and WallPaper[wallType] or nil
    local paperItems = ISPaintMenu and ISPaintMenu.WallpaperMenuItems or {}
    if paper then
        for itemIndex = 1, #paperItems do
            local name = paperItems[itemIndex].paper
            if paper[name] then
                mapping.wallpapers[name] = {
                    W = paper[name],
                    N = paper[name .. "North"] or paper[name],
                    Corner = paper[name .. "Corner"]
                }
            end
        end
    end
    return mapping
end

local function wallTypeFromSprite(spriteName)
    if spriteName and registeredSpriteTypes[tostring(spriteName)] then
        return registeredSpriteTypes[tostring(spriteName)]
    end
    local sprite = spriteName and getSprite and getSprite(spriteName) or nil
    local props = sprite and sprite:getProperties() or nil
    if not props then return nil end
    local paintingType = KBWB41.propVal(props, "PaintingType")
    if paintingType ~= nil and tostring(paintingType) ~= "" then return tostring(paintingType) end
    if KBWB41.propIs(props, "WindowN") or KBWB41.propIs(props, "WindowW") then return "windowsframe" end
    if KBWB41.propIs(props, "DoorWallN") or KBWB41.propIs(props, "DoorWallW") then return "doorframe" end
    if KBWB41.propIs(props, IsoFlagType.WallSE) then return "pillar" end
    if KBWB41.propIs(props, "WallN") or KBWB41.propIs(props, "WallW") or KBWB41.propIs(props, "WallNW") then return "wall" end
    return nil
end

local function eachStageSprite(stage, callback)
    local seen = {}
    for direction, spriteName in pairs((stage and stage.sprites) or {}) do
        if type(spriteName) == "string" and not seen[spriteName] then
            seen[spriteName] = true
            callback(spriteName, direction)
        end
    end
    for direction, cells in pairs((stage and stage.footprints) or {}) do
        for cellIndex = 1, #cells do
            local spriteName = cells[cellIndex].sprite
            if type(spriteName) == "string" and not seen[spriteName] then
                seen[spriteName] = true
                callback(spriteName, direction)
            end
        end
    end
end

local VANILLA_WALL_FLAGS = { "WallN", "WallW", "WindowN", "WindowW", "DoorWallN", "DoorWallW" }

local function propsVanillaPaintable(props)
    if not props then return false end
    for flagIndex = 1, #VANILLA_WALL_FLAGS do
        if KBWB41.propIs(props, VANILLA_WALL_FLAGS[flagIndex]) then return true end
    end
    return KBWB41.propIs(props, IsoFlagType.WallSE)
end

function WallFinishes.vanillaPaintable(spriteName)
    local sprite = spriteName and getSprite and getSprite(spriteName) or nil
    return propsVanillaPaintable(sprite and sprite:getProperties() or nil)
end

function WallFinishes.prepareStage(definition, stage)
    local config = finishConfig(definition, stage)
    if config.enabled == false then return end
    if type(config.mapping) == "table" then WallFinishes.mappingFor(definition, stage) end
    local surface = config.surface or (config.mapping and config.mapping.surface) or {}
    local paintingType = config.wallType
    if type(paintingType) ~= "string" or paintingType == "" then return end
    local sealed = surface.canPlaster ~= true
        and surface.canPaint ~= true
        and surface.canWallpaper ~= true
    if surface.canPaint ~= true and not sealed then return end
    local bareIsPaintable = surface.paintRequiresPlaster == false
        or surface.wallpaperRequiresPlaster == false
    local seen = {}
    local function prepareSprite(spriteName, direction, paintable)
        if type(spriteName) ~= "string" or spriteName == "" or seen[spriteName] then return end
        seen[spriteName] = true
        registeredSpriteTypes[spriteName] = paintingType
        if direction == "N" or direction == "S" then
            registeredSpriteDirections[spriteName] = "N"
        elseif direction == "W" or direction == "E" then
            registeredSpriteDirections[spriteName] = "W"
        end
        local sprite = getSprite and getSprite(spriteName) or nil
        local props = sprite and sprite:getProperties() or nil
        if props then
            if paintable and not sealed and propsVanillaPaintable(props) then
                KBWB41.propSet(props, "IsPaintable", "")
            end
            KBWB41.propSet(props, "PaintingType", paintingType)
        end
    end
    local function prepareBareSprite(spriteName, direction)
        prepareSprite(spriteName, direction, bareIsPaintable)
    end
    eachStageSprite(stage, prepareBareSprite)
    local mapping = config.mapping or {}
    local function prepareMapping(spriteMap)
        for finishName, faces in pairs(spriteMap or {}) do
            if type(faces) == "table" then
                for direction, spriteName in pairs(faces) do
                    prepareSprite(spriteName, direction, true)
                end
            end
        end
    end
    local plasterFaces = mapping.plaster
    if type(plasterFaces) == "table" then
        for direction, spriteName in pairs(plasterFaces) do
            prepareSprite(spriteName, direction, true)
        end
    elseif type(plasterFaces) == "string" then
        prepareSprite(plasterFaces, nil, true)
    end
    prepareMapping(mapping.paints)
    prepareMapping(mapping.directPaints or mapping.barePaints)
    prepareMapping(mapping.wallpapers)
    prepareMapping(mapping.directWallpapers or mapping.bareWallpapers)
    local baseSprites = mapping.baseSprites or mapping.sprites or {}
    for spriteIndex = 1, #baseSprites do
        prepareSprite(baseSprites[spriteIndex], nil, bareIsPaintable)
    end
end

function WallFinishes.wallType(definition, stage, spriteName)
    local configured = finishConfig(definition, stage).wallType
    if configured then return configured end
    local derived = wallTypeFromSprite(spriteName)
    if derived then return derived end
    local sprites = stage and stage.sprites or {}
    return wallTypeFromSprite(sprites.W) or wallTypeFromSprite(sprites.N) or "wall"
end

function WallFinishes.mappingFor(definition, stage, spriteName)
    local config = finishConfig(definition, stage)
    local wallType = WallFinishes.wallType(definition, stage, spriteName)
    if type(config.mapping) == "table" then
        if not registeredWallTypes[wallType] then
            WallFinishes.registerWallType(wallType, config.mapping)
        end
        if config.surface and registeredWallTypes[wallType] then
            registeredWallTypes[wallType].surface = config.surface
        end
        return registeredWallTypes[wallType]
            or {
                plaster = config.mapping.plaster,
                paints = config.mapping.paints or {},
                wallpapers = config.mapping.wallpapers or {},
                directPaints = config.mapping.directPaints or config.mapping.barePaints or {},
                directWallpapers = config.mapping.directWallpapers or config.mapping.bareWallpapers or {},
                surface = config.surface or config.mapping.surface or config.mapping.capabilities or {}
            }
    end
    return registeredWallTypes[wallType] or vanillaMapping(wallType)
end

function WallFinishes.mappingForWallType(wallType, spriteName)
    wallType = tostring(wallType or "wall")
    if spriteName and registeredWallTypes[wallType]
        and registeredSpriteTypes[spriteName] ~= wallType then
        return vanillaMapping(wallType)
    end
    return registeredWallTypes[wallType] or vanillaMapping(wallType)
end

local function surfaceValue(surface, key, fallback)
    if surface and surface[key] ~= nil then return surface[key] == true end
    return fallback
end

function WallFinishes.surfaceRules(definition, stage, wallType, spriteName)
    local config = finishConfig(definition, stage)
    local mapping = wallType and WallFinishes.mappingForWallType(wallType, spriteName)
        or WallFinishes.mappingFor(definition, stage)
    mapping = mapping or { paints = {}, wallpapers = {} }
    local surface = config.surface or mapping.surface or {}
    return {
        canPlaster = surfaceValue(surface, "canPlaster", mapping.plaster ~= nil),
        canPaint = surfaceValue(surface, "canPaint", mapping.paints ~= nil),
        canWallpaper = surfaceValue(surface, "canWallpaper", mapping.wallpapers ~= nil),
        paintRequiresPlaster = surfaceValue(surface, "paintRequiresPlaster", true),
        wallpaperRequiresPlaster = surfaceValue(surface, "wallpaperRequiresPlaster", true)
    }
end

function WallFinishes.actionMode(action)
    if action == "paintThump" then return "paint" end
    if action == "wallpaper" then return "wallpaper" end
    if action == "plaster" then return "plaster" end
    return action
end

local function mappedFaceSprite(entry, north, baseSprite)
    if type(entry) ~= "table" then return nil end
    if baseSprite and getSprite then
        local sprite = getSprite(baseSprite)
        local props = sprite and sprite:getProperties() or nil
        if props then
            if KBWB41.propIs(props, "WallNW") and entry.Corner then return entry.Corner end
            if KBWB41.propIs(props, IsoFlagType.WallSE) and entry.Pillar then return entry.Pillar end
        end
    end
    if north then return entry.N or entry.W end
    return entry.W or entry.N
end

function WallFinishes.customColorFor(wallType, finish)
    if not finish or not finish.paintType then return nil end
    local reference = OtherPainting and OtherPainting[wallType] or nil
    local color = reference and reference[finish.paintType] or nil
    if not color then return nil end
    local r = color.r or color[1]
    local g = color.g or color[2]
    local b = color.b or color[3]
    if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then return nil end
    return { r = r, g = g, b = b, a = color.a or color[4] or 1 }
end

function WallFinishes.spriteForWallType(action, finish, north, wallType, baseSprite)
    local mode = WallFinishes.actionMode(action)
    local mapping = WallFinishes.mappingForWallType(wallType, baseSprite)
    if not mapping then return nil end
    local entry = nil
    if mode == "plaster" then
        entry = mapping.plaster
    elseif mode == "paint" then
        local direct = finish and finish.plaster == false
        if finish and finish.plaster == nil and mapping.surface and mapping.surface.paintRequiresPlaster == false then
            direct = true
        end
        local paints = direct and mapping.directPaints or mapping.paints
        if direct and (not paints
            or (paints[finish and finish.paintType] == nil and paints["*"] == nil)) then
            paints = mapping.paints
        end
        entry = finish and finish.paintType and paints
            and (paints[finish.paintType] or paints["*"]) or nil
        if WallFinishes.customColorFor(wallType, finish) then
            return mappedFaceSprite(entry, north, baseSprite) or baseSprite
        end
    elseif mode == "wallpaper" then
        local direct = finish and finish.plaster == false
        if finish and finish.plaster == nil and mapping.surface and mapping.surface.wallpaperRequiresPlaster == false then
            direct = true
        end
        local papers = direct and mapping.directWallpapers or mapping.wallpapers
        if direct and (not papers or papers[finish and finish.wallpaperType] == nil) then
            papers = mapping.wallpapers
        end
        entry = finish and finish.wallpaperType and papers and papers[finish.wallpaperType] or nil
    end
    return mappedFaceSprite(entry, north, baseSprite)
end

function WallFinishes.objectWallType(object)
    if not object or not object.getSprite or not object:getSprite() then return nil end
    local data = object.getModData and object:getModData() or nil
    local kbw = data and data.KBW or nil
    if kbw and kbw.wallType then return tostring(kbw.wallType) end
    return wallTypeFromSprite(object:getSprite():getName())
end

function WallFinishes.prepareObject(object)
    local wallType = WallFinishes.objectWallType(object)
    if not wallType or registeredWallTypes[wallType] then return wallType end
    local data = object and object.getModData and object:getModData() or nil
    local kbw = data and data.KBW or nil
    if not kbw or not kbw.buildableId then return wallType end
    local Registry = require("KnoxBuildworks/Definitions/Registry")
    local Resolver = require("KnoxBuildworks/Definitions/Resolver")
    local definition = Resolver.resolve(kbw.buildableId, kbw.variantId, kbw.materialId)
        or Registry:get(kbw.buildableId)
    if not definition then return wallType end
    local stage = Registry:getStage(definition, kbw.stageId)
        or (definition.stages and definition.stages[1])
    if stage then
        local sprite = object:getSprite()
        WallFinishes.mappingFor(definition, stage, sprite and sprite:getName() or nil)
    end
    return wallType
end

function WallFinishes.objectNorth(object)
    if not object then return false end
    if instanceof(object, "IsoThumpable") and object.getNorth then return object:getNorth() == true end
    local sprite = object.getSprite and object:getSprite() or nil
    local spriteName = sprite and sprite:getName() or nil
    if registeredSpriteDirections[spriteName] then return registeredSpriteDirections[spriteName] == "N" end
    local props = object.getProperties and object:getProperties() or nil
    if not props then return false end
    return KBWB41.propIs(props, "WallN") or KBWB41.propIs(props, "WindowN") or KBWB41.propIs(props, "DoorWallN")
end

local function mappingForFinishState(wallType)
    return registeredWallTypes[wallType] or vanillaMapping(wallType)
end

local function faceCarriesSprite(entry, spriteName)
    if type(entry) ~= "table" then return entry ~= nil and tostring(entry) == spriteName end
    for _direction, name in pairs(entry) do
        if name ~= nil and tostring(name) == spriteName then return true end
    end
    return false
end

local function mapCarriesSprite(spriteMap, spriteName)
    for _finishName, faces in pairs(spriteMap or {}) do
        if faceCarriesSprite(faces, spriteName) then return true end
    end
    return false
end

local function mappingSpriteIsPlastered(mapping, spriteName)
    if not mapping or not spriteName then return false end
    if faceCarriesSprite(mapping.plaster, spriteName) then return true end
    if mapCarriesSprite(mapping.directPaints or mapping.barePaints, spriteName)
        or mapCarriesSprite(mapping.directWallpapers or mapping.bareWallpapers, spriteName) then
        return false
    end
    return mapCarriesSprite(mapping.paints, spriteName)
        or mapCarriesSprite(mapping.wallpapers, spriteName)
end

local function objectSpriteName(object)
    local sprite = object and object.getSprite and object:getSprite() or nil
    return sprite and sprite:getName() or nil
end

local function objectIsPlastered(object)
    if not object then return false end
    local wallType = WallFinishes.objectWallType(object)
    local mapping = wallType and mappingForFinishState(tostring(wallType)) or nil
    if mapping then return mappingSpriteIsPlastered(mapping, objectSpriteName(object)) end
    if object.isPaintable and object:isPaintable() then return true end
    local props = object.getProperties and object:getProperties() or nil
    return props ~= nil and KBWB41.propIs(props, "IsPaintable")
end

function WallFinishes.isObjectPlastered(object)
    return objectIsPlastered(object)
end

local function namedFinishIn(spriteMap, spriteName, prefix)
    for finishName, faces in pairs(spriteMap or {}) do
        if faceCarriesSprite(faces, spriteName) then return prefix .. tostring(finishName) end
    end
    return nil
end

function WallFinishes.objectFinishSignature(object)
    if not object then return nil end
    local wallType = WallFinishes.objectWallType(object)
    local mapping = wallType and mappingForFinishState(tostring(wallType)) or nil
    if not mapping then return nil end
    local spriteName = objectSpriteName(object)
    if not spriteName then return nil end
    if faceCarriesSprite(mapping.plaster, spriteName) then return "plaster" end
    return namedFinishIn(mapping.paints, spriteName, "paint:")
        or namedFinishIn(mapping.directPaints or mapping.barePaints, spriteName, "paint:")
        or namedFinishIn(mapping.wallpapers, spriteName, "wallpaper:")
        or namedFinishIn(mapping.directWallpapers or mapping.bareWallpapers, spriteName, "wallpaper:")
end

function WallFinishes.plannedFinishSignature(finish)
    if not WallFinishes.isWallFinish(finish) then return nil end
    if finish.paintType then return "paint:" .. tostring(finish.paintType) end
    if finish.wallpaperType then return "wallpaper:" .. tostring(finish.wallpaperType) end
    if finish.plaster then return "plaster" end
    return nil
end

function WallFinishes.canApplyToObject(action, finish, object, hasPlasterAction)
    local mode = WallFinishes.actionMode(action)
    local wallType = WallFinishes.prepareObject(object)
    if not wallType then return false, "no compatible wall face", nil end
    local objectSprite = object:getSprite() and object:getSprite():getName() or nil
    local rules = WallFinishes.surfaceRules(nil, nil, wallType, objectSprite)
    if not WallFinishes.spriteForWallType(
            mode, finish, WallFinishes.objectNorth(object), wallType, objectSprite
        ) then
        return false, "finish is not mapped for this wall surface", wallType
    end
    if mode == "plaster" then
        if not rules.canPlaster then return false, "wall surface cannot be plastered", wallType end
        if objectIsPlastered(object) then return false, "wall is already plastered", wallType end
        local plasterMapping = WallFinishes.mappingForWallType(wallType, objectSprite)
        if not (plasterMapping and plasterMapping.plaster)
            and instanceof(object, "IsoThumpable")
            and not (object.canBePlastered and object:canBePlastered()) then
            return false, "wall is not ready for plaster", wallType
        end
        return true, nil, wallType
    end
    if mode == "paint" then
        if not rules.canPaint then return false, "wall surface cannot be painted", wallType end
        if rules.paintRequiresPlaster and not objectIsPlastered(object) and not hasPlasterAction then
            return false, "wall must be plastered before painting", wallType
        end
        return true, nil, wallType
    end
    if mode == "wallpaper" then
        if not rules.canWallpaper then return false, "wall surface cannot be wallpapered", wallType end
        if rules.wallpaperRequiresPlaster and not objectIsPlastered(object) and not hasPlasterAction then
            return false, "wall must be plastered before wallpapering", wallType
        end
        return true, nil, wallType
    end
    return false, "unsupported wall finish action", wallType
end

function WallFinishes.canApplyToPlanned(action, finish, definition, stage, plannedFinish, hasPlasterAction)
    local mode = WallFinishes.actionMode(action)
    local wallType = WallFinishes.wallType(definition, stage)
    local rules = WallFinishes.surfaceRules(definition, stage, wallType)
    if not WallFinishes.spriteForWallType(mode, finish, false, wallType) then
        return false, "finish is not mapped for this wall surface", wallType
    end
    local plastered = WallFinishes.isWallFinish(plannedFinish) and plannedFinish.plaster == true
    plastered = plastered or hasPlasterAction == true
    if mode == "plaster" then
        if not rules.canPlaster or not WallFinishes.isPlasterable(definition, stage) then
            return false, "planned wall cannot be plastered", wallType
        end
        if plastered then return false, "planned wall is already plastered", wallType end
        return true, nil, wallType
    end
    if mode == "paint" then
        if not rules.canPaint then return false, "planned wall cannot be painted", wallType end
        if rules.paintRequiresPlaster and not plastered then
            return false, "plan plaster before painting", wallType
        end
        return true, nil, wallType
    end
    if mode == "wallpaper" then
        if not rules.canWallpaper then return false, "planned wall cannot be wallpapered", wallType end
        if rules.wallpaperRequiresPlaster and not plastered then
            return false, "plan plaster before wallpapering", wallType
        end
        return true, nil, wallType
    end
    return false, "unsupported wall finish action", wallType
end

function WallFinishes.buildsAsProp(definition, stage)
    local placement = StageConfig.placement(definition, stage)
    if placement.kind == "overlay" or placement.kind == "floor" then return false end
    local object = (stage and stage.object) or {}
    if object.isProp == true or object.canPassThrough == true then return true end
    return StageConfig.sprite(definition, stage).isProp == true
end

function WallFinishes.isPlasterable(definition, stage)
    local config = finishConfig(definition, stage)
    local surface = config.surface or (config.mapping and config.mapping.surface) or nil
    if surface and surface.canPlaster ~= nil then return surface.canPlaster == true end
    if WallFinishes.buildsAsProp(definition, stage) then return false end
    if config.enabled == false then return false end
    if config.enabled == true then return true end
    if not stage then return false end
    if stage.canBePlastered == true then return true end
    local spriteConfig = StageConfig.sprite(definition, stage)
    if spriteConfig.onCreate == "BuildRecipeCode.canBePlastered.OnCreate" then return true end
    local tags = definition and definition.tags or {}
    for tagIndex = 1, #tags do
        if tags[tagIndex] == "plasterable" then return true end
    end
    return false
end

function WallFinishes.isWallFinish(finish)
    return type(finish) == "table" and (finish.actionType == "wallFinish" or finish.plaster == true)
end

function WallFinishes.spriteFor(mode, finish, north, definition, stage, baseSprite)
    local mapping = WallFinishes.mappingFor(definition, stage, baseSprite)
    if not mapping then return nil end
    local entry = nil
    if mode == "plaster" then
        entry = mapping.plaster
    elseif mode == "paint" then
        local wallType = WallFinishes.wallType(definition, stage, baseSprite)
        local direct = finish and finish.plaster == false
        local paints = direct and mapping.directPaints or mapping.paints
        if direct and (not paints
            or (paints[finish and finish.paintType] == nil and paints["*"] == nil)) then
            paints = mapping.paints
        end
        entry = finish and finish.paintType and paints
            and (paints[finish.paintType] or paints["*"]) or nil
        if WallFinishes.customColorFor(wallType, finish) then
            return mappedFaceSprite(entry, north, baseSprite) or baseSprite
        end
    elseif mode == "wallpaper" then
        local direct = finish and finish.plaster == false
        local papers = direct and mapping.directWallpapers or mapping.wallpapers
        if direct and (not papers or papers[finish and finish.wallpaperType] == nil) then
            papers = mapping.wallpapers
        end
        entry = finish and finish.wallpaperType and papers and papers[finish.wallpaperType] or nil
    end
    return mappedFaceSprite(entry, north, baseSprite)
end

function WallFinishes.previewSprite(finish, north, definition, stage, baseSprite)
    if not WallFinishes.isWallFinish(finish) then return nil end
    local mode = "plaster"
    if finish.wallpaperType then
        mode = "wallpaper"
    elseif finish.paintType then
        mode = "paint"
    end
    return WallFinishes.spriteFor(mode, finish, north, definition, stage, baseSprite)
        or WallFinishes.spriteFor("plaster", finish, north, definition, stage, baseSprite)
end

local function allowedByConfig(configured, name)
    if configured == false then return false end
    if type(configured) ~= "table" then return true end
    for index = 1, #configured do
        if configured[index] == name then return true end
    end
    return false
end

local function paintLabel(name)
    local items = ISPaintMenu and ISPaintMenu.PaintMenuItems or {}
    for index = 1, #items do
        if items[index].paint == name then return translated(items[index].text, name), items[index].color end
    end
    if getItemNameFromFullType then return getItemNameFromFullType("Base." .. tostring(name)), nil end
    return tostring(name), nil
end

local function blendedPaintLabel(name)
    local parts = WallFinishes.paintComponents(name)
    if #parts < 2 then return paintLabel(name) end
    local label, total, r, g, b = nil, 0, 0, 0, 0
    for index = 1, #parts do
        local text, color = paintLabel(parts[index].item)
        local weight = parts[index].parts
        total = total + weight
        if color then
            r = r + (color[1] or 0) * weight
            g = g + (color[2] or 0) * weight
            b = b + (color[3] or 0) * weight
        end
        if weight > 1 then text = text .. " x" .. tostring(weight) end
        label = label and (label .. " + " .. text) or text
    end
    if total > 0 then return label, { r / total, g / total, b / total } end
    return label, nil
end

local function paperLabel(name)
    local items = ISPaintMenu and ISPaintMenu.WallpaperMenuItems or {}
    for index = 1, #items do
        if items[index].paper == name then return translated(items[index].text, name) end
    end
    if getItemNameFromFullType then return getItemNameFromFullType("Base." .. tostring(name)) end
    return tostring(name)
end

local function sortedKeys(map)
    local keys = {}
    for key in pairs(map or {}) do
        keys[#keys + 1] = tostring(key)
    end
    table.sort(keys)
    return keys
end

local function paintNamesFor(mapping, wallType, direct)
    local colors = OtherPainting and OtherPainting[wallType] or nil
    if colors then
        local names = {}
        local seen = {}
        local items = ISPaintMenu and ISPaintMenu.PaintMenuItems or {}
        for itemIndex = 1, #items do
            local name = items[itemIndex].paint
            if colors[name] then
                names[#names + 1] = name
                seen[name] = true
            end
        end
        local extras = sortedKeys(colors)
        for extraIndex = 1, #extras do
            local name = extras[extraIndex]
            if not seen[name] then names[#names + 1] = name end
        end
        return names
    end
    local paints = direct and mapping.directPaints or mapping.paints
    if direct and #sortedKeys(paints) == 0 then paints = mapping.paints or {} end
    return sortedKeys(paints)
end

local function finishLabel(mapping, paint)
    local labels = mapping and mapping.paintLabels or nil
    local key = labels and labels[paint] or nil
    if key then
        local text = translated(tostring(key), nil)
        if text and text ~= tostring(key) then
            return text, select(2, blendedPaintLabel(paint))
        end
    end
    return blendedPaintLabel(paint)
end

function WallFinishes.entriesFor(definition, stage)
    local entries = {}
    local config = finishConfig(definition, stage)
    local mapping = WallFinishes.mappingFor(definition, stage)
    if not mapping then return entries end
    local wallType = WallFinishes.wallType(definition, stage)
    local rules = WallFinishes.surfaceRules(definition, stage)
    local plasterLabel = translated("ContextMenu_Plaster", "Plaster")
    local canPlaster = rules.canPlaster and mapping.plaster ~= nil and WallFinishes.isPlasterable(definition, stage)
    if canPlaster then
        entries[#entries + 1] = { label = plasterLabel, actionType = "wallFinish", plaster = true }
        local paintNames = paintNamesFor(mapping, wallType, false)
        for nameIndex = 1, #paintNames do
            local name = paintNames[nameIndex]
            if allowedByConfig(config.paints, name) then
                local label, color = finishLabel(mapping, name)
                entries[#entries + 1] = {
                    label = plasterLabel .. " + " .. label,
                    actionType = "wallFinish",
                    plaster = true,
                    paintType = name,
                    color = color
                }
            end
        end
        local paperNames = sortedKeys(mapping.wallpapers)
        for nameIndex = 1, #paperNames do
            local name = paperNames[nameIndex]
            if allowedByConfig(config.wallpapers, name) then
                entries[#entries + 1] = {
                    label = plasterLabel .. " + " .. paperLabel(name),
                    actionType = "wallFinish",
                    plaster = true,
                    wallpaperType = name
                }
            end
        end
    end
    if rules.canPaint and not rules.paintRequiresPlaster then
        local paintNames = paintNamesFor(mapping, wallType, true)
        for nameIndex = 1, #paintNames do
            local name = paintNames[nameIndex]
            if allowedByConfig(config.paints, name) then
                local label, color = finishLabel(mapping, name)
                entries[#entries + 1] = {
                    label = label,
                    actionType = "wallFinish",
                    plaster = false,
                    paintType = name,
                    color = color
                }
            end
        end
    end
    if rules.canWallpaper and not rules.wallpaperRequiresPlaster then
        local papers = mapping.directWallpapers or {}
        if #sortedKeys(papers) == 0 then papers = mapping.wallpapers or {} end
        local paperNames = sortedKeys(papers)
        for nameIndex = 1, #paperNames do
            local name = paperNames[nameIndex]
            if allowedByConfig(config.wallpapers, name) then
                entries[#entries + 1] = {
                    label = paperLabel(name),
                    actionType = "wallFinish",
                    plaster = false,
                    wallpaperType = name
                }
            end
        end
    end
    return entries
end

function WallFinishes.validateItems(player, finish, definition, stage)
    if not WallFinishes.isWallFinish(finish) then return true end
    if not player then return false, "missing player" end
    if player.isBuildCheat and player:isBuildCheat() then return true end
    local inventory = player:getInventory()
    if not inventory then return false, "missing inventory" end
    local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
    if finish.plaster ~= false and BuildableRules.wallFinishRequirement(definition, stage, "plaster") then
        if not scanTag(inventory, "PlasterTrowel", predicateNotBroken) then
            return false, "missing plastering trowel"
        end
        if not scanTag(inventory, "PlasterBucket", predicateEnoughDrain) then
            return false, "missing plaster bucket"
        end
    end
    if finish.paintType and BuildableRules.wallFinishRequirement(definition, stage, "paint") then
        if not scanTag(inventory, "Paintbrush", predicateNotBroken) then return false, "missing paintbrush" end
        if not WallFinishes.paintItemsIn(inventory, finish.paintType) then
            return false, "missing selected paint"
        end
    end
    if finish.wallpaperType and BuildableRules.wallFinishRequirement(definition, stage, "wallpaper") then
        if not scanTag(inventory, "Paintbrush", predicateNotBroken) then return false, "missing paintbrush" end
        if not firstType(inventory, finish.wallpaperType) then return false, "missing selected wallpaper" end
        if not scanTag(inventory, "WallpaperPaste", predicateEnoughDrain) then
            return false, "missing wallpaper paste"
        end
        if not scanTag(inventory, "Scissors", predicateNotBroken) then return false, "missing scissors" end
    end
    return true
end

local function tagRow(player, id, label, tag, tagName, mode, role, predicate, flags)
    local inventory = player and player:getInventory() or nil
    local countUses = mode == "drain"
    local item = inventory and scanTag(inventory, tag, predicate) or nil
    local availableItems, available = allByTag(inventory, tag, predicate, countUses)
    local cheat = player and player.isBuildCheat and player:isBuildCheat()
    return {
        id = id,
        kind = "input",
        role = role or "tool",
        mode = mode or "keep",
        resourceType = "Item",
        label = label,
        needed = 1,
        uses = countUses and 1 or nil,
        available = available,
        ok = cheat == true or available >= 1,
        item = item,
        matchTag = tag,
        isFinish = true,
        possibleItems = preferPossibleItem(possibleItemsForTag(tag), preferredForTag(tag)),
        possibleTags = { tagName },
        flags = flags or {},
        availableItems = availableItems
    }
end

local function itemRow(player, id, itemType, mode, role, needed)
    local inventory = player and player:getInventory() or nil
    local fullType = normalizeFullType(itemType)
    local countUses = mode == "drain"
    local availableItems, available = allByTypes(inventory, typeAliases(itemType), predicateAnyUsable, countUses)
    local cheat = player and player.isBuildCheat and player:isBuildCheat()
    needed = needed or 1
    return {
        id = id,
        kind = "input",
        role = role or "material",
        mode = mode or "drain",
        resourceType = "Item",
        label = itemLabel(fullType),
        selectedFullType = fullType,
        needed = needed,
        uses = countUses and needed or nil,
        available = available,
        ok = cheat == true or available >= needed,
        isFinish = true,
        possibleItems = { fullType },
        items = { fullType },
        possibleTags = {},
        flags = {},
        availableItems = availableItems
    }
end

function WallFinishes.statusRows(player, finish, definition, stage)
    local rows = {}
    if not WallFinishes.isWallFinish(finish) then return rows end
    local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
    if finish.plaster ~= false and BuildableRules.wallFinishRequirement(definition, stage, "plaster") then
        rows[#rows + 1] = tagRow(
            player, "finish-plaster-trowel", translated("IGUI_KBW_PlasterTrowel", "Plastering trowel"),
            "PlasterTrowel", "base:plastertrowel", "keep", "tool", predicateNotBroken,
            { "Prop1", "MayDegradeVeryLight" }
        )
        rows[#rows + 1] = tagRow(
            player, "finish-plaster", translated("IGUI_KBW_PlasterBucket", "Plaster bucket"), "PlasterBucket",
            "base:plasterbucket", "drain", "material", predicateEnoughDrain
        )
    end
    if finish.paintType and BuildableRules.wallFinishRequirement(definition, stage, "paint") then
        rows[#rows + 1] = tagRow(
            player, "finish-brush", translated("IGUI_KBW_Paintbrush", "Paintbrush"), "Paintbrush",
            "base:paintbrush", "keep", "tool", predicateNotBroken
        )
        local parts = WallFinishes.paintComponents(finish.paintType)
        if #parts > 1 then
            for partIndex = 1, #parts do
                local part = parts[partIndex]
                rows[#rows + 1] = itemRow(
                    player, "finish-paint-" .. tostring(partIndex), part.item, "drain", "material", part.parts
                )
            end
        else
            rows[#rows + 1] = itemRow(player, "finish-paint", finish.paintType, "drain", "material")
        end
    end
    if finish.wallpaperType and BuildableRules.wallFinishRequirement(definition, stage, "wallpaper") then
        rows[#rows + 1] = tagRow(
            player, "finish-brush", translated("IGUI_KBW_Paintbrush", "Paintbrush"), "Paintbrush",
            "base:paintbrush", "keep", "tool", predicateNotBroken
        )
        rows[#rows + 1] = itemRow(player, "finish-paper", finish.wallpaperType, "drain", "material")
        rows[#rows + 1] = tagRow(
            player, "finish-paste", translated("IGUI_KBW_WallpaperPaste", "Wallpaper paste"), "WallpaperPaste",
            "base:wallpaperpaste", "drain", "material", predicateEnoughDrain
        )
        rows[#rows + 1] = tagRow(
            player, "finish-scissors", translated("IGUI_KBW_Scissors", "Scissors"), "Scissors", "base:scissors",
            "keep", "tool", predicateNotBroken
        )
    end
    return rows
end

function WallFinishes.fetchRows(player, finish, definition, stage)
    return WallFinishes.statusRows(player, finish, definition, stage)
end

return WallFinishes
