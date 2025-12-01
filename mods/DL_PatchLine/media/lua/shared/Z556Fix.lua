function Deadline556ClipPatch()
    print("[DL PatchLine 556 Override] Looking for items that use 556 clip...")
    local allItems = getAllItems();
    for i = 0, allItems:size() - 1 do
        local item = allItems:get(i);

        if item and item:getType() == Type.Weapon then

            if item:getAmmoType() == "Base.556Bullets" then
                print("[DL PatchLine 556 Override] Found item with 556clip as mag type:");
                item:DoParam("MagazineType = DL_556Clip");
            end
        end
    end
end

Events.OnGameBoot.Add(Deadline556ClipPatch);