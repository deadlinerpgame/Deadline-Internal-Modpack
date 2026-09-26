local JSON = require("ElyonLib/FileUtils/JSON")
local SafeJSON = require("KnoxBuildworks/Util/SafeJSON")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

if PZAPI == nil then PZAPI = {} end
if PZAPI.ModOptions ~= nil then return PZAPI.ModOptions end

local SAVE_FILE = "KnoxBuildworks_options.json"

local Option = {}
Option.__index = Option

function Option:getValue()
    if self.kind == "key" and self.bindingName then
        local core = getCore and getCore() or nil
        if core and core.getKey then
            local bound = core:getKey(self.bindingName)
            if bound and bound ~= 0 then return bound end
        end
    end
    return self.value
end

function Option:setValue(value)
    self.value = value
    if self.onChange then self.onChange(self, value) end
    return value
end

function Option:getTooltip()
    return self.tooltip and getText(self.tooltip) or nil
end

function Option:getName()
    return self.name and getText(self.name) or self.id
end

function Option:addItem(nameKey, selected)
    self.items = self.items or {}
    self.items[#self.items + 1] = nameKey
    if selected == true then
        self.default = #self.items
        if self.value == nil then self.value = #self.items end
    end
    if self.value == nil then self.value = 1 end
    return self
end

function Option:getItems()
    return self.items or {}
end

local Page = {}
Page.__index = Page

local ModOptions = {}
ModOptions._pages = {}

local function newOption(page, id, name, tooltip, kind, default, extra)
    local option = setmetatable({
        id = id, name = name, tooltip = tooltip, kind = kind,
        default = default, value = default
    }, Option)
    for key, value in pairs(extra or {}) do option[key] = value end
    page.options[id] = option
    page.order[#page.order + 1] = id
    return option
end

function ModOptions:create(id, name)
    local page = setmetatable({ id = id, name = name, options = {}, order = {} }, Page)
    ModOptions._pages[id] = page
    page:load()
    return page
end

local keyBindingSectionAdded = false

function Page:addKeyBind(id, nameKey, defaultKey, tooltipKey)
    local option = newOption(self, id, nameKey, tooltipKey, "key", defaultKey)
    if type(keyBinding) == "table" then
        if not keyBindingSectionAdded then
            keyBindingSectionAdded = true
            table.insert(keyBinding, { value = "[Knox Buildworks]" })
        end
        local label = getText(nameKey)
        if label == nameKey then label = id end
        option.bindingName = label
        table.insert(keyBinding, { value = label, key = defaultKey })
    end
    return option
end

function Page:addTickBox(id, nameKey, default, tooltipKey)
    return newOption(self, id, nameKey, tooltipKey, "boolean", default == true)
end

function Page:addSlider(id, nameKey, min, max, step, default, tooltipKey)
    return newOption(self, id, nameKey, tooltipKey, "slider", default,
        { min = min, max = max, step = step })
end

function Page:addComboBox(id, nameKey, tooltipKey)
    return newOption(self, id, nameKey, tooltipKey, "combo", nil, { items = {} })
end

function Page:addColorPicker(id, nameKey, r, g, b, a, tooltipKey)
    return newOption(self, id, nameKey, tooltipKey, "color",
        { r = r, g = g, b = b, a = a })
end

function Page:addTitle(nameKey)
    return newOption(self, "_title_" .. tostring(#self.order), nameKey, nil, "title")
end

function Page:addDescription(text)
    return newOption(self, "_desc_" .. tostring(#self.order), text, nil, "description")
end

function Page:getOption(id)
    return self.options[id]
end

local function readFile()
    local reader = getFileReader(SAVE_FILE, false)
    if not reader then return {} end
    local lines, line = {}, reader:readLine()
    while line do
        lines[#lines + 1] = line
        line = reader:readLine()
    end
    reader:close()
    local data = SafeJSON.decode(table.concat(lines, "\n"))
    if type(data) ~= "table" then return {} end
    return data
end

local SANDBOX_BACKED = {
    ShowMenuDock = true, KeepInventoryVisibleInPlanning = true,
    FadeUnavailableIcons = true, Debug = true, Profile = true,
    PinnedAlignment = true, PinnedPositionMode = true, PinnedOpacity = true,
    PinnedBar = true, PinnedContent = true,
}

local function sandboxValue(id)
    if not SANDBOX_BACKED[id] then return nil end
    local options = getSandboxOptions and getSandboxOptions() or nil
    if not options then return nil end
    local option = options:getOptionByName("KnoxBuildworks." .. id)
    if not (option and option.getValue) then return nil end
    return option:getValue()
end

function Page:load()
    local saved = readFile()[self.id]
    if type(saved) == "table" then self._pending = saved end
end

function Page:applyPending()
    for id in pairs(SANDBOX_BACKED) do
        local option = self.options[id]
        if option then
            local value = sandboxValue(id)
            if value ~= nil then option.value = value end
        end
    end
    if type(self._pending) ~= "table" then return end
    for id, value in pairs(self._pending) do
        local option = self.options[id]
        if option then option.value = value end
    end
end

function Page:save()
    self:applyPending()
    local existing = readFile()
    local page = {}
    for id, option in pairs(self.options) do
        if option.kind ~= "title" and option.kind ~= "description" then
            page[id] = option.value
        end
    end
    existing[self.id] = page
    local writer = getFileWriter(SAVE_FILE, true, false)
    if not writer then return false end
    writer:write(JSON.stringify(existing))
    writer:close()
    return true
end

KBWB41.addEvent("OnGameStart", function ()
    for _, page in pairs(ModOptions._pages) do
        page:applyPending()
        if type(page.apply) == "function" then page.apply(page) end
    end
end)

PZAPI.ModOptions = ModOptions
return ModOptions
