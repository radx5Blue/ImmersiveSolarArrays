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
        local noKey = tonumber(pKeys[key])
        local noX = tonumber(pX[key])
        local noY = tonumber(pY[key])
        local noZ = tonumber(pZ[key])
        local spawned = tonumber(hasSpawned[key])
		
		--print("******************* Spawned before: ", spawned)

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
					
					
				if sprite_type == "solarmod_tileset_01_36" then
					AddItemsToBox(panelSquare)
					newSprite:setOverlaySprite("solarmod_tileset_01_38") --set this because it don't autorefresh
					
					
					
				end

					hasSpawned[key] = 1
                    --table.insert(hasSpawned, key, 1)
					--print("******************* Spawned after: ", spawned)
					--print("******************* Has Spawned after: ", hasSpawned[key])
                end
            end
        end
    end
end



function AddItemsToBox(panelSquare)
	
	local fonSquare = ISMoveableSpriteProps:findOnSquare(panelSquare, "solarmod_tileset_01_36")
	local container = fonSquare:getContainer()
	--generate numbers:
	local panelnumber = ZombRand(4, 5) * SandboxVars.ISA.LRMSolarPanels
	local batterynumber = ZombRand(1, 2) * SandboxVars.ISA.LRMBatteries
	local miscnumber = 1 * SandboxVars.ISA.LRMMisc
		for i=1,panelnumber do 
			container:AddItem("ISA.SolarPanel") 
			container:AddItem("Radio.ElectricWire")
			container:AddItem("Radio.ElectricWire")
			container:AddItem("Radio.ElectricWire")
			container:AddItem("Base.MetalBar")
			container:AddItem("Base.MetalBar")
		end
		for i=1,batterynumber do 
			container:AddItem("ISA.DeepCycleBattery") 
		end
		for i=1,miscnumber do 
			container:AddItem("ISA.ISAInverter")
			container:AddItem("ISA.ISAMag1")
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

        local chance = 0
		local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4722)
            table.insert(spawnCellY, CellKeysNumber, 7997) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_07")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4743) --checked and working
            table.insert(spawnCellY, CellKeysNumber, 7848)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9656) --checked and working
            table.insert(spawnCellY, CellKeysNumber, 10156)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10254) --working
            table.insert(spawnCellY, CellKeysNumber, 8762)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9670) --working
            table.insert(spawnCellY, CellKeysNumber, 8775)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12482) 
            table.insert(spawnCellY, CellKeysNumber, 8879) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12477) --working
            table.insert(spawnCellY, CellKeysNumber, 8918)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12066) --checked and works
            table.insert(spawnCellY, CellKeysNumber, 7378)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13631) 
            table.insert(spawnCellY, CellKeysNumber, 7220) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9345)
            table.insert(spawnCellY, CellKeysNumber, 10292) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9671)
            table.insert(spawnCellY, CellKeysNumber, 8775) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4253)
            table.insert(spawnCellY, CellKeysNumber, 7228) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7460)
            table.insert(spawnCellY, CellKeysNumber, 7968) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11612)
            table.insert(spawnCellY, CellKeysNumber, 9295)
            table.insert(spawnCellZ, CellKeysNumber, 1) --working
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11588)
            table.insert(spawnCellY, CellKeysNumber, 9292)
            table.insert(spawnCellZ, CellKeysNumber, 1) --working
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10379)
            table.insert(spawnCellY, CellKeysNumber, 10098) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_9")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10182)
            table.insert(spawnCellY, CellKeysNumber, 6761) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10745)
            table.insert(spawnCellY, CellKeysNumber, 9843) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 8540)
            table.insert(spawnCellY, CellKeysNumber, 9037) --works as intended
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 8622)
            table.insert(spawnCellY, CellKeysNumber, 8824) 
            table.insert(spawnCellZ, CellKeysNumber, 1) -- User Suggested Spawn - Works
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11619)
            table.insert(spawnCellY, CellKeysNumber, 9961) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11619)
            table.insert(spawnCellY, CellKeysNumber, 9934) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11642)
            table.insert(spawnCellY, CellKeysNumber, 9762) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11644)
            table.insert(spawnCellY, CellKeysNumber, 9754) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11642)
            table.insert(spawnCellY, CellKeysNumber, 9744) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 9763) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10045) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10054) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10060) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10085) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		chance = ZombRand(1, 100) 
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5332)
            table.insert(spawnCellY, CellKeysNumber, 10558) 
            table.insert(spawnCellZ, CellKeysNumber, 0) -- User Suggested Farmhouse
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end
		
		--adding boxes here
		
		--riverside hardware:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 6363)
            table.insert(spawnCellY, CellKeysNumber, 5324) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end
		
		--west point hardware:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11971)
            table.insert(spawnCellY, CellKeysNumber, 6907) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end
		
		--dixie hardware:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7251) 
            table.insert(spawnCellY, CellKeysNumber, 8226) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end
		
		--The mall electronics:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13917)
            table.insert(spawnCellY, CellKeysNumber, 5786) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end
		
		--The mall hardware:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13916) 
            table.insert(spawnCellY, CellKeysNumber, 5804) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end
		
		--Army quarter warehouse:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9185)
            table.insert(spawnCellY, CellKeysNumber, 11828) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end
		
		--warehouse near rosewood:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 8279)
            table.insert(spawnCellY, CellKeysNumber, 10028) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end		

		--warehouse in muldraugh:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10698)
            table.insert(spawnCellY, CellKeysNumber, 10450) --may need to fix
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end		
		
		--warehouse in the countryside:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5878)
            table.insert(spawnCellY, CellKeysNumber, 9861) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--warehouse near valley station:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12621)
            table.insert(spawnCellY, CellKeysNumber, 4712) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--Secret military base:
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5541)
            table.insert(spawnCellY, CellKeysNumber, 12440) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		------------------------------------- NEW ONES -----------------------------------------
		--- Dixie
		---farming store
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7248)
            table.insert(spawnCellY, CellKeysNumber, 8313) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		-- general store
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7308)
            table.insert(spawnCellY, CellKeysNumber, 8248) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--warehouse
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7648)
            table.insert(spawnCellY, CellKeysNumber, 9331) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--warehouse
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 6548)
            table.insert(spawnCellY, CellKeysNumber, 8930) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--warehouse
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5878)
            table.insert(spawnCellY, CellKeysNumber, 9852) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--muldraugh
		-- warehouse
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10693) --need to check
            table.insert(spawnCellY, CellKeysNumber, 10099) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--elect store
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10623) --no work
            table.insert(spawnCellY, CellKeysNumber, 9890) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--garage
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10633)
            table.insert(spawnCellY, CellKeysNumber, 9375) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--railyard
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11618)
            table.insert(spawnCellY, CellKeysNumber, 9935) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--self storage
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10672)
            table.insert(spawnCellY, CellKeysNumber, 9819) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--storage
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10752)
            table.insert(spawnCellY, CellKeysNumber, 10344) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--warehouse 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10613)
            table.insert(spawnCellY, CellKeysNumber, 9311) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--warehouse 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10018)
            table.insert(spawnCellY, CellKeysNumber, 10913) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--warehouse 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10716)
            table.insert(spawnCellY, CellKeysNumber, 10419) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--Valley Station
		-- 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12828)
            table.insert(spawnCellY, CellKeysNumber, 6432) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--farm 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 14318)
            table.insert(spawnCellY, CellKeysNumber, 4947) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--farm 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13843)
            table.insert(spawnCellY, CellKeysNumber, 4748) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--West Point
		-- farm 
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11133)
            table.insert(spawnCellY, CellKeysNumber, 6861) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--hardwarestore
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11961)
            table.insert(spawnCellY, CellKeysNumber, 6920) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--warehouse
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12148)
            table.insert(spawnCellY, CellKeysNumber, 7099) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--storage
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12148)
            table.insert(spawnCellY, CellKeysNumber, 7074) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--hardware store
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11835)
            table.insert(spawnCellY, CellKeysNumber, 6916) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		-- warehouse
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9204)
            table.insert(spawnCellY, CellKeysNumber, 11823) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		-- Riverside
		-- farm
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7243)
            table.insert(spawnCellY, CellKeysNumber, 8285) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--self storage
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5541)
            table.insert(spawnCellY, CellKeysNumber, 6068) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		-- factory
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5577)
            table.insert(spawnCellY, CellKeysNumber, 5875) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
		--factory storage
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5628)
            table.insert(spawnCellY, CellKeysNumber, 5957) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		--farm
		chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5704)
            table.insert(spawnCellY, CellKeysNumber, 5717) 
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)	
        end	
		
		
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
