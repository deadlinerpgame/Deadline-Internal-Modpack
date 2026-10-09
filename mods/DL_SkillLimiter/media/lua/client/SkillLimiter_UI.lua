if ISSkillProgressBar == nil then
    DL.warn("caps UI: ISSkillProgressBar not found; overlay not installed")
    return
end

local CUBE_SLOT = 20
local CUBE_HEIGHT = 18

local vanillaRender = ISSkillProgressBar.render

function ISSkillProgressBar:render()
    vanillaRender(self)
    local character = self.char
    local perk = self.perk
    if character == nil or perk == nil then return end
    if DL.Caps == nil or DL.Caps.isExempt(character) then return end
    local maxLevel = DL.Caps.maxLevel()
    local caps = DL.Caps.computeCapsCached(character)
    local cap = DL.Caps.capFor(character, perk:getType(), caps)
    if cap >= maxLevel then return end
    self:drawRect(cap * CUBE_SLOT, 0, (maxLevel - cap) * CUBE_SLOT - 1, CUBE_HEIGHT, 0.55, 0.0, 0.0, 0.0)
end

DL.log("caps UI overlay loaded (dim over-cap cubes)")
