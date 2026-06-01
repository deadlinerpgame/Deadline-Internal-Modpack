if ISSkillProgressBar == nil then
    DL.warn("caps UI: ISSkillProgressBar not found; overlay not installed")
    return
end

local CUBE_SLOT   = 20
local CUBE_HEIGHT = 18
local MAXLEVEL    = 10

local _vanillaRender = ISSkillProgressBar.render

function ISSkillProgressBar:render()
    _vanillaRender(self)

    local _ = (function()
        local char, perk = self.char, self.perk
        if char == nil or perk == nil then return end
        if DL.Caps.isExempt(char) then return end

        local perkType = perk:getType()
        local bonus = DL.Caps.computeBonusesCached(char)
        local cap = DL.Caps.capFor(char, perkType, bonus)
        if cap >= MAXLEVEL then return end

        if cap < 0 then cap = 0 end
        local x = cap * CUBE_SLOT
        local w = (MAXLEVEL - cap) * CUBE_SLOT - 1

        self:drawRect(x, 0, w, CUBE_HEIGHT, 0.55, 0.0, 0.0, 0.0)
    end)()
end

DL.log("caps UI overlay loaded (dim over-cap cubes)")
