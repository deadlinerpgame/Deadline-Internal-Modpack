local ItemUtils = require("ElyonLib/ItemUtils/ItemUtils")

local S = {}
local TM = getTextManager()

S.HS = TM:getFontHeight(UIFont.Small)
S.HM = TM:getFontHeight(UIFont.Medium)
S.HL = TM:getFontHeight(UIFont.Large)
S.PAD = 10
S.ICON = 32
S.SMALL_ICON = 20
S.ROW_H = math.max(S.ICON + 8, S.HM + S.HS + 8)
S.BUTTON_H = math.max(25, S.HS + 10)

S.white = { r = 1, g = 1, b = 1, a = 1 }
S.grey = { r = 0.54, g = 0.54, b = 0.54, a = 1 }

function S.textWidth(font, text)
    return TM:MeasureStringX(font, text or "")
end

local function fromColorInfo(ci)
    return { r = ci:getR(), g = ci:getG(), b = ci:getB(), a = 1 }
end

function S.good() return fromColorInfo(getCore():getGoodHighlitedColor()) end
function S.bad() return fromColorInfo(getCore():getBadHighlitedColor()) end

function S.lerp(c1, c2, t)
    if t < 0 then t = 0 elseif t > 1 then t = 1 end
    return { r = c1.r + (c2.r - c1.r) * t, g = c1.g + (c2.g - c1.g) * t, b = c1.b + (c2.b - c1.b) * t, a = 1 }
end

function S.conditionColor(frac)
    return S.lerp(S.bad(), S.good(), frac)
end

function S.chanceColor(chance)
    if chance >= 0.75 then return S.good() end
    if chance < 0.40 then return S.bad() end
    return S.white
end

function S.percent(frac)
    return tostring(math.floor((frac or 0) * 100 + 0.5)) .. "%"
end

function S.texture(itemOrType)
    return ItemUtils.getTexture(itemOrType)
end

function S.displayName(fullType)
    return ItemUtils.getDisplayName(fullType)
end

function S.perkName(perk)
    local p = PerkFactory.getPerk(perk)
    return p and p:getName() or tostring(perk)
end

function S.drawIcon(ui, tex, x, y, size, alpha)
    if not tex then return end
    alpha = alpha or 1
    local tw, th = tex:getWidthOrig(), tex:getHeightOrig()
    if tw <= size and th <= size then
        ui:drawTexture(tex, x + (size - tw) / 2, y + (size - th) / 2, alpha, 1, 1, 1)
    else
        ui:drawTextureScaledAspect(tex, x, y, size, size, alpha, 1, 1, 1)
    end
end

function S.drawRow(list, y, item, tex, title, sub, subColor, available)
    local h = item.height or list.itemheight
    local w = list:getWidth()
    local a = (available == false) and 0.3 or 0.9
    local bc = list.borderColor
    list:drawRectBorder(0, y, w, h - 1, a, bc.r, bc.g, bc.b)
    if list.selected == item.index then
        list:drawRect(0, y, w, h - 1, 0.3, 0.7, 0.35, 0.15)
    end
    local x = 6
    if tex then
        S.drawIcon(list, tex, x, y + (h - S.ICON) / 2, S.ICON, a)
        x = x + S.ICON + 8
    end
    local textH = S.HM + ((sub and sub ~= "") and S.HS or 0)
    local ty = y + (h - textH) / 2
    list:drawText(title or item.text or "", x, ty, 1, 1, 1, a, UIFont.Medium)
    if sub and sub ~= "" then
        local c = subColor or S.white
        list:drawText(sub, x, ty + S.HM, c.r, c.g, c.b, a, UIFont.Small)
    end
    return y + h
end

function S.drawHeader(ui, x, y, tex, title, subtitle, subColor)
    local box = S.ICON + 10
    ui:drawRectBorder(x, y, box, box, 1, 1, 1, 1)
    S.drawIcon(ui, tex, x + 5, y + 5, S.ICON, 1)
    ui:drawText(title or "", x + box + 5, y, 1, 1, 1, 1, UIFont.Large)
    if subtitle and subtitle ~= "" then
        local c = subColor or S.white
        ui:drawText(subtitle, x + box + 5, y + S.HL, c.r, c.g, c.b, 1, UIFont.Small)
    end
    return y + math.max(box, S.HL + S.HS) + 6
end

function S.drawSection(ui, text, x, y)
    ui:drawText(text, x, y, 1, 1, 1, 1, UIFont.Medium)
    return y + S.HM + 2
end

function S.drawLine(ui, text, x, y, color, font)
    local c = color or S.white
    ui:drawText(text, x, y, c.r, c.g, c.b, 1, font or UIFont.Small)
    return y + TM:getFontHeight(font or UIFont.Small)
end

function S.drawReqLine(ui, x, y, tex, text, ok)
    local c = ok and S.white or S.grey
    local ty = y + (S.SMALL_ICON - S.HS) / 2
    local dx = x + 15
    ui:drawText("-", dx, ty, c.r, c.g, c.b, 1, UIFont.Small)
    dx = dx + S.textWidth(UIFont.Small, "-") + 4
    if tex then
        S.drawIcon(ui, tex, dx, y, S.SMALL_ICON, ok and 0.9 or 0.3)
        dx = dx + S.SMALL_ICON + 4
    end
    ui:drawText(text, dx, ty, c.r, c.g, c.b, 1, UIFont.Small)
    return y + S.SMALL_ICON + 2
end

function S.drawSkillLine(ui, x, y, perk, have, need)
    local ok = have >= need
    local text = " - " .. S.perkName(perk) .. ": " .. tostring(have) .. " / " .. tostring(need)
    ui:drawText(text, x + 15, y, 1, ok and 1 or 0, ok and 1 or 0, 1, UIFont.Small)
    return y + S.HS
end

function S.drawBar(ui, x, y, w, h, frac, color)
    ui:drawProgressBar(x, y, w, h, frac, color)
    ui:drawRectBorder(x, y, w, h, 1, 0.4, 0.4, 0.4)
end

function S.newButton(target, title, onclick)
    local b = ISButton:new(0, 0, S.textWidth(UIFont.Small, title) + 30, S.BUTTON_H, title, target, onclick)
    b:initialise()
    b:instantiate()
    return b
end

function S.setButtonState(button, enabled, reason)
    button:setEnable(enabled and true or false)
    button:setTooltip((not enabled) and reason or nil)
end

function S.newList(target, rowHeight, onSelect, drawRow)
    local list = ISScrollingListBox:new(0, 0, 10, 10)
    list:initialise()
    list.itemheight = rowHeight
    list.font = UIFont.Small
    list.drawBorder = true
    list.target = target
    list.onmousedown = onSelect
    list.doDrawItem = drawRow
    return list
end

return S
