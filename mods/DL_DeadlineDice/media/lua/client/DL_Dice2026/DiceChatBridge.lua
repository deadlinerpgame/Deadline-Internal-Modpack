local DiceChatBridge = {}

DiceChatBridge.TAB_ID = 96

local tabReady = false

local function chatModAvailable()
	return WRC ~= nil
		and WL_FakeMessage ~= nil
		and ISChat ~= nil
		and ISChat.instance ~= nil
		and ISChat.onTabAdded ~= nil
		and type(ISChat.allChatStreams) == "table"
		and type(ISChat.defaultTabStream) == "table"
		and type(ISChat.instance.tabs) == "table"
end

local function ensureTab()
	if tabReady then
		return true
	end
	if not chatModAvailable() then
		return false
	end

	local streamId = #ISChat.allChatStreams + 1
	ISChat.allChatStreams[streamId] = { name = "dice", command = "/say ", tabID = DiceChatBridge.TAB_ID + 1 }

	ISChat.onTabAdded("Dice", DiceChatBridge.TAB_ID)

	for i = 1, #ISChat.instance.tabs do
		if ISChat.instance.tabs[i].tabID == DiceChatBridge.TAB_ID then
			ISChat.defaultTabStream[i] = ISChat.allChatStreams[streamId]
		end
	end

	tabReady = true
	return true
end

function DiceChatBridge.send(text)
	if not ensureTab() then
		return false
	end

	local addLine = (WRC.ISChatOriginal and WRC.ISChatOriginal.addLineInChat) or ISChat.addLineInChat
	if not addLine then
		return false
	end
	local message = WL_FakeMessage:new(text, {
		author = "Dice",
		color = "0.95,0.76,0.33",
		chatId = DiceChatBridge.TAB_ID,
	})
	addLine(message, DiceChatBridge.TAB_ID)
	return true
end

return DiceChatBridge
