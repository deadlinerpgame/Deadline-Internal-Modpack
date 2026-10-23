require "WL_Utils"
-- Ty to WastelandRp team for allowing me to peak and pull random functions from WastelandItemTweaks <3

-- Example of disableitem
-- disableItem("Base.Padlock")
-- disableItem("Base.CombinationPadlock")

local function disableItem(itemId)
    WL_Utils.setItemProperties(itemId, { Obsolete = true, Hidden = true, Tooltip = "Tooltip_DL_DisabledItem" })
end

-- Makes it heavy additionally
local function disableItem2(itemId)
    WL_Utils.setItemProperties(itemId, { Weight = 45, Obsolete = true, Hidden = true, Tooltip = "Tooltip_DL_DisabledItem" })
end

-- WL_Utils.setItemProperties("Module.Item", { Property = value, OtherProperty = value })
-- Example: WL_Utils.setItemProperties("Base.Padlock", { Weight = 0.1, Tooltip = "Tooltip_DL_DisabledItem" })
-- Example: WL_Utils.setItemProperties("Base.Padlock", { [Weight] = 0.1, [Tooltip] = "Tooltip_DL_DisabledItem" })
-- WL_Utils.setItemProperties prints this for misconfigured items: print("ERROR: Item not found to modify: " .. itemID)

WL_Utils.setItemProperties("Base.WoodenStick", { Weight = 0.5 })
WL_Utils.setItemProperties("Base.Log", { Weight = 6 })
WL_Utils.setItemProperties("Base.Plank", { Weight = 2 })