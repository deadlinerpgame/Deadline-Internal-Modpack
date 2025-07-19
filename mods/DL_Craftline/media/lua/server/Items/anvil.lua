function AcceptItemFunction.Anvil (container, item)
	if  item:hasTag('ingot') == true then 
		return true
	else
		return false
	 end
end