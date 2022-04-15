ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

local _powerbank , _panel

local function ConnectPanel(worldobjects,player,panel,powerbank)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, panel:getSquare()) then
		ISTimedActionQueue.add(ISAConnectPanel:new(character, panel, powerbank));
	end
end

local function ActivatePowerbank (worlobjects,player,powerbank,activate)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, powerbank:getSquare()) then
		ISTimedActionQueue.add(ISAActivatePowerbank:new(character, powerbank, activate));
	end
end

local OnPreFillWorldObjectContextMenu = function(player, context, worldobjects, test)
	for _,obj in pairs(worldobjects) do
		local spritename = obj:getSprite() and obj:getSprite():getName()
		if not spritename then
			return
		elseif spritename == "solarmod_tileset_01_0" then
			_powerbank = obj
			generator = nil
			return
		elseif spritename == "solarmod_tileset_01_6" or spritename == "solarmod_tileset_01_7" or spritename == "solarmod_tileset_01_8" or
				spritename == "solarmod_tileset_01_9" or spritename == "solarmod_tileset_01_10" then
			_panel = obj
			return
		end
	end
end

ISAMenu.createMenuEntries = function(player, context, worldobjects, test)

	if test and ISWorldObjectContextMenu.Test then return true end

	if _powerbank then
		local powerbank = _powerbank
		local square = powerbank:getSquare()
		--local key = ISA.findKeyFromSquare(square)
		if test then return ISWorldObjectContextMenu.setTest() end
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_BatteryBank"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, function() ISAStatusWindow.OnOpenPanel(square) end);

		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_DiagnoseBankIssues"), worldobjects, function() CPowerbankSystem.instance:sendCommand(getSpecificPlayer(player),"reboot", { x = powerbank:getX(), y = powerbank:getY(), z = powerbank:getZ() }) end);

		if powerbank:getModData()["on"] then
			if test then return ISWorldObjectContextMenu.setTest() end
			ISASubMenu:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ActivatePowerbank, player, powerbank, false);
		else
			if test then return ISWorldObjectContextMenu.setTest() end
			ISASubMenu:addOption(getText("ContextMenu_Turn_On"), worldobjects, ActivatePowerbank, player, powerbank, true);
		end
		_powerbank = nil
	end

	if _panel then
		local options = CPowerbankSystem.instance.canConnectPanelTo(_panel:getSquare())
		local panel = _panel
		if test then return ISWorldObjectContextMenu.setTest() end
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_SolarPanel"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);
		for _,opt in ipairs(options) do
			if test then return ISWorldObjectContextMenu.setTest() end
			ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel").."( "..opt[1].." : "..opt[2].." )", worldobjects, ConnectPanel,player,panel, opt[3]);
		end
		_panel = nil
	end

end

ISAIsDayTime = function(currentHour)
	-- Get the current season to calculate when is day time or night time
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

Events.OnPreFillWorldObjectContextMenu.Add(OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries)
