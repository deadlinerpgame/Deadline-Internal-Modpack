local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")

local FinishOptions = {}

FinishOptions.signOptions = {
    { sign = 36, text = "ContextMenu_SignSkull" }, { sign = 32, text = "ContextMenu_SignRightArrow" },
    { sign = 33, text = "ContextMenu_SignLeftArrow" }, { sign = 35, text = "ContextMenu_SignUpArrow" },
    { sign = 34, text = "ContextMenu_SignDownArrow" }
}

local fallbackPaintMenuItems = {
    { paint = "PaintBlue", text = "ContextMenu_Blue", color = { 0.35, 0.35, 0.80 } },
    { paint = "PaintGreen", text = "ContextMenu_Green", color = { 0.41, 0.80, 0.41 } },
    { paint = "PaintLightBrown", text = "ContextMenu_Light_Brown", color = { 0.59, 0.44, 0.21 } },
    { paint = "PaintLightBlue", text = "ContextMenu_Light_Blue", color = { 0.55, 0.55, 0.87 } },
    { paint = "PaintBrown", text = "ContextMenu_Brown", color = { 0.45, 0.23, 0.11 } },
    { paint = "PaintOrange", text = "ContextMenu_Orange", color = { 0.79, 0.44, 0.19 } },
    { paint = "PaintCyan", text = "ContextMenu_Cyan", color = { 0.50, 0.80, 0.80 } },
    { paint = "PaintPink", text = "ContextMenu_Pink", color = { 0.81, 0.60, 0.60 } },
    { paint = "PaintGrey", text = "ContextMenu_Grey", color = { 0.50, 0.50, 0.50 } },
    { paint = "PaintTurquoise", text = "ContextMenu_Turquoise", color = { 0.49, 0.70, 0.80 } },
    { paint = "PaintPurple", text = "ContextMenu_Purple", color = { 0.61, 0.40, 0.63 } },
    { paint = "PaintYellow", text = "ContextMenu_Yellow", color = { 0.84, 0.78, 0.30 } },
    { paint = "PaintWhite", text = "ContextMenu_White", color = { 0.92, 0.92, 0.92 } },
    { paint = "PaintRed", text = "ContextMenu_Red", color = { 0.63, 0.10, 0.10 } },
    { paint = "PaintBlack", text = "ContextMenu_Black", color = { 0.20, 0.20, 0.20 } }
}

local fallbackWallpaperMenuItems = {
    { paper = "Wallpaper_BeigeStripe", text = "ContextMenu_BeigeStripe" },
    { paper = "Wallpaper_BlackFloral", text = "ContextMenu_BlackFloral" },
    { paper = "Wallpaper_BlueStripe", text = "ContextMenu_Light_BlueStripe" },
    { paper = "Wallpaper_GreenDiamond", text = "ContextMenu_Light_GreenDiamond" },
    { paper = "Wallpaper_GreenFloral", text = "ContextMenu_GreenFloral" },
    { paper = "Wallpaper_PinkChevron", text = "ContextMenu_PinkChevron" },
    { paper = "Wallpaper_PinkFloral", text = "ContextMenu_PinkFloral" }
}

local function translated(key, fallback)
    local text = key and getText(key) or nil
    if text and text ~= key then return text end
    return fallback or tostring(key or "?")
end

local function ensurePaintMenu()
    if not ISPaintMenu then require "BuildingObjects/ISPaintMenu" end
end

function FinishOptions.paintMenuItems()
    ensurePaintMenu()
    return (ISPaintMenu and ISPaintMenu.PaintMenuItems) or fallbackPaintMenuItems
end

function FinishOptions.wallpaperMenuItems()
    ensurePaintMenu()
    return (ISPaintMenu and ISPaintMenu.WallpaperMenuItems) or fallbackWallpaperMenuItems
end

function FinishOptions.paintColorFor(paintType)
    local items = FinishOptions.paintMenuItems()
    for itemIndex = 1, #items do
        local item = items[itemIndex]
        if item.paint == paintType then return item.color end
    end
    local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
    local parts = WallFinishes.paintComponents(paintType)
    if #parts < 2 then return nil end
    local total, r, g, b = 0, 0, 0, 0
    for partIndex = 1, #parts do
        local color = FinishOptions.paintColorFor(parts[partIndex].item)
        local weight = parts[partIndex].parts
        if color then
            total = total + weight
            r = r + (color[1] or 0) * weight
            g = g + (color[2] or 0) * weight
            b = b + (color[3] or 0) * weight
        end
    end
    if total == 0 then return nil end
    return { r / total, g / total, b / total }
end

function FinishOptions.coveringAction(definition, stage)
    if not definition or ((definition.placement or {}).kind ~= "wallCovering") then return nil end
    local compat = EntityCompat.metadata(stage)
    local config = compat.wallCoveringConfig or {}
    return config.type or (definition.placement or {}).wallCoveringType
end

function FinishOptions.entriesFor(definition, stage)
    local entries = {}
    local action = FinishOptions.coveringAction(definition, stage)
    if action == "paintThump" then
        local items = FinishOptions.paintMenuItems()
        for itemIndex = 1, #items do
            local item = items[itemIndex]
            entries[#entries + 1] = {
                label = translated(item.text, item.paint),
                actionType = action,
                paintType = item.paint,
                color = item.color
            }
        end
    elseif action == "paintSign" then
        local items = FinishOptions.paintMenuItems()
        for signIndex = 1, #FinishOptions.signOptions do
            local sign = FinishOptions.signOptions[signIndex]
            for itemIndex = 1, #items do
                local item = items[itemIndex]
                entries[#entries + 1] = {
                    label = translated(sign.text, "Sign") .. " - " .. translated(item.text, item.paint),
                    actionType = action,
                    paintType = item.paint,
                    color = item.color,
                    sign = sign.sign
                }
            end
        end
    elseif action == "wallpaper" then
        local items = FinishOptions.wallpaperMenuItems()
        for itemIndex = 1, #items do
            local item = items[itemIndex]
            entries[#entries + 1] = {
                label = translated(item.text, item.paper),
                actionType = action,
                wallpaperType = item.paper
            }
        end
    elseif action == "plaster" then
        entries[#entries + 1] = { label = translated("ContextMenu_Plaster", "Plaster"), actionType = action }
    end
    local wallEntries = WallFinishes.entriesFor(definition, stage)
    if #wallEntries > 0 then
        entries[#entries + 1] = { label = getText("IGUI_KBW_NoFinish"), none = true }
        for entryIndex = 1, #wallEntries do
            entries[#entries + 1] = wallEntries[entryIndex]
        end
    end
    local finishOptions = stage and stage.finishOptions or {}
    for entryIndex = 1, #finishOptions do
        entries[#entries + 1] = finishOptions[entryIndex]
    end
    return entries
end

return FinishOptions
