local string, math, getText = string, math, getText

local isa = require "ISAUtilities"

local UI = {}

local rgbDefault, rgbGood, rgbBad = { r = 1, g = 1, b = 1, rich = " <RGB:1,1,1> " }, {}, {}
UI.rgbDefault, UI.rgbGood, UI.rgbBad = rgbDefault, rgbGood, rgbBad

function UI.updateColours()
	local core = getCore()
	local good = core:getGoodHighlitedColor()
	rgbGood.ColorInfo = good
	rgbGood.r, rgbGood.g, rgbGood.b = good:getR(), good:getG(), good:getB()
	rgbGood.rich = string.format(" <RGB:%.2f,%.2f,%.2f> ", rgbGood.r, rgbGood.g, rgbGood.b)
	local bad = core:getBadHighlitedColor()
	rgbBad.ColorInfo = bad
	rgbBad.r, rgbBad.g, rgbBad.b = bad:getR(), bad:getG(), bad:getB()
	rgbBad.rich = string.format(" <RGB:%.2f,%.2f,%.2f> ", rgbBad.r, rgbBad.g, rgbBad.b)
end
UI.updateColours()

function UI.onConnectPanel(player,panel,powerbank)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, panel:getSquare(), true) then
		ISTimedActionQueue.add(isa.ConnectPanel:new(character, panel, powerbank))
	end
end

local function ActivatePowerbank(player,powerbank,activate)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, powerbank:getSquare(), true) then
		ISTimedActionQueue.add(isa.ActivatePowerbank:new(character, powerbank, activate))
	end
end

local function onConnectPanelCursor(player, square, powerbank)
	return isa.ConnectPanelCursor:new(player, square, powerbank)
end

local _powerbank

function UI.OnPreFillWorldObjectContextMenu(player, context, worldobjects, test)
	if generator then
		_powerbank = isa.WorldUtil.findTypeOnSquare(generator:getSquare(),"Powerbank")
		if _powerbank then generator = nil end
	end
end

function UI.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	local powerbank = _powerbank
	local panel
	--local panels = {}

	for _,obj in ipairs(worldobjects) do
		local sprite = obj:getTextureName()
		local type = isa.WorldUtil.Types[sprite]
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
		local ISASubMenu = context:getNew(context);
		context:addSubMenu(context:addOption(getText("ContextMenu_ISA_BatteryBank")), ISASubMenu)
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_BatteryBankStatus"), player, isa.StatusWindow.OnOpenPanel, square)
		local isOn = powerbank:getModData()["on"]
		local textOn = isOn and getText("ContextMenu_Turn_Off") or getText("ContextMenu_Turn_On")
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(textOn, player, ActivatePowerbank, powerbank, not isOn)
		if test then return ISWorldObjectContextMenu.setTest() end
		ISASubMenu:addOption(getText("ContextMenu_ISA_ConnectPanels"), player, onConnectPanelCursor, square, powerbank)
	end

	--for _,panel in ipairs(panels) do
		if panel then
			if test then return ISWorldObjectContextMenu.setTest() end
			local panelOption = context:addOption(getText("ContextMenu_ISA_SolarPanel"))
			local options = isa.PbSystem_client.canConnectPanelTo(panel)
			if #options > 0 then
				local ISASubMenu = context:getNew(context)
				context:addSubMenu(panelOption, ISASubMenu)
				for i,opt in ipairs(options) do
					if test then return ISWorldObjectContextMenu.setTest() end
					local option = ISASubMenu:addOption(getText("ContextMenu_ISA_Connect_Panel"), player, UI.onConnectPanel, panel, opt[1])
					local tooltip = ISWorldObjectContextMenu.addToolTip()
					tooltip:setName(getText("ContextMenu_ISA_BatteryBank"))
					tooltip.description = opt[4] and rgbGood.rich .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected") or rgbBad.rich .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected_false")
					tooltip.description = tooltip.description .. (rgbDefault.rich .. "<BR>" .. "( "..opt[2].." : "..opt[3].." )" .. getText("ContextMenu_ISA_Connect_Panel_toolTip"))
					option.toolTip = tooltip
				end
			else
				if test then return ISWorldObjectContextMenu.setTest() end
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				if options.inside then
					tooltip.description = rgbBad.rich .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isOutside")
				else
					tooltip.description = rgbBad.rich .. getText("ContextMenu_ISA_Connect_Panel_NoPowerbank")
				end
				panelOption.toolTip = tooltip
				panelOption.notAvailable = true
				panelOption.onSelect = nil
			end
		end
	--end
end

--update dawn / dusk less often?
local climateManager
UI.ISAIsDayTime = function(currentTime)
	if not climateManager then climateManager = getClimateManager() end
	-- Get the current season to calculate when is day time or night time
	local season = climateManager:getSeason()

	return currentTime > season:getDawn() and currentTime < season:getDusk()
end

function UI.ISInventoryPane_drawItemDetails_patch(drawItemDetails)
	local NewColorInfo = ColorInfo:new()

	return function(self,item, y, xoff, yoff, red,...)
		if not item then return end
		if not (item:getModData().ISA_maxCapacity) then
			return drawItemDetails(self,item, y, xoff, yoff, red,...)
		else
			local hdrHgt = self.headerHgt
			local top = hdrHgt + y * self.itemHgt + yoff
			rgbBad.ColorInfo:interp(rgbGood.ColorInfo, item:getCondition()/100, NewColorInfo)
			local fgBar = {r=NewColorInfo:getR(),g=NewColorInfo:getG(),b=NewColorInfo:getB(),a=1}
			local fgText = red and {r=0.0, g=0.0, b=0.5, a=0.7} or {r=0.6, g=0.8, b=0.5, a=0.6}
			self:drawTextAndProgressBar(getText("Tooltip_weapon_Condition") .. ":", item:getCondition()/100, xoff, top, fgText, fgBar)
		end
	end
end

function UI.DoTooltip_patch(DoTooltip)
	return function(item,tooltip)
		local maxCapacity = item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()]
		if not maxCapacity then
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
				option:setValue(string.format("%.2f",item:isEquipped() and item:getEquippedWeight() or item:getUnequippedWeight()),1,1,0.8,1)
				option = layout:addItem()
				option:setLabel(getText("IGUI_invpanel_Remaining")..":",1,1,0.8,1)
				option:setValue(string.format("%d%%",item:getUsedDelta()*100),1,1,0.8,1)
				option = layout:addItem()
				option:setLabel(getText("Tooltip_weapon_Condition")..":",1,1,0.8,1)
				option:setValue(string.format("%d%%",item:getCondition()),1,1,0.8,1)
				option = layout:addItem()
				option:setLabel(getText("Tooltip_container_Capacity")..":",1,1,0.8,1)
				option:setValue(string.format("%d / %d",maxCapacity * (1 - math.pow((1 - (item:getCondition()/100)),6)),maxCapacity),1,1,0.8,1)
			end
			y = layout:render(5,y,tooltip)
			tooltip:endLayout(layout)
			--if width < 150 -- tooltip:setWidth(tooltip:getWidth())
			tooltip:setHeight(y+5)
		end
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(UI.OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(UI.OnFillWorldObjectContextMenu)

isa.UI = UI