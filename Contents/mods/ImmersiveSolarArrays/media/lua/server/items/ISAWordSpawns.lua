function SpawnPanels()
	
	 local player = getPlayer()
	 
	local pKeys = ModData.get("SpawnCellKeys")
    local pX = ModData.get("SpawnCellX")
    local pY = ModData.get("SpawnCellY")
    local pZ = ModData.get("SpawnCellZ")
    local pType = ModData.get("SpawnCellType")
	 local hasSpawned = ModData.get("SpawnCellSpawned")
	

    local keyIndex = #pKeys

    for key = 1, #pKeys do
		
     local   noKey = tonumber(pKeys[key])
      local  noX = tonumber(pX[key])
      local  noY = tonumber(pY[key])
      local  noZ = tonumber(pZ[key])
	  local  spawned = tonumber(hasSpawned[key])
	  
	  
	 if spawned == 0 then

	local panelSquare = getWorld():getCell():getGridSquare(noX, noY, noZ)
	
	if panelSquare ~= nil then
	if (calculateDistance(player:getX(), player:getY(), panelSquare:getX(), panelSquare:getY()) < 70) then
		
	local sprite_type = tostring(pType[key])
    if not sprite_type then
        print("NO SPRITE TYPE!")
        return false
    end        
    local newSprite = (IsoObject.new(getCell(), panelSquare, sprite_type))    
    if not newSprite then
        print("NO NEW SPRITE!")
        return false
    end    
    if newSprite and newSprite:getProperties() then 
        if newSprite:getProperties():Val("ContainerType") or newSprite:getProperties():Val("container") then
             newSprite:createContainersFromSpriteProperties()                
        end
    end
    panelSquare:getObjects():add(newSprite)
    panelSquare:RecalcProperties()    
	
	--player:Say("Solars")
	
	table.insert(hasSpawned, key, 1)
	
    end
		
		

	
	
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
	local spawnCellSpawned = {}
	--local spawnCellChance = {}
	--local spawnCellHasSpawned = {}


    if ModData.exists("SpawnCellKeys") == false then

		
		local CellKeysNumber = 0
		
		CellKeysNumber = CellKeysNumber + 1
		table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
		table.insert(spawnCellX, CellKeysNumber, 4723)
		table.insert(spawnCellY, CellKeysNumber, 7997)
		table.insert(spawnCellZ, CellKeysNumber, 0)
		table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
		table.insert(spawnCellSpawned, CellKeysNumber, 0)
		
		CellKeysNumber = CellKeysNumber + 1
		table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
		table.insert(spawnCellX, CellKeysNumber, 4744)
		table.insert(spawnCellY, CellKeysNumber, 7849)
		table.insert(spawnCellZ, CellKeysNumber, 0)
		table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
		table.insert(spawnCellSpawned, CellKeysNumber, 0)
		
		
		ModData.add("SpawnCellKeys", spawnCellKeys)
		ModData.add("SpawnCellX", spawnCellX)
		ModData.add("SpawnCellY", spawnCellY)
		ModData.add("SpawnCellZ", spawnCellZ)
		ModData.add("SpawnCellType", spawnCellType)
		ModData.add("SpawnCellSpawned", spawnCellSpawned)
		--ModData.add("SpawnCellChance", spawnCellChance)
		--ModData.add("SpawnCellHasSpawned", spawnCellHasSpawned)
		
	end

	
	
	
end


Events.OnPlayerUpdate.Add(SpawnPanels)
Events.OnGameStart.Add(SpawnRolls)