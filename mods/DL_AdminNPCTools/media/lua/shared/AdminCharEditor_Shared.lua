
AdminCharEditor = AdminCharEditor or {}

AdminCharEditor.SkinColors = {
    { name = "Light",       index = 0 },
    { name = "Medium Light", index = 1 },
    { name = "Medium",      index = 2 },
    { name = "Medium Dark", index = 3 },
    { name = "Dark",        index = 4 },
}

AdminCharEditor.Genders = {
    { name = "Male",   isFemale = false },
    { name = "Female", isFemale = true },
}

AdminCharEditor.Commands = {
    REQUEST_CHANGE_GENDER = "ACE_ChangeGender",
    REQUEST_CHANGE_SKIN = "ACE_ChangeSkin",
    SYNC_VISUAL = "ACE_SyncVisual",
}

function AdminCharEditor.getSkinColorName(index)
    for _, skin in ipairs(AdminCharEditor.SkinColors) do
        if skin.index == index then
            return skin.name
        end
    end
    return "Unknown"
end

function AdminCharEditor.getGenderName(isFemale)
    return isFemale and "Female" or "Male"
end
