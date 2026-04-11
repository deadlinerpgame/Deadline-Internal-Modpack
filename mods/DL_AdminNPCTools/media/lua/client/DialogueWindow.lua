require "ISUI/ISUIElement"
require "ISUI/ISPanel"

DialogueWindow = ISPanel:derive("DialogueWindow")
local W            = 540
local H            = 420
local PAD          = 10
local PORTRAIT_SZ  = 80
local HEADER_H     = 30
local OPTION_H     = 22
local HINT_EXTRA   = 16
local COL_X  = PAD + PORTRAIT_SZ + PAD
local COL_W  = W - COL_X - PAD

local CLOSE_KEYS = { Keyboard.KEY_F, Keyboard.KEY_V }

function DialogueWindow:new()
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local o  = ISPanel.new(self, math.floor((sw - W) / 2), math.floor((sh - H) / 2), W, H)
    o.moveWithMouse = false
    o.npcName       = ""
    o.portrait      = nil
    o.zoneId        = nil
    o.nodes         = {}
    o.rootId        = nil
    o.currentNodeId = nil
    o.npcText       = ""
    o.responses     = {}
    o.nodeStack     = {}
    o.scrollOffset  = 0
    o.maxScroll     = 0
    o.hoveredOption = nil
    o.hoveredBack   = false
    o.fadeAlpha = 0
    o.fadeDir   = 1
    o.fadeSpeed = 3
    o.active    = false
    o.sbDragging    = false
    o.sbDragOffset  = 0
    o.pendingConfirm = nil
    o.backRect = { x = 0, y = 0, w = 0, h = 0 }
    return o
end

local function onGlobalKeyPressed(key)
    local inst = DialogueWindow._instance
    if not inst or not inst.active then return end

    if inst.pendingConfirm then
        if key == Keyboard.KEY_RETURN or key == Keyboard.KEY_Y then
            inst:confirmResponse(true)
        elseif key == Keyboard.KEY_N or key == Keyboard.KEY_ESCAPE then
            inst:confirmResponse(false)
        end
        return
    end

    for _, k in ipairs(CLOSE_KEYS) do
        if key == k then inst:endSession(); return end
    end

    local numMap = {
        [Keyboard.KEY_1]=1,[Keyboard.KEY_2]=2,[Keyboard.KEY_3]=3,
        [Keyboard.KEY_4]=4,[Keyboard.KEY_5]=5,[Keyboard.KEY_6]=6,
        [Keyboard.KEY_7]=7,[Keyboard.KEY_8]=8,[Keyboard.KEY_9]=9,
    }
    local num = numMap[key]
    if num then inst:activateResponse(num); return end

    if key == Keyboard.KEY_BACK then inst:goBack() end
end

function DialogueWindow:openForZone(zoneId, npcName, nodes, rootId, portraitPath)
    self.zoneId        = zoneId
    self.npcName       = npcName or "Unknown"
    self.nodes         = nodes   or {}
    self.rootId        = rootId  or "root"
    self.nodeStack     = {}
    self.scrollOffset  = 0
    self.hoveredOption = nil
    self.active        = true
    self.pendingConfirm = nil
    self.portrait = nil
    if portraitPath and portraitPath ~= "" then
        local name = portraitPath:match("^(.+)%.[^%.]+$") or portraitPath
        local tried = {
            "media/ui/portraits/" .. name .. ".jpg",
            "media/ui/portraits/" .. name .. ".png",
            portraitPath,
        }
        for _, path in ipairs(tried) do
            local ok, tex = pcall(getTexture, path)
            if ok and tex then self.portrait = tex; break end
        end
    end

    self:goToNode(self.rootId)
    self.fadeAlpha = 0
    self.fadeDir   = 1
    self:setVisible(true)

    if not DialogueWindow._keyHookAdded then
        Events.OnKeyPressed.Add(onGlobalKeyPressed)
        DialogueWindow._keyHookAdded = true
    end
end

function DialogueWindow:endSession()
    if not self.active then return end
    self.active = false
    self.pendingConfirm = nil
    if self.zoneId then
        sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "EndSession", { zoneId = self.zoneId })
    end

    self.fadeDir = -1
end

function DialogueWindow:goToNode(nodeId)
    local node = self.nodes[nodeId]
    if not node then return end
    if self.currentNodeId then table.insert(self.nodeStack, self.currentNodeId) end
    self.currentNodeId = nodeId
    self.npcText       = node.npcText or ""
    self.responses     = node.responses or {}
    self.scrollOffset  = 0
    self.hoveredOption = nil
end

function DialogueWindow:goBack()
    if #self.nodeStack == 0 then return end
    local prevId = table.remove(self.nodeStack)
    local node   = self.nodes[prevId]
    if not node then return end
    self.currentNodeId = prevId
    self.npcText       = node.npcText or ""
    self.responses     = node.responses or {}
    self.scrollOffset  = 0
    self.hoveredOption = nil
end

local function describeConsume(consumeList)
    if not consumeList or #consumeList == 0 then return nil end
    local parts = {}
    for _, entry in ipairs(consumeList) do
        local amt = tonumber(entry.amount) or 1
        local display = entry.itemName or "item"
        local ok, scriptItem = pcall(function()
            return ScriptManager.instance:getItem(entry.itemName)
        end)
        if ok and scriptItem then display = scriptItem:getDisplayName() end
        parts[#parts + 1] = (amt > 1) and (amt .. "x " .. display) or display
    end
    return table.concat(parts, ", ")
end

function DialogueWindow:executeResponse(resp)
    if resp.consumeList then
        local player = getSpecificPlayer(0)
        if player then
            local inv = player:getInventory()
            for _, entry in ipairs(resp.consumeList) do
                local remaining = tonumber(entry.amount) or 1
                while remaining > 0 do
                    local item = inv:getFirstTypeRecurse(entry.itemName)
                    if not item then break end
                    inv:Remove(item)
                    remaining = remaining - 1
                end
            end
        end
    end
    local leadsTo = resp.leadsTo
    if leadsTo and leadsTo ~= "(end)" then
        self:goToNode(leadsTo)
    else
        self:endSession()
    end
end

function DialogueWindow:activateResponse(i)
    local resp = self.responses[i]
    if not resp or resp.state ~= "normal" then return end
    if resp.consumeList and #resp.consumeList > 0 then
        local summary = describeConsume(resp.consumeList)
        if summary then
            self.pendingConfirm = { respIndex = i, label = "Give " .. summary .. "?" }
            return
        end
    end
    self:executeResponse(resp)
end

function DialogueWindow:confirmResponse(accept)
    local pc = self.pendingConfirm
    self.pendingConfirm = nil
    if not accept or not pc then return end
    local resp = self.responses[pc.respIndex]
    if resp and resp.state == "normal" then self:executeResponse(resp) end
end

local function wrapText(text, font, maxW)
    local words = {}
    for w in text:gmatch("%S+") do words[#words + 1] = w end
    local lines, line = {}, ""
    for _, word in ipairs(words) do
        local test = line == "" and word or (line .. " " .. word)
        if getTextManager():MeasureStringX(font, test) <= maxW then
            line = test
        else
            if line ~= "" then lines[#lines + 1] = line end
            line = word
        end
    end
    if line ~= "" then lines[#lines + 1] = line end
    return lines
end

function DialogueWindow:drawTextWrapped(text, font, x, y, maxW)
    local lines = wrapText(text, font, maxW)
    local lh    = getTextManager():getFontHeight(font) + 2
    for _, l in ipairs(lines) do
        self:drawText(l, x, y, 1, 1, 1, 1, font)
        y = y + lh
    end
    return y
end

function DialogueWindow:update()
    ISPanel.update(self)
    local dt = 1 / 30
    self.fadeAlpha = self.fadeAlpha + self.fadeDir * self.fadeSpeed * dt
    if self.fadeAlpha >= 1 then
        self.fadeAlpha = 1
    elseif self.fadeAlpha <= 0 then
        self.fadeAlpha = 0
        if self.fadeDir == -1 then
            self:setVisible(false)
            if DialogueWindow._keyHookAdded then
                Events.OnKeyPressed.Remove(onGlobalKeyPressed)
                DialogueWindow._keyHookAdded = false
            end
        end
    end
end

function DialogueWindow:prerender()
    local a    = self.fadeAlpha
    local fSm  = UIFont.Small
    local fMed = UIFont.Medium
    local fTny = UIFont.Tiny
    local lhMd = getTextManager():getFontHeight(fMed)
    local tm   = getTextManager()
    self:drawRect(0, 0, W, H, a, 0, 0, 0)
    self:drawRectBorder(0, 0, W, H, a, 0.5, 0.5, 0.5)

    local topY = PAD
    local px = PAD
    local py = topY
    if self.portrait then
        self:drawTextureScaled(self.portrait, px, py, PORTRAIT_SZ, PORTRAIT_SZ, a, 1, 1, 1)
    else
        self:drawRect(px, py, PORTRAIT_SZ, PORTRAIT_SZ, a * 0.6, 0.08, 0.08, 0.08)
        self:drawRectBorder(px, py, PORTRAIT_SZ, PORTRAIT_SZ, a, 0.35, 0.35, 0.35)
        local initial = (self.npcName and self.npcName:sub(1,1)) or "?"
        local iFont = UIFont.Large
        local iW = tm:MeasureStringX(iFont, initial)
        local iH = tm:getFontHeight(iFont)
        self:drawText(initial,
            math.floor(px + (PORTRAIT_SZ - iW) / 2),
            math.floor(py + (PORTRAIT_SZ - iH) / 2),
            0.55, 0.55, 0.55, a, iFont)
    end
    local nameY = topY + math.floor((PORTRAIT_SZ - lhMd) / 2)
    self:drawText(self.npcName, COL_X, nameY, 1, 1, 1, a, fMed)
    local divY = topY + PORTRAIT_SZ + PAD
    self:drawRect(PAD, divY, W - PAD * 2, 1, 0.4, 0.4, 0.4, a)
    local y = divY + 6
    y = self:drawTextWrapped(self.npcText, fSm, PAD, y, W - PAD * 2) + PAD
    self:drawRect(PAD, y, W - PAD * 2, 1, 0.4, 0.4, 0.4, a)
    y = y + 6
    local optAreaY = y
    self.optAreaY  = optAreaY
    local optAreaH = H - optAreaY - HEADER_H - PAD
    self:setStencilRect(0, optAreaY, W, optAreaH)

    local optY   = optAreaY - self.scrollOffset
    local totalH = 0
    for i, resp in ipairs(self.responses) do
        local isGreyed = resp.state == "greyed"
        local isReject = resp.state == "reject"
        local hasReqs  = resp.reqs ~= nil
        local rowH     = OPTION_H + (hasReqs and HINT_EXTRA or 0)
        totalH = totalH + rowH

        if optY + rowH > optAreaY and optY < optAreaY + optAreaH then
            local hovered = self.hoveredOption == i
            if hovered and not isGreyed then
                self:drawRect(PAD, optY, W - PAD * 2, rowH - 2, 0.15, 0.15, 0.15, a)
            end
            local r, g, b
            if isGreyed then r, g, b = 0.5, 0.5, 0.5
            elseif isReject then r, g, b = 0.7, 0.4, 0.3
            elseif hovered then r, g, b = 1, 1, 0.6
            else r, g, b = 0.9, 0.9, 0.9 end
            local prefix = (i <= 9) and ("[" .. i .. "] ") or "> "
            self:drawText(prefix .. resp.label, PAD + 4, optY + 3, r, g, b, a, fSm)

            if hasReqs then
                local reqY = optY + OPTION_H - 2
                local prefixTxt = "[ Requirements : "
                local suffix    = " ]"
                local prefixW   = tm:MeasureStringX(fTny, prefixTxt)
                self:drawText(prefixTxt, PAD + 4, reqY, 0.55, 0.55, 0.55, a, fTny)
                local rx = PAD + 4 + prefixW
                for ri2, req in ipairs(resp.reqs) do
                    local cr, cg, cb
                    if req.met then cr, cg, cb = 0.7, 0.9, 0.7
                    else cr, cg, cb = 0.9, 0.35, 0.35 end
                    local reqText = req.label
                    if ri2 < #resp.reqs then reqText = reqText .. "  ·  " end
                    self:drawText(reqText, rx, reqY, cr, cg, cb, a, fTny)
                    rx = rx + tm:MeasureStringX(fTny, reqText)
                end
                self:drawText(suffix, rx, reqY, 0.55, 0.55, 0.55, a, fTny)
            end
        end
        optY = optY + rowH
    end

    self.maxScroll = math.max(0, totalH - optAreaH)
    self:clearStencilRect()
    self.sbRect = nil
    if self.maxScroll > 0 then
        local sbX    = W - 6
        local sbH    = optAreaH
        local thumbH = math.max(16, sbH * (optAreaH / totalH))
        local thumbY = optAreaY + (self.scrollOffset / self.maxScroll) * (sbH - thumbH)
        self:drawRect(sbX, optAreaY, 4, sbH, 0.2, 0.2, 0.2, a)
        local tr, tg, tb = 0.6, 0.6, 0.6
        if self.sbDragging then tr, tg, tb = 0.9, 0.9, 0.9 end
        self:drawRect(sbX, thumbY, 4, thumbH, tr, tg, tb, a)
        self.sbRect = { x = sbX, y = optAreaY, w = 4, h = sbH, thumbY = thumbY, thumbH = thumbH }
    end

    local footerY = H - HEADER_H
    self:drawRect(PAD, footerY, W - PAD * 2, 1, 0.4, 0.4, 0.4, a)
    footerY = footerY + 6
    if #self.nodeStack > 0 then
        local backTxt = "[Back]"
        local bw = tm:MeasureStringX(fTny, backTxt)
        local bh = tm:getFontHeight(fTny)
        local br, bg, bb = 0.8, 0.8, 0.5
        if self.hoveredBack then br, bg, bb = 1, 1, 0.6 end
        self:drawText(backTxt, PAD, footerY, br, bg, bb, a, fTny)
        self.backRect = { x = PAD, y = footerY, w = bw, h = bh }
        self:drawText("[F/V] Close", PAD + bw + 10, footerY, 0.5, 0.5, 0.5, a, fTny)
    else
        self:drawText("[F/V] Close", PAD, footerY, 0.5, 0.5, 0.5, a, fTny)
        self.backRect = { x = 0, y = 0, w = 0, h = 0 }
    end

    if self.pendingConfirm then
        local mw, mh = 320, 90
        local mx = math.floor((W - mw) / 2)
        local my = math.floor((H - mh) / 2)
        self:drawRect(0, 0, W, H, a * 0.5, 0, 0, 0)
        self:drawRect(mx, my, mw, mh, a, 0.08, 0.08, 0.08)
        self:drawRectBorder(mx, my, mw, mh, a, 0.6, 0.6, 0.6)
        local label = self.pendingConfirm.label
        local lw = tm:MeasureStringX(fSm, label)
        self:drawText(label, mx + math.floor((mw - lw) / 2), my + 14, 1, 1, 1, a, fSm)
        local btnY = my + mh - 28
        local yesTxt, noTxt = "[Y] Yes", "[N] No"
        local yw = tm:MeasureStringX(fSm, yesTxt)
        local nw = tm:MeasureStringX(fSm, noTxt)
        local gap = 40
        local totalBtnW = yw + nw + gap
        local bx = mx + math.floor((mw - totalBtnW) / 2)
        self:drawText(yesTxt, bx, btnY, 0.7, 0.9, 0.7, a, fSm)
        self:drawText(noTxt,  bx + yw + gap, btnY, 0.9, 0.5, 0.5, a, fSm)
        self.confirmYesRect = { x = bx, y = btnY, w = yw, h = tm:getFontHeight(fSm) }
        self.confirmNoRect  = { x = bx + yw + gap, y = btnY, w = nw, h = tm:getFontHeight(fSm) }
    else
        self.confirmYesRect = nil
        self.confirmNoRect  = nil
    end
end

local function pointInRect(mx, my, r)
    return r and mx >= r.x and mx <= r.x + r.w and my >= r.y and my <= r.y + r.h
end

function DialogueWindow:onMouseMove(dx, dy)
    local optAreaY = self.optAreaY or 0
    local optAreaH = H - optAreaY - HEADER_H - PAD
    local mx, my   = self:getMouseX(), self:getMouseY()

    if self.sbDragging and self.sbRect then
        local sb = self.sbRect
        local trackUsable = sb.h - sb.thumbH
        if trackUsable > 0 then
            local newThumbY = my - self.sbDragOffset
            local rel = (newThumbY - sb.y) / trackUsable
            if rel < 0 then rel = 0 elseif rel > 1 then rel = 1 end
            self.scrollOffset = rel * self.maxScroll
        end
        return
    end

    self.hoveredOption = nil
    local optY = optAreaY - self.scrollOffset
    for i, resp in ipairs(self.responses) do
        local rowH = OPTION_H + (resp.reqs and HINT_EXTRA or 0)
        if my >= optY and my < optY + rowH and my >= optAreaY and my < optAreaY + optAreaH then
            self.hoveredOption = i
            break
        end
        optY = optY + rowH
    end

    self.hoveredBack = (#self.nodeStack > 0) and pointInRect(mx, my, self.backRect) or false
end

function DialogueWindow:onMouseUp(x, y)
    self.sbDragging = false
end
DialogueWindow.onMouseUpOutside = DialogueWindow.onMouseUp

function DialogueWindow:onMouseWheel(del)
    self.scrollOffset = math.max(0, math.min(self.maxScroll, self.scrollOffset - del * 20))
    return true
end

function DialogueWindow:onMouseDown(x, y)
    if self.pendingConfirm then
        if pointInRect(x, y, self.confirmYesRect) then self:confirmResponse(true); return
        elseif pointInRect(x, y, self.confirmNoRect) then self:confirmResponse(false); return end
        return
    end

    if self.sbRect then
        local sb = self.sbRect
        if x >= sb.x - 2 and x <= sb.x + sb.w + 2 and y >= sb.y and y <= sb.y + sb.h then
            if y >= sb.thumbY and y <= sb.thumbY + sb.thumbH then
                self.sbDragging   = true
                self.sbDragOffset = y - sb.thumbY
            else
                local trackUsable = sb.h - sb.thumbH
                if trackUsable > 0 then
                    local rel = (y - sb.y - sb.thumbH / 2) / trackUsable
                    if rel < 0 then rel = 0 elseif rel > 1 then rel = 1 end
                    self.scrollOffset = rel * self.maxScroll
                    self.sbDragging   = true
                    self.sbDragOffset = sb.thumbH / 2
                end
            end
            return
        end
    end

    local optAreaY = self.optAreaY or 0
    local optAreaH = H - optAreaY - HEADER_H - PAD

    if pointInRect(x, y, self.backRect) and #self.nodeStack > 0 then
        self:goBack(); return
    end

    local optY = optAreaY - self.scrollOffset
    for i, resp in ipairs(self.responses) do
        local rowH = OPTION_H + (resp.reqs and HINT_EXTRA or 0)
        if y >= optY and y < optY + rowH and y >= optAreaY and y < optAreaY + optAreaH then
            self:activateResponse(i)
            return
        end
        optY = optY + rowH
    end
end

local instance = nil
function DialogueWindow.getInstance()
    if not instance then
        instance = DialogueWindow:new()
        instance:initialise()
        instance:addToUIManager()
        instance:setVisible(false)
        DialogueWindow._instance = instance
    end
    return instance
end
