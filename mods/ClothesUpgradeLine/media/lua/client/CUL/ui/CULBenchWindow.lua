require "ISUI/ISCollapsableWindow"
require "ISUI/ISTabPanel"

local Layout = require("ElyonLib/UI/Layout/LayoutUtils")

CULBenchWindow = ISCollapsableWindow:derive("CULBenchWindow")

function CULBenchWindow.OpenBench(playerNum, bench)
    playerNum = playerNum or 0
    local win = ClothesUpgrade.window
    if win and win.javaObject and win:getIsVisible() then
        if win.bench == bench and win.playerNum == playerNum then
            win:bringToTop()
            return win
        end
        win:close()
    end
    local cfg = ClothesUpgrade.Config
    local x, y, w, h = Layout.defaultWindowGeometry(cfg.windowWidth, cfg.windowHeight, 660, 460, 30)
    win = CULBenchWindow:new(x, y, w, h, playerNum, bench)
    win:initialise()
    win:addToUIManager()
    ClothesUpgrade.window = win
    return win
end

function CULBenchWindow:new(x, y, width, height, playerNum, bench)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum or 0
    o.bench = bench
    o.title = "Clothing Bench"
    o.minimumWidth = 660
    o.minimumHeight = 460
    o:setResizable(true)
    return o
end

function CULBenchWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight()
    local rh = self:resizeWidgetHeight()

    self.panel = ISTabPanel:new(0, th, self.width, self.height - th - rh)
    self.panel:initialise()
    self.panel:setAnchorRight(true)
    self.panel:setAnchorBottom(true)
    self.panel.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.panel.target = self
    self.panel.onActivateView = CULBenchWindow.onActivateView
    self.panel:setEqualTabWidth(false)
    self:addChild(self.panel)

    local vh = self.panel.height - self.panel.tabHeight
    self:addView("Apparel", CULUpgradeTab:new(0, 0, self.width, vh, self.playerNum, "apparel", self))
    self:addView("Packs", CULUpgradeTab:new(0, 0, self.width, vh, self.playerNum, "pack", self))
    self:addView("Appearance", CULAppearanceTab:new(0, 0, self.width, vh, self.playerNum, self))
    self.lastView = self.panel:getActiveView()
end

function CULBenchWindow:addView(name, view)
    view:initialise()
    view:setAnchorRight(true)
    view:setAnchorBottom(true)
    self.panel:addView(name, view)
end

function CULBenchWindow:onActivateView(tabPanel)
    local view = tabPanel:getActiveView()
    local prev = self.lastView
    if prev and prev ~= view and prev.onHide then prev:onHide() end
    self.lastView = view
    if view and view.refresh then view:refresh() end
end

function CULBenchWindow:update()
    ISCollapsableWindow.update(self)
    local player = getSpecificPlayer(self.playerNum)
    if not player or player:isDead() or not ClothesUpgrade.Bench.isNear(player, self.bench) then
        self:close()
    end
end

function CULBenchWindow:close()
    if ClothesUpgrade.window == self then ClothesUpgrade.window = nil end
    ISCollapsableWindow.close(self)
    self:removeFromUIManager()
    if self.panel then
        for _, v in ipairs(self.panel.viewList or {}) do
            local view = v.view
            if view and view.onHide then view:onHide() end
        end
    end
end
