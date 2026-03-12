require "NPCDialogueShared"
require "ISUI/ISUIElement"
require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISComboBox"
require "ISUI/ISLabel"

AdminEditorWindow = ISPanel:derive("AdminEditorWindow")

local W         = 860
local H         = 580
local PAD       = 8
local HEADER_H  = 28
local FOOTER_H  = 30
local LEFT_W    = 170
local RIGHT_W   = 180
local CENTER_X  = LEFT_W + 1
local CENTER_W  = W - LEFT_W - RIGHT_W - 2
local CONTENT_Y = HEADER_H
local CONTENT_H = H - HEADER_H - FOOTER_H
local INPUT_H   = 20
local BTN_H     = 22
local BTN_W     = 70
local NODE_ROW_H = 38

local FAIL_OPTIONS = { "hide", "grey" }
local COND_TYPES   = { "item", "skill", "occupation", "talked" }
local AND_OR       = { "AND", "OR" }

local function makeId(tree)
    local n = 0
    for _ in pairs(tree.nodes) do n = n + 1 end
    return string.format("%03d", n)
end

local function deepCopyTree(src)
    if type(src) ~= "table" then return src end
    local copy = {}
    for k, v in pairs(src) do copy[k] = deepCopyTree(v) end
    return copy
end

function AdminEditorWindow:new()
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local o  = ISPanel.new(self,
        math.floor((sw - W) / 2),
        math.floor((sh - H) / 2),
        W, H)
    o.moveWithMouse  = true
    o.zone           = nil
    o.workingTree    = nil
    o.selectedNodeId = nil
    o.unsaved        = false
    o.widgets        = {}
    return o
end

function AdminEditorWindow:initialise()
    ISPanel.initialise(self)
    self:buildStaticButtons()
end

function AdminEditorWindow:openForZone(zone)
    self.zone        = zone
    self.workingTree = deepCopyTree(zone.dialogueTree) or { nodes = {}, nodeOrder = {} }
    if not self.workingTree.nodes     then self.workingTree.nodes     = {} end
    if not self.workingTree.nodeOrder then self.workingTree.nodeOrder = {} end
    self.selectedNodeId = self.workingTree.nodeOrder[1] or nil
    self.unsaved        = false
    self:rebuildWidgets()
    self:setVisible(true)
end

function AdminEditorWindow:buildStaticButtons()
    self.btnSave = ISButton:new(W - PAD - BTN_W*2 - 4, 4, BTN_W, BTN_H, "Save", self, AdminEditorWindow.onSave)
    self.btnSave:initialise(); self.btnSave:instantiate(); self:addChild(self.btnSave)

    self.btnDiscard = ISButton:new(W - PAD - BTN_W, 4, BTN_W, BTN_H, "Discard", self, AdminEditorWindow.onDiscard)
    self.btnDiscard:initialise(); self.btnDiscard:instantiate(); self:addChild(self.btnDiscard)

    self.btnClose = ISButton:new(W - PAD - BTN_W, H - FOOTER_H + 4, BTN_W, BTN_H, "Close", self, AdminEditorWindow.onClose)
    self.btnClose:initialise(); self.btnClose:instantiate(); self:addChild(self.btnClose)
end

function AdminEditorWindow:rebuildWidgets()
    for _, w in ipairs(self.widgets) do self:removeChild(w) end
    self.widgets = {}
    if not self.zone then return end
    local tree = self.workingTree

    local lx = PAD
    local ly = CONTENT_Y + PAD + 16

    ly = ly + 14
    self.entryName = ISTextEntryBox:new(self.zone.name or "", lx, ly, LEFT_W - PAD*2, INPUT_H)
    self.entryName:initialise(); self.entryName:instantiate(); self:addChild(self.entryName)
    self.widgets[#self.widgets+1] = self.entryName
    ly = ly + INPUT_H + PAD

    ly = ly + 14
    self.entryPortrait = ISTextEntryBox:new(self.zone.portrait or "", lx, ly, LEFT_W - PAD*2, INPUT_H)
    self.entryPortrait:initialise(); self.entryPortrait:instantiate(); self:addChild(self.entryPortrait)
    self.widgets[#self.widgets+1] = self.entryPortrait
    ly = ly + INPUT_H + PAD

    ly = ly + 14
    self.entryRadius = ISTextEntryBox:new(tostring(self.zone.radius or 2), lx, ly, LEFT_W - PAD*2, INPUT_H)
    self.entryRadius:initialise(); self.entryRadius:instantiate(); self:addChild(self.entryRadius)
    self.widgets[#self.widgets+1] = self.entryRadius
    ly = ly + INPUT_H + PAD * 2

    local btnAddNode = ISButton:new(lx, ly, LEFT_W - PAD*2, BTN_H, "+ Add Node", self, AdminEditorWindow.onAddNode)
    btnAddNode:initialise(); btnAddNode:instantiate(); self:addChild(btnAddNode)
    self.widgets[#self.widgets+1] = btnAddNode
    ly = ly + BTN_H + PAD

    if self.selectedNodeId and #tree.nodeOrder > 1 then
        local btnDelNode = ISButton:new(lx, ly, LEFT_W - PAD*2, BTN_H, "- Delete Node", self, AdminEditorWindow.onDeleteNode)
        btnDelNode:initialise(); btnDelNode:instantiate(); self:addChild(btnDelNode)
        self.widgets[#self.widgets+1] = btnDelNode
    end

    local rx = W - RIGHT_W + PAD
    local ry = CONTENT_Y + PAD + 16

    self.nodeButtons = {}
    for idx, nid in ipairs(tree.nodeOrder) do
        local node   = tree.nodes[nid]
        local label  = nid .. (node.editorName ~= "" and (" " .. node.editorName) or "")
        if idx == 1 then label = label .. " [R]" end
        local btn = ISButton:new(rx, ry, RIGHT_W - PAD*2, NODE_ROW_H - 4, label, self, AdminEditorWindow.onSelectNode)
        btn.nodeId = nid
        btn:initialise(); btn:instantiate(); self:addChild(btn)
        self.widgets[#self.widgets+1] = btn
        self.nodeButtons[#self.nodeButtons+1] = btn
        ry = ry + NODE_ROW_H
    end

    if not self.selectedNodeId then return end
    local node = tree.nodes[self.selectedNodeId]
    if not node then return end

    local cx = CENTER_X + PAD
    local cy = CONTENT_Y + PAD + 14 + 4

    cy = cy + 14
    self.entryNodeName = ISTextEntryBox:new(node.editorName or "", cx, cy, CENTER_W - PAD*2, INPUT_H)
    self.entryNodeName:initialise(); self.entryNodeName:instantiate(); self:addChild(self.entryNodeName)
    self.widgets[#self.widgets+1] = self.entryNodeName
    cy = cy + INPUT_H + PAD

    cy = cy + 14
    local taH = 56
    self.entryNpcText = ISTextEntryBox:new(node.npcText or "", cx, cy, CENTER_W - PAD*2, taH)
    self.entryNpcText:initialise(); self.entryNpcText:instantiate(); self:addChild(self.entryNpcText)
    self.widgets[#self.widgets+1] = self.entryNpcText
    cy = cy + taH + PAD

    local leadsToOptions = { "(end)" }
    for _, nid in ipairs(tree.nodeOrder) do
        leadsToOptions[#leadsToOptions+1] = nid
    end

    self.responseWidgets = {}
    for ri, resp in ipairs(node.responses) do
        if not resp.conditions    then resp.conditions    = {} end
        if not resp.conditionMode then resp.conditionMode = "AND" end
        if not resp.conditionFail then resp.conditionFail = "hide" end

        local rEntry = {}
        local fullW  = CENTER_W - PAD*2

        
        local labelEntry = ISTextEntryBox:new(resp.label or "", cx, cy, fullW - 80, INPUT_H)
        labelEntry:initialise(); labelEntry:instantiate(); self:addChild(labelEntry)
        self.widgets[#self.widgets+1] = labelEntry
        rEntry.labelEntry = labelEntry

        local btnDel = ISButton:new(cx + fullW - 76, cy, 74, INPUT_H, "- Remove", self, AdminEditorWindow.onDeleteResponse)
        btnDel.respIdx = ri
        btnDel:initialise(); btnDel:instantiate(); self:addChild(btnDel)
        self.widgets[#self.widgets+1] = btnDel
        cy = cy + INPUT_H + 2

        
        local halfW = math.floor((fullW - 4) / 2)

        local leadsCombo = ISComboBox:new(cx, cy, halfW, INPUT_H, self, nil)
        leadsCombo:initialise(); leadsCombo:instantiate()
        for _, opt in ipairs(leadsToOptions) do leadsCombo:addOption(opt) end
        local selIdx = 1
        if resp.leadsTo then
            for oi, opt in ipairs(leadsToOptions) do
                if opt == resp.leadsTo then selIdx = oi; break end
            end
        end
        leadsCombo.selected = selIdx
        self:addChild(leadsCombo)
        self.widgets[#self.widgets+1] = leadsCombo
        rEntry.leadsToCombo = leadsCombo

        local failCombo = ISComboBox:new(cx + halfW + 4, cy, halfW, INPUT_H, self, nil)
        failCombo:initialise(); failCombo:instantiate()
        for _, opt in ipairs(FAIL_OPTIONS) do failCombo:addOption(opt) end
        local failIdx = 1
        for fi, opt in ipairs(FAIL_OPTIONS) do
            if opt == resp.conditionFail then failIdx = fi; break end
        end
        failCombo.selected = failIdx
        self:addChild(failCombo)
        self.widgets[#self.widgets+1] = failCombo
        rEntry.failCombo = failCombo
        cy = cy + INPUT_H + 2

        
        if #resp.conditions >= 2 then
            local andOrCombo = ISComboBox:new(cx, cy, 80, INPUT_H, self, nil)
            andOrCombo:initialise(); andOrCombo:instantiate()
            for _, opt in ipairs(AND_OR) do andOrCombo:addOption(opt) end
            andOrCombo.selected = (resp.conditionMode == "OR") and 2 or 1
            self:addChild(andOrCombo)
            self.widgets[#self.widgets+1] = andOrCombo
            rEntry.andOrCombo = andOrCombo
            cy = cy + INPUT_H + 2
        end

        
        rEntry.conditionWidgets = {}
        for ci, cond in ipairs(resp.conditions) do
            local cEntry = {}

            local typeCombo = ISComboBox:new(cx, cy, 100, INPUT_H, self, nil)
            typeCombo:initialise(); typeCombo:instantiate()
            for _, opt in ipairs(COND_TYPES) do typeCombo:addOption(opt) end
            local typeIdx = 1
            for ti, opt in ipairs(COND_TYPES) do
                if opt == cond.type then typeIdx = ti; break end
            end
            typeCombo.selected     = typeIdx
            typeCombo.lastSelected = typeIdx
            typeCombo.respIdx      = ri
            typeCombo.condIdx      = ci
            self:addChild(typeCombo)
            self.widgets[#self.widgets+1] = typeCombo
            cEntry.typeCombo = typeCombo

            local btnDelCond = ISButton:new(cx + fullW - 74, cy, 74, INPUT_H, "- Cond", self, AdminEditorWindow.onDeleteCondition)
            btnDelCond.respIdx = ri
            btnDelCond.condIdx = ci
            btnDelCond:initialise(); btnDelCond:instantiate(); self:addChild(btnDelCond)
            self.widgets[#self.widgets+1] = btnDelCond
            cy = cy + INPUT_H + 2

            if cond.type == "item" then
                local itemEntry = ISTextEntryBox:new(cond.itemName or "", cx, cy, fullW - 54, INPUT_H)
                itemEntry:initialise(); itemEntry:instantiate(); self:addChild(itemEntry)
                self.widgets[#self.widgets+1] = itemEntry
                cEntry.itemEntry = itemEntry

                local amountEntry = ISTextEntryBox:new(tostring(cond.amount or 1), cx + fullW - 50, cy, 50, INPUT_H)
                amountEntry:initialise(); amountEntry:instantiate(); self:addChild(amountEntry)
                self.widgets[#self.widgets+1] = amountEntry
                cEntry.amountEntry = amountEntry
                cy = cy + INPUT_H + 2

            elseif cond.type == "skill" then
                local skillCombo = ISComboBox:new(cx, cy, fullW - 54, INPUT_H, self, nil)
                skillCombo:initialise(); skillCombo:instantiate()
                for _, s in ipairs(NPCDialogue.SKILLS) do skillCombo:addOption(s) end
                local skillIdx = 1
                for si, s in ipairs(NPCDialogue.SKILLS) do
                    if s == cond.skill then skillIdx = si; break end
                end
                skillCombo.selected = skillIdx
                self:addChild(skillCombo)
                self.widgets[#self.widgets+1] = skillCombo
                cEntry.skillCombo = skillCombo

                local lvlEntry = ISTextEntryBox:new(tostring(cond.level or 1), cx + fullW - 50, cy, 50, INPUT_H)
                lvlEntry:initialise(); lvlEntry:instantiate(); self:addChild(lvlEntry)
                self.widgets[#self.widgets+1] = lvlEntry
                cEntry.levelEntry = lvlEntry
                cy = cy + INPUT_H + 2

            elseif cond.type == "occupation" then
                local occEntry = ISTextEntryBox:new(cond.occupation or "", cx, cy, fullW, INPUT_H)
                occEntry:initialise(); occEntry:instantiate(); self:addChild(occEntry)
                self.widgets[#self.widgets+1] = occEntry
                cEntry.occupationEntry = occEntry
                cy = cy + INPUT_H + 2
            end
            

            rEntry.conditionWidgets[ci] = cEntry
        end

        
        local btnAddCond = ISButton:new(cx, cy, 130, BTN_H, "+ Add Condition", self, AdminEditorWindow.onAddCondition)
        btnAddCond.respIdx = ri
        btnAddCond:initialise(); btnAddCond:instantiate(); self:addChild(btnAddCond)
        self.widgets[#self.widgets+1] = btnAddCond
        cy = cy + BTN_H + PAD

        self.responseWidgets[ri] = rEntry
    end

    local btnAddResp = ISButton:new(cx, cy, 120, BTN_H, "+ Add Response", self, AdminEditorWindow.onAddResponse)
    btnAddResp:initialise(); btnAddResp:instantiate(); self:addChild(btnAddResp)
    self.widgets[#self.widgets+1] = btnAddResp
end

function AdminEditorWindow:flushEdits()
    if not self.zone then return end
    local tree = self.workingTree

    if self.entryName     then self.zone.name    = self.entryName:getText() end
    if self.entryPortrait then self.zone.portrait = self.entryPortrait:getText() end
    if self.entryRadius   then
        local r = tonumber(self.entryRadius:getText())
        if r then self.zone.radius = r end
    end

    if self.selectedNodeId then
        local node = tree.nodes[self.selectedNodeId]
        if node then
            if self.entryNodeName then node.editorName = self.entryNodeName:getText() end
            if self.entryNpcText  then node.npcText    = self.entryNpcText:getText()  end

            for ri, rw in ipairs(self.responseWidgets or {}) do
                local resp = node.responses[ri]
                if resp then
                    if rw.labelEntry then resp.label = rw.labelEntry:getText() end

                    if rw.leadsToCombo then
                        local opt = rw.leadsToCombo:getOptionText(rw.leadsToCombo.selected)
                        resp.leadsTo = (opt == "(end)") and nil or opt
                    end

                    if rw.failCombo then
                        resp.conditionFail = rw.failCombo:getOptionText(rw.failCombo.selected)
                    end

                    if rw.andOrCombo then
                        resp.conditionMode = rw.andOrCombo:getOptionText(rw.andOrCombo.selected)
                    end

                    for ci, cw in ipairs(rw.conditionWidgets or {}) do
                        local cond = resp.conditions[ci]
                        if cond and cw.typeCombo then
                            cond.type = cw.typeCombo:getOptionText(cw.typeCombo.selected)
                            if cw.itemEntry   then cond.itemName = cw.itemEntry:getText() end
                            if cw.amountEntry then cond.amount   = tonumber(cw.amountEntry:getText()) or 1 end
                            
                            if cw.skillCombo      then cond.skill      = cw.skillCombo:getOptionText(cw.skillCombo.selected) end
                            if cw.levelEntry      then cond.level      = tonumber(cw.levelEntry:getText()) or 1 end
                            if cw.occupationEntry then cond.occupation = cw.occupationEntry:getText() end
                        end
                    end
                end
            end
        end
    end
end

function AdminEditorWindow:onSelectNode(btn)
    self:flushEdits()
    self.selectedNodeId = btn.nodeId
    self:rebuildWidgets()
end

function AdminEditorWindow:onAddNode()
    self:flushEdits()
    local tree  = self.workingTree
    local newId = makeId(tree)
    tree.nodes[newId] = { id = newId, editorName = "", npcText = "", responses = {} }
    tree.nodeOrder[#tree.nodeOrder+1] = newId
    self.selectedNodeId = newId
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onDeleteNode()
    self:flushEdits()
    local tree  = self.workingTree
    local delId = self.selectedNodeId
    if not delId then return end
    local newOrder = {}
    for _, nid in ipairs(tree.nodeOrder) do
        if nid ~= delId then newOrder[#newOrder+1] = nid end
    end
    tree.nodeOrder = newOrder
    tree.nodes[delId] = nil
    for _, node in pairs(tree.nodes) do
        for _, resp in ipairs(node.responses) do
            if resp.leadsTo == delId then resp.leadsTo = nil end
        end
    end
    self.selectedNodeId = tree.nodeOrder[1] or nil
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onAddResponse()
    self:flushEdits()
    if not self.selectedNodeId then return end
    local node = self.workingTree.nodes[self.selectedNodeId]
    if not node then return end
    node.responses[#node.responses+1] = {
        label          = "New response",
        leadsTo        = nil,
        state          = "normal",
        conditions     = {},
        conditionMode  = "AND",
        conditionFail  = "hide",
    }
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onDeleteResponse(btn)
    self:flushEdits()
    if not self.selectedNodeId then return end
    local node = self.workingTree.nodes[self.selectedNodeId]
    if not node then return end
    table.remove(node.responses, btn.respIdx)
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onToggleConsume(btn)
    self:flushEdits()
    if not self.selectedNodeId then return end
    local node = self.workingTree.nodes[self.selectedNodeId]
    if not node then return end
    local resp = node.responses[btn.respIdx]
    if not resp or not resp.conditions then return end
    local cond = resp.conditions[btn.condIdx]
    if not cond then return end
    cond.consume = not cond.consume
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onAddCondition(btn)
    self:flushEdits()
    if not self.selectedNodeId then return end
    local node = self.workingTree.nodes[self.selectedNodeId]
    if not node then return end
    local resp = node.responses[btn.respIdx]
    if not resp then return end
    if not resp.conditions then resp.conditions = {} end
    resp.conditions[#resp.conditions+1] = { type = "item", itemName = "" }
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onDeleteCondition(btn)
    self:flushEdits()
    if not self.selectedNodeId then return end
    local node = self.workingTree.nodes[self.selectedNodeId]
    if not node then return end
    local resp = node.responses[btn.respIdx]
    if not resp or not resp.conditions then return end
    table.remove(resp.conditions, btn.condIdx)
    self.unsaved = true
    self:rebuildWidgets()
end

function AdminEditorWindow:onSave()
    self:flushEdits()
    local zone = self.zone
    if not zone then return end

    zone.dialogueTree = deepCopyTree(self.workingTree)

    local cell = getCell()
    if not cell then return end
    local sq = cell:getGridSquare(zone.x, zone.y, zone.z)
    if not sq then return end

    sq:getModData()["NPCDialogueZone"] = zone
    if sq.transmitModData then
        sq:transmitModData()
    elseif sq.transmitModdata then
        sq:transmitModdata()
    end

    ModData.request(NPCDialogue.MODDATA_KEY)
    local modTable = ModData.getOrCreate(NPCDialogue.MODDATA_KEY)
    if not modTable.zones then modTable.zones = {} end
    modTable.zones[zone.id] = { id = zone.id, x = zone.x, y = zone.y, z = zone.z }
    ModData.add(NPCDialogue.MODDATA_KEY, modTable)
    ModData.transmit(NPCDialogue.MODDATA_KEY)
    ModData.request(NPCDialogue.MODDATA_KEY)

    sendClientCommand(getSpecificPlayer(0), "NPCDialogue", "UpdateZone", { zone = zone })

    self.unsaved = false
    print("[NPCDialogue EDITOR] Saved zone: " .. tostring(zone.id))
end

function AdminEditorWindow:onDiscard()
    if not self.zone then return end
    self.workingTree = deepCopyTree(self.zone.dialogueTree) or { nodes = {}, nodeOrder = {} }
    if not self.workingTree.nodes     then self.workingTree.nodes     = {} end
    if not self.workingTree.nodeOrder then self.workingTree.nodeOrder = {} end
    self.selectedNodeId = self.workingTree.nodeOrder[1] or nil
    self.unsaved        = false
    self:rebuildWidgets()
end

function AdminEditorWindow:onClose()
    self:setVisible(false)
end

function AdminEditorWindow:onMouseUp(x, y)
    
    if not self.selectedNodeId then return end
    local node = self.workingTree and self.workingTree.nodes[self.selectedNodeId]
    if not node then return end
    for ri, rw in ipairs(self.responseWidgets or {}) do
        local resp = node.responses[ri]
        if resp then
            for ci, cw in ipairs(rw.conditionWidgets or {}) do
                if cw.typeCombo and cw.typeCombo.selected ~= cw.typeCombo.lastSelected then
                    local newType = COND_TYPES[cw.typeCombo.selected] or "item"
                    self:flushEdits()
                    local cond = node.responses[ri] and node.responses[ri].conditions and node.responses[ri].conditions[ci]
                    if cond then
                        cond.type       = newType
                        cond.itemName   = nil
                        cond.skill      = nil
                        cond.level      = nil
                        cond.occupation = nil
                    end
                    self.unsaved = true
                    self:rebuildWidgets()
                    return
                end
            end
        end
    end
end

function AdminEditorWindow:onKeyPressed(key)
    if key == Keyboard.KEY_ESCAPE then self:onClose() end
end

function AdminEditorWindow:prerender()
    self:drawRect(0, 0, W, H, 1, 0, 0, 0)
    self:drawRectBorder(0, 0, W, H, 1, 0.5, 0.5, 0.5)

    local fSm  = UIFont.Small
    local fMed = UIFont.Medium
    local fTny = UIFont.Tiny
    local lhSm = getTextManager():getFontHeight(fSm) + 2
    local lhTy = getTextManager():getFontHeight(fTny) + 2

    local title = "NPC Editor" .. (self.unsaved and "  *" or "")
    self:drawText(title, PAD, 6, 1, 1, 1, 1, fMed)
    self:drawRect(0, HEADER_H - 1, W, 1, 0.5, 0.5, 0.5, 1)
    self:drawRect(LEFT_W,          CONTENT_Y, 1, CONTENT_H, 0.4, 0.4, 0.4, 1)
    self:drawRect(W - RIGHT_W - 1, CONTENT_Y, 1, CONTENT_H, 0.4, 0.4, 0.4, 1)
    self:drawRect(0, H - FOOTER_H, W, 1, 0.5, 0.5, 0.5, 1)
    if self.unsaved then
        self:drawText("* Unsaved changes", PAD, H - FOOTER_H + 7, 1, 0.8, 0.3, 1, fSm)
    end

    local lx = PAD
    local ly = CONTENT_Y + PAD
    self:drawText("NPC SETTINGS", lx, ly, 0.6, 0.6, 0.6, 1, fTny)
    ly = ly + lhTy + 4
    self:drawText("Name:",         lx, ly, 0.8, 0.8, 0.8, 1, fSm); ly = ly + lhSm + INPUT_H + PAD
    self:drawText("Portrait name:", lx, ly, 0.8, 0.8, 0.8, 1, fSm); ly = ly + lhSm + INPUT_H + PAD
    self:drawText("Radius:",        lx, ly, 0.8, 0.8, 0.8, 1, fSm)

    
    self:drawText("DIALOGUE TREE", W - RIGHT_W + PAD, CONTENT_Y + PAD, 0.6, 0.6, 0.6, 1, fTny)

    
    for _, rw in ipairs(self.responseWidgets or {}) do
        for _, cw in ipairs(rw.conditionWidgets or {}) do
            if cw.amountEntry then
                self:drawText("qty", cw.amountEntry:getX(), cw.amountEntry:getY() - lhTy, 0.5, 0.5, 0.5, 1, fTny)
            end
        end
    end

    
    if self.selectedNodeId then
        local cx   = CENTER_X + PAD
        local cy   = CONTENT_Y + PAD
        local tree = self.workingTree
        local node = tree and tree.nodes[self.selectedNodeId]
        if node then
            local isRoot = tree.nodeOrder[1] == self.selectedNodeId
            self:drawText("NODE " .. self.selectedNodeId .. (isRoot and "  [ROOT]" or ""), cx, cy, 1, 1, 1, 1, fSm)
            cy = cy + lhSm + 2
            self:drawText("Editor label:", cx, cy, 0.6, 0.6, 0.6, 1, fTny)
            cy = cy + lhTy + INPUT_H + PAD
            self:drawText("NPC Text:", cx, cy, 0.6, 0.6, 0.6, 1, fTny)
            cy = cy + lhTy + 56 + PAD
            self:drawRect(cx, cy, CENTER_W - PAD*2, 1, 0.35, 0.35, 0.35, 1)
            cy = cy + 4
            self:drawText("RESPONSES  (label | goes to | if fail:)", cx, cy, 0.6, 0.6, 0.6, 1, fTny)
        end
    else
        self:drawText("No node selected.", CENTER_X + PAD, CONTENT_Y + PAD, 0.5, 0.5, 0.5, 1, fSm)
    end
end


local instance = nil
function AdminEditorWindow.getInstance()
    if not instance then
        instance = AdminEditorWindow:new()
        instance:initialise()
        instance:addToUIManager()
        instance:setVisible(false)
    end
    return instance
end
