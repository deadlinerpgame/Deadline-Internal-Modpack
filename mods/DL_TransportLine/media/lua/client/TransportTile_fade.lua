require "ISUI/ISPanel"

DD_Fader = DD_Fader or ISPanel:derive("DD_Fader")

function DD_Fader:new(pid)
    local w, h = getCore():getScreenWidth(), getCore():getScreenHeight()
    local o = ISPanel.new(self, 0, 0, w, h)
    o:noBackground()
    o.pin       = pid or 0
    o.alpha     = 0
    o.target    = 0
    o.dur       = 0.5
    o._phase    = nil
    o._lastMs   = getTimestampMs and getTimestampMs() or (os.time()*1000)
    o.onMid     = nil
    o.onDone    = nil
    o.active    = false
    o:setAlwaysOnTop(true)
    o.anchorLeft = true; o.anchorRight = true; o.anchorTop = true; o.anchorBottom = true
    return o
end

function DD_Fader:prerender()
    -- keep full-screen
    self:setWidth(getCore():getScreenWidth())
    self:setHeight(getCore():getScreenHeight())

    local now = getTimestampMs and getTimestampMs() or (os.time()*1000)
    local dt  = (now - (self._lastMs or now)) / 1000.0
    self._lastMs = now

    if self.active then
        local step = dt / math.max(self.dur, 0.0001)
        if self.alpha < self.target then
            self.alpha = math.min(self.target, self.alpha + step)
        elseif self.alpha > self.target then
            self.alpha = math.max(self.target, self.alpha - step)
        end

        if self.alpha == self.target then
            if self._phase == "out" and self.onMid then
                local cb = self.onMid; self.onMid = nil
                cb()
            elseif self._phase == "in" then
                self.active = false
                self.alpha  = 0
                self:setVisible(false)
                local cb = self.onDone; self.onDone = nil
                if cb then cb() end
            end
        end
    end

    ISPanel.prerender(self)
end

function DD_Fader:render()
    if self.alpha > 0 then
        self:drawRect(0, 0, self.width, self.height, self.alpha, 0, 0, 0)
    end
end

local function resetTimer(self)
    self._lastMs = getTimestampMs and getTimestampMs() or (os.time()*1000)
end

function DD_Fader:fadeOut(duration, onMid)
    self.dur       = duration or 0.5
    self.onMid     = onMid
    self.target    = 1
    self._phase    = "out"
    self.active    = true
    resetTimer(self)
    self:setVisible(true); self:bringToTop()
end

function DD_Fader:fadeIn(duration, onDone)
    self.dur       = duration or 0.5
    self.onDone    = onDone
    self.target    = 0
    self._phase    = "in"
    self.active    = true
    resetTimer(self)
    self:setVisible(true); self:bringToTop()
end

function DD_Fader:fadeOutIn(dOut, dIn, pid, tox, toy, toz, onMid, onDone)
    self.alpha = 0
    self:fadeOut(dOut or 0.5, function()
        if onMid then
            
        local args = {
        player = pid,
        x = tox,
        y = toy,
        z = toz,

    }

        sendClientCommand("DeadlineTeleport", "requestTileTeleport", args)            
            
        onMid() end
        self:fadeIn(dIn or 0.5, onDone)
    end)
end

local DD_FaderInstance = nil
function DD_GetFader(pid)
    if DD_FaderInstance and DD_FaderInstance.pin == (pid or 0) then return DD_FaderInstance end
    local f = DD_Fader:new(pid)
    f:initialise()
    f:addToUIManager()
    f:setVisible(true)
    DD_FaderInstance = f
    return f
end
