function SpawnPanels()
	
	 local player = getPlayer()
	 
	local pKeys = ModData.get("SpawnCellKeys")
    local pX = ModData.get("SpawnCellX")
    local pY = ModData.get("SpawnCellY")
    local pZ = ModData.get("SpawnCellZ")
    local pType = ModData.get("SpawnCellType")
	

    local keyIndex = #pKeys

    for key = 1, #pKeys do
		
        noKey = tonumber(pKeys[key])
        noX = tonumber(pX[key])
        noY = tonumber(pY[key])
        noZ = tonumber(pZ[key])

	local square = getWorld():getCell():getGridSquare(noX, noY, noZ)
	
	if square ~= nil then
	if (calculateDistance(player:getX(), player:getY(), square:getX(), square:getY()) < 5 and test == false) then
		
	local sprite_type = tostring(pType[key])
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
	
	player:Say("Solars")
	
	table.remove(pKeys, key, key)
    table.remove(pX, key, noX)
    table.remove(pY, key, noY)
    table.remove(pZ, key, noZ)
    table.remove(pType, key, pType)
     end
		
		

	
	
	end
	
end
	
	
	
	
	
	
	
end


function SpawnRolls()
	
	local spawnCellKeys = {}
	local spawnCellX = {}
	local spawnCellY = {}
	local spawnCellZ = {}
	local spawnCellType = {}
	--local spawnCellChance = {}
	--local spawnCellHasSpawned = {}


    if ModData.exists("SpawnCellKeys") == false then

		
		local CellKeysNumber = 0
		
		table.insert(spawnCellKeys, CellKeysNumber + 1, CellKeysNumber + 1)
		table.insert(spawnCellX, CellKeysNumber, 4723)
		table.insert(spawnCellY, CellKeysNumber, 7997)
		table.insert(spawnCellZ, CellKeysNumber, 0)
		table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
		
		
		table.insert(spawnCellKeys, CellKeysNumber + 1, CellKeysNumber + 1)
		table.insert(spawnCellX, CellKeysNumber, 4744)
		table.insert(spawnCellY, CellKeysNumber, 7849)
		table.insert(spawnCellZ, CellKeysNumber, 0)
		table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
		
		
		ModData.add("SpawnCellKeys", spawnCellKeys)
		ModData.add("SpawnCellX", spawnCellX)
		ModData.add("SpawnCellY", spawnCellY)
		ModData.add("SpawnCellZ", spawnCellZ)
		ModData.add("SpawnCellType", spawnCellType)
		--ModData.add("SpawnCellChance", spawnCellChance)
		--ModData.add("SpawnCellHasSpawned", spawnCellHasSpawned)
		
	end

	
	
	
end


Events.OnPlayerUpdate.Add(SpawnPanels)
Events.OnGameStart.Add(SpawnRolls)