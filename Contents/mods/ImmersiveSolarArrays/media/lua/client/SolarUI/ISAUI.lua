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
		
			local ISAOption = context:addOption("Battery Bank", worldobjects, function() OpenBatterBankInfo(square) end);
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
         
		 -- do logic in here
		 
	 end

		
	 
 end


end


Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries);