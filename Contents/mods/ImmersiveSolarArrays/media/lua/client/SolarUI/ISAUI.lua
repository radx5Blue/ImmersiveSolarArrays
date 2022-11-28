ISAMenu = ISAMenu or {}
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
local maxCapacityTable = ISAUtilities.maxBatteryCapacity

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

local function ConnectPanelCursor(worldobjects,player, square, powerbank)
	ISACursor.cursor = ISAConnectPanelCursor:new(player, square, powerbank)
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
	--local panels = {}

	for _,obj in ipairs(worldobjects) do
		local spritename = obj:getSprite() and obj:getSprite():getName()
		local type = ISAScan.Types[spritename]
		if type == "Powerbank" then
			powerbank = obj
		elseif type == "Panel" then
			panel = obj
			--table.insert(panels,obj)
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
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_ConnectPanels"), worldobjects, ConnectPanelCursor, player, square, powerbank)
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

function ISAMenu.ISInventoryPane_drawItemDetails_patch(drawItemDetails)
	return function(self,item, y, xoff, yoff, red,...)
		if not item then return end
		if not (item:hasModData() and item:getModData().ISAMaxCapacityAh or maxCapacityTable[item:getType()]) then
			return drawItemDetails(self,item, y, xoff, yoff, red,...)
		else
			local hdrHgt = self.headerHgt
			local top = hdrHgt + y * self.itemHgt + yoff
			local fgBar = {r=0.69, g=0.69, b=0.1, a=1}
			if getCore().getGoodHighlitedColor then --41.78+
				local NewColorInfo = ColorInfo:new()
				getCore():getBadHighlitedColor():interp(getCore():getGoodHighlitedColor(), item:getCondition()/100, NewColorInfo)
				fgBar = {r=NewColorInfo:getR(),g=NewColorInfo:getG(),b=NewColorInfo:getB(),a=1}
			end
			local fgText = {r=0.6, g=0.8, b=0.5, a=0.6}
			if red then fgText = {r=0.0, g=0.0, b=0.5, a=0.7} end
			self:drawTextAndProgressBar(getText("Tooltip_weapon_Condition") .. ":", item:getCondition()/100, xoff, top, fgText, fgBar)
		end
	end
end

function ISAMenu.DoTooltip_patch(DoTooltip)
	return function(item,tooltip)
		if not (item:hasModData() and item:getModData().ISAMaxCapacityAh or maxCapacityTable[item:getType()]) then
			return DoTooltip(item,tooltip)
		else
			local lineHeight = tooltip:getLineSpacing()
			local font = tooltip:getFont()
			local y = 5
			--tooltip:render()
			tooltip:DrawText(font, item:getName(), 5, 5, 1, 1, 0.8, 1)
			y = y + lineHeight + 5
			--adjustWidth(5, name;
			local layout = tooltip:beginLayout()
			--setminwidth
			local option
			if tooltip:getWeightOfStack() > 0 then
				option = layout:addItem()
				option:setLabel(getText("Tooltip_item_StackWeight")..":",1,1,0.8,1)
				option:setValueRightNoPlus(tooltip:getWeightOfStack())
			else
				option = layout:addItem()
				option:setLabel(getText("Tooltip_item_Weight")..":",1,1,0.8,1)
				if item:isEquipped() or item:getAttachedSlot() > -1 then
					option:setValue(string.format("%.2f    (%.2f %s) ",item:getEquippedWeight(),item:getUnequippedWeight(),getText("Tooltip_item_Unequipped")),1,1,0.8,1)
				else
					option:setValue(string.format("%.2f    (%.2f %s) ",item:getUnequippedWeight(),item:getEquippedWeight(),getText("Tooltip_item_Equipped")),1,1,0.8,1)
				end
				option = layout:addItem()
				option:setLabel(getText("IGUI_invpanel_Remaining")..":",1,1,0.8,1)
				option:setValue(string.format("%d%%",item:getUsedDelta()*100),1,1,0.8,1)
				option = layout:addItem()
				option:setLabel(getText("Tooltip_weapon_Condition")..":",1,1,0.8,1)
				option:setValue(string.format("%d%%",item:getCondition()),1,1,0.8,1)
				option = layout:addItem()
				option:setLabel(getText("Tooltip_container_Capacity")..":",1,1,0.8,1)
				local max = (item:hasModData() and item:getModData().ISAMaxCapacityAh or maxCapacityTable[item:getType()])
				option:setValue(string.format("%d / %d",max * (1 - math.pow((1 - (item:getCondition()/100)),6)),max),1,1,0.8,1)
			end
			y = layout:render(5,y,tooltip)
			tooltip:endLayout(layout)
			--if width < 150 -- tooltip:setWidth(tooltip:getWidth())
			tooltip:setHeight(y+5)
		end
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries)
