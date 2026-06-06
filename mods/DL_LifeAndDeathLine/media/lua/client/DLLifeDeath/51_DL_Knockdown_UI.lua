DL = DL or {}
DL.Knockdown = DL.Knockdown or {}
local K = DL.Knockdown

if ISPanel == nil then
    DL.warn("knockdown UI: ISPanel not found; overlay not installed")
    return
end

local DLKnockPanel = ISPanel:derive("DLKnockPanel")

function DLKnockPanel:new()
    local w = 340
    local h = 136
    local x = (getCore():getScreenWidth() - w) / 2
    local y = getCore():getScreenHeight() * 0.70
    local o = ISPanel:new(x, y, w, h)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.0 }
    o.borderColor     = { r = 0, g = 0, b = 0, a = 0.0 }
    o.moveWithMouse   = false
    return o
end

function DLKnockPanel:createChildren()
    local bw, bh = 130, 26
    self.giveUpBtn = ISButton:new((self.width - bw) / 2, self.height - bh - 8, bw, bh,
        "Give Up", self, DLKnockPanel.onGiveUp)
    self.giveUpBtn:initialise()
    self.giveUpBtn:instantiate()
    self.giveUpBtn.backgroundColor          = { r = 0.40, g = 0.06, b = 0.06, a = 0.85 }
    self.giveUpBtn.backgroundColorMouseOver = { r = 0.65, g = 0.10, b = 0.10, a = 0.95 }
    self:addChild(self.giveUpBtn)
end

function DLKnockPanel:onGiveUp()
    local p = getPlayer()
    if p and p:getModData().dl_downed and DL.Knockdown.realDeath then
        DL.Knockdown.realDeath(p)
    end
end

function DLKnockPanel:render()
    self:drawRect(0, 0, self.width, self.height, 0.55, 0.0, 0.0, 0.0)
    self:drawRectBorder(0, 0, self.width, self.height, 0.7, 0.45, 0.08, 0.08)

    self:drawTextCentre("YOU ARE DOWN", self.width / 2, 7, 0.92, 0.22, 0.22, 1, UIFont.Medium)

    local p = getPlayer()
    local md = p and p:getModData()
    local remainMs = 0
    if md and md.dl_downedStart then
        local dur = ((DL.Config and DL.Config.knockdownDurationSec) or 120) * 1000
        remainMs = dur - (getTimestampMs() - md.dl_downedStart)
        if remainMs < 0 then remainMs = 0 end
    end
    local secs = math.floor(remainMs / 1000)
    local txt  = string.format("%02d:%02d", math.floor(secs / 60), secs % 60)
    self:drawTextCentre(txt, self.width / 2, 30, 1, 1, 1, 1, UIFont.Large)

    if md and type(md.dl_strike) == "number" and type(md.dl_strikeLimit) == "number"
       and md.dl_strike >= (md.dl_strikeLimit - 1) then
        self:drawTextCentre("If you go down again, you won't get back up.",
            self.width / 2, 60, 1.0, 0.55, 0.12, 1, UIFont.Small)
    end

    local rn = DL.Knockdown and DL.Knockdown._reviverName
    if rn then
        self:drawTextCentre(tostring(rn) .. " is picking you up...",
            self.width / 2, 82, 0.40, 0.90, 0.45, 1, UIFont.Small)
    end
end

function K.uiShow()
    if K._panel == nil then
        K._panel = DLKnockPanel:new()
        K._panel:initialise()
        K._panel:instantiate()
        K._panel:addToUIManager()
    end
    K._panel:setVisible(true)
end

function K.uiHide()
    if K._panel then
        K._panel:setVisible(false)
        K._panel:removeFromUIManager()
        K._panel = nil
    end
end

DL.log("knockdown UI loaded (timer overlay + give up)")
