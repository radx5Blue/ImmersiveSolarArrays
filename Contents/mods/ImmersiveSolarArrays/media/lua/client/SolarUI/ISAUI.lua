ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

local _powerbank

local function ConnectPanel(worldobjects,player,panel,powerbank)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, panel:getSquare(), true) then
		ISTimedActionQueue.add(ISAConnectPanel:new(character, panel, powerbank))
	end
end

local function ActivatePowerbank (worlobjects,player,powerbank,activate)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, powerbank:getSquare(), true) then
		ISTimedActionQueue.add(ISAActivatePowerbank:new(character, powerbank, activate))
	end
end

local OnPreFillWorldObjectContextMenu = function(player, context, worldobjects, test)
	if generator then
		_powerbank = ISAScan.findTypeOnSquare(generator:getSquare(),"Powerbank")
		if _powerbank then generator = nil end
	end
end

ISAMenu.createMenuEntries = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	local powerbank = _powerbank
	local panel

	for _,obj in ipairs(worldobjects) do
		local spritename = obj:getSprite() and obj:getSprite():getName()
		local type = ISAScan.Types[spritename]
		if type == "Powerbank" then
			powerbank = obj
		elseif type == "Panel" then
			panel = obj
		end
	end

	if powerbank then
		_powerbank = nil
		local square = powerbank:getSquare()
		if test then return ISWorldObjectContextMenu.setTest() end
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_BatteryBank"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu);
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, function() ISAStatusWindow.OnOpenPanel(square,player) end)

		local isOn = powerbank:getModData()["on"]
		local textOn = isOn and getText("ContextMenu_Turn_Off") or getText("ContextMenu_Turn_On")
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(textOn, worldobjects, ActivatePowerbank, player, powerbank, not isOn)
	end

	if panel then
		if test then return ISWorldObjectContextMenu.setTest() end
		local ISABBMenu = context:addOption(getText("ContextMenu_ISA_SolarPanel"), worldobjects);
		local ISASubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(ISABBMenu, ISASubMenu)
		local isOutside = panel:getSquare():isOutside()
		local options = CPowerbankSystem.instance.canConnectPanelTo(panel)
		if #options > 0 and isOutside then
			for i,opt in ipairs(options) do
				if test then return ISWorldObjectContextMenu.setTest() end
				local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel"), worldobjects, ConnectPanel, player, panel, opt[1])
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				tooltip:setName(getText("ContextMenu_ISA_BatteryBank"))
				tooltip.description = opt[4] and " <RGB:0,1,0>" .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected") or " <RGB:1,0,0>" .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected_false")
				tooltip.description = tooltip.description .. (" <RGB:1,1,1><BR>" .. "( "..opt[2].." : "..opt[3].." )" .. getText("ContextMenu_ISA_Connect_Panel_toolTip"))
				option.toolTip = tooltip;
			end
		else
			if test then return ISWorldObjectContextMenu.setTest() end
			local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel"), worldobjects)
			local tooltip = ISWorldObjectContextMenu.addToolTip()
			tooltip.description = " <RGB:1,0,0>" .. (#options == 0 and getText("ContextMenu_ISA_Connect_Panel_NoPowerbank") .. " <BR>" or "")
			tooltip.description = tooltip.description .. (not isOutside and getText("ContextMenu_ISA_Connect_Panel_toolTip_isOutside") or "")

			option.notAvailable = true;
			option.onSelect = nil;
			option.toolTip = tooltip;
		end
	end
end

ISAIsDayTime = function(currentTime)
	-- Get the current season to calculate when is day time or night time
	local season = getClimateManager():getSeason();

	local dawn = season:getDawn();
	local dusk = season:getDusk();

	if (currentTime > dawn) and (currentTime < dusk) then
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
