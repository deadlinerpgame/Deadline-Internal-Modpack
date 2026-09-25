DL = DL or {}
DL.IngotItems = {
    ["iron"] = "Ingot_Iron",
    ["iron_impure"] = "Ingot_IronImpure",
    ["copper"] = "Ingot_Copper",
    ["copper_impure"] = "Ingot_CopperImpure",
    ["aluminum"] = "Ingot_Aluminum",
    ["aluminum_impure"] = "Ingot_AluminumImpure",
    ["tin"] = "Ingot_Tin",
    ["tin_impure"] = "Ingot_TinImpure",
    ["zinc"] = "Ingot_Zinc",
    ["zinc_impure"] = "Ingot_ZincImpure",
    ["lead"] = "Ingot_Lead",
    ["lead_impure"] = "Ingot_LeadImpure",
    ["nickel"] = "Ingot_Nickel",
    ["nickel_impure"] = "Ingot_NickelImpure",
    ["chromium"] = "Ingot_Chromium",
    ["chromium_impure"] = "Ingot_ChromiumImpure",
    ["silver"] = "Ingot_Silver",
    ["silver_impure"] = "Ingot_SilverImpure",
    ["gold"] = "Ingot_Gold",
    ["gold_impure"] = "Ingot_GoldImpure",
    ["titanium"] = "Ingot_Titanium",
    ["titanium_impure"] = "Ingot_TitaniumImpure",
    ["carbon"] = "Ingot_Carbon",
    ["carbon_impure"] = "Ingot_CarbonImpure",
}

function DL.ingotItemType(result)
    local name = result and result.id and DL.IngotItems[result.id] or nil
    if name then return (DL.MODULE or "DL_MetalLine") .. "." .. name end
    return DL.bucketItemType(result and result.color or nil)
end
