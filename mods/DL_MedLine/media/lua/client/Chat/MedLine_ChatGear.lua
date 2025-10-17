MedLine_ChatOptions = {};

local _original_onGear = ISChat.onGearButtonClick;
function ISChat:onGearButtonClick()
    _original_onGear(self);

    local context = getPlayerContextMenu(0);
    MedLine_ChatOptions.onGearButtonClick(context);
end

function MedLine_ChatOptions.onClickBloodType(self, value)
    local currentBloodType = MedLine_Client.getBloodType().type;

    if value == currentBloodType then
        return;
    end

end

function MedLine_ChatOptions.onGearButtonClick(context)

    local currentBloodType = MedLine_Client.getBloodType().type;

    local bloodTypeMain = context:addOption(getText("UI_chat_medline_bloodtype"), ISChat.instance);
    local bloodSubMenu = context:getNew(context);

    context:addSubMenu(bloodTypeMain, bloodSubMenu);

    for i, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType then
            context:addSubMenu(bloodType.type, ISChat.instance, MedLine_ChatOptions.MedLine_ChatOptions.onClickBloodType, bloodType.type);
            if currentBloodType == bloodType.type then
                bloodSubMenu:setOptionChecked(bloodSubMenu.options[i], true);
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

function MedLine_ChatOptions.onConfirmBloodType(btn)
    if btn.internal == "NO" then return end;


end

function MedLine_ChatOptions.showBloodConfirmModal()
    local modal = ISModalDialog:new(0, 0, 350, 150, getText("UI_SuicideConfirm"), true, self, MedLine_ChatOptions.onConfirmBloodType);
    modal:initialise();
    modal:addToUIManager();
end


return MedLine_ChatOptions;