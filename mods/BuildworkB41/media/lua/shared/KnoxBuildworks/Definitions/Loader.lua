local KBW = require("KnoxBuildworks/Core")
local SafeJSON = require("KnoxBuildworks/Util/SafeJSON")
local Hash = require("KnoxBuildworks/Util/Hash")
local Schema = require("KnoxBuildworks/Definitions/Schema")
local Registry = require("KnoxBuildworks/Definitions/Registry")
local Overrides = require("KnoxBuildworks/Definitions/Overrides")
local Profiler = require("KnoxBuildworks/Util/Profiler")
local Log = require("KnoxBuildworks/Log")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local Loader = { providers = {} }

local STEP_BUDGET_MS = 3
local HASH_SLICE = 8192
local DECODE_SLICE = 400
local NORMALIZE_MAX = 50

local function nowMs()
    return getTimestampMs and getTimestampMs() or 0
end

function Loader.registerProvider(modId)
    Loader.providers[modId] = true
end

local function readModText(modId, path)
    local reader = getModFileReader(modId, path, false)
    if not reader then return nil, "file not found" end
    local lines, line = {}, reader:readLine()
    while line do
        lines[#lines + 1] = line
        line = reader:readLine()
    end
    reader:close()
    return table.concat(lines, "\n")
end

local function readModJson(modId, path)
    local text, err = readModText(modId, path)
    if not text then return nil, err end
    local data, decodeErr = SafeJSON.decode(text)
    if not data then return nil, decodeErr end
    return data, nil, Hash.string(text)
end

local function activeProviders()
    local result = { KBW.ID }
    local seen = { [KBW.ID] = true }
    local mods = getActivatedMods and getActivatedMods()
    if mods then
        for i = 0, mods:size() - 1 do
            local id = tostring(mods:get(i))
            if not seen[id] then
                result[#result + 1] = id
                seen[id] = true
            end
        end
    end
    for id in pairs(Loader.providers) do
        if not seen[id] then result[#result + 1] = id end
    end
    table.sort(result)
    return result
end

local function collectFileList()
    local files = {}
    local providers = activeProviders()
    for providerIndex = 1, #providers do
        local modId = providers[providerIndex]
        local manifest = readModJson(modId, KBW.MANIFEST_PATH)
        if manifest then
            local definitionFiles = manifest.definitions or {}
            for fileIndex = 1, #definitionFiles do
                local path = definitionFiles[fileIndex]
                files[#files + 1] = { modId = modId, path = path, source = modId .. ":" .. path }
            end
        end
    end
    return files
end

local function beginState()
    Registry:reset()
    local overrides, overridesHash = Overrides.load()
    Registry.overridesHash = overridesHash
    return { templates = {}, groups = {}, bundles = {}, overrides = overrides, patches = {} }
end

local function acceptBundle(state, source, bundle, fileHash)
    local errors = Schema.validateBundle(bundle)
    if #errors > 0 then
        Log:validation(source, errors)
        return
    end
    Registry.files[source] = fileHash
    Overrides.collect(state.patches, bundle, source)
    for name, value in pairs(bundle.templates or {}) do
        if state.templates[name] then Log:warning("Template '%s' replaced by %s", name, source) end
        state.templates[name] = value
    end
    for name, value in pairs(bundle.materialGroups or {}) do
        state.groups[name] = value
    end
    state.bundles[#state.bundles + 1] = { source = source, data = bundle }
    Log:info("Loaded definition file %s (%s)", source, fileHash)
end

local function normalizeOne(state, bundle, raw)
    local patched = Overrides.apply(Overrides.applyPatch(raw, state.patches), state.overrides)
    local normalized, errors = Schema.normalize(patched, state.templates, state.groups)
    if #errors > 0 then
        Log:validation((raw.id or "<unknown>") .. " in " .. bundle.source, errors)
    else
        Registry:register(normalized, bundle.source)
    end
end

local function finishState()
    local finalizeStart = Profiler.now()
    Registry:finalize()
    Profiler.add("loader.finalize", finalizeStart)
    KBW.Runtime.loaded = true
    Profiler.mem("loader.heapAfterLoad")
    Profiler.report("definitions loaded")
end

function Loader.loadAll()
    local state = beginState()
    local files = collectFileList()
    for fileIndex = 1, #files do
        local entry = files[fileIndex]
        local fileStart = Profiler.now()
        local bundle, err, fileHash = readModJson(entry.modId, entry.path)
        Profiler.add("loader.readHashDecode", fileStart)
        if not bundle then
            Log:error("Skipped %s: %s", entry.source, err)
        else
            acceptBundle(state, entry.source, bundle, fileHash)
        end
    end
    local normalizeStart = Profiler.now()
    for bundleIndex = 1, #state.bundles do
        local bundle = state.bundles[bundleIndex]
        local buildables = bundle.data.buildables or {}
        for buildableIndex = 1, #buildables do
            normalizeOne(state, bundle, buildables[buildableIndex])
        end
    end
    Profiler.add("loader.normalize", normalizeStart)
    finishState()
    return Registry
end

local async = nil

local function asyncFinish()
    KBWB41.removeEvent("OnFETick", Loader.stepAsync)
    KBWB41.removeEvent("OnTickEvenPaused", Loader.stepAsync)
    local callbacks = async.callbacks
    async = nil
    for callbackIndex = 1, #callbacks do
        callbacks[callbackIndex]()
    end
end

function Loader.stepAsync()
    local state = async
    if not state then return end
    if state.phase == "files" then
        local pending = state.pending
        if not pending then
            state.fileIndex = state.fileIndex + 1
            local entry = state.files[state.fileIndex]
            if not entry then
                state.phase = "normalize"
                state.bundleIndex, state.buildableIndex = 1, 1
                return
            end
            local readStart = Profiler.now()
            local text, err = readModText(entry.modId, entry.path)
            Profiler.add("loader.read", readStart)
            if not text then
                Log:error("Skipped %s: %s", entry.source, err)
                return
            end
            Profiler.count("loader.bytes", #text)
            Profiler.count("loader.files")
            state.pending = { entry = entry, text = text, hash = Hash.begin(), pos = 1, json = nil }
            return
        end
        local text = pending.text
        local deadline = nowMs() + STEP_BUDGET_MS
        if pending.pos <= #text then
            local hashStart = Profiler.now()
            while pending.pos <= #text do
                local last = math.min(pending.pos + HASH_SLICE - 1, #text)
                Hash.update(pending.hash, text, pending.pos, last)
                pending.pos = last + 1
                if nowMs() >= deadline then break end
            end
            Profiler.add("loader.hash", hashStart)
            if pending.pos <= #text then return end
            pending.fileHash = Hash.finish(pending.hash)
        end
        if not pending.json then pending.json = SafeJSON.newSession(text) end
        local decodeStart = Profiler.now()
        local done = false
        while nowMs() < deadline do
            done = SafeJSON.stepSession(pending.json, DECODE_SLICE)
            if done then break end
        end
        Profiler.add("loader.decode", decodeStart)
        if done then
            local session = pending.json
            if session.err then
                Log:error("Skipped %s: %s", pending.entry.source, session.err)
            else
                acceptBundle(state, pending.entry.source, session.result, pending.fileHash)
            end
            state.pending = nil
        end
    elseif state.phase == "normalize" then
        local deadline = nowMs() + STEP_BUDGET_MS
        local normalizeStart = Profiler.now()
        local processed = 0
        while processed < NORMALIZE_MAX do
            local bundle = state.bundles[state.bundleIndex]
            if not bundle then
                Profiler.add("loader.normalize", normalizeStart)
                finishState()
                asyncFinish()
                return
            end
            local raw = (bundle.data.buildables or {})[state.buildableIndex]
            if raw then
                normalizeOne(state, bundle, raw)
                state.buildableIndex = state.buildableIndex + 1
                processed = processed + 1
                if nowMs() >= deadline then break end
            else
                state.bundleIndex = state.bundleIndex + 1
                state.buildableIndex = 1
            end
        end
        Profiler.add("loader.normalize", normalizeStart)
    end
end

function Loader.startAsync(onComplete)
    if KBW.Runtime.loaded then
        if onComplete then onComplete() end
        return
    end
    if async then
        if onComplete then async.callbacks[#async.callbacks + 1] = onComplete end
        return
    end
    local state = beginState()
    state.files = collectFileList()
    state.fileIndex = 0
    state.pending = nil
    state.phase = "files"
    state.callbacks = {}
    if onComplete then state.callbacks[1] = onComplete end
    async = state
    KBWB41.addEvent("OnFETick", Loader.stepAsync)
    KBWB41.addEvent("OnTickEvenPaused", Loader.stepAsync)
    Log:info("Definition loading started (%d files)", #state.files)
end

function Loader.isLoading()
    return async ~= nil
end

return Loader
