function TurnOnPower(powerConsumption, numberOfPanels, square, createKey)
    -- testK = ModData.get("PBK")
    -- testX = ModData.get("PBX")
    -- testY = ModData.get("PBY")
    -- testZ = ModData.get("PBZ")

    -- print("ModData Key: ", testK[key])
    -- print("ModData X: ",testX[key])
    -- print("ModData Y: ",testY[key])
    -- print("ModData Z: ",testZ[key])

    -- noKey = tonumber(testK[key])
    -- noX = tonumber(testX[key])
    -- noY = tonumber(testY[key])
    -- noZ = tonumber(testZ[key])

    -- local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

    if numberOfPanels > powerConsumption then
        if createKey == true then
            local pbKey = ModData.get("PBK")
            local pbX = ModData.get("PBX")
            local pbY = ModData.get("PBY")
            local pbZ = ModData.get("PBZ")
			local pbNP = ModData.get("PBNP")

            local pbkLen = #pbKey
            local newpbKLen = pbkLen + 1

            table.insert(pbKey, newpbKLen, newpbKLen)
            table.insert(pbX, newpbKLen, square:getX())
            table.insert(pbY, newpbKLen, square:getY())
            table.insert(pbZ, newpbKLen, square:getZ())
			table.insert(pbNP, newpbKLen, numberOfPanels)

            sqX = square:getX()
            sqY = square:getY()
            sqZ = square:getZ()

            print("Created Passed X: ", sqX)
            print("Created Passed Y: ", sqY)
            print("Created Passed Z: ", sqZ)
        end

        -- might need to 'remove' a generator first if one is here so it doesn't create a new one on top of one that exists
		
		player = getPlayer()

        local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
        NewGenerator:setConnected(false)
        NewGenerator:setFuel(0)
        NewGenerator:setCondition(0)
        NewGenerator:setActivated(false)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()

        local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
        NewGenerator:setConnected(true)
        NewGenerator:setFuel(100)
        NewGenerator:setCondition(100)
        NewGenerator:setActivated(true)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()
        print("Solar Array Created")
    end
end

function PowerCheck()
    testK = ModData.get("PBK")
    testX = ModData.get("PBX")
    testY = ModData.get("PBY")
    testZ = ModData.get("PBZ")
	testNP = ModData.get("PBNP")

    local pbkLen = #testK

    for key = 1, #testK do
        print("Check ModData Key: ", testK[key])
        print("Check ModData X: ", testX[key])
        print("Check ModData Y: ", testY[key])
        print("Check ModData Z: ", testZ[key])

        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
		noPZ = tonumber(testNP[key])

        local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

		if square ~= nil then
			
		player = getPlayer()

        local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
        NewGenerator:setConnected(false)
        NewGenerator:setFuel(0)
        NewGenerator:setCondition(0)
        NewGenerator:setActivated(false)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()

        local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
        NewGenerator:setConnected(true)
        NewGenerator:setFuel(100)
        NewGenerator:setCondition(100)
        NewGenerator:setActivated(true)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()
        print("Solar Array Re-created")
			
			
		end
	
		
    end

    -- --getPlayer():Say("DONE!!")

    -- -- local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

    -- -- if numberOfPanels > powerConsumption then

    -- -- local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
    -- -- NewGenerator:setConnected(true)
    -- -- NewGenerator:setFuel(100)
    -- -- NewGenerator:setCondition(100)
    -- -- NewGenerator:setActivated(true)
    -- -- NewGenerator:setSurroundingElectricity()
    -- -- NewGenerator:remove()
    -- -- end
end

function DisconnectPower(square)
    sqX = square:getX()
    sqY = square:getY()
    sqZ = square:getZ()

    testK = ModData.get("PBK")
    testX = ModData.get("PBX")
    testY = ModData.get("PBY")
    testZ = ModData.get("PBZ")

    local pbkLen = #testK

    for key = 1, #testK do
        -- print("ModData Key: ", testK[key])
        -- print("ModData X: ",testX[key])
        -- print("ModData Y: ",testY[key])
        -- print("ModData Z: ",testZ[key])

        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])

        --print("ModData Key: ", testK[key])
        --print("ModData X: ",testX[key])
        --print("ModData Y: ",testY[key])
        --print("ModData Z: ",testZ[key])

        --print("ModData Key: ", testK[key])
        print("Removed Passed X: ", sqX)
        print("Removed Passed Y: ", sqY)
        print("Removed Passed Z: ", sqZ)

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            squareTest = getWorld():getCell():getGridSquare(sqX, sqY, sqZ)

            player = getPlayer()

            local NewGenerator = IsoGenerator.new(nil, player:getCell(), squareTest)
            NewGenerator:setFuel(0)
            NewGenerator:setCondition(0)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:setActivated(false)
            NewGenerator:remove()
            print("removed")

            table.remove(testK, key, key)
            table.remove(testX, key, sqX)
            table.remove(testY, key, sqY)
            table.remove(testZ, key, sqZ)

        --ModData.remove(noKey)
        --ModData.remove(noX)
        --ModData.remove(noY)
        --ModData.remove(noZ)
        end
    end

    -- local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

    -- if numberOfPanels > powerConsumption then

    -- local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
    -- NewGenerator:setConnected(true)
    -- NewGenerator:setFuel(100)
    -- NewGenerator:setCondition(100)
    -- NewGenerator:setActivated(true)
    -- NewGenerator:setSurroundingElectricity()
    -- NewGenerator:remove()
    -- end
end

function SetUpGlobalData()
    local powerBankKey = {}
    local powerBankX = {}
    local powerBankY = {}
    local powerBankZ = {}
	local NumberOfPanels = {}

    ModData.add("PBK", powerBankKey)
    ModData.add("PBX", powerBankX)
    ModData.add("PBY", powerBankY)
    ModData.add("PBZ", powerBankZ)
	ModData.add("PBNP", NumberOfPanels)
end

Events.OnNewGame.Add(SetUpGlobalData)
Events.EveryTenMinutes.Add(PowerCheck)
