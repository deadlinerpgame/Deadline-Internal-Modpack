-- B41 addon: use SpnCharCustom's registration API and existing BodyDetail2 slot.
local FM_Data = require("CharacterCustomisation/FM_Data")
local FM_Presets = require("CharacterCustomisation/FM_Presets")
local camera = FM_Presets.CameraPresets
local icons = FM_Presets.IconPresets

-- One item per source texture. Index zero applies to all five skin tones.
-- Selection is deliberate: random character creation does not add scars.
local details = {
    {
        name = "DL_ScarLine_Back_Burn_Scar", id = "DL_ScarLine.Back_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.torsoback, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_BackRight_Burn_Scar", id = "DL_ScarLine.BackRight_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.torsoback, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Face_Burn_Scar", id = "DL_ScarLine.Face_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Groin_Burn_Scar", id = "DL_ScarLine.Groin_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.lowerbody, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_LeftLeg_Burn_Scar", id = "DL_ScarLine.LeftLeg_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.legs, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_LeftSide_Burn_Scar", id = "DL_ScarLine.LeftSide_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.default, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_RightFace_Burn_Scar", id = "DL_ScarLine.RightFace_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_RightHand_Burn_Scar", id = "DL_ScarLine.RightHand_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.armright, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_RightSideFull_Burn_Scar", id = "DL_ScarLine.RightSideFull_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.default, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_RightSideShoulder_Burn_Scar", id = "DL_ScarLine.RightSideShoulder_Burn_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.chest, icon = icons.burn,
        category = "Burns", sort = "d2", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Both_Arm_Cuts_Scar", id = "DL_ScarLine.Both_Arm_Cuts_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.torso, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Both_Wrist_Cut_Scar", id = "DL_ScarLine.Both_Wrist_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.torso, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_BoundWrist_Cut_Scar", id = "DL_ScarLine.BoundWrist_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.torso, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Center_Chest_Cut_Scar", id = "DL_ScarLine.Center_Chest_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.chest, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Cescerian_Cut_Scar", id = "DL_ScarLine.Cescerian_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.lowerbody, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Collarbone_Cut_Scar", id = "DL_ScarLine.Collarbone_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.chest, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Cheek_Cut_Scar", id = "DL_ScarLine.Cheek_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Chin_Cut_Scar", id = "DL_ScarLine.Chin_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Eye_Cut_Scar", id = "DL_ScarLine.Eye_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Eyebrow_Cut_Scar", id = "DL_ScarLine.Eyebrow_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Face_Horizontal_Cut_Scar", id = "DL_ScarLine.Face_Horizontal_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Facial_Scar_LiptoCheek", id = "DL_ScarLine.Facial_Scar_LiptoCheek",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Lip_Cut_Scar", id = "DL_ScarLine.Lip_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Nose_Cut_Scar", id = "DL_ScarLine.Nose_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Three_Claw_Cut_Scar", id = "DL_ScarLine.Three_Claw_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.faceclose, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Horizontal_Chest_Cut_Scar", id = "DL_ScarLine.Horizontal_Chest_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.chest, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Left_Arm_Cuts_Scar", id = "DL_ScarLine.Left_Arm_Cuts_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.armleft, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Left_Wrist_Cut_Scar", id = "DL_ScarLine.Left_Wrist_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.armleft, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Neck_Cut_Scar", id = "DL_ScarLine.Neck_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.neck, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Right_Arm_Cuts_Scar", id = "DL_ScarLine.Right_Arm_Cuts_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.armright, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Right_Wrist_Cut_Scar", id = "DL_ScarLine.Right_Wrist_Cut_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.armright, icon = icons.scars,
        category = "Scars", sort = "c5", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Left_Arm_Gunshot_Scar", id = "DL_ScarLine.Left_Arm_Gunshot_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.armleft, icon = icons.scars,
        category = "Scars", sort = "c6", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Left_Shin_Gunshot_Scar", id = "DL_ScarLine.Left_Shin_Gunshot_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.legs, icon = icons.scars,
        category = "Scars", sort = "c6", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Left_Thigh_Gunshot_Scar", id = "DL_ScarLine.Left_Thigh_Gunshot_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.legs, icon = icons.scars,
        category = "Scars", sort = "c6", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Right_Shin_Gunshot_Scar", id = "DL_ScarLine.Right_Shin_Gunshot_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.legs, icon = icons.scars,
        category = "Scars", sort = "c6", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Right_Thigh_Gunshot_Scar", id = "DL_ScarLine.Right_Thigh_Gunshot_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.legs, icon = icons.scars,
        category = "Scars", sort = "c6", randomExcluded = true,
    },
    {
        name = "DL_ScarLine_Shoulder_Gunshot_Scar", id = "DL_ScarLine.Shoulder_Gunshot_Scar",
        textures = { 0 }, male = true, female = true,
        view = camera.chest, icon = icons.scars,
        category = "Scars", sort = "c6", randomExcluded = true,
    },
}

for _, detail in ipairs(details) do
    FM_Data.AddBodyDetailData(detail)
end
