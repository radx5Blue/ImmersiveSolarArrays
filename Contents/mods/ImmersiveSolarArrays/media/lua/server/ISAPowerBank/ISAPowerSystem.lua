function TurnOnPower(powerConsumption, numberOfPanels, key)
	
	testK = ModData.get("PBK")
	testX = ModData.get("PBX")
	testY = ModData.get("PBY")
	testZ = ModData.get("PBZ")
	
	print("ModData Key: ", testK[key])
	print("ModData X: ",testX[key])
	print("ModData Y: ",testY[key])
	print("ModData Z: ",testZ[key])
	
	noKey = tonumber(testK[key])
	noX = tonumber(testX[key])
	noY = tonumber(testY[key])
	noZ = tonumber(testZ[key])
	
	
	local square = getWorld():getCell():getGridSquare(noX, noY, noZ)
	
	if numberOfPanels > powerConsumption then
		
		-- might need to 'remove' a generator first if one is here so it doesn't create a new one on top of one that exists
		
		local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
        NewGenerator:setConnected(false)
        NewGenerator:setFuel(0)
        NewGenerator:setCondition(0)
        NewGenerator:setActivated(false)
        NewGenerator:remove()
		
		local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
        NewGenerator:setConnected(true)
        NewGenerator:setFuel(100)
        NewGenerator:setCondition(100)
        NewGenerator:setActivated(true)
        NewGenerator:setSurroundingElectricity()
		NewGenerator:remove()
	end
	
end



function PowerCheck()
	
	
	testK = ModData.get("PBK")
	testX = ModData.get("PBX")
	testY = ModData.get("PBY")
	testZ = ModData.get("PBZ")
	
	local pbkLen = #testK
	
	for key = 1, #testK do
		
	print("ModData Key: ", testK[key])
	print("ModData X: ",testX[key])
	print("ModData Y: ",testY[key])
	print("ModData Z: ",testZ[key])
	
	noKey = tonumber(testK[key])
	noX = tonumber(testX[key])
	noY = tonumber(testY[key])
	noZ = tonumber(testZ[key])
	
	
	local square = getWorld():getCell():getGridSquare(noX, noY, noZ)
	
	--solarscan(square, false, true, true, 0)
		
	end
	
	getPlayer():Say("DONE!!")
	

	
	
	
	
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
	
	
	ModData.add("PBK", powerBankKey)
	ModData.add("PBX", powerBankX)
	ModData.add("PBY", powerBankY)
	ModData.add("PBZ", powerBankZ)
 
 

end



Events.OnNewGame.Add(SetUpGlobalData)
--Events.EveryTenMinutes.Add(PowerCheck)