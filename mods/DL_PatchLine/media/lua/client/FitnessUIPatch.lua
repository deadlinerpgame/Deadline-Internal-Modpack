-- media/lua/client/MyFitnessPatch.lua
-- Adds a companion "Daily Limits" panel next to ISFitnessUI and keeps it locked.
-- It shows:
-- 1) Daily Strength Cap: used / cap
-- 2) Daily Fitness  Cap: used / cap
-- 3) Hours Until Strength Cap Reset
-- 4) Hours Until Fitness  Cap Reset

require "ISUI/ISFitnessUI"

-- ========= Daily cap helper (mirrors your CAPS + capFor) =========
local _CAPS = {
    [Perks.Fitness] = {
        {to=1,  cap=750}, {to=2,  cap=1000}, {to=3,  cap=1500}, {to=4,  cap=1800},
        {to=5,  cap=3000}, {to=6,  cap=4300}, {to=7,  cap=7500}, {to=8,  cap=10000},
        {to=9,  cap=15000}, {to=10,  cap=18750},
    },
    [Perks.Strength] = {
        {to=1,  cap=750}, {to=2,  cap=1000}, {to=3,  cap=1500}, {to=4,  cap=1800},
        {to=5,  cap=3000}, {to=6,  cap=4300}, {to=7,  cap=7500}, {to=8,  cap=10000},
        {to=9,  cap=15000}, {to=10,  cap=18750},
    }
}

local function getDailyCap(perk, level)
    local rows = _CAPS[perk]; if not rows then return 0 end
    for _, r in ipairs(rows) do
        if level <= r.to then return r.cap end
    end
    return rows[#rows].cap
end

-- ========= keep originals =========
local _ISFitnessUI_new                 = ISFitnessUI.new
local _ISFitnessUI_addToUIManager      = ISFitnessUI.addToUIManager
local _ISFitnessUI_removeFromUIManager = ISFitnessUI.removeFromUIManager
local _ISFitnessUI_setVisible          = ISFitnessUI.setVisible
local _ISFitnessUI_prerender           = ISFitnessUI.prerender

-- add a slot for our sibling UI per instance
function ISFitnessUI:new(x, y, w, h, player, clickedSquare)
    local o = _ISFitnessUI_new(self, x, y, w, h, player, clickedSquare)
    o._myOtherUI   = nil
    o._otherUILock = { side = "right", dx = 10, dy = 0 } -- where we lock our panel
    -- handles to the four value labels:
    o._dl_lblStrength   = nil
    o._dl_lblFitness    = nil
    o._dl_lblStrReset   = nil
    o._dl_lblFitReset   = nil
    return o
end

-- Create (once) the companion panel + child labels
local function ensureOtherUI(self)
    if self._myOtherUI and self._myOtherUI:isReallyVisible() then return end

    if not self._myOtherUI then
        local w, h = 300, 160
        local x = math.min(self:getRight() + 10, getCore():getScreenWidth() - w)
        local y = self:getY()

        local p = ISPanel:new(x, y, w, h)
        p.backgroundColor = { r=0, g=0, b=0, a=0.6 }
        p.borderColor     = { r=0.8, g=0.8, b=0.8, a=1 }
        p.moveWithMouse   = false
        p.alwaysOnTop     = true
        p:initialise()

        local fontHmed = getTextManager():getFontHeight(UIFont.Medium)
        local fontHsm  = getTextManager():getFontHeight(UIFont.Small)

        -- Title
        local title = ISLabel:new(12, 10, fontHmed, "Daily Limits", 1,1,1,1, UIFont.Medium, true)
        title:initialise(); p:addChild(title)

        -- Static labels (left column)
        local y0 = 10 + fontHmed + 6
        local lineH = fontHsm + 6
        local l1 = ISLabel:new(12, y0 + 0*lineH, fontHsm, "Strength Cap:", 1,1,1,1, UIFont.Small, true)
        local l2 = ISLabel:new(12, y0 + 1*lineH, fontHsm, "Fitness Cap:",  1,1,1,1, UIFont.Small, true)
        local l3 = ISLabel:new(12, y0 + 2*lineH, fontHsm, "Str Reset:",    1,1,1,1, UIFont.Small, true)
        local l4 = ISLabel:new(12, y0 + 3*lineH, fontHsm, "Fit Reset:",    1,1,1,1, UIFont.Small, true)
        l1:initialise(); l2:initialise(); l3:initialise(); l4:initialise()
        p:addChild(l1); p:addChild(l2); p:addChild(l3); p:addChild(l4)

        -- Dynamic value labels (right column)
        local vx = 120
        self._dl_lblStrength = ISLabel:new(vx, y0 + 0*lineH, fontHsm, "-", 1,1,1,1, UIFont.Small, true)
        self._dl_lblFitness  = ISLabel:new(vx, y0 + 1*lineH, fontHsm, "-", 1,1,1,1, UIFont.Small, true)
        self._dl_lblStrReset = ISLabel:new(vx, y0 + 2*lineH, fontHsm, "-", 1,1,1,1, UIFont.Small, true)
        self._dl_lblFitReset = ISLabel:new(vx, y0 + 3*lineH, fontHsm, "-", 1,1,1,1, UIFont.Small, true)
        self._dl_lblStrength:initialise(); self._dl_lblFitness:initialise()
        self._dl_lblStrReset:initialise(); self._dl_lblFitReset:initialise()
        p:addChild(self._dl_lblStrength); p:addChild(self._dl_lblFitness)
        p:addChild(self._dl_lblStrReset); p:addChild(self._dl_lblFitReset)

        self._myOtherUI = p
    end

    if not self._myOtherUI:isReallyVisible() then
        self._myOtherUI:addToUIManager()
       -- self._myOtherUI:setVisible(True)
        self._myOtherUI:bringToTop()
    end
end

-- Position the companion relative to Fitness UI, clamped to screen
local function positionOtherUI(self)
    local ui = self._myOtherUI
    if not (ui and ui:isVisible()) then return end

    local lock  = self._otherUILock or { side="right", dx=10, dy=0 }
    local side  = lock.side or "right"
    local dx    = lock.dx   or 10
    local dy    = lock.dy   or 0

    local w, h  = ui:getWidth(), ui:getHeight()
    local sw, sh = getCore():getScreenWidth(), getCore():getScreenHeight()

    local x, y
    if side == "right" then
        x, y = self:getRight() + dx, self:getY() + dy
    elseif side == "left" then
        x, y = self:getX() - w - dx, self:getY() + dy
    elseif side == "bottom" then
        x, y = self:getX() + dx, self:getBottom() + dy
    else -- "top"
        x, y = self:getX() + dx, self:getY() - h - dy
    end

    x = math.max(0, math.min(x, sw - w))
    y = math.max(0, math.min(y, sh - h))

    if ui:getX() ~= x or ui:getY() ~= y then
        ui:setX(x); ui:setY(y)
    end
end

-- Update the four text values every frame
local function updateDailyLimitsUI(self)
    if not (self._myOtherUI and self._myOtherUI:isVisible()) then return end
    if not (self._dl_lblStrength and self._dl_lblFitness and self._dl_lblStrReset and self._dl_lblFitReset) then return end

    local player = self.player
    if not player then return end
    local modData = player:getModData() or {}

    local usedStr = tonumber(modData.xpCooldown_strength_xp)      or 0
    local usedFit = tonumber(modData.xpCooldown_fitness_xp)       or 0
    local tsStr   = tonumber(modData.xpCooldown_strength_timestamp) or -9000
    local tsFit   = tonumber(modData.xpCooldown_fitness_timestamp)  or -9000

    local lvlStr  = player:getPerkLevel(Perks.Strength)
    local lvlFit  = player:getPerkLevel(Perks.Fitness)
    local capStr  = getDailyCap(Perks.Strength, lvlStr)
    local capFit  = getDailyCap(Perks.Fitness,  lvlFit)

    -- 1) & 2) used / cap
    local function fmtUsedCap(used, cap)
        -- keep within [0..cap] for display; cap can be 0 if something is wrong
        if cap <= 0 then return tostring(math.floor(used + 0.5)) .. " / 0" end
        local u = math.max(0, math.min(used, cap))
        return tostring(math.floor(u + 0.5)) .. " / " .. tostring(cap)
    end
    self._dl_lblStrength:setName(fmtUsedCap(usedStr, capStr))
    self._dl_lblFitness:setName(fmtUsedCap(usedFit, capFit))

    -- 3) & 4) hours until reset
    local now = getGameTime():getWorldAgeHours()
    local RESET = 170
    local function fmtRemaining(ts)
        local elapsed = now - (ts or 0)
        local remain = RESET - elapsed
        if remain <= 0 or ts <= -1 then return "Ready" end
        -- round down to whole hours (ingame hours)
        local hrs = math.floor(remain)
        return tostring(hrs) .. " Ingame Hours"
    end
    self._dl_lblStrReset:setName(fmtRemaining(tsStr))
    self._dl_lblFitReset:setName(fmtRemaining(tsFit))
end

-- when Fitness UI is added, spawn + place our companion
function ISFitnessUI:addToUIManager()
    _ISFitnessUI_addToUIManager(self)
    ensureOtherUI(self)
    positionOtherUI(self)
end

-- keep visibility in sync
function ISFitnessUI:setVisible(bVisible)
    _ISFitnessUI_setVisible(self, bVisible)
    if bVisible then
        ensureOtherUI(self)
        positionOtherUI(self)
        if self._myOtherUI then self._myOtherUI:bringToTop() end
    else
        if self._myOtherUI then
            self._myOtherUI:setVisible(false)
        end
    end
end

-- tear everything down on close (covers all close paths)
function ISFitnessUI:removeFromUIManager()
    if self._myOtherUI then
        self._myOtherUI:removeFromUIManager()
        self._myOtherUI = nil
        self._dl_lblStrength = nil
        self._dl_lblFitness  = nil
        self._dl_lblStrReset = nil
        self._dl_lblFitReset = nil
    end
    _ISFitnessUI_removeFromUIManager(self)
end

-- lock position + update values every frame the Fitness UI renders
function ISFitnessUI:prerender()
    _ISFitnessUI_prerender(self)
    positionOtherUI(self)
    updateDailyLimitsUI(self)
end

-- OPTIONAL: change where it locks at runtime, e.g.:
-- ISFitnessUI.instance[1]._otherUILock = { side="left", dx=8, dy=0 }
