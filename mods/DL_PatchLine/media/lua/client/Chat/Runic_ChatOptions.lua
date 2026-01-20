if (not isClient()) or (not isAdmin()) then return end;

local _original_onGear = ISChat.onGearButtonClick;
function ISChat:onGearButtonClick()
    _original_onGear(self);

    local context = getPlayerContextMenu(0);
    runicOptions_onGearButtonClick(context);
end

local function runicOptions_enableIgnore()
    if not isAdmin() then return end;

    local modData = getPlayer():getModData();
    modData.ADMIN_RunicIgnore = true;

    getPlayer():setHaloNote("Runic Zombie Ignore - Enabled", 20, 255, 20, 200);

    getPlayer():setZombiesDontAttack(true);
    getPlayer():setGhostMode(true);
end


local function runicOptions_disableIgnore()
    if not isAdmin() then return end;

    local modData = getPlayer():getModData();
    modData.ADMIN_RunicIgnore = false;

    getPlayer():setHaloNote("Runic Zombie Ignore - Disabled", 255, 255, 255, 200);

    getPlayer():setZombiesDontAttack(false);
    getPlayer():setGhostMode(false);
end

local function runicOptions_onGearButtonClick(context)
    if not isAdmin() then return end;

    local runicOptions = context:addOption("Runic - Zombies Ignore", ISChat.instance);
    local runicSub = context:getNew(context);

    context:addSubMenu(runicOptions, runicSub);

    local enable = runicSub:addOption("Enable", ISChat.instance, runicOptions_enableIgnore);
    local disable = runicSub:addOption("Disable", ISChat.instance, runicOptions_disableIgnore);

    local modData = getPlayer():getModData();
    if modData.ADMIN_RunicIgnore then
        runicSub:setOptionChecked(enable, true);
        enable.notAvailable = true;
    else
        runicSub:setOptionChecked(disable, true);
        disable.notAvailable = true;
    end

    return;
end

local varsResetThisLogin = false;

local function runicOptions_ignoreEvent()
    if varsResetThisLogin then
        Events.EveryOneMinute.Remove(runicOptions_ignoreEvent);
        return;
    end

    if string.contains(getPlayer():getDescriptor():getForename(), "Runic") then
        getPlayer():getModData().ADMIN_RunicIgnore = true;
        varsResetThisLogin = true;
        return;
    end

    getPlayer():getModData().ADMIN_RunicIgnore = false;
    varsResetThisLogin = true;
end

Events.EveryOneMinute.Add(runicOptions_resetOnConnect);