local GlowStickList = {
    "AuthenticZLite.AuthenticGlowstick_Red",
    "AuthenticZLite.AuthenticGlowstick_Blue",
    "AuthenticZLite.AuthenticGlowstick_Green",
    "AuthenticZLite.AuthenticGlowstick_Orange",
    "AuthenticZLite.AuthenticGlowstick_Pink",
    "AuthenticZLite.AuthenticGlowstick_Purple",
    "AuthenticZLite.AuthenticGlowstick_Yellow",
    "AuthenticZLite.AuthenticGlowstick_White",
}

function Recipe.OnCreate.OpenGlowStickPackage(items, result, player)
    player:getInventory():AddItem(GlowStickList[ZombRand(#GlowStickList)+1]);
    player:getInventory():AddItem(GlowStickList[ZombRand(#GlowStickList)+1]);
    player:getInventory():AddItem(GlowStickList[ZombRand(#GlowStickList)+1]);
end


-- old list kept for reference
local SealedMedkitList = {
            "AlcoholWipes",
            "AlcoholWipes",
            "Bandage",
            "Bandage",
            "Bandage",
            "Bandaid",
            "Bandaid",
            "Bandaid",
            "CottonBalls",
            "CottonBalls",
            "CottonBalls",
            "Disinfectant",
            "Gloves_Surgical",
            "Scalpel",
            "Scissors",
            "SutureNeedle",
            "SutureNeedle",
            "SutureNeedleHolder",
            "Tweezers",
}
function Recipe.OnCreate.OpenSealedMedkit(items, result, player)
    player:getInventory():AddItem("Tweezers");
    player:getInventory():AddItem("AlcoholWipes");
    player:getInventory():AddItem("Bandage");
    player:getInventory():AddItem("Bandage");
    player:getInventory():AddItem("AlcoholBandage");
    player:getInventory():AddItem("AlcoholBandage");
    player:getInventory():AddItem("SutureNeedle");
    player:getInventory():AddItem("SutureNeedle");
    player:getInventory():AddItem("SutureNeedleHolder");
    player:getInventory():AddItem("Scissors");
    player:getInventory():AddItem("Scalpel");
    player:getInventory():AddItem("CottonBalls");
    player:getInventory():AddItem("Gloves_Surgical");
    player:getInventory():AddItem("Bandaid");
    player:getInventory():AddItem("Bandaid");
    player:getInventory():AddItem("AlcoholBandage2");
end