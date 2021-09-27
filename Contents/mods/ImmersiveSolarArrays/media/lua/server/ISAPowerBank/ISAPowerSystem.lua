function TurnOnPower()
	
	local powerCreated = 0
	local powerConsumed = 0
	
	testK = ModData.get("PBK")
	testX = ModData.get("PBX")
	--testY = ModData.get("PBY")
	
	print("ModData Key: ", testK[1])
	print("ModData X: ",testX[1])
	--print("ModData Y: ",testY[1])
	
	
	powerCreated = PanelScan(testX[1])
	
	
	print("Power Created: ",powerCreated)
	
	if powerCreated > 0 then
		print("power on")
		
	end
	
	
	
	
	
	
	
	
	
	
end

function SetUpGlobalData()
	
	local powerBankKey = {}
	local powerBankX = {}
	local powerBankY = {}
	
	
	ModData.add("PBK", powerBankKey)
	ModData.add("PBX", powerBankX)
	--ModData.add("PBY", powerBankY)
 
 

end



Events.OnNewGame.Add(SetUpGlobalData)
--Events.OnTick.Add(TurnOnPower)


