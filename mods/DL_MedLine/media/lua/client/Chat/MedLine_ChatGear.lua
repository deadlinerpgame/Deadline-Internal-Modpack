require "MedLine_Client";

MedLine_ChatOptions = {};
MedLine_Client = MedLine_Client or {};

local _original_onGear = ISChat.onGearButtonClick;
function ISChat:onGearButtonClick()
    _original_onGear(self);

    local context = getPlayerContextMenu(0);
    MedLine_ChatOptions.onGearButtonClick(context);
end

function MedLine_ChatOptions.onClickBloodType(self, value)
    local currentBloodType = MedLine_Client.getBloodType(getPlayer());
    if not currentBloodType then return end;

    if value == currentBloodType.type then
        return;
    end

    MedLine_ChatOptions._selectedType = value;
    MedLine_ChatOptions._currentType = currentBloodType.type;
    MedLine_ChatOptions.showBloodConfirmModal();
end

function MedLine_ChatOptions.onGearButtonClick(context)

    local player = getPlayer();

    local currentBloodType = MedLine_Client.getBloodType(player).type;
    if not currentBloodType then
        MedLine_Logging.log("No blood type found");
        return;
    end

    local changedBefore = MedLine_Client.hasPrevChangedBloodType();

    local bloodTypeMain = context:addOption(getText("UI_chat_medline_bloodtype"), ISChat.instance);

    if changedBefore then
        bloodTypeMain.notAvailable = true;
        return;
    end

    local bloodSubMenu = context:getNew(context);

    context:addSubMenu(bloodTypeMain, bloodSubMenu);

    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType then
            local typeOption = bloodSubMenu:addOption(bloodType.type, ISChat.instance, (not changedBefore and MedLine_ChatOptions.onClickBloodType) or nil, bloodType.type);
            if currentBloodType == bloodType.type then
                bloodSubMenu:setOptionChecked(typeOption, true);
                typeOption.notAvailable = true;
            end

            if changedBefore then
                typeOption.notAvailable = true;
            end
        end
    end
end

------------------
---
---
---
---
---
---
---
-----------------
---

function MedLine_ChatOptions.onConfirmBloodType(self, btn)
    if btn.internal == "NO" then return end;

    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    MedLine_Client.changeBloodType(MedLine_ChatOptions._selectedType);
end

function MedLine_ChatOptions.showBloodConfirmModal()
    local posX = (getCore():getScreenWidth() / 2) - (350 / 2);
    local posY = (getCore():getScreenHeight() / 2) - (150 / 2);

    local modal = ISModalDialog:new(posX, posY, 350, 150, getText("IGUI_ConfirmChangeBloodType", MedLine_ChatOptions._currentType, MedLine_ChatOptions._selectedType), true, self, MedLine_ChatOptions.onConfirmBloodType, getPlayer():getPlayerNum());
    modal:initialise();
    modal:addToUIManager();
end


return MedLine_ChatOptions;