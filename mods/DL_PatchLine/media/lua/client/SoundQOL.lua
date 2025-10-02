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

WRC.SpecialCommands["/ps"] = {
    handler = "PlaySoundEx",
    tabHandlers = {};
    usage = "/ps [show message (yes = 1, 0 = no)] [distance] [sound name]",
    help = "/playsound alternative with more functionality.",
    adminOnly = true,
};

function WRC.Commands.PlaySoundEx(args, showMsg)
    local params = WRC.SplitString(args);

    if #params ~= 3 then
        WL_Utils.addErrorToChat("Invalid format. /ps [distance] [sound name]");
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

    -- Now call request to play sound.
    sendClientCommand(getPlayer(), "PatchLine", "PlaySoundEx", { range = rangeNum, soundStr = sound, fromPos = srcPos, showMsg = msgAsNum });
    local queuedStr = string.format("[PlaySoundEx] Request made to play song \"%s\" for all players within %0d tiles (message shown: %0d).", sound, rangeNum, msgAsNum);
    WL_Utils.addInfoToChat(queuedStr);
end

function WRC.Commands.StopSoundEx(args)
    local params = WRC.SplitString(args);

    if #params ~= 1 then
        WL_Utils.addErrorToChat("Invalid format. /stopsoundex [range (1-999)]");
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

    local queuedStr = string.format("[StopSoundEx] Request made to stop sound for all players within %0d tiles.", rangeNum);
    WL_Utils.addInfoToChat(queuedStr);
end

function SoundQOL.SoundPlayingCheck()
    if not SoundQOL.IsCustomSoundPlaying or SoundQOL.IsCustomSoundPlaying == false then
        Events.EveryOneMinute.Remove(SoundQOL.SoundPlayingCheck);
        return;
    end

    if not SoundQOL.CustomSoundString then
        getSoundManager():stop();
        SoundQOL.IsCustomSoundPlaying = false;
        Events.EveryOneMinute.Remove(SoundQOL.SoundPlayingCheck);
    end

    if not getSoundManager():isPlayingUISound(SoundQOL.CustomSoundString) then
        getCore():setOptionMusicVolume(SoundQOL.PreviousVolume or 0);
        SoundQOL.IsCustomSoundPlaying = false;
        SoundQOL.CustomSoundString = nil;
        Events.EveryOneMinute.Remove(SoundQOL.SoundPlayingCheck);
    end
end

function SoundQOL.StartSoundEx(sound, showMsg)
    --[[
        PlaySound(String name, boolean loop, float maxGain) - we're using this one, and we don't want loops.
        PlaySound(String name, boolean loop, float pitchVar, float maxGain)
    --]]
    getSoundManager():stop();

    getSoundManager():playUISound(sound); -- I don't think we can play this as music, Java looks to use GameSoundClip for music.
    SoundQOL.IsCustomSoundPlaying = true;

    if showMsg and showMsg == 1 then
        WL_Utils.addInfoToChat("[PlaySoundEx] Music has started. Type /stopsound to stop music playing.");
    end

    -- Game music was still playing, so mute it temporarily.
    SoundQOL.PreviousVolume = getCore():getOptionMusicVolume();
    getCore():setOptionMusicVolume(0);

    Events.EveryOneMinute.Add(SoundQOL.SoundPlayingCheck);
end

function SoundQOL.OnServerCommand(module, command, args)
    if module ~= "PatchLine" then return end;

    if command == "PlaySoundEx_Error" then
        WL_Utils.addErrorToChat("[PlaySoundEx] There was an error retrieving players to play a sound for. This has been logged in the server logs.");
        return;
    end

    if command == "PlaySoundEx_NoPlayers" then
        WL_Utils.addErrorToChat("[PlaySoundEx] No players within range to play sound for.");
        return;
    end

    if command == "StopSoundEx_NoPlayers" then
        WL_Utils.addErrorToChat("[StopSoundEx] No players within range to stop sound for.");
        return;
    end

    if command == "PlaySoundEx_PlayInRange" then
        local currentVolume = getCore():getOptionMusicVolume();
        if not currentVolume or currentVolume <= 0 then return end -- No point playing it for someone with music disabled.

        SoundQOL.StartSoundEx(args.sound, args.showMsg);
    end

    if command == "StopSoundEx_StopInRange" then
        getSoundManager():stop();
        SoundQOL.IsCustomSoundPlaying = false;
        SoundQOL.CustomSoundStartedTimestamp = 0;
        
    end
end

Events.OnServerCommand.Add(SoundQOL.OnServerCommand);