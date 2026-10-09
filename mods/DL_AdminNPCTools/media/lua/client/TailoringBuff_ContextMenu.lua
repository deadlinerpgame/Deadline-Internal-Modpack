require "ISUI/ISContextMenu"
require "TailoringBuff_DyeUI"
require "TailoringBuff_TextureUI"
local TailoringBuff_Utils = require("TailoringBuff_Utils")

local function openDye(item, player)
    TailoringBuff_DyeUI.showUI(player, item)
end

local function openTexture(item, player)
    TailoringBuff_TextureUI.showUI(player, item)
end

local function chooseTexture(item, player, index)
    TailoringBuff_Utils.applyTextureIndex(item, player, index)
end

local function onFill(playerIndex, context, items)
    local player = getSpecificPlayer(playerIndex)
    if not TailoringBuff_Utils.isAdmin(player) then return end

    for _, entry in ipairs(items) do
        local item = entry.items and entry.items[1] or entry

        -- Keep the B42 ordering: dye first, then one main texture option.
        if TailoringBuff_Utils.canDye(player, item) then
            context:addOption(getText("ContextMenu_TailoringBuff_Inventory_DyeClothing"), item, openDye, player)
        end

        local textures = TailoringBuff_Utils.getTextures(player, item)
        if textures and textures:size() > 1 then
            -- Clicking this main row opens the B42-style manager. Hovering shows
            -- the B41-style list of direct texture choices on the same row.
            local option = context:addOption(getText("ContextMenu_TailoringBuff_Inventory_ChangeTexture"), item, openTexture, player)
            local submenu = ISContextMenu:getNew(context)
            context:addSubMenu(option, submenu)

            for i = 0, textures:size() - 1 do
                local texture = tostring(textures:get(i))
                local name = texture:match("[^/\\]+$") or texture
                submenu:addOption(name, item, chooseTexture, player, i)
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFill)
