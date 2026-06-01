DL = DL or {}
DL.Config = DL.Config or {}
DL.Config.deathRespawnLabel   = DL.Config.deathRespawnLabel   or "REVIVE"
DL.Config.deathPurgatoryLabel = DL.Config.deathPurgatoryLabel or "ENTER PURGATORY"
DL.Wounds = DL.Wounds or {}

local _prerender = ISPostDeathUI.prerender
function ISPostDeathUI:prerender()
    _prerender(self)
    if self.buttonExit then self.buttonExit:setVisible(false) end
    if self.buttonRespawn then
        local toCell = DL.Wounds and DL.Wounds.pendingToCell
        local label = toCell and DL.Config.deathPurgatoryLabel or DL.Config.deathRespawnLabel
        local _ = (function() self.buttonRespawn:setTitle(label) end)()
    end
end

DL.log("death UI loaded (REVIVE / Enter Purgatory; Exit hidden)")
