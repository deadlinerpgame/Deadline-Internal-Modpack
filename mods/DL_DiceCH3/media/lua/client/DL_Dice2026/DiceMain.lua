
local Core = require("DL_Dice2026/DiceCore")
local ChatBridge = require("DL_Dice2026/DiceChatBridge")
local MenuDock = require("ElyonLib/UI/MenuDock/MenuDock")
local UIUtils = require("ElyonLib/UI/Utils/UIUtils")
local DiceTurnOrder = require("DL_Dice2026/UI/DiceTurnOrder")
local DiceMyHP = require("DL_Dice2026/UI/DiceMyHP")
local DiceCombat = require("DL_Dice2026/UI/DiceCombat")
local DiceRolls = require("DL_Dice2026/UI/DiceRolls")
local DiceRollLog = require("DL_Dice2026/UI/DiceRollLog")
local DiceRules = require("DL_Dice2026/UI/DiceRules")
local DiceMiniHud = require("DL_Dice2026/UI/DiceMiniHud")
local DiceAdmin = require("DL_Dice2026/UI/DiceAdmin")
local DiceToolbar = require("DL_Dice2026/UI/DiceToolbar")
require("DL_Dice2026/DiceRangeMarkers")
require("DL_Dice2026/DiceTileMarkers")
local DiceMain = {}

DiceMain.panels = {}
DiceMain.panelClasses = {}

local function getPanelById(panelId)
	return DiceMain.panels[panelId]
end

local function createPanel(class)
	local panel = class:new()
	panel:initialise()
	panel:instantiate()
	panel:addToUIManager()
	panel:restoreState()
	DiceMain.panels[panel.panelId] = panel
	DiceMain.panelClasses[panel.panelId] = class
	return panel
end

function DiceMain.rebuildPanel(panelId)
	local old = DiceMain.panels[panelId]
	local class = DiceMain.panelClasses[panelId]
	if not old or not class then
		return
	end
	old:removeFromUIManager()
	DiceMain.panels[panelId] = nil
	local panel = createPanel(class)
	if panelId == "toolbar" then
		panel.getPanelById = getPanelById
		panel:refreshButtons()
	end
	if panelId == "turnOrder" and panel.recalcHeight then
		panel:recalcHeight()
	end
	Core.notify("ui")
end

local wasMyTurn = false

local function onCoreEvent(event)
	for _, panel in pairs(DiceMain.panels) do
		if panel.onCoreEvent then
			panel:onCoreEvent(event)
		end
	end

	if event == "log" then
		local last = Core.log[#Core.log]
		if last then
			ChatBridge.send(last)
		end
	end

	if event == "state" then
		local mine = Core.isMyTurn()
		if mine and not wasMyTurn then
			UIUtils.playSound("UIActivateMainMenuItem")
			local turnOrder = DiceMain.panels.turnOrder
			if turnOrder and turnOrder.flash then
				turnOrder:flash()
			end
		end
		wasMyTurn = mine
	end
end

local function onBoot()
	Core.loadSettings()
	Core.me()

	createPanel(DiceTurnOrder)
	createPanel(DiceMyHP)
	createPanel(DiceCombat)
	createPanel(DiceRolls)
	createPanel(DiceRollLog)
	createPanel(DiceRules)
	createPanel(DiceMiniHud)
	createPanel(DiceAdmin)

	local toolbar = createPanel(DiceToolbar)
	toolbar.getPanelById = getPanelById
	toolbar:refreshButtons()

	DiceMain.panels.turnOrder:recalcHeight()
	Core.addListener(onCoreEvent)
	Core.rebuildPanel = DiceMain.rebuildPanel
	Core.updateMyWeapon()
	Core.requestState()
	if isClient and isClient() then
		pcall(MenuDock.registerButton, {
			id = "DL_Dice2026",
			title = "Dice 2026 - turn-based combat",
			label = "DICE",
			onClick = function(playerNum, entry)
				local bar = DiceMain.panels.toolbar
				if bar then
					bar:setPanelVisible(not bar:getIsVisible())
				end
			end,
		})
	end
end

local function onResolutionChange()
	for _, panel in pairs(DiceMain.panels) do
		if panel.onResolutionChange then
			panel:onResolutionChange()
		end
	end
end

Events.OnGameStart.Add(onBoot)
Events.OnResolutionChange.Add(onResolutionChange)
Events.OnEquipPrimary.Add(function(playerObj, item)
	if playerObj and getPlayer and playerObj == getPlayer() then
		Core.updateMyWeapon()
	end
end)

return DiceMain
