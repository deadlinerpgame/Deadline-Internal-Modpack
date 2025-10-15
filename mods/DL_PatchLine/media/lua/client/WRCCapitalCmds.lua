-- If you type /ME or /ENV or similar then the command will fail. This adds options for the capitalized versions.

if not isClient() then return end;

WRC = WRC or {};
WRC.ChatModifiers = WRC.ChatModifiers or {};

WRC.ChatModifiers["ME"] = WRC.ChatModifiers["me"];
WRC.ChatModifiers["ENV"] = WRC.ChatModifiers["env"];
WRC.ChatModifiers["OOC"] = WRC.ChatModifiers["ooc"];

WRC.ChatTypes["SHOUT"] = WRC.ChatTypes["shout"];
WRC.ChatTypes["LOUD"] = WRC.ChatTypes["loud"];
WRC.ChatTypes["SAY"] = WRC.ChatTypes["say"];
WRC.ChatTypes["LOW"] = WRC.ChatTypes["low"];
WRC.ChatTypes["WHISPER"] = WRC.ChatTypes["whisper"];