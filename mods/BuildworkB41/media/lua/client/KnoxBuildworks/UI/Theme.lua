local Theme = {}

local good = getCore():getGoodHighlitedColor()

Theme.backdrop = { r = 0.025, g = 0.022, b = 0.020, a = 0.86 }
Theme.surface = { r = 0.070, g = 0.065, b = 0.060, a = 0.78 }
Theme.surfaceRaised = { r = 0.115, g = 0.100, b = 0.086, a = 0.90 }
Theme.selected = { r = 0.16, g = 0.18, b = 0.13, a = 0.92 }
Theme.selectedSoft = { r = 0.115, g = 0.135, b = 0.105, a = 0.72 }
Theme.accent = { r = 0.76, g = 0.70, b = 0.42, a = 1.0 }
Theme.border = { r = 0.48, g = 0.46, b = 0.42, a = 0.75 }
Theme.borderSoft = { r = 0.30, g = 0.29, b = 0.27, a = 0.65 }
Theme.text = { r = 0.92, g = 0.91, b = 0.88, a = 1.0 }
Theme.textMuted = { r = 0.64, g = 0.63, b = 0.60, a = 1.0 }
Theme.good = { r = good:getR(), g = good:getG(), b = good:getB(), a = 1.0 }
Theme.bad = { r = 0.84, g = 0.42, b = 0.24, a = 1.0 }
Theme.warn = { r = 0.86, g = 0.62, b = 0.28, a = 1.0 }
Theme.warnSoft = { r = 0.46, g = 0.32, b = 0.18, a = 0.80 }
Theme.dangerSoft = { r = 0.38, g = 0.24, b = 0.18, a = 0.85 }
Theme.primary = { r = 0.30, g = 0.44, b = 0.29, a = 0.88 }
Theme.primaryHover = { r = 0.38, g = 0.52, b = 0.35, a = 0.94 }
Theme.disabled = { r = 0.16, g = 0.15, b = 0.14, a = 0.55 }

local PANEL_TONES = {
    {
        backdrop = { .025, .022, .020 }, surface = { .070, .065, .060 }, raised = { .115, .100, .086 },
        selected = { .160, .180, .130 }, selectedSoft = { .115, .135, .105 }, accent = { .760, .700, .420 },
        primary = { .300, .440, .290 }, primaryHover = { .380, .520, .350 }
    },
    {
        backdrop = { .055, .055, .055 }, surface = { .105, .105, .105 }, raised = { .155, .155, .155 },
        selected = { .170, .180, .185 }, selectedSoft = { .125, .135, .140 }, accent = { .760, .760, .720 },
        primary = { .300, .410, .430 }, primaryHover = { .380, .500, .520 }
    },
    {
        backdrop = { .040, .052, .064 }, surface = { .075, .092, .108 }, raised = { .120, .140, .160 },
        selected = { .120, .175, .210 }, selectedSoft = { .090, .135, .165 }, accent = { .520, .760, .900 },
        primary = { .220, .410, .540 }, primaryHover = { .290, .500, .640 }
    },
    {
        backdrop = { .025, .050, .040 }, surface = { .055, .095, .075 }, raised = { .085, .140, .110 },
        selected = { .100, .205, .145 }, selectedSoft = { .070, .150, .110 }, accent = { .560, .820, .550 },
        primary = { .200, .480, .300 }, primaryHover = { .270, .570, .370 }
    },
    {
        backdrop = { .018, .025, .055 }, surface = { .045, .055, .105 }, raised = { .075, .085, .155 },
        selected = { .100, .120, .235 }, selectedSoft = { .075, .090, .180 }, accent = { .570, .680, .980 },
        primary = { .250, .330, .620 }, primaryHover = { .330, .420, .730 }
    },
    {
        backdrop = { .050, .025, .052 }, surface = { .095, .055, .100 }, raised = { .145, .085, .150 },
        selected = { .205, .105, .220 }, selectedSoft = { .150, .075, .165 }, accent = { .850, .590, .900 },
        primary = { .490, .240, .540 }, primaryHover = { .590, .320, .640 }
    },
    {
        backdrop = { .075, .060, .042 }, surface = { .125, .100, .070 }, raised = { .180, .145, .095 },
        selected = { .220, .175, .095 }, selectedSoft = { .165, .130, .075 }, accent = { .940, .710, .310 },
        primary = { .520, .390, .180 }, primaryHover = { .620, .480, .240 }
    }
}

local function optionValue(options, id, fallback)
    local option = options and options.getOption and options:getOption(id)
    return option and option.getValue and option:getValue() or fallback
end

local function setColor(target, values, alpha)
    target.r = values[1]
    target.g = values[2]
    target.b = values[3]
    if alpha ~= nil then target.a = alpha end
end

local function optionColor(options, id, fallback)
    local value = optionValue(options, id, fallback)
    if type(value) ~= "table" then return fallback end
    return {
        r = tonumber(value.r) or fallback.r,
        g = tonumber(value.g) or fallback.g,
        b = tonumber(value.b) or fallback.b,
        a = tonumber(value.a) or fallback.a
    }
end

function Theme.applyAccessibility(options)
    local opacity = tonumber(optionValue(options, "PanelOpacity", 86)) or 86
    if opacity > 1 then opacity = opacity / 100 end
    opacity = math.max(.35, math.min(1, opacity))
    local tone = PANEL_TONES[tonumber(optionValue(options, "PanelTone", 1)) or 1] or PANEL_TONES[1]
    setColor(Theme.backdrop, tone.backdrop, opacity)
    setColor(Theme.surface, tone.surface, math.min(1, opacity * .90))
    setColor(Theme.surfaceRaised, tone.raised, math.min(1, opacity * 1.02))
    setColor(Theme.selected, tone.selected, .92)
    setColor(Theme.selectedSoft, tone.selectedSoft, .72)
    setColor(Theme.accent, tone.accent, 1)
    setColor(Theme.primary, tone.primary, .88)
    setColor(Theme.primaryHover, tone.primaryHover, .94)
    local highContrast = optionValue(options, "HighContrast", false) == true
    if highContrast then
        setColor(Theme.text, { 1, 1, 1 }, 1)
        setColor(Theme.textMuted, { .80, .80, .78 }, 1)
        setColor(Theme.border, { .80, .78, .70 }, .95)
        setColor(Theme.borderSoft, { .55, .54, .50 }, .85)
        setColor(Theme.accent, { .95, .84, .38 }, 1)
    else
        setColor(Theme.text, { .92, .91, .88 }, 1)
        setColor(Theme.textMuted, { .64, .63, .60 }, 1)
        setColor(Theme.border, { .48, .46, .42 }, .75)
        setColor(Theme.borderSoft, { .30, .29, .27 }, .65)
        setColor(Theme.accent, tone.accent, 1)
    end
end

function Theme.previewBackground(options)
    local mode = tonumber(optionValue(options, "PreviewBackground", 1)) or 1
    if mode == 2 then return "light" end
    if mode == 3 then return "dark" end
    if mode == 4 then return "custom" end
    return "checker"
end

function Theme.drawPreviewBackground(panel, x, y, width, height, options)
    local mode = Theme.previewBackground(options)
    if mode == "light" then
        panel:drawRect(x, y, width, height, .96, .64, .64, .62)
        return
    end
    if mode == "dark" then
        panel:drawRect(x, y, width, height, .96, .025, .025, .025)
        return
    end
    if mode == "custom" then
        local color = optionColor(options, "BuildableBackgroundColor", { r = .35, g = .35, b = .35, a = 1 })
        panel:drawRect(x, y, width, height, color.a, color.r, color.g, color.b)
        return
    end
    local cell = 12
    panel:drawRect(x, y, width, height, .96, .48, .48, .46)
    local rows = math.ceil(height / cell)
    local columns = math.ceil(width / cell)
    for row = 0, rows - 1 do
        for column = 0, columns - 1 do
            if (row + column) % 2 == 0 then
                panel:drawRect(
                    x + column * cell, y + row * cell, math.min(cell, width - column * cell),
                    math.min(cell, height - row * cell), .72, .22, .22, .22
                )
            end
        end
    end
end

local function cloneColor(c)
    return { r = c.r or 1, g = c.g or 1, b = c.b or 1, a = c.a or 1 }
end

Theme.color = cloneColor

function Theme.lockButtonColors(button)
    if not button then
        return
    end
    button.borderColorEnabled = cloneColor(button.borderColor)
    button.backgroundColorEnabled = cloneColor(button.backgroundColor)
end

function Theme.setButtonEnabled(button, enabled)
    if not button then
        return
    end
    if not button.borderColorEnabled then Theme.lockButtonColors(button) end
    button.enable = enabled == true
    if button.enable then
        button.textureColor = { r = 1, g = 1, b = 1, a = 1 }
        button.textColor = cloneColor(Theme.text)
        button.borderColor = cloneColor(button.borderColorEnabled)
        button.backgroundColor = cloneColor(button.backgroundColorEnabled)
    else
        button.textureColor = { r = 0.42, g = 0.42, b = 0.42, a = 1 }
        button.textColor = cloneColor(Theme.textMuted)
        button.borderColor = cloneColor(Theme.borderSoft)
        button.backgroundColor = cloneColor(Theme.disabled)
    end
    button.textColorDisable = cloneColor(Theme.textMuted)
end

function Theme.applyButton(button, selected)
    if not button then
        return
    end
    button.backgroundColor = cloneColor(selected and Theme.selectedSoft or Theme.surface)
    button.backgroundColorMouseOver = cloneColor(Theme.surfaceRaised)
    button.backgroundColorPressed = nil
    button.borderColor = cloneColor(selected and Theme.accent or Theme.borderSoft)
    button.textColor = cloneColor(Theme.text)
    button.textColorMouseOver = cloneColor(Theme.text)
    button.textColorDisable = cloneColor(Theme.textMuted)
    Theme.lockButtonColors(button)
    Theme.setButtonEnabled(button, button.enable ~= false)
end

function Theme.applyActionButton(button, enabled, primary)
    if not button then
        return
    end
    button.backgroundColor = cloneColor(primary and Theme.primary or Theme.surface)
    button.backgroundColorMouseOver = cloneColor(primary and Theme.primaryHover or Theme.surfaceRaised)
    button.backgroundColorPressed = nil
    button.borderColor = cloneColor(primary and Theme.accent or Theme.borderSoft)
    button.textColor = cloneColor(Theme.text)
    button.textColorDisable = cloneColor(Theme.textMuted)
    Theme.lockButtonColors(button)
    Theme.setButtonEnabled(button, enabled == true)
end

return Theme
