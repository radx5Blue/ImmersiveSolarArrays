ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

local _powerbank , _pbgenerator, _panel

local function ConnectPanel(worldobjects,player,panel,powerbank)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, panel:getSquare()) then
		ISTimedActionQueue.add(ISAConnectPanel:new(character, panel, powerbank));
	end
end

local function ActivatePowerbank (worlobjects,player,generator,powerbank,activate)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, powerbank:getSquare()) then
		ISTimedActionQueue.add(ISAActivatePowerbank:new(character, generator, powerbank, activate));
	end
end

local OnPreFillWorldObjectContextMenu = function(player, context, worldobjects, test)
	for _,obj in pairs(worldobjects) do
		local spritename = obj:getSprite() and obj:getSprite():getName()
		if not spritename then
			return
		elseif spritename == "solarmod_tileset_01_0" then
			_powerbank = obj
			_pbgenerator = generator
			generator = nil
			return
		elseif spritename == "solarmod_tileset_01_6" or spritename == "solarmod_tileset_01_7" or spritename == "solarmod_tileset_01_8" or
				spritename == "solarmod_tileset_01_9" or spritename == "solarmod_tileset_01_10" then
			_panel = obj
			return
		end
	end
end

ISAMenu.createMenuEntries = function(player, context, worldobjects)

	if test and ISWorldObjectContextMenu.Test then return true end

	if _powerbank then
		local powerbank , pbgenerator = _powerbank , _pbgenerator
		local square = powerbank:getSquare()
		--local key = ISA.findKeyFromSquare(square)
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_BatteryBank"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);
		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, function() ISAStatusWindow.OnOpenPanel(square) end);
		ISASubMenu:addOption(getText("ContextMenu_ISA_DiagnoseBankIssues"), worldobjects, function() CPowerbankSystem.instance:sendCommand(getSpecificPlayer(player),"reboot", { x = powerbank:getX(), y = powerbank:getY(), z = powerbank:getZ() }) end);
		if pbgenerator then
			if powerbank:getModData()["on"] then
				ISASubMenu:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ActivatePowerbank, player, powerbank, pbgenerator, false);
			else
				ISASubMenu:addOption(getText("ContextMenu_Turn_On"), worldobjects, ActivatePowerbank, player, powerbank, pbgenerator, true);
			end
		end
		_powerbank ,_pbgenerator = nil, nil
	end

	if _panel then
		local options = CPowerbankSystem.instance.canConnectPanelTo(_panel:getSquare())
		local panel = _panel
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_SolarPanel"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);
		for _,opt in ipairs(options) do
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
Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries);