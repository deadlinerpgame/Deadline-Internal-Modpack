DL = DL or {}
DL.Retire = DL.Retire or {}
local R = DL.Retire

R.itemType = "Base.DLRetirePapers"

local function onConfirm(_, button, player)
    if button.internal ~= "YES" or player:isDead() then return end
    R.player = player
    DBNO.Knockdown.finalKill(player)
end

local function onRetire(player)
    local modal = ISModalDialog:new(getCore():getScreenWidth() / 2 - 175, getCore():getScreenHeight() / 2 - 75, 350, 150,
        "Retire this character? They will die and you will create a new character.",
        true, nil, onConfirm, player:getPlayerNum(), player)
    modal:initialise()
    modal:addToUIManager()
end

local function resolveItem(entry)
    if instanceof(entry, "InventoryItem") then return entry end
    return entry.items[1]
end

local function onFillInventoryObjectContextMenu(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)
    if player:isDead() or player:getModData().DLTutorialKit == "done" then return end
    for _, entry in ipairs(items) do
        if resolveItem(entry):getFullType() == R.itemType then
            context:addOption("Retire Character", player, onRetire)
            return
        end
    end
end

local function onTick()
    local player = R.player
    if player == nil then return end
    local panel = ISPostDeathUI.instance[player:getPlayerNum()]
    if panel == nil then return end
    R.player = nil
    sendClientCommand(player, "DBNOKnock", "retire", {})
    DBNO.OverkillRescue.pending = false
    DBNO.Wounds.finalDeath = true
    panel:onRespawn()
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)
Events.OnTick.Add(onTick)
