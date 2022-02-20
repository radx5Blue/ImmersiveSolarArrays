ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

ISAMenu.createMenuEntries = function(_player, _context, _worldObjects)

	local context = _context;
	local worldobjects = _worldObjects; 
	
 
 	if test and ISWorldObjectContextMenu.Test then return true end

	local bank = nil

	local objects = {}
	for _,object in ipairs(worldobjects) do
		local square = object:getSquare()
		if square then
			for i=1,square:getObjects():size() do
				local object2 = square:getObjects():get(i-1)
				if ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0") then
					bank = object2
				end
			end
		end
	end
	
	if bank ~= nil then
		
	local ISAOption = context:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, function() OpenBatterBankInfo(bank:getSquare()) end);
	local ISAOption = context:addOption(getText("ContextMenu_ISA_DiagnoseBankIssues"), worldobjects, function() ResetBatteryBank(bank:getSquare()) end);
		
	end
	 


	

end

ResetBatteryBank = function(fsquare)

    local sqX = fsquare:getX()
    local sqY = fsquare:getY()
    local sqZ = fsquare:getZ()

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
		

        if (sqX == noX and sqY == noY and sqZ == noZ) then
			DisconnectPower(fsquare)
			--solarscan(fsquare, false, true, true, 0)
			ResetBank(fsquare, noCH)
	 end

		
	 
 end


end


OpenBatterBankInfo = function(fsquare)

    local sqX = fsquare:getX()
    local sqY = fsquare:getY()
    local sqZ = fsquare:getZ()

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
		

        if (sqX == noX and sqY == noY and sqZ == noZ) then
			
			local batterybank = ISMoveableSpriteProps:findOnSquare(fsquare, "solarmod_tileset_01_0")
            local inventory = batterybank:getContainer()
            local capacity = HandleBatteries(inventory, noCH, false)
            local batterynumber = HandleBatteries(inventory, noCH, true)
            local drain = solarscan(fsquare, false, true, false, 0)
            local input = getModifiedSolarOutput(noPZ)
            local actualCharge = capacity * noCH
            local difference = input - drain


			
		if noPZ < 1 then
			local text = (getText("ContextMenu_ISA_NoPanels"))
			player:Say(text)
		end
				
		if noPZ == 1 then
			local text = "There is currently " .. noPZ .. " solar panel connected"
		player:Say(text)
		end
			
				if noPZ > 1 then
			local text = "There are currently " .. noPZ .. " solar panels connected"
			player:Say(text)
		end
		
		if difference > 0 then
		    local dtime = ((capacity - actualCharge) / difference)
			local text4 = "The battery bank has enough solar panels to power my connected devices"
			if dtime > 0 then
				text4 = text4 .. " It will take about " .. math.abs(math.floor(dtime)) .. " hours to fully charge"
			end
			player:Say(text4)
		end
		
		if difference == 0 then
			local text4 = "The battery bank has enough solar panels to power my connected devices but not to charge batteries"
			player:Say(text4)
		end
		
		if difference < 0 then
		    local dtime = (actualCharge / difference)
			local text4 = ""
			if input > 0 then
				text4 = "I need more solar panels to power my devices."
			else
				text4 = "Panels do not generate electricity - need to check during sunny day."
		    end
			text4 = text4 .. " Power will remain for about " .. math.abs(math.floor(dtime)) .. "hours."
			player:Say(text4)
		end
		
		if batterynumber == 0 then
			local text3 = "There are no batteries to charge up the battery bank"
			player:Say(text3)
		end
		
		if noCH == 0 and batterynumber > 0 then
			local text2 = "The battery bank has no stored power"
			player:Say(text2)
		end
		
		if noCH > 0 and batterynumber > 0 then
			local text2 = "The battery bank is currently at " .. math.floor(noCH * 100) .. "% power"
			player:Say(text2)
		end
         
	 end

		
	 
 end


end


Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries);