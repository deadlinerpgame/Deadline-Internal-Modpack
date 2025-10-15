--if not getActivatedMods():contains("buffysounds") then return end; -- Don't run this if Buffy's sound mod isn't active.

SoundQOL = {};
SoundQOL.IsCustomSoundPlaying = false;
SoundQOL.CustomSoundStartedTimestamp = 0;
SoundQOL.CustomSoundString = nil;

WRC = WRC or {};
WRC.Meta = WRC.Meta or {};
WRC.SpecialCommands = WRC.SpecialCommands or {};
WRC.Commands = WRC.Commands or {};

WRC.SpecialCommands["/stopsoundex"] = {
    handler = "StopSoundEx",
    tabHandlers = {},
    usage = "/stopsoundex [range (1-999)]",
    help = "Allows staff members to stop sounds for all players within a specific range of themselves.",
    adminOnly = true,
}

WRC.SpecialCommands["/psx"] = {
    handler = "PlaySoundEx",
    tabHandlers = {};
    usage = "/ps [show message (yes = 1, 0 = no)] [distance] [sound name]",
    help = "/playsound alternative with more functionality including variable range.",
    adminOnly = true,
}

WRC.SpecialCommands["/ps"] = {
    handler = "PlaySoundFixed",
    tabHandlers = {};
    usage = "/ps [show message (yes = 1, 0 = no)] [sound name]",
    help = "/playsound alternative with range of 50.",
    adminOnly = true,
}

WRC.SpecialCommands["/pslooped"] = {
    handler = "PlaySoundLooped",
    tabHandlers = {},
    usage = "/ps(looped) [show message (yes = 1, 0 = no)]  [sound name]",
    help = "/ps with the specified sound name and distance of 50 set to automatically loop on completion.",
    adminOnly = true,
}

WRC.SpecialCommands["/psxlooped"] = {
    handler = "PlaySoundExLooped",
    tabHandlers = {},
    usage = "/psx(looped) [show message (yes = 1, 0 = no)] [distance] [sound name]",
    help = "/psx with the specified sound name set to automatically loop on completion.",
    adminOnly = true,
}

WRC.SpecialCommands["/ss"] = {
    handler = "StopSoundLocal",
    tabHandlers = {},
    usage = "/ss",
    help = "Alternative to stop sound which also stops looping sounds.",
    adminOnly = true,
}

function SoundQOL.StopSoundEx(args)
    SoundQOL.IsCustomSoundPlaying = nil;
    SoundQOL.CustomSoundString = nil;
    SoundQOL.ShouldLoop = false;

    SoundQOL.SoundPlayingCheck();
end

function WRC.Commands.PlaySoundFixed(args)
    local params = WRC.SplitString(args);

    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. /ps(looped) [show message (yes = 1, 0 = no)] [sound name]");
        return;
    end

    local showMsg, sound = params[1], params[2];

    local msgAsNum = tonumber(showMsg);
    if not msgAsNum or (msgAsNum < 0 or msgAsNum > 1) then
        WL_Utils.addErrorToChat("Show message must either be 1 (show message) or 0 (do not show message)");
        return;
    end

    WRC.Commands.PlaySoundEx({showMsg, 50, sound}, false);
end

function WRC.Commands.PlaySoundEx(args, doLoop)
    local params = WRC.SplitString(args);

    if #params ~= 3 then
        WL_Utils.addErrorToChat("Invalid format. /psx(looped) [show message (yes = 1, 0 = no)] [distance] [sound name]");
        return;
    end

    local showMsg, range, sound = params[1], params[2], params[3];

    local msgAsNum = tonumber(showMsg);
    if not msgAsNum or (msgAsNum < 0 or msgAsNum > 1) then
        WL_Utils.addErrorToChat("Show message must either be 1 (show message) or 0 (do not show message)");
        return;
    end

    local rangeNum = tonumber(range);
    if not rangeNum or (rangeNum < 1 or rangeNum > 999) then
        WL_Utils.addErrorToChat("Distance must be a number between 1 and 999.");
        return;
    end

    local srcPos = { x = getPlayer():getX(), y = getPlayer():getY(), z = getPlayer(): getZ() };

    if not doLoop then doLoop = 0 end;

    -- Now call request to play sound.
    sendClientCommand(getPlayer(), "PatchLine", "PlaySoundEx", { range = rangeNum, soundStr = sound, fromPos = srcPos, showMsg = msgAsNum, looped = doLoop });
    
    local msgShownStr = "";
    if msgAsNum and msgAsNum == 1 then
        msgShownStr = "<SPACE> <RGB:0.8,0.8,0.8>  ( <RGB:0.2,0.2,0.8> with notif <RGB:0.8,0.8,0.8> )";
    else
        msgShownStr = "<SPACE> <RGB:0.8,0.8,0.8> <SPACE> ( <RGB:0.8,0.2,0.2> no notif <RGB:0.8,0.8,0.8> )";
    end

    local queuedStr = string.format("<RGB:0.2,0.2,0.8> [PlaySoundEx] <RGB:0.8,0.8,0.8> <SPACE> Request made to play song <RGB:0.2,0.2,0.8> <SPACE> %s <RGB:0.8,0.8,0.8> <SPACE> for all players within <RGB:0.2,0.2,0.8> <SPACE> %0d <RGB:0.8,0.8,0.8> <SPACE> tiles %s.", sound, rangeNum, msgShownStr);
    WL_Utils.addInfoToChat(queuedStr);
end

function WRC.Commands.PlaySoundExLooped(args)
    WRC.Commands.PlaySoundEx(args, 1);
end

function WRC.Commands.PlaySoundLooped(args)
    local params = WRC.SplitString(args);

    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. /ps(looped) [show message (yes = 1, 0 = no)] [sound name]");
        return;
    end

    local showMsg, sound = params[1], params[2];

    local msgAsNum = tonumber(showMsg);
    if not msgAsNum or (msgAsNum < 0 or msgAsNum > 1) then
        WL_Utils.addErrorToChat("Show message must either be 1 (show message) or 0 (do not show message)");
        return;
    end

    WRC.Commands.PlaySoundEx({showMsg, 50, sound}, true);
end

function WRC.Commands.StopSoundLocal(args)
    getSoundManager():stop();
    SoundQOL.IsCustomSoundPlaying = false;
    SoundQOL.CustomSoundStartedTimestamp = 0;
end

function WRC.Commands.StopSoundEx(args)
    local params = WRC.SplitString(args);

    if #params ~= 1 then
        WL_Utils.addErrorToChat("Invalid format. <RGB:0.8,0.8,0.8> <SPACE> /stopsoundex [range (1-999)]");
        return;
    end

    local range = params[1];
    
    local rangeNum = tonumber(range);
    if not rangeNum or (rangeNum < 1 or rangeNum > 999) then
        WL_Utils.addErrorToChat("Range must be a number between 1 and 999.");
        return;
    end

    local fromPos = { x = getPlayer():getX(), y = getPlayer():getY(), z = getPlayer():getZ() };

    sendClientCommand(getPlayer(), "PatchLine", "StopSoundEx", { range = rangeNum, pos = fromPos });

    local queuedStr = string.format("[StopSoundEx] <RGB:0.8,0.8,0.8> <SPACE> Request made to stop sound for all players within <RGB:0.2,0.2,0.8> <SPACE> %0d <RGB:0.8,0.8,0.8> <SPACE> tiles.", rangeNum);
    WL_Utils.addInfoToChat(queuedStr);
end

function SoundQOL.SoundPlayingCheck()
    if not SoundQOL.IsCustomSoundPlaying or SoundQOL.IsCustomSoundPlaying == false then
        getSoundManager():stop();
        Events.EveryOneMinute.Remove(SoundQOL.SoundPlayingCheck);
        return;
    end

    if not SoundQOL.CustomSoundString then
        getSoundManager():stop();
        SoundQOL.IsCustomSoundPlaying = false;
        Events.EveryOneMinute.Remove(SoundQOL.SoundPlayingCheck);
        return;
    end

    if not getSoundManager():isPlayingUISound(SoundQOL.CustomSoundString) and SoundQOL.IsCustomSoundPlaying then

        if SoundQOL.ShouldLoop and SoundQOL.ShouldLoop == 1 then
            SoundQOL.StartSoundEx(SoundQOL.CustomSoundString, 0, 1);
            return;
        end

        getSoundManager():stop();
        getCore():setOptionMusicVolume(SoundQOL.PreviousVolume or 0);
        SoundQOL.IsCustomSoundPlaying = false;
        SoundQOL.CustomSoundString = nil;
        Events.EveryOneMinute.Remove(SoundQOL.SoundPlayingCheck);
    end
end

function SoundQOL.StartSoundEx(sound, showMsg, looped)

    if not looped then looped = 0 end;
    --[[
        PlaySound(String name, boolean loop, float maxGain) - we're using this one, and we don't want loops.
        PlaySound(String name, boolean loop, float pitchVar, float maxGain)
    --]]
    getSoundManager():stop();

    getSoundManager():playUISound(sound); -- I don't think we can play this as music, Java looks to use GameSoundClip for music.

    SoundQOL.IsCustomSoundPlaying = true;
    SoundQOL.CustomSoundString = sound;
    SoundQOL.ShouldLoop = looped;

    if showMsg and showMsg == 1 then
        getPlayer():addLineChatElement("Event audio started. Type /ss to stop the audio.");
    end

    -- Game music was still playing, so mute it temporarily.
    SoundQOL.PreviousVolume = getCore():getOptionMusicVolume();
    getCore():setOptionMusicVolume(0);

    Events.EveryOneMinute.Add(SoundQOL.SoundPlayingCheck);
end

function SoundQOL.OnServerCommand(module, command, args)
    if module ~= "PatchLine" then return end;

    if command == "PlaySoundEx_Error" then
        WL_Utils.addErrorToChat("[PlaySoundEx] <PUSHRGB:0.8,0.8,0.8> <SPACE> There was an error retrieving players to play a sound for. This has been logged in the server logs.<POPRGB>");
        return;
    end

    if command == "PlaySoundEx_NoPlayers" then
        WL_Utils.addErrorToChat("[PlaySoundEx] <RGB:0.8,0.8,0.8> <SPACE> No players within range to play sound for.");
        return;
    end

    if command == "StopSoundEx_NoPlayers" then
        WL_Utils.addErrorToChat("[StopSoundEx] <RGB:0.8,0.8,0.8> <SPACE> No players within range to stop sound for.");
        return;
    end

    if command == "PlaySoundEx_PlayInRange" then
        SoundQOL.PreviousVolume = getCore():getOptionMusicVolume();

        SoundQOL.StartSoundEx(args.sound, args.showMsg, args.looped);
    end

    if command == "StopSoundEx_StopInRange" then
        getSoundManager():stop();
        SoundQOL.IsCustomSoundPlaying = false;
        SoundQOL.CustomSoundStartedTimestamp = 0;
    end
end

Events.OnServerCommand.Add(SoundQOL.OnServerCommand);