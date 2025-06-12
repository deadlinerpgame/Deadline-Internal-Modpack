function AcceptItemFunction.Crucible (container, item)
	if item:getWeight() <= 0.11 and item:hasTag('meltable') == true then 
		return true
	else
		return false
	 end
end