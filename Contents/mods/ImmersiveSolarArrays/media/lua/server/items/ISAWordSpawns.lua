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

        local chance = 0

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4723)
            table.insert(spawnCellY, CellKeysNumber, 7997)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4744)
            table.insert(spawnCellY, CellKeysNumber, 7849)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9657)
            table.insert(spawnCellY, CellKeysNumber, 10157)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10254)
            table.insert(spawnCellY, CellKeysNumber, 8763)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9671)
            table.insert(spawnCellY, CellKeysNumber, 8776)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12483)
            table.insert(spawnCellY, CellKeysNumber, 8880)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12477)
            table.insert(spawnCellY, CellKeysNumber, 8919)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12067)
            table.insert(spawnCellY, CellKeysNumber, 7379)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13632)
            table.insert(spawnCellY, CellKeysNumber, 7220)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9346)
            table.insert(spawnCellY, CellKeysNumber, 10299)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9672)
            table.insert(spawnCellY, CellKeysNumber, 8776)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4254)
            table.insert(spawnCellY, CellKeysNumber, 7229)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7461)
            table.insert(spawnCellY, CellKeysNumber, 7969)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11613)
            table.insert(spawnCellY, CellKeysNumber, 9296)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11589)
            table.insert(spawnCellY, CellKeysNumber, 9293)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10380)
            table.insert(spawnCellY, CellKeysNumber, 10099)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_9")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 10)
        if chance >= 5 then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10186)
            table.insert(spawnCellY, CellKeysNumber, 6769)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
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
