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
    local currentBloodType = MedLine_Client.getBloodData():getBloodType();

    if value == currentBloodType.type then
        return;
    end

    MedLine_ChatOptions._selectedType = value;
    MedLine_ChatOptions._currentType = currentBloodType.type;
    MedLine_ChatOptions.showBloodConfirmModal();
end

function MedLine_ChatOptions.onGearButtonClick(context)

    local currentBloodType = MedLine_Client.getBloodData():getBloodType().type;

    local changedBefore = MedLine_Client.hasPrevChangedBloodType();

    local bloodTypeMain = context:addOption(getText("UI_chat_medline_bloodtype"), ISChat.instance);
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
                typeOption.tooltip = "<RED>You have already changed your blood type.";
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

    bloodData:changeBloodType(MedLine_ChatOptions._selectedType);
end

function MedLine_ChatOptions.showBloodConfirmModal()
    local modal = ISModalDialog:new(0, 0, 350, 150, getText("IGUI_ConfirmChangeBloodType", MedLine_ChatOptions._currentType, MedLine_ChatOptions._selectedType), true, self, MedLine_ChatOptions.onConfirmBloodType, getPlayer():getPlayerNum());
    modal:initialise();
    modal:addToUIManager();
end


return MedLine_ChatOptions;