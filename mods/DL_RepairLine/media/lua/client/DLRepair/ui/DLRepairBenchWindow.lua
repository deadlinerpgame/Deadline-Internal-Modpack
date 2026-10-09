require "ISUI/ISCollapsableWindow"
require "ISUI/ISTabPanel"

local Layout = require("ElyonLib/UI/Layout/LayoutUtils")

DLRepairBenchWindow = ISCollapsableWindow:derive("DLRepairBenchWindow")

function DLRepairBenchWindow.OpenBench(playerNum, bench)
    playerNum = playerNum or 0
    local win = DLRepair.window
    if win and win.javaObject and win:getIsVisible() then
        if win.bench == bench and win.playerNum == playerNum then
            win:bringToTop()
            return win
        end
        win:close()
    end
    local cfg = DLRepair.Config
    local x, y, w, h = Layout.defaultWindowGeometry(cfg.windowWidth, cfg.windowHeight, 640, 440, 30)
    win = DLRepairBenchWindow:new(x, y, w, h, playerNum, bench)
    win:initialise()
    win:addToUIManager()
    DLRepair.window = win
    return win
end

function DLRepairBenchWindow:new(x, y, width, height, playerNum, bench)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum or 0
    o.bench = bench
    o.title = "Repair Bench"
    o.minimumWidth = 640
    o.minimumHeight = 440
    o:setResizable(true)
    return o
end

function DLRepairBenchWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight()
    local rh = self:resizeWidgetHeight()

    self.panel = ISTabPanel:new(0, th, self.width, self.height - th - rh)
    self.panel:initialise()
    self.panel:setAnchorRight(true)
    self.panel:setAnchorBottom(true)
    self.panel.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.panel.target = self
    self.panel.onActivateView = DLRepairBenchWindow.onActivateView
    self.panel:setEqualTabWidth(false)
    self:addChild(self.panel)

    local vh = self.panel.height - self.panel.tabHeight
    self:addView("Repair", DLRepairTab:new(0, 0, self.width, vh, self.playerNum, self))
    self:addView("Reinforce", DLReinforceTab:new(0, 0, self.width, vh, self.playerNum, self))
end

function DLRepairBenchWindow:addView(name, view)
    view:initialise()
    view:setAnchorRight(true)
    view:setAnchorBottom(true)
    self.panel:addView(name, view)
end

function DLRepairBenchWindow:onActivateView(tabPanel)
    local view = tabPanel:getActiveView()
    if view and view.refresh then view:refresh() end
end

function DLRepairBenchWindow:update()
    ISCollapsableWindow.update(self)
    local player = getSpecificPlayer(self.playerNum)
    if not player or player:isDead() or not DLRepair.Bench.isNear(player, self.bench) then
        self:close()
    end
end

function DLRepairBenchWindow:close()
    if DLRepair.window == self then DLRepair.window = nil end
    ISCollapsableWindow.close(self)
    self:removeFromUIManager()
end
