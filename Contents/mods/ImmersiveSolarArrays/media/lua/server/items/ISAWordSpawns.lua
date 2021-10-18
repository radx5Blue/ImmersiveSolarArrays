
test = false

function SpawnPanels()
	
	 local player = getPlayer()
	
	local square = getWorld():getCell():getGridSquare(4723, 7998, 0)
	
	
	
	if (calculateDistance(player:getX(), player:getY(), square:getX(), square:getY()) < 5 and test == false) then
		
	local sprite_type = tostring("solarmod_tileset_01_7")
    if not sprite_type then
        print("NO SPRITE TYPE!")
        return false
    end        
    local newSprite = (IsoObject.new(getCell(), square, sprite_type))    
    if not newSprite then
        print("NO NEW SPRITE!")
        return false
    end    
    if newSprite and newSprite:getProperties() then 
        if newSprite:getProperties():Val("ContainerType") or newSprite:getProperties():Val("container") then
             newSprite:createContainersFromSpriteProperties()                
        end
    end
    square:getObjects():add(newSprite)
    square:RecalcProperties()    
		
		

		test = true
		
		
		
		
		
		
		
	end
	
	
	
	
	
	
	
end



Events.OnPlayerUpdate.Add(SpawnPanels)