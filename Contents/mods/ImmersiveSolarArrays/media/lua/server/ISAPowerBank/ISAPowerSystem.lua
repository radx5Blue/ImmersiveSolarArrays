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
            local pbLD = ModData.get("PBLD")
            local pbCH = ModData.get("PBCH")
			local pbBO = ModData.get("PBBO")

            local pbkLen = #pbKey
            local newpbKLen = pbkLen + 1

            table.insert(pbKey, newpbKLen, newpbKLen)
            table.insert(pbX, newpbKLen, square:getX())
            table.insert(pbY, newpbKLen, square:getY())
            table.insert(pbZ, newpbKLen, square:getZ())
            table.insert(pbNP, newpbKLen, numberOfPanels)
            table.insert(pbLD, newpbKLen, "1")
            table.insert(pbCH, newpbKLen, "1") -- get charge here!! *******************************************************************************************
			table.insert(pbBO, newpbKLen, "1") 

            sqX = square:getX()
            sqY = square:getY()
            sqZ = square:getZ()

            print("Created Passed X: ", sqX)
            print("Created Passed Y: ", sqY)
            print("Created Passed Z: ", sqZ)
        end

        local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
        NewGenerator:setConnected(false)
        NewGenerator:setFuel(0)
        NewGenerator:setCondition(0)
        NewGenerator:setActivated(false)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()

        local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
        NewGenerator:setConnected(true)
        NewGenerator:setFuel(100)
        NewGenerator:setCondition(100)
        NewGenerator:setActivated(true)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()
        print("Solar Array Created")
    end
end

function DisconnectPower(square)
    sqX = square:getX()
    sqY = square:getY()
    sqZ = square:getZ()

    testK = ModData.get("PBK")
    testX = ModData.get("PBX")
    testY = ModData.get("PBY")
    testZ = ModData.get("PBZ")
    testNP = ModData.get("PBNP")
    testL = ModData.get("PBLD")
    testC = ModData.get("PBCH")
	 testB = ModData.get("PBBO")
    local pbkLen = #testK

    for key = 1, #testK do
        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])

        print("Removed Passed X: ", sqX)
        print("Removed Passed Y: ", sqY)
        print("Removed Passed Z: ", sqZ)

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            squareTest = getWorld():getCell():getGridSquare(sqX, sqY, sqZ)

            local NewGenerator = IsoGenerator.new(nil, square:getCell(), squareTest)
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
            table.remove(testNP, key, testNP)
            table.remove(testL, key, testL)
            table.remove(testC, key, testC)
			table.remove(testB, key, testB)
        end
    end
end

function CheckGlobalData()
    local powerBankKey = {}
    local powerBankX = {}
    local powerBankY = {}
    local powerBankZ = {}
    local NumberOfPanels = {}
    local PowerBankLoaded = {}
    local PowerBankCharge = {}
	local PowerBankOn = {}

    if ModData.exists("PBK") == false then
        ModData.add("PBK", powerBankKey)
        ModData.add("PBX", powerBankX)
        ModData.add("PBY", powerBankY)
        ModData.add("PBZ", powerBankZ)
        ModData.add("PBNP", NumberOfPanels)
        ModData.add("PBLD", PowerBankLoaded)
        ModData.add("PBCH", PowerBankCharge)
		ModData.add("PBBO", PowerBankCharge)
    end
end

function getModifiedSolarOutput(SolarInput)
    local myWeather = getClimateManager()
    local cloudiness = 1 - (myWeather:getCloudiness() * 0.25)
    local fogginess = 1 - (myWeather:getFogStrength() * 0.25)
    local currentHour = getGameTime():getHour()
    local output = SolarInput * 83
    output = output * cloudiness
    output = output * fogginess
    if currentHour < myWeather:getDawn() or currentHour > myWeather:getDusk() then
        --it's night, no power
        output = 0
    end
    return output
end

local function ReloadPower()
    local testK = ModData.get("PBK")
    local testX = ModData.get("PBX")
    local testY = ModData.get("PBY")
    local testZ = ModData.get("PBZ")
    local testNP = ModData.get("PBNP")
    local testL = ModData.get("PBLD")
    local testC = ModData.get("PBCH")
	local testB = ModData.get("PBBO")

    local pbkLen = #testK

    for key = 1, #testK do
        print("Check ModData Key: ", testK[key])
        print("Check ModData X: ", testX[key])
        print("Check ModData Y: ", testY[key])
        print("Check ModData Z: ", testZ[key])
        print("Check ModData NP: ", testNP[key])
        print("Check ModData LOADED: ", testL[key])
        print("Check ModData Charge: ", testC[key])

        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
        noPZ = tonumber(testNP[key])
        noLD = tonumber(testL[key])
        noCH = tonumber(testC[key])

        if (getWorld():getCell():getGridSquare(noX, noY, noZ) ~= nil) then
            local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

            local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
            NewGenerator:setConnected(false)
            NewGenerator:setFuel(0)
            NewGenerator:setCondition(0)
            NewGenerator:setActivated(false)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:remove()

            local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
            NewGenerator:setConnected(true)
            NewGenerator:setFuel(100)
            NewGenerator:setCondition(100)
            NewGenerator:setActivated(true)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:remove()
            testL[key] = "0"

            print("Solar Array Re-created")
        --print("Solar Array Re-created and: ", testL[key])
        end
    end
end

globalPCounter = 0
loc = true

function PowerCheck()
    local testK = ModData.get("PBK")
    local testX = ModData.get("PBX")
    local testY = ModData.get("PBY")
    local testZ = ModData.get("PBZ")
    local testNP = ModData.get("PBNP")
    local testL = ModData.get("PBLD")
    local testC = ModData.get("PBCH")
	local testB = ModData.get("PBBO")

    globalPCounter = globalPCounter + 1

    print(globalPCounter)

    for key = 1, #testK do
        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
        noPZ = tonumber(testNP[key])
        noLD = tonumber(testL[key])
        noCH = tonumber(testC[key])
		noPB = tonumber(testB[key])

        local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

        if (square ~= nil and globalPCounter > 500 and loc == false and noPB == 1 ) then
            local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
            NewGenerator:setConnected(false)
            NewGenerator:setFuel(0)
            NewGenerator:setCondition(0)
            NewGenerator:setActivated(false)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:remove()

            local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
            NewGenerator:setConnected(true)
            NewGenerator:setFuel(100)
            NewGenerator:setCondition(100)
            NewGenerator:setActivated(true)
            NewGenerator:remove()

            globalPCounter = 0

            loc = true

            print("Created")
        end

        if (globalPCounter > 400 and loc == true) then
            loc = false
            globalPCounter = 0
            print("Not Created")
        end
    end
end

function chargeLogic()
    local testK = ModData.get("PBK")
    local testX = ModData.get("PBX")
    local testY = ModData.get("PBY")
    local testZ = ModData.get("PBZ")
    local testNP = ModData.get("PBNP")
    local testL = ModData.get("PBLD")
    local testC = ModData.get("PBCH")
	local testB = ModData.get("PBBO")

    local pbkLen = #testK

    for key = 1, #testK do
        print("Check ModData Key: ", testK[key])
        print("Check ModData X: ", testX[key])
        print("Check ModData Y: ", testY[key])
        print("Check ModData Z: ", testZ[key])
        print("Check ModData NP: ", testNP[key])
        print("Check ModData LOADED: ", testL[key])
        print("Check ModData Charge: ", testC[key])
		print("Check ModData On: ", testB[key])

        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
        noPZ = tonumber(testNP[key])
        noLD = tonumber(testL[key])
        noCH = tonumber(testC[key])
		noOff = tonumber(testB[key]) 

        local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

        if (square ~= nil) then
            local updatedCH = 0
			local inventory = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0"):getContainer()
			local capacity = HandleBatteries(inventory, noCH, false)
			local batterynumber = HandleBatteries(inventory, noCH, true)
			local drain = solarscan(square, false, true, false, 0)
			local input = getModifiedSolarOutput(noPZ)
			local actualCharge = capacity * noCH
			local difference = input - drain

			

			updatedCH = (actualCharge + difference / 6) / capacity -- uh, divide by 6 I guess because we're doing this every 10 mins and not hourly
			
			--make sure charge is within bounds
			if updatedCH > 1 then
			 updatedCH = 1
			end
			if updatedCH < 0 then
			 updatedCH = 0
			end
			
			--shutdown logic goes below
			if actualCharge <= 0 and difference < 0 and noOff ~= 0 then
				noOff = 0
				table.insert(testB, key, noOff)  
				------------------------------turn off
				local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
				NewGenerator:setConnected(false)
				NewGenerator:setFuel(0)
				NewGenerator:setCondition(0)
				NewGenerator:setActivated(false)
				NewGenerator:setSurroundingElectricity()
				NewGenerator:remove()
			end
			if actualCharge <= 0 and difference > 0 and noOff == 0 then
				noOff = 1
				table.insert(testB, key, noOff)  
				-------------------------------turn on
				local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
				NewGenerator:setConnected(true)
				NewGenerator:setFuel(100)
				NewGenerator:setCondition(100)
				NewGenerator:setActivated(true)
				NewGenerator:setSurroundingElectricity()
				NewGenerator:remove()

			end
			
			--TODO: sprite handling
			
        

        table.insert(testC, key, updatedCH)  
        end
    end
end

Events.EveryTenMinutes.Add(chargeLogic)
Events.OnTick.Add(PowerCheck)
Events.OnGameStart.Add(CheckGlobalData)
Events.OnGameStart.Add(ReloadPower)
