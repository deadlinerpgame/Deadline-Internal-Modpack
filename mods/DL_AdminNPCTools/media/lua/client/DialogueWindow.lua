
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
function DialogueWindow:new()
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local o  = ISPanel.new(self, math.floor((sw - W) / 2), math.floor((sh - H) / 2), W, H)
    o.moveWithMouse = true
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
    return o
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
            if ok and tex then
                self.portrait = tex
                break
            end
        end
    end

    self:goToNode(self.rootId)
    self.fadeAlpha = 0
    self.fadeDir   = 1
    self:setVisible(true)
end
function DialogueWindow:endSession()
    if not self.active then return end
    self.active = false
    if self.zoneId then
        sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "EndSession", { zoneId = self.zoneId })
    end
    self:setVisible(false)
end
function DialogueWindow:goToNode(nodeId)
    local node = self.nodes[nodeId]
    if not node then return end
    if self.currentNodeId then
        table.insert(self.nodeStack, self.currentNodeId)
    end
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
        if self.fadeDir == -1 then self:setVisible(false) end
    end
end
function DialogueWindow:prerender()
    local a    = self.fadeAlpha
    local fSm  = UIFont.Small
    local fMed = UIFont.Medium
    local fTny = UIFont.Tiny
    local lhSm = getTextManager():getFontHeight(fSm) + 2
    local lhMd = getTextManager():getFontHeight(fMed)
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
        self:drawRect(px,                    py,                    PORTRAIT_SZ, 1, a, 0.3, 0.3, 0.3)
        self:drawRect(px,                    py + PORTRAIT_SZ - 1,  PORTRAIT_SZ, 1, a, 0.3, 0.3, 0.3)
        local xFont = UIFont.Large
        local xW    = getTextManager():MeasureStringX(xFont, "X")
        local xH    = getTextManager():getFontHeight(xFont)
        self:drawText("X",
            math.floor(px + (PORTRAIT_SZ - xW) / 2),
            math.floor(py + (PORTRAIT_SZ - xH) / 2),
            0.35, 0.35, 0.35, a, xFont)
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
            if isGreyed then
                r, g, b = 0.5, 0.5, 0.5
            elseif isReject then
                r, g, b = 0.7, 0.4, 0.3
            elseif hovered then
                r, g, b = 1, 1, 0.6
            else
                r, g, b = 0.9, 0.9, 0.9
            end
            self:drawText("> " .. resp.label, PAD + 4, optY + 3, r, g, b, a, fSm)

            if hasReqs then
                local reqY = optY + OPTION_H - 2
                local prefix    = "[ Requirements : "
                local suffix    = " ]"
                local tm        = getTextManager()
                local prefixW   = tm:MeasureStringX(fTny, prefix)
                self:drawText(prefix, PAD + 4, reqY, 0.55, 0.55, 0.55, a, fTny)
                local rx = PAD + 4 + prefixW
                for ri2, req in ipairs(resp.reqs) do
                    local col_r, col_g, col_b
                    if req.met then
                        col_r, col_g, col_b = 0.7, 0.9, 0.7   
                    else
                        col_r, col_g, col_b = 0.9, 0.35, 0.35  
                    end
                    local reqText = req.label
                    if ri2 < #resp.reqs then reqText = reqText .. "  ·  " end
                    self:drawText(reqText, rx, reqY, col_r, col_g, col_b, a, fTny)
                    rx = rx + tm:MeasureStringX(fTny, reqText)
                end
                self:drawText(suffix, rx, reqY, 0.55, 0.55, 0.55, a, fTny)
            end
        end
        optY = optY + rowH
    end

    self.maxScroll = math.max(0, totalH - optAreaH)
    self:clearStencilRect()
    if self.maxScroll > 0 then
        local sbX    = W - 6
        local sbH    = optAreaH
        local thumbH = math.max(16, sbH * (optAreaH / totalH))
        local thumbY = optAreaY + (self.scrollOffset / self.maxScroll) * (sbH - thumbH)
        self:drawRect(sbX, optAreaY, 4, sbH,    0.2, 0.2, 0.2, a)
        self:drawRect(sbX, thumbY,   4, thumbH, 0.6, 0.6, 0.6, a)
    end
    local footerY = H - HEADER_H
    self:drawRect(PAD, footerY, W - PAD * 2, 1, 0.4, 0.4, 0.4, a)
    footerY = footerY + 6
    if #self.nodeStack > 0 then
        self:drawText("[Back]",      PAD,      footerY, 0.8, 0.8, 0.5, a, fTny)
        self:drawText("[ESC] Close", PAD + 46, footerY, 0.5, 0.5, 0.5, a, fTny)
    else
        self:drawText("[ESC] Close", PAD, footerY, 0.5, 0.5, 0.5, a, fTny)
    end
end
function DialogueWindow:onMouseMove(dx, dy)
    local fSm      = UIFont.Small
    local lhSm     = getTextManager():getFontHeight(fSm) + 2
    local optAreaY = self.optAreaY or 0
    local optAreaH = H - optAreaY - HEADER_H - PAD
    local mx, my   = self:getMouseX(), self:getMouseY()

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

    local footerY = H - HEADER_H + 6
    self.hoveredBack = (#self.nodeStack > 0
        and mx >= PAD and mx <= PAD + 40
        and my >= footerY and my <= footerY + lhSm)
end

function DialogueWindow:onMouseWheel(del)
    self.scrollOffset = math.max(0, math.min(self.maxScroll, self.scrollOffset - del * 20))
    return true
end

function DialogueWindow:onMouseDown(x, y)
    local optAreaY = self.optAreaY or 0
    local optAreaH = H - optAreaY - HEADER_H - PAD
    local footerY  = H - HEADER_H + 6
    local fSm      = UIFont.Small
    local lhSm     = getTextManager():getFontHeight(fSm) + 2
    if #self.nodeStack > 0
       and x >= PAD and x <= PAD + 40
       and y >= footerY and y <= footerY + lhSm then
        self:goBack(); return
    end
    local optY = optAreaY - self.scrollOffset
    for i, resp in ipairs(self.responses) do
        local rowH = OPTION_H + (resp.reqs and HINT_EXTRA or 0)
        if y >= optY and y < optY + rowH and y >= optAreaY and y < optAreaY + optAreaH then
            if resp.state == "normal" then
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
            return
        end
        optY = optY + rowH
    end
end

function DialogueWindow:onKeyPressed(key)
    if key == Keyboard.KEY_ESCAPE then self:endSession() end
end
local instance = nil
function DialogueWindow.getInstance()
    if not instance then
        instance = DialogueWindow:new()
        instance:initialise()
        instance:addToUIManager()
        instance:setVisible(false)
    end
    return instance
end
