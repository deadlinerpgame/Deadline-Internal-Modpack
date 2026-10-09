local function GarandEjectMag(player, weapon)
	if not player or player:isDead() then return end
	if getDebug() and getDebugOptions():getBoolean("Cheat.Player.UnlimitedAmmo") then
		return;
	end

	local weaponType = weapon and weapon:getType():gsub("^DL", "")
	if weapon and (weaponType == "M1Garand" or weaponType == "M1GarandBayonet") and not weapon:isRoundChambered() and weapon:isContainsClip() and weapon:getCurrentAmmoCount() == 0 then
		local newMag = InventoryItemFactory.CreateItem(weapon:getMagazineType())
		newMag:setCurrentAmmoCount(0)
		player:getInventory():AddItem(newMag)

		weapon:setContainsClip(false)
		weapon:setCurrentAmmoCount(0)

		player:getEmitter():playSound("FirearmM1GarandPing")
	end
end

if not OldISReloadWeaponActionOnShoot then
	OldISReloadWeaponActionOnShoot = ISReloadWeaponAction.onShoot
end

Events.OnWeaponSwingHitPoint.Add(GarandEjectMag);
