WRC = WRC or {}
WRC.TabHandlers = WRC.TabHandlers or {}
WRC.Commands = WRC.Commands or {}
WRC.SpecialCommands = WRC.SpecialCommands or {}

MLine = {}

-- Finds all the Deadline Mannequin scripts, splits them by _, and separates them into a LUA object.
function MLine.InitMannequins()
    if not (isAdmin() or isDebugEnabled()) then return end

    local mannequins = getScriptManager():getAllMannequinScripts();

    local mannequinScripts = {}
    mannequinScripts.info = {
        skin = {},
        pose = {},
    };
    mannequinScripts.data = {}

    local highestxLenSkin = 50;
    local highestyLenSkin = 30;

    local highestxLenPose = 50;
    local highestyLenPose = 30;

    for i = 0, mannequins:size() - 1 do
		local script = mannequins:get(i)

		if script and script:getName():contains("DL_") then -- If it is a Deadline Mannequin script.

            local scriptName = script:getName();
            local splitName = scriptName:split("_");

            if #splitName >= 3 then
                skinType = splitName[2];
                pose = splitName[3];

                if not mannequinScripts.data[skinType] then
                    mannequinScripts.data[skinType] = {};
                end

                table.insert(mannequinScripts.data[skinType], pose);

                -- Calculating the box sizes for skin.
                local xLenSkin = getTextManager():MeasureStringX(UIFont.Small, skinType);
                local yLenSkin = getTextManager():MeasureStringY(UIFont.Small, skinType);

                if xLenSkin > highestxLenSkin then
                    highestxLenSkin = xLenSkin
                end

                if yLenSkin > highestyLenSkin then
                    highestyLenSkin = yLenSkin
                end

                -- Calculating the box sizes for pose.
                local xLenPose = getTextManager():MeasureStringX(UIFont.Small, pose);
                local yLenPose = getTextManager():MeasureStringY(UIFont.Small, pose);

                if xLenPose > highestxLenPose then
                    highestxLenPose = xLenPose
                end

                if yLenPose > highestyLenPose then
                    highestyLenPose = yLenPose
                end
            end
            
        end
	end

    mannequinScripts.info.skin.maxX = highestxLenSkin;
    mannequinScripts.info.skin.maxY = highestyLenSkin;

    mannequinScripts.info.pose.maxX = highestxLenPose;
    mannequinScripts.info.pose.maxY = highestyLenPose;

    return mannequinScripts;
end


function MLine.OpenInterface()
    if not (isAdmin() or isDebugEnabled()) then return end

    mannequinData = MLine.InitMannequins();

    local screenWidth = getCore():getScreenWidth();
    local screenHeight = getCore():getScreenHeight();

    local width = screenWidth / 5;
    local height = screenHeight / 3;

    local x = (screenWidth / 2) - (width / 2);
    local y = (screenHeight / 2) - (height / 2);

    local mannUI = ISMannequinUI:new(x, y, width, height);
    mannUI:initialise();
    mannUI:instantiate();
    mannUI:addToUIManager();
    mannUI:loadMannequinData(mannequinData);
end

function WRC.Commands.CreateMannequin()
    if not (isAdmin() or isDebugEnabled()) then return end

    MLine.OpenInterface()
end

WRC.SpecialCommands["/createmannequin"] = {
   handler = "CreateMannequin",
   tabHandlers = {},
   usage = "/createmannequin",
   help = "Allows admins/STs to create mannequins for roleplay.",
   adminOnly = false,
}