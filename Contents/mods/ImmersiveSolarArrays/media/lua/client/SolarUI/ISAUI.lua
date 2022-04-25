ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

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
	if generator and generator:getTextureName() == "solarmod_tileset_01_0" then
		--_powerbank = generator
		generator = nil
	end
end

ISAMenu.createMenuEntries = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	local powerbank , panel

	for _,obj in pairs(worldobjects) do
		local spritename = obj:getSprite() and obj:getSprite():getName()
		if spritename == "solarmod_tileset_01_0" then
			powerbank = obj
		elseif spritename == "solarmod_tileset_01_6" or spritename == "solarmod_tileset_01_7" or spritename == "solarmod_tileset_01_8" or
				spritename == "solarmod_tileset_01_9" or spritename == "solarmod_tileset_01_10" then
			panel = obj
		end
	end

	if powerbank then
		local square = powerbank:getSquare()
		if test then return ISWorldObjectContextMenu.setTest() end
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_BatteryBank"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, function() ISAStatusWindow.OnOpenPanel(square) end);

		if getDebug() then
			if test then return ISWorldObjectContextMenu.setTest() end
			ISASubMenu:addOption(getText("ContextMenu_ISA_DiagnoseBankIssues"), worldobjects, function() CPowerbankSystem.instance:sendCommand(getSpecificPlayer(player),"reboot", { x = powerbank:getX(), y = powerbank:getY(), z = powerbank:getZ() }) end)
		end

		if powerbank:getModData()["on"] then
			if test then return ISWorldObjectContextMenu.setTest() end
			ISASubMenu:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ActivatePowerbank, player, powerbank, false);
		else
			if test then return ISWorldObjectContextMenu.setTest() end
			ISASubMenu:addOption(getText("ContextMenu_Turn_On"), worldobjects, ActivatePowerbank, player, powerbank, true);
		end
	end

	if panel then
		local options = CPowerbankSystem.instance.canConnectPanelTo(panel:getSquare())
		if test then return ISWorldObjectContextMenu.setTest() end
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_SolarPanel"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu)
		if #options ~= 0 then
			for i,opt in ipairs(options) do
				if test then return ISWorldObjectContextMenu.setTest() end
				local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel")..i, worldobjects, ConnectPanel, player, panel, opt[3])
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				tooltip.description = getText("ContextMenu_ISA_Connect_Panel_toolTip").."( "..opt[1].." : "..opt[2].." )"
				option.toolTip = tooltip;
			end
		else
			if test then return ISWorldObjectContextMenu.setTest() end
			local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel"), worldobjects)
			local tooltip = ISWorldObjectContextMenu.addToolTip()
			tooltip.description = getText("ContextMenu_ISA_Connect_Panel_NoPowerbank")
			option.notAvailable = true;
			option.toolTip = tooltip;
			option.onSelect = nil;
		end
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
