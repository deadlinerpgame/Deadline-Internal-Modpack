
function NBRPMain()
	local player = getPlayer();
	
	if player:isInARoom() then
		local bodydamage = player:getBodyDamage();
		local boredom = bodydamage:getBoredomLevel();
		
		if boredom > 10 and boredom < 25 then
			bodydamage:setBoredomLevel(boredom - 6);
		end
	end
end

Events.EveryTenMinutes.Add(NBRPMain);


