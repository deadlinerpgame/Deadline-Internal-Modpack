DL_DonatorClothes = {};

function DL_DonatorClothes.RequestSlotsFromServer(playerNum, playerItem)
    if not playerNum then return end;
    getSpecificPlayer(playerNum):getModData()["DeadlineDonatorClothes_Item"] = playerItem;
    sendClientCommand(getSpecificPlayer(playerNum), "DeadlineDonatorClothes", "RequestSlots", { item = playerItem });
end

function DL_DonatorClothes.OpenInterface(playerNum, item, slotTabs)
    local screenWidth = getCore():getScreenWidth();
    local screenHeight = getCore():getScreenHeight();

    local width = screenWidth - 50;
    local height = screenHeight - 50;

    local x = (screenWidth / 2) - (width / 2);
    local y = (screenHeight / 2) - (height / 2);

    local dcUI = ISDonatorClothesUI:new(x, y, width, height, playerNum, item, slotTabs);
    dcUI:initialise();
    dcUI:addToUIManager();
end

DL_DonatorClothes.SlotTabs = {
    Head = {
        "Mask",
        "Hat",
        "Helmet",
        "Ears",
        "EarTop",
        "Nose",
        "Glasses",
        "Left Eye",
        "Right Eye",
    },
    UpperBody = {
        "Neck",
        "Necklace",
        "TorsoAndLegs",
        "Vest",
        "Tshirt",
        "TorsoExtraVestBullet",
        "ShortSleeveShirt",
        "LeftWrist",
        "RightWrist",
        "Shirt",
        "LongNecklace",
        "RightMiddleFinger",
        "LeftMiddleFinger",
        "LeftRingFinger",
        "RightRingFinger",
        "Gloves",
        "LeftHand",
        "RightHand",
        "RH93ElbowArmor",

    },
    LowerBody = {
        "Belt",
        "BeltExtra",
        "BellyButton",
        "Underwear",
        "UnderwearBottom",
        "UnderwearTop",
        "UnderwearExtra1",
        "UnderwearExtra2",
        "Socks",
        "Legs",
        "Pants",
        "Coveralls",
        "Shoes",
        "Skirt",
        "Legs",
        "Dress",
        "Tail",
    },
    Accessories = {
        "FannyPackFront",
        "FannyPackBack",
        "AmmoStrap",
        "Extra",
        "FullSuitHead"
    },
};

function DL_DonatorClothes.GetSlotTab(table, slotString)
    for k,v in pairs(table) do
        for _, slot in ipairs(table[k]) do
            if slot == slotString then
                return k;
            end
        end
    end

    return nil;
end


function DL_DonatorClothes.OnServerCommand(module, command, args)
    if module ~= "DeadlineDonatorClothes" then return end;

    if command ~= "ReceiveSlots" then return end;

    if not args.result then return end;

    local slotTabs = args.result;
    DL_DonatorClothes.OpenInterface(getPlayer():getOnlineID(), args.item, slotTabs);
end

Events.OnServerCommand.Add(DL_DonatorClothes.OnServerCommand);



return DL_DonatorClothes;