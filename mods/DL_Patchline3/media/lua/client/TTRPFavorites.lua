local json = require "TTRPJson"

TTRPFavorites = TTRPFavorites or {}
Favorites = Favorites or {}

-- .txt instead of .json for B41 file writing -Milo
local FAVORITES_FILE_PATH = "TTRP_Favorites.txt"
local favoritesLoaded = false

-----------------------------------------------
-- Internal Helper Functions                 --
-----------------------------------------------

local function ensureFavoritesTable()
    Favorites = Favorites or {}
    return Favorites
end

local function jsonEncode(value)
    if type(json) ~= "table" then
        return nil
    end

    if type(json.stringify) == "function" then
        return json.stringify(value)
    end

    if type(json.encode) == "function" then
        return json.encode(value)
    end

    if type(json.Encode) == "function" then
        return json.Encode(value)
    end

    return nil
end

local function jsonDecode(value)
    if type(json) ~= "table" then
        return nil
    end

    if type(json.parse) == "function" then
        return json.parse(value)
    end

    if type(json.decode) == "function" then
        return json.decode(value)
    end

    if type(json.Decode) == "function" then
        return json.Decode(value)
    end

    return nil
end

local function resolveEmoteFunction()
    if type(TTRPdoEmote) == "function" then
        return TTRPdoEmote
    end
    return "TTRPdoEmote"
end

local function textureToPath(texture)
    if texture and type(texture) == "userdata" and texture.getName then
        return texture:getName()
    end

    if type(texture) == "string" then
        return texture
    end

    return nil
end

local function normalizeTexturePath(texturePath)
    if type(texturePath) ~= "string" or texturePath == "" then
        return nil
    end

    return texturePath:gsub("\\\\", "/"):gsub("\\", "/")
end

local function getEntryEmote(entryData)
    if type(entryData) ~= "table" then
        return nil
    end

    if type(entryData.command) == "table" and type(entryData.command[2]) == "string" then
        return entryData.command[2]
    end

    if type(entryData.emote) == "string" then
        return entryData.emote
    end

    return nil
end

local function toRuntimeEntry(texture, emote)
    return {
        texture = texture,
        command = { resolveEmoteFunction(), emote }
    }
end

-------------------------------------------------
-- Favorites API for the radial and tree menus --
-------------------------------------------------

function TTRPFavorites.getFilePath()
    return FAVORITES_FILE_PATH
end

function TTRPFavorites.getTable()
    return ensureFavoritesTable()
end

function TTRPFavorites.hasAny()
    for _ in pairs(ensureFavoritesTable()) do
        return true
    end
    return false
end

function TTRPFavorites.contains(label)
    if type(label) ~= "string" then
        return false
    end
    return ensureFavoritesTable()[label] ~= nil
end

function TTRPFavorites.getEntryEmote(entryData)
    return getEntryEmote(entryData)
end

function TTRPFavorites.resolveTexture(texture)
    if type(texture) == "userdata" then
        return texture
    end

    local texturePath = normalizeTexturePath(textureToPath(texture))
    if not texturePath then
        return nil
    end

    return getTexture(texturePath) or texturePath
end

function TTRPFavorites.save()
    local favoritesTable = ensureFavoritesTable()
    local serializableFavorites = {}

    for label, entryData in pairs(favoritesTable) do
        local emote = getEntryEmote(entryData)
        if type(label) == "string" and emote then
            serializableFavorites[label] = {
                texture = textureToPath(entryData.texture),
                command = { "TTRPdoEmote", emote }
            }
        end
    end

    local fileWriter = getFileWriter(FAVORITES_FILE_PATH, true, false)
    if not fileWriter then
        return false
    end

    local jsonString = jsonEncode(serializableFavorites)
    if type(jsonString) ~= "string" then
        fileWriter:close()
        return false
    end

    fileWriter:write(jsonString)
    fileWriter:close()
    return true
end

function TTRPFavorites.load()
    local fileReader = getFileReader(FAVORITES_FILE_PATH, false)
    favoritesLoaded = true

    if not fileReader then
        ensureFavoritesTable()
        return Favorites
    end

    local fileLines = {}
    local nextLine = fileReader:readLine()
    while nextLine do
        table.insert(fileLines, nextLine)
        nextLine = fileReader:readLine()
    end
    fileReader:close()

    local jsonString = table.concat(fileLines, "\n")
    if jsonString == "" then
        Favorites = {}
        return Favorites
    end

    local parsed = jsonDecode(jsonString)
    if type(parsed) ~= "table" then
        Favorites = {}
        return Favorites
    end

    local loadedFavorites = {}
    for label, entryData in pairs(parsed) do
        local emote = getEntryEmote(entryData)
        if type(label) == "string" and emote then
            loadedFavorites[label] = toRuntimeEntry(TTRPFavorites.resolveTexture(entryData.texture), emote)
        end
    end

    Favorites = loadedFavorites
    return Favorites
end

function TTRPFavorites.ensureLoaded()
    if not favoritesLoaded then
        TTRPFavorites.load()
    end
    return ensureFavoritesTable()
end

function TTRPFavorites.toggle(label, texture, emote)
    if type(label) ~= "string" or label == "" or type(emote) ~= "string" or emote == "" then
        return nil
    end

    local favoritesTable = ensureFavoritesTable()
    if favoritesTable[label] then
        favoritesTable[label] = nil
        TTRPFavorites.save()
        return false
    end

    favoritesTable[label] = toRuntimeEntry(texture, emote)
    TTRPFavorites.save()
    return true
end

return TTRPFavorites
