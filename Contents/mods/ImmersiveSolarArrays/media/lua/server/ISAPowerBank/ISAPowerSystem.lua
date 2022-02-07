function TurnOnPower(powerConsumption, numberOfPanels, square, createKey)
    local ISASolarEfficiency = SandboxVars.ISA.solarPanelEfficiency
    if SandboxVars.ISA.solarPanelEfficiency == nil then
        ISASolarEfficiency = 90
    end

    local player = getPlayer()

    print("numberOfPanels: ", numberOfPanels * ISASolarEfficiency)
    print("powerConsumption: ", powerConsumption)

    if createKey == true then
        local pbKey = ModData.get("PBK")
        local pbX = ModData.get("PBX")
        local pbY = ModData.get("PBY")
        local pbZ = ModData.get("PBZ")
        local pbNP = ModData.get("PBNP")
        local pbLD = ModData.get("PBLD")
        local pbCH = ModData.get("PBCH")
        local pbBO = ModData.get("PBBO")
        local pbGN = ModData.get("PBGN")

        local pbkLen = #pbKey
        local newpbKLen = pbkLen + 1

        table.insert(pbKey, newpbKLen, newpbKLen)
        table.insert(pbX, newpbKLen, square:getX())
        table.insert(pbY, newpbKLen, square:getY())
        table.insert(pbZ, newpbKLen, square:getZ())
        table.insert(pbNP, newpbKLen, numberOfPanels)
        table.insert(pbLD, newpbKLen, 1)
        table.insert(pbCH, newpbKLen, 0) -- get charge here!! *******************************************************************************************
        table.insert(pbBO, newpbKLen, 0)
        table.insert(pbGN, newpbKLen, 0)

        sqX = square:getX()
        sqY = square:getY()
        sqZ = square:getZ()
    end

    if numberOfPanels * (83 * ((ISASolarEfficiency * 1.25) / 100)) > powerConsumption then
        local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
        NewGenerator:setConnected(true)
        NewGenerator:setFuel(100)
        NewGenerator:setCondition(100)
        NewGenerator:setActivated(true)
        NewGenerator:setSurroundingElectricity()
        NewGenerator:remove()

        if square:getBuilding() ~= nil then
            square:getBuilding():setToxic(false)
        end
        sqX = square:getX()
        sqY = square:getY()
        sqZ = square:getZ()

        testK = ModData.get("PBK")
        testX = ModData.get("PBX")
        testY = ModData.get("PBY")
        testZ = ModData.get("PBZ")
        testB = ModData.get("PBBO")
        local pbkLen = #testK

        for key = 1, #testK do
            noX = tonumber(testX[key])
            noY = tonumber(testY[key])
            noZ = tonumber(testZ[key])

            if (sqX == noX and sqY == noY and sqZ == noZ) then
                table.insert(testB, key, 1)
                print("setting noOff to 1")
            end
        end
    else
        sqX = square:getX()
        sqY = square:getY()
        sqZ = square:getZ()

        testK = ModData.get("PBK")
        testX = ModData.get("PBX")
        testY = ModData.get("PBY")
        testZ = ModData.get("PBZ")
        testB = ModData.get("PBBO")
        local pbkLen = #testK

        for key = 1, #testK do
            noX = tonumber(testX[key])
            noY = tonumber(testY[key])
            noZ = tonumber(testZ[key])

            if (sqX == noX and sqY == noY and sqZ == noZ) then
                table.insert(testB, key, 0)
                print("setting noOff to 0")
            end
        end
    end

    liteModeFunction(square)
end

function ResetBank(square, charge)
    solarscan(square, false, true, true, 0)

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

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            table.insert(testC, key, charge)
        end
    end
end

-- ---------sprite fix:---------
-- ISInventoryTransferAction.OriginaltransferItem = ISInventoryTransferAction.transferItem -- we save the original function so we can run it as well as our code
-- function ISInventoryTransferAction:transferItem(item)
-- local res = self:OriginaltransferItem(item)
-- print("testing")
-- local bankfinal = nil
-- local bank1 = nil
-- local bank2 = nil
-- local adding = nil
-- local container = nil
-- local updatedCH = 0
-- local batterynumber = 0

-- if self.srcContainer:getSourceGrid() ~= nil then
-- --print("src sqr found")
-- bank1 = ISMoveableSpriteProps:findOnSquare(self.srcContainer:getSourceGrid(), "solarmod_tileset_01_0")
-- if bank1 ~= nil then
-- container = bank1:getContainer()
-- end
-- end
-- if self.destContainer:getSourceGrid() ~= nil then
-- --print("dest sqr found")
-- bank2 = ISMoveableSpriteProps:findOnSquare(self.destContainer:getSourceGrid(), "solarmod_tileset_01_0")
-- if bank2 ~= nil then
-- container = bank2:getContainer()
-- end
-- end
-- if bank1 ~= nil then
-- --print("src is bank")
-- bankfinal = bank1
-- adding = false
-- elseif bank2 ~= nil then
-- --print("dest is bank")
-- bankfinal = bank2
-- adding = true
-- end
-- if bank1 == nil and bank2 == nil then
-- -- print("stopping now")
-- return res
-- end
-- if bankfinal ~= nil and container ~= nil then
-- --print("looks like someone is transferring items to/from a powerbank")
-- local square = bankfinal:getSquare()
-- --print(square)
-- local charge = getBankCharge(square)
-- local updatedCH = getBankCharge(square) --remove this line later when done
-- -- print(charge)
-- if charge ~= nil and adding == true then
-- local type = item:getType()
-- local batterypower = item:getUsedDelta()
-- local capacity = 0
-- local cond = 1 - (item:getCondition()/100)
-- local condition = 1 - (cond*cond*cond*cond*cond*cond)
-- local isBattery = false
-- if type == "50AhBattery" and item:getCondition() > 0 then
-- capacity = 50 * condition
-- isBattery = true
-- end
-- if type == "75AhBattery" and item:getCondition() > 0 then
-- capacity = 75 * condition
-- isBattery = true
-- end
-- if type == "100AhBattery" and item:getCondition() > 0 then
-- capacity = 100 * condition
-- isBattery = true
-- end
-- if type == "DeepCycleBattery" and item:getCondition() > 0 then
-- capacity = 200 * condition
-- isBattery = true
-- end
-- if type == "SuperBattery" and item:getCondition() > 0 then
-- capacity = 400 * condition
-- isBattery = true
-- end
-- if type == "DIYBattery" and item:getCondition() > 0 then
-- local ISADIYBatteryCapacity = SandboxVars.ISA.DIYBatteryCapacity
-- if SandboxVars.ISA.DIYBatteryCapacity == nil then
-- ISADIYBatteryCapacity = 200
-- end
-- capacity = ISADIYBatteryCapacity * condition
-- isBattery = true
-- end
-- --get the bank's capacity
-- local bankcapacity = 0
-- for i = 1, container:getItems():size() do
-- local itemx = container:getItems():get(i - 1)
-- local type = itemx:getType()
-- local condx = 1 - (itemx:getCondition()/100)
-- local conditionx = 1 - (condx*condx*condx*condx*condx*condx)
-- if type == "50AhBattery" and itemx:getCondition() > 0 then
-- bankcapacity = bankcapacity + 50 * conditionx
-- batterynumber = batterynumber + 1
-- end
-- if type == "75AhBattery" and itemx:getCondition() > 0 then
-- bankcapacity = bankcapacity + 75 * conditionx
-- batterynumber = batterynumber + 1
-- end
-- if type == "100AhBattery" and itemx:getCondition() > 0 then
-- bankcapacity = bankcapacity + 100 * conditionx
-- batterynumber = batterynumber + 1
-- end
-- if type == "DeepCycleBattery" and itemx:getCondition() > 0 then
-- bankcapacity = bankcapacity + 200 * conditionx
-- batterynumber = batterynumber + 1
-- end
-- if type == "SuperBattery" and itemx:getCondition() > 0 then
-- bankcapacity = bankcapacity + 400 * conditionx
-- batterynumber = batterynumber + 1
-- end
-- if type == "DIYBattery" and itemx:getCondition() > 0 then
-- local ISADIYBatteryCapacity = SandboxVars.ISA.DIYBatteryCapacity
-- if SandboxVars.ISA.DIYBatteryCapacity == nil then
-- ISADIYBatteryCapacity = 200
-- end
-- bankcapacity = bankcapacity + ISADIYBatteryCapacity * conditionx
-- batterynumber = batterynumber + 1
-- end
-- end
-- if isBattery == true then
-- -- print("doing Advanced(TM) charge math!")
-- --do Advanced(TM) charge math!
-- local newbatteryamount = batterypower * capacity -- bat charge in Ah
-- local oldbatteryamount = bankcapacity * charge -- bank charge in Ah
-- --add up and divive
-- -- print("newbatteryamount")
-- -- print(newbatteryamount)
-- -- print("oldbatteryamount")
-- -- print(oldbatteryamount)
-- local systemtotal = (newbatteryamount + oldbatteryamount)
-- local systemmax = capacity + bankcapacity
-- -- print("systemtotal")
-- -- print(systemtotal)
-- -- print("systemmax")
-- --print(systemmax)
-- updatedCH = systemtotal / systemmax
-- -- print("updatedCH")
-- --print(updatedCH)
-- --got it, now set the charge!
-- item:setUsedDelta(updatedCH)
-- for i = 1, container:getItems():size() do
-- local itemx = container:getItems():get(i - 1)
-- local type = itemx:getType()
-- if
-- type == "50AhBattery" or type == "75AhBattery" or type == "100AhBattery" or
-- type == "DeepCycleBattery" or type == "SuperBattery" or type == "DIYBattery"
-- then
-- itemx:setUsedDelta(updatedCH)
-- end
-- end
-- setBankCharge(square, updatedCH)
-- end
-- elseif charge == nil and isBattery == true then
-- updatedCH = batterypower
-- elseif charge == nil and isBattery == false then
-- updatedCH = 0
-- end
-- --fix the sprites!
-- if adding == false then
-- for i = 1, container:getItems():size() do
-- local itemx = container:getItems():get(i - 1)
-- local type = itemx:getType()
-- if type == "50AhBattery" then
-- batterynumber = batterynumber + 1
-- end
-- if type == "75AhBattery" then
-- batterynumber = batterynumber + 1
-- end
-- if type == "100AhBattery" then
-- batterynumber = batterynumber + 1
-- end
-- if type == "DeepCycleBattery" then
-- batterynumber = batterynumber + 1
-- end
-- if type == "SuperBattery" then
-- batterynumber = batterynumber + 1
-- end
-- if type == "DIYBattery" then
-- batterynumber = batterynumber + 1
-- end
-- end
-- end
-- local batterybank = bankfinal
-- if updatedCH < 0.25 then
-- --batterybank:setOverlaySprite(nil)
-- --show 0 charge
-- if batterynumber == 0 then
-- batterybank:setOverlaySprite(nil)
-- elseif batterynumber > 0 and batterynumber < 5 then
-- --show bottom shelf
-- batterybank:setOverlaySprite("solarmod_tileset_01_1")
-- elseif batterynumber >= 5 and batterynumber < 9 then
-- --show two shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_2")
-- elseif batterynumber >= 9 and batterynumber < 13 then
-- --show three shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_3")
-- elseif batterynumber >= 13 and batterynumber < 17 then
-- --show four shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_4")
-- elseif batterynumber >= 17 then
-- --show five shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_5")
-- end
-- elseif updatedCH >= 0.25 and updatedCH < 0.50 then
-- --
-- --show 25 charge
-- if batterynumber == 0 then
-- batterybank:setOverlaySprite(nil)
-- elseif batterynumber > 0 and batterynumber < 5 then
-- --show bottom shelf
-- batterybank:setOverlaySprite("solarmod_tileset_01_16")
-- elseif batterynumber >= 5 and batterynumber < 9 then
-- --show two shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_20")
-- elseif batterynumber >= 9 and batterynumber < 13 then
-- --show three shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_24")
-- elseif batterynumber >= 13 and batterynumber < 17 then
-- --show four shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_28")
-- elseif batterynumber >= 17 then
-- --show five shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_32")
-- end
-- elseif updatedCH >= 0.50 and updatedCH < 0.75 then
-- --batterybank:setOverlaySprite("solarmod_tileset_01_12")
-- -- show 50 charge
-- if batterynumber == 0 then
-- batterybank:setOverlaySprite(nil)
-- elseif batterynumber > 0 and batterynumber < 5 then
-- --show bottom shelf
-- batterybank:setOverlaySprite("solarmod_tileset_01_17")
-- elseif batterynumber >= 5 and batterynumber < 9 then
-- --show two shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_21")
-- elseif batterynumber >= 9 and batterynumber < 13 then
-- --show three shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_25")
-- elseif batterynumber >= 13 and batterynumber < 17 then
-- --show four shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_29")
-- elseif batterynumber >= 17 then
-- --show five shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_33")
-- end
-- elseif updatedCH >= 0.75 and updatedCH < 0.95 then
-- --batterybank:setOverlaySprite("solarmod_tileset_01_13")
-- -- show 75 charge
-- if batterynumber == 0 then
-- batterybank:setOverlaySprite(nil)
-- elseif batterynumber > 0 and batterynumber < 5 then
-- --show bottom shelf
-- batterybank:setOverlaySprite("solarmod_tileset_01_18")
-- elseif batterynumber >= 5 and batterynumber < 9 then
-- --show two shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_22")
-- elseif batterynumber >= 9 and batterynumber < 13 then
-- --show three shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_26")
-- elseif batterynumber >= 13 and batterynumber < 17 then
-- --show four shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_30")
-- elseif batterynumber >= 17 then
-- --show five shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_34")
-- end
-- elseif updatedCH >= 0.95 then
-- --show 100 charge
-- if batterynumber == 0 then
-- batterybank:setOverlaySprite(nil)
-- elseif batterynumber > 0 and batterynumber < 5 then
-- --show bottom shelf
-- batterybank:setOverlaySprite("solarmod_tileset_01_19")
-- elseif batterynumber >= 5 and batterynumber < 9 then
-- --show two shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_23")
-- elseif batterynumber >= 9 and batterynumber < 13 then
-- --show three shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_27")
-- elseif batterynumber >= 13 and batterynumber < 17 then
-- --show four shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_31")
-- elseif batterynumber >= 17 then
-- --show five shelves
-- batterybank:setOverlaySprite("solarmod_tileset_01_35")
-- end
-- end
-- end
-- return res
-- end

function getBankCharge(square) -- get the battery bank charge and stores it for later
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

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            return (tonumber(testC[key]))
        end
    end
end

function setBankCharge(square, charge)
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

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            table.insert(testC, key, charge)
        end
    end
end

---end sprite fix-------------

function changePanelData(square, noOfPanels)
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

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            squareTest = getWorld():getCell():getGridSquare(sqX, sqY, sqZ)

            table.insert(testNP, key, noOfPanels)
            local pc = solarscan(squareTest, false, true, false, 0)
            print("pc: ", pc)
            TurnOnPower(pc, noOfPanels, squareTest, false)
            liteModeFunction(squareTest)
        end
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

        -- print("Removed Passed X: ", sqX)
        -- print("Removed Passed Y: ", sqY)
        -- print("Removed Passed Z: ", sqZ)

        if (sqX == noX and sqY == noY and sqZ == noZ) then
            squareTest = getWorld():getCell():getGridSquare(sqX, sqY, sqZ)

            local NewGenerator = IsoGenerator.new(nil, square:getCell(), squareTest)
            NewGenerator:setFuel(0)
            NewGenerator:setCondition(0)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:setActivated(false)
            NewGenerator:remove()
            --  print("removed")

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
    local PowerBankGen = {}
    local PowerBankLiteDrain = {}
    local PowerBankLiteMode = {}

    if ModData.exists("PBK") == false then
        ModData.add("PBK", powerBankKey)
        ModData.add("PBX", powerBankX)
        ModData.add("PBY", powerBankY)
        ModData.add("PBZ", powerBankZ)
        ModData.add("PBNP", NumberOfPanels)
        ModData.add("PBLD", PowerBankLoaded)
        ModData.add("PBCH", PowerBankCharge)
        ModData.add("PBBO", PowerBankOn)
        ModData.add("PBGN", PowerBankGen)
    end

    if ModData.exists("PBGN") == false then
        ModData.add("PBGN", PowerBankGen)
    end

    if ModData.exists("PBLiteDrain") == false then
        ModData.add("PBLiteDrain", PowerBankLiteDrain)
        ModData.add("PBLiteMode", PowerBankLiteMode)
        table.insert(PowerBankLiteMode, 1, 0)
    end
end

function getModifiedSolarOutput(SolarInput)
    local myWeather = getClimateManager()
    local currentHour = getGameTime():getHour()
    local ISASolarEfficiency = SandboxVars.ISA.solarPanelEfficiency
    if SandboxVars.ISA.solarPanelEfficiency == nil then
        ISASolarEfficiency = 90
    end

    -- print("My weather: ", myWeather)
    -- print("My time: ", currentHour)
    local cloudiness = getClimateManager():getCloudIntensity()
    local light = getClimateManager():getDayLightStrength()
    local fogginess = getClimateManager():getFogIntensity()
    local CloudinessFogginessMean = 1 - (((cloudiness + fogginess) / 2) * 0.25) --make it so that clouds and fog can only reduce output by 25%
    local output = SolarInput * (83 * ((ISASolarEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
    local temperature = getClimateManager():getTemperature()
    local temperaturefactor = temperature * -0.0035 + 1.1 --based on linear single crystal sp efficiency
    output = output * CloudinessFogginessMean
    output = output * temperaturefactor
    output = output * light
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
        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
        noPZ = tonumber(testNP[key])
        noLD = tonumber(testL[key])
        noCH = tonumber(testC[key])
        noPB = tonumber(testB[key])

        if (getWorld():getCell():getGridSquare(noX, noY, noZ) ~= nil and noPB == 1) then
            local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

            GenRemove(square)

            local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
            NewGenerator:setConnected(true)
            NewGenerator:setFuel(100)
            NewGenerator:setCondition(100)
            NewGenerator:setActivated(true)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:remove()
            testL[key] = "0"

            if square:getBuilding() ~= nil then
                square:getBuilding():setToxic(false)
            end

            --GenRemove(square)

            print("Solar Array Reloaded")
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

	if testK ~= nil then

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

        if (square ~= nil and globalPCounter > 1500 and loc == false and noPB == 1 and noLD == 1 and noCH > 0) then
            local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
            NewGenerator:setConnected(true)
            NewGenerator:setFuel(100)
            NewGenerator:setCondition(100)
            NewGenerator:setActivated(true)
            NewGenerator:remove()

            if square:getBuilding() ~= nil then
                square:getBuilding():setToxic(false)
            end

            loc = true
            table.insert(testL, key, 0)
        end

        if (globalPCounter > 1500 and loc == true and noLD == 0) then
            loc = false
            globalPCounter = 0
        end
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

    local liteMode = ModData.get("PBLiteMode")
    local liteDrain = ModData.get("PBLiteDrain")

if liteMode ~= nil then
    local noLiteMode = tonumber(liteMode[1])

    local pbkLen = #testK

    for key = 1, #testK do
        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
        noPZ = tonumber(testNP[key])
        noLD = tonumber(testL[key])
        noCH = tonumber(testC[key])
        noOff = tonumber(testB[key])

        local noLiteDrain = tonumber(liteDrain[key])

        --local currentHour = getGameTime():getHour()

        -- print("Check ModData Key: ", testK[key])
        -- print("Check ModData X: ", testX[key])
        -- print("Check ModData Y: ", testY[key])
        -- print("Check ModData Z: ", testZ[key])
        -- print("Check ModData NP: ", testNP[key])
        -- print("Check ModData LOADED: ", testL[key])
        -- print("Check ModData Charge: ", testC[key])
        -- print("Check ModData On: ", testB[key])

        local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

        if (square ~= nil) then
            --if (ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0") == nil) then
            --	DisconnectPower(square)
            --end

            if (square ~= nil) then
                local updatedCH = 0
                local batterybank = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
                local inventory = batterybank:getContainer()
                local capacity = HandleBatteries(inventory, noCH, false)
                local batterynumber = HandleBatteries(inventory, noCH, true)
                local drain = 0

                print("LITEMODE: ", noLiteMode)

                if noLiteMode == 0 then
                    drain = solarscan(square, false, true, false, 0)
                end

                if noLiteMode == 1 then
                    if noLiteDrain == nil then
                        liteModeFunction(square)
                    end
                    drain = noLiteDrain
                end

                print("Drain: ", drain)
                print("noLiteDrain: ", noLiteDrain)

                local input = getModifiedSolarOutput(noPZ)
                local actualCharge = capacity * noCH
                local difference = input - drain

                updatedCH = (actualCharge + difference / 6) / capacity

                --make sure charge is within bounds
                if updatedCH > 1 then
                    updatedCH = 1
                end
                if updatedCH < 0 then
                    updatedCH = 0
                end

                --print("noOff is:")
                --print(noOff)

                --shutdown logic goes below
                if actualCharge <= 0 and difference < 0 then --and noOff ~= 0
                    noOff = 0
                    --table.insert(testB, key, noOff)
                    testB[key] = noOff
                    --print("turn off: setting noOff to:")
                    --print(noOff)
                    ------------------------------turn off
                    solarscan(square, true, true, false, 1)
                    --^^run this first for uninterrupted power... maybe?
                    local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
                    NewGenerator:setConnected(false)
                    NewGenerator:setFuel(0)
                    NewGenerator:setCondition(0)
                    NewGenerator:setActivated(false)
                    NewGenerator:setSurroundingElectricity()
                    NewGenerator:remove()
                end
                if (actualCharge > 0 or difference >= 0) and noOff == 0 then
                    noOff = 1
                    --table.insert(testB, key, noOff)
                    testB[key] = noOff
                    -------------------------------turn on
                    --print("turn on: setting noOff to:")
                    --print(noOff)
                    local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
                    NewGenerator:setConnected(true)
                    NewGenerator:setFuel(100)
                    NewGenerator:setCondition(100)
                    NewGenerator:setActivated(true)
                    NewGenerator:setSurroundingElectricity()
                    NewGenerator:remove()
                    solarscan(square, true, true, false, 2)

                    if square:getBuilding() ~= nil then
                        square:getBuilding():setToxic(false)
                    end
                end

                -- new sprite handler:

                if updatedCH < 0.25 then
                    --batterybank:setOverlaySprite(nil)
                    --show 0 charge
                    if batterynumber == 0 then
                        batterybank:setOverlaySprite(nil)
                    elseif batterynumber > 0 and batterynumber < 5 then
                        --show bottom shelf
                        batterybank:setOverlaySprite("solarmod_tileset_01_1")
                    elseif batterynumber >= 5 and batterynumber < 9 then
                        --show two shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_2")
                    elseif batterynumber >= 9 and batterynumber < 13 then
                        --show three shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_3")
                    elseif batterynumber >= 13 and batterynumber < 17 then
                        --show four shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_4")
                    elseif batterynumber >= 17 then
                        --show five shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_5")
                    end
                elseif updatedCH >= 0.25 and updatedCH < 0.50 then
                    --
                    --show 25 charge
                    if batterynumber == 0 then
                        batterybank:setOverlaySprite(nil)
                    elseif batterynumber > 0 and batterynumber < 5 then
                        --show bottom shelf
                        batterybank:setOverlaySprite("solarmod_tileset_01_16")
                    elseif batterynumber >= 5 and batterynumber < 9 then
                        --show two shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_20")
                    elseif batterynumber >= 9 and batterynumber < 13 then
                        --show three shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_24")
                    elseif batterynumber >= 13 and batterynumber < 17 then
                        --show four shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_28")
                    elseif batterynumber >= 17 then
                        --show five shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_32")
                    end
                elseif updatedCH >= 0.50 and updatedCH < 0.75 then
                    --batterybank:setOverlaySprite("solarmod_tileset_01_12")
                    -- show 50 charge
                    if batterynumber == 0 then
                        batterybank:setOverlaySprite(nil)
                    elseif batterynumber > 0 and batterynumber < 5 then
                        --show bottom shelf
                        batterybank:setOverlaySprite("solarmod_tileset_01_17")
                    elseif batterynumber >= 5 and batterynumber < 9 then
                        --show two shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_21")
                    elseif batterynumber >= 9 and batterynumber < 13 then
                        --show three shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_25")
                    elseif batterynumber >= 13 and batterynumber < 17 then
                        --show four shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_29")
                    elseif batterynumber >= 17 then
                        --show five shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_33")
                    end
                elseif updatedCH >= 0.75 and updatedCH < 0.95 then
                    --batterybank:setOverlaySprite("solarmod_tileset_01_13")
                    -- show 75 charge
                    if batterynumber == 0 then
                        batterybank:setOverlaySprite(nil)
                    elseif batterynumber > 0 and batterynumber < 5 then
                        --show bottom shelf
                        batterybank:setOverlaySprite("solarmod_tileset_01_18")
                    elseif batterynumber >= 5 and batterynumber < 9 then
                        --show two shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_22")
                    elseif batterynumber >= 9 and batterynumber < 13 then
                        --show three shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_26")
                    elseif batterynumber >= 13 and batterynumber < 17 then
                        --show four shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_30")
                    elseif batterynumber >= 17 then
                        --show five shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_34")
                    end
                elseif updatedCH >= 0.95 then
                    --show 100 charge
                    if batterynumber == 0 then
                        batterybank:setOverlaySprite(nil)
                    elseif batterynumber > 0 and batterynumber < 5 then
                        --show bottom shelf
                        batterybank:setOverlaySprite("solarmod_tileset_01_19")
                    elseif batterynumber >= 5 and batterynumber < 9 then
                        --show two shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_23")
                    elseif batterynumber >= 9 and batterynumber < 13 then
                        --show three shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_27")
                    elseif batterynumber >= 13 and batterynumber < 17 then
                        --show four shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_31")
                    elseif batterynumber >= 17 then
                        --show five shelves
                        batterybank:setOverlaySprite("solarmod_tileset_01_35")
                    end
                end

                --table.insert(testC, key, updatedCH)
                testC[key] = updatedCH
			end
            end
        end
    end
end

function batteryDegrade()
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
        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])

        local square = getWorld():getCell():getGridSquare(noX, noY, noZ)

        if (square ~= nil) then
            local batterybank = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
            local inventory = batterybank:getContainer()

            if inventory ~= nil then
                DegradeBatteries(inventory)
            end
        end
    end
end

function GenCheck()
    local testK = ModData.get("PBK")
    local testX = ModData.get("PBX")
    local testY = ModData.get("PBY")
    local testZ = ModData.get("PBZ")
    local testNP = ModData.get("PBNP")
    local testL = ModData.get("PBLD")
    local testC = ModData.get("PBCH")
    local testB = ModData.get("PBBO")
    local testG = ModData.get("PBGN")

    player = getPlayer()

    if testK ~= nil then
        for key = 1, #testK do
            noKey = tonumber(testK[key])
            noX = tonumber(testX[key])
            noY = tonumber(testY[key])
            noZ = tonumber(testZ[key])
            noPZ = tonumber(testNP[key])
            noLD = tonumber(testL[key])
            noCH = tonumber(testC[key])
            noPB = tonumber(testB[key])
            noGN = tonumber(testG[key])

            local square = getWorld():getCell():getGridSquare(noX, noY, noZ)
            local squarex = getWorld():getCell():getGridSquare(noX, noY, noZ)

            if square ~= nil then
                if
                    (noPB == 1 and calculateDistance(player:getX(), player:getY(), square:getX(), square:getY()) >= 50 and
                        noGN == 1)
                 then
                    for i = 1, 20 do
                        local NewGenerator = IsoGenerator.new(nil, squarex:getCell(), squarex)
                        NewGenerator:setConnected(true)
                        NewGenerator:setFuel(100)
                        NewGenerator:setCondition(100)
                        NewGenerator:setActivated(true)
                        NewGenerator:setSurroundingElectricity()
                    end

                    if squarex:getBuilding() ~= nil then
                        squarex:getBuilding():setToxic(false)
                    end

                    table.insert(testG, key, 0)
                end

                if (calculateDistance(player:getX(), player:getY(), square:getX(), square:getY()) < 50 and noGN == 0) then
                    GenRemove(squarex)

                    if square:getBuilding() ~= nil then
                        square:getBuilding():setToxic(false)
                    end

                    table.insert(testG, key, 1)
                    table.insert(testL, key, 1)
                end
            end
        end
    end
end

function calculateDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function GenRemove(square)
    local objs = square:getObjects()
    local sz = objs:size()
    if objs and sz > 0 then
        for i = sz - 1, 0, -1 do -- reverse iteration
            local myObject = objs:get(i)
            if myObject and instanceof(myObject, "IsoGenerator") then
                myObject:remove()
            end
        end
    end
end

function liteModeFunction(square)
    local testK = ModData.get("PBK")
    local testX = ModData.get("PBX")
    local testY = ModData.get("PBY")
    local testZ = ModData.get("PBZ")
    local testNP = ModData.get("PBNP")
    local testL = ModData.get("PBLD")
    local testC = ModData.get("PBCH")
    local testB = ModData.get("PBBO")

    local liteMode = ModData.get("PBLiteMode")
    local liteDrain = ModData.get("PBLiteDrain")

    local pbkLen = #testK

    for key = 1, #testK do
        noKey = tonumber(testK[key])
        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])
        noPZ = tonumber(testNP[key])
        noLD = tonumber(testL[key])
        noCH = tonumber(testC[key])
        noOff = tonumber(testB[key])

        noX = tonumber(testX[key])
        noY = tonumber(testY[key])
        noZ = tonumber(testZ[key])

        squarea = getWorld():getCell():getGridSquare(noX, noY, noZ)
		
		if squarea ~= nil then

        local noLiteDrain = tonumber(liteDrain[key])

        local drain = solarscan(squarea, false, true, false, 0)

        liteDrain[key] = drain
	end
    end
end

timeToSave = false

function Test()
    local testK = ModData.get("PBK")
    local testX = ModData.get("PBX")
    local testY = ModData.get("PBY")
    local testZ = ModData.get("PBZ")
    local testNP = ModData.get("PBNP")
    local testL = ModData.get("PBLD")
    local testC = ModData.get("PBCH")
    local testB = ModData.get("PBBO")
    local testG = ModData.get("PBGN")

    player = getPlayer()

    if test ~= nil then
        for key = 1, #testK do
            noKey = tonumber(testK[key])
            noX = tonumber(testX[key])
            noY = tonumber(testY[key])
            noZ = tonumber(testZ[key])
            noPZ = tonumber(testNP[key])
            noLD = tonumber(testL[key])
            noCH = tonumber(testC[key])
            noPB = tonumber(testB[key])
            noGN = tonumber(testG[key])

            local square = getWorld():getCell():getGridSquare(noX, noY, noZ)
            local squarex = getWorld():getCell():getGridSquare(noX, noY, noZ)

            if (calculateDistance(player:getX(), player:getY(), square:getX(), square:getY()) < 50 and noPB == 1) then
                if player:isAsleep() == true then
                    timeToSave = true
                end

                if player:isAsleep() == false and timeToSave == false then
                    timeToSave = true

                    local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
                    NewGenerator:setConnected(true)
                    NewGenerator:setFuel(100)
                    NewGenerator:setCondition(100)
                    NewGenerator:setActivated(true)
                    NewGenerator:setSurroundingElectricity()

                    if player:getSquare():getBuilding() ~= nil then
                        player:getSquare():getBuilding():setToxic(false)
                    end
                end

                -- --table.insert(testG, key, 0)

                if player:isAsleep() == false then
                    timeToSave = false
                end

                if square:getBuilding() ~= nil then
                    square:getBuilding():setToxic(false)
                end

            -- table.insert(testG, key, 1)
            -- table.insert(testL, key, 1)
            end
        end
    end
end

Events.OnSave.Add(Test)
Events.EveryDays.Add(batteryDegrade)
Events.EveryDays.Add(liteModeFunction)
Events.EveryTenMinutes.Add(chargeLogic)
Events.OnTick.Add(PowerCheck)
Events.OnTick.Add(GenCheck)
Events.OnGameStart.Add(CheckGlobalData)
Events.OnGameStart.Add(ReloadPower)
