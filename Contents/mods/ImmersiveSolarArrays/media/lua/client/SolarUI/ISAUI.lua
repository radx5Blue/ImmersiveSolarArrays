ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

local _powerbank

local rGood, gGood, bGood = 0,1,0
local rBad, gBad, bBad = 0,1,0
local richGood, richBad, richNeutral = " <RGB:0,1,0> ", " <RGB:1,0,0> ", " <RGB:1,1,1> "
--ver41.78+
if getCore().getGoodHighlitedColor then
	local good = getCore():getGoodHighlitedColor()
	local bad = getCore():getBadHighlitedColor()
	rGood, gGood, bGood, rBad, gBad, bBad = good:getR(), good:getG(), good:getB(), bad:getR(), bad:getG(), bad:getB()
	richGood, richBad = string.format(" <RGB:%.2f,%.2f,%.2f> ",rGood, gGood, bGood), string.format(" <RGB:%.2f,%.2f,%.2f> ",rBad, gBad, bBad)
end

function ISAMenu.onConnectPanel(worldobjects,player,panel,powerbank)
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
		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), worldobjects, ISAStatusWindow.OnOpenPanel, square, player)

		local isOn = powerbank:getModData()["on"]
		local textOn = isOn and getText("ContextMenu_Turn_Off") or getText("ContextMenu_Turn_On")
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(textOn, worldobjects, ActivatePowerbank, player, powerbank, not isOn)



		--local function ConnectPanelCursor1(worldobjects,player,powerbank)
		--	if JoypadState.players[player+1] then
		--		local cursor = ISAConnectPanelCursor1:new(player,powerbank)
		--		getCell():setDrag(cursor, player)
		--		cursor.xJoypad = square:getX()
		--		cursor.yJoypad = square:getY()
		--		cursor.zJoypad = square:getZ()
		--
		--		ISACursor1.cursor = cursor
		--	end
		--	if getSpecificPlayer(player):getJoypadBind() ~= -1 then
		--		ISACursor1.cursor = ISAConnectPanelCursor1:new(player,powerbank)
		--		getCell():setDrag(ISACursor1.cursor, player)
		--	end
		--end
		local function ConnectPanelCursor(worldobjects,player, square, powerbank)
			ISACursor.cursor = ISAConnectPanelCursor:new(player, square, powerbank) --todo reuse?
		end
		--if test then return ISWorldObjectContextMenu.setTest() end
		--ISASubMenu:addOption("Connect Panels1", worldobjects, ConnectPanelCursor1, player, powerbank)

		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption("Connect Panels", worldobjects, ConnectPanelCursor, player, square, powerbank)



	end

	--for _,panel in ipairs(panels) do
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
					local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel"), worldobjects, ISAMenu.onConnectPanel, player, panel, opt[1])
					local tooltip = ISWorldObjectContextMenu.addToolTip()
					tooltip:setName(getText("ContextMenu_ISA_BatteryBank"))
					tooltip.description = opt[4] and richGood .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected") or richBad .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected_false")
					tooltip.description = tooltip.description .. (richNeutral .. "<BR>" .. "( "..opt[2].." : "..opt[3].." )" .. getText("ContextMenu_ISA_Connect_Panel_toolTip"))
					option.toolTip = tooltip;
				end
			else
				if test then return ISWorldObjectContextMenu.setTest() end
				local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel"), worldobjects)
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				tooltip.description = richBad .. (#options == 0 and getText("ContextMenu_ISA_Connect_Panel_NoPowerbank") .. " <BR>" or "")
				tooltip.description = tooltip.description .. (not isOutside and getText("ContextMenu_ISA_Connect_Panel_toolTip_isOutside") or "")

				option.notAvailable = true;
				option.onSelect = nil;
				option.toolTip = tooltip;
			end
		end
	--end
end

function ISAMenu.getRGB()
	return rGood, gGood, bGood, rBad, gBad, bBad
end

function ISAMenu.getRGBRich()
	return richGood, richBad, richNeutral
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
