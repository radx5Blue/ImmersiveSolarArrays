ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

ISAMenu.createMenuEntries = function(_player, _context, _worldObjects)

	local context = _context;
	local worldobjects = _worldObjects; 
	
	

	
	
	
	-- local testK = ModData.get("PBK")
    -- local testX = ModData.get("PBX")
    -- local testY = ModData.get("PBY")
    -- local testZ = ModData.get("PBZ")
    -- local testNP = ModData.get("PBNP")
    -- local testL = ModData.get("PBLD")
    -- local testC = ModData.get("PBCH")
    -- local testB = ModData.get("PBBO")
    -- local testG = ModData.get("PBGN")

    -- player = getPlayer()

    -- for key = 1, #testK do
        -- noKey = tonumber(testK[key])
        -- noX = tonumber(testX[key])
        -- noY = tonumber(testY[key])
        -- noZ = tonumber(testZ[key])
        -- noPZ = tonumber(testNP[key])
        -- noLD = tonumber(testL[key])
        -- noCH = tonumber(testC[key])
        -- noPB = tonumber(testB[key])
        -- noGN = tonumber(testG[key])

		
		
	 -- subMenu:addOption("Battery Bank", worldobjects, function() SaySolar() end);
	 
 -- end
 
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

	if not bank then return end
	
	if bank ~= nil then
		
			local ISAOption = context:addOption("Battery Bank Status", worldobjects, function() OpenBatterBankInfo(square) end);
	--local subMenu = ISContextMenu:getNew(context);
	--context:addSubMenu(ISAOption, subMenu);
	
	ISAOption.context = context
	ISAOption.subMenu = subMenu
		
	end
	 


	

end


OpenBatterBankInfo = function(square)

    sqX = square:getX()
    sqY = square:getY()
    sqZ = square:getZ()

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
			
			local batterybank = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
            local inventory = batterybank:getContainer()
            local capacity = HandleBatteries(inventory, noCH, false)
            local batterynumber = HandleBatteries(inventory, noCH, true)
            local drain = solarscan(square, false, true, false, 0)
            local input = getModifiedSolarOutput(noPZ)
            local actualCharge = capacity * noCH
            local difference = input - drain


			
		if noPZ < 1 then
			local text = "There are currently no solar panels connected"
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
			local text4 = "The battery bank has enough solar panels to power my connected devices"
			player:Say(text4)
		end
		
		if difference == 0 then
			local text4 = "The battery bank has enough solar panels to power my connected devices but not to charge batteries"
			player:Say(text4)
		end
		
		if difference < 0 then
			local text4 = "I need more solar panels to power my devices"
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