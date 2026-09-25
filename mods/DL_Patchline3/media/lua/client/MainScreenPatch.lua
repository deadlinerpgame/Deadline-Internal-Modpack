require "OptionsScreens/MainScreen";

local isExitToDesktopDisabled = false;

local function disableExitToDesktop()
    MainScreen.instance.quitToDesktop.onMouseDown = nil;
    MainScreen.instance.quitToDesktop.tooltip = "<RGB:1,0,0> Quit to Desktop is disabled on Deadline to prevent data loss from sudden disconnects.";
    MainScreen.instance.quitToDesktop.textColor = { r = 1, g = 0, b = 0, a = 0.7};
end

local function OnPostUIDraw()
    if isExitToDesktopDisabled then
        Events.OnPostUIDraw.Remove(OnPostUIDraw);
        return;
    end

    if MainScreen.instance and MainScreen.instance:isVisible() and MainScreen.instance.quitToDesktop then
        if MainScreen.instance.quitToDesktop.onMouseDown ~= nil then
            disableExitToDesktop();
            isExitToDesktopDisabled = true;
        end
    end
end

local onMenuItemDown_original = MainScreen.onMenuItemMouseDownMainMenu;
function MainScreen.onMenuItemMouseDownMainMenu(item, x, y)
    if item.internal == "EXIT" and MainScreen.instance.inGame == true then
        sendClientCommand(getPlayer(), "PatchLine", "QuitChecker", { time = getTimestamp() });
    end

    onMenuItemDown_original(item, x, y);
end

Events.OnPostUIDraw.Add(OnPostUIDraw);