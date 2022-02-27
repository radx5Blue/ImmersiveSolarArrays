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
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_BatteryBank"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);

		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, function() ISAStatusWindow.OnOpenPanel(bank:getSquare()) end);
		ISASubMenu:addOption(getText("ContextMenu_ISA_DiagnoseBankIssues"), worldobjects, function() ResetBatteryBank(bank:getSquare()) end);

		--ISASubMenu:addOption("Test", worldobjects, function() ISAStatusWindow.OnOpenPanel(bank:getSquare()) end);
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

ISAIsDayTime = function(currentHour)
	-- We don't need to get the season every time, so will be done every 4500 frames and just because to detect changes in real time, because is not important
	local season = getClimateManager():getSeason();

	local dawn = season:getDawn();
	local dusk = season:getDusk();

	if (currentHour > dawn) and (currentHour < dusk) then
		return true
	else
		return false
	end
end

-- This function fixes the escaped strings that are retreived
-- by getText as literals, making it fail.
ISAFixedGetText = function(getTextString)
	local text = getText(getTextString)
	text = string.gsub(text, '\\n', '\n')

	return text
end

--[[
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
				local text = getText("ContextMenu_ISA_NoPanels")
				player:Say(text)
			elseif noPZ == 1 then
				local text = string.format(getText("ContextMenu_ISA_CurrentPanels"), noPZ)
				player:Say(text)
			else
				local text = string.format(getText("ContextMenu_ISA_CurrentPanels_Plural"), noPZ)
				player:Say(text)
			end
			
			if difference > 0 then
				local dtime = ((capacity - actualCharge) / difference)
				local text4 = getText("ContextMenu_ISA_Power_Enough_Panels")
				if dtime > 2 then
					text4 = text4 .. " " .. string.format(getText("ContextMenu_ISA_Power_Charging_Plural"), math.abs(math.floor(dtime)))
				elseif dtime >= 1 then
					text4 = text4 .. " " .. string.format(getText("ContextMenu_ISA_Power_Charging"), math.abs(math.floor(dtime)))
				else
					text4 = text4 .. " " .. getText("ContextMenu_ISA_Power_Charging_Almost_Full")
				end
				player:Say(text4)

			
			elseif difference == 0 then
				local text4 = getText("ContextMenu_ISA_Power_Enough_Panels_No_Charging")
				player:Say(text4)
			
			
			else
				local dtime = math.abs(actualCharge / difference)
				local text4 = ""
				if input > 0 then
					text4 = getText("ContextMenu_ISA_Power_No_Enough_Panels")
				else
					text4 = getText("ContextMenu_ISA_Power_No_Sun")
				end
				if dtime > 2 then
					text4 = text4 .. " " .. string.format(getText("ContextMenu_ISA_Power_Discharging_Plural"), math.abs(math.floor(dtime)))
				elseif dtime >= 1 then
					text4 = text4 .. " " .. string.format(getText("ContextMenu_ISA_Power_Discharging"), math.abs(math.floor(dtime)))
				else
					text4 = text4 .. " " .. getText("ContextMenu_ISA_Power_Discharging_Almost_Empty")
				end
				player:Say(text4)
			end
			
			if batterynumber == 0 then
				local text3 = getText("ContextMenu_ISA_Batteries_No_Batteries")
				player:Say(text3)
			elseif batterynumber > 0 then
			
				if noCH == 0 then
					local text2 = getText("ContextMenu_ISA_Batteries_No_Power")
					player:Say(text2)

				elseif noCH > 0 then
					local text2 = string.format(getText("ContextMenu_ISA_Batteries_Power_Level"), math.floor(noCH * 100))
					player:Say(text2)
				end
			end
			
		end
	end
end
]]


Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries);