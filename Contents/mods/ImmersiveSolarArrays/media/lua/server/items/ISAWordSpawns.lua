
test = false

function SpawnPanels()
	
	 local player = getPlayer()
	
	local square = getWorld():getCell():getGridSquare(4723, 7998, 0)
	
	
	
	if (calculateDistance(player:getX(), player:getY(), square:getX(), square:getY()) < 5 and test == false) then
		
		
		player:Say("Spawn here !")
		
		
	
		
		test = true
		
		
		
		
		
	end
	
	
	
	
	
	
	
end



Events.OnPlayerUpdate.Add(SpawnPanels)