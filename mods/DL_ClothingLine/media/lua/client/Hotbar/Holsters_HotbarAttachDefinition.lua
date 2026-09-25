require "Hotbar/ISHotbarAttachDefinition"

if not ISHotbarAttachDefinition then
    return
end

local HolsterShoulder = {
    type = "HolsterShoulder",
    name = "Holster",
    animset = "holster left",
    attachments = {
        Holster = "Holster Shoulder",
        HolsterSmall = "Holster Shoulder",
    },
}
table.insert(ISHotbarAttachDefinition, HolsterShoulder)

local HolsterAnkle = {
    type = "HolsterAnkle",
    name = "Holster",
    animset = "holster right",
    attachments = {
        Holster = "Holster Ankle",
        HolsterSmall = "Holster Ankle",
    },
}
table.insert(ISHotbarAttachDefinition, HolsterAnkle)
