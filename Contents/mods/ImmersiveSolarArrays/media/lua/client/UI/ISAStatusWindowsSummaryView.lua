require "ISUI/ISPanelJoypad"
local isa = require "ISAUtilities"

local ISAWindowsSumaryTab = ISPanelJoypad:derive("ISAWindowsSumaryTab")

function ISAWindowsSumaryTab:initialise()
	ISPanelJoypad.initialise(self)

	-- House
	self.imageHouse = ISImage:new(321, 185, 254, 185, self.textureHouse)
	self.imageHouse.scaledWidth = 254
	self.imageHouse.scaledHeight = 185
	self.imageHouse:initialise()
	self.imageHouse.parent = self
    self:addChild(self.imageHouse)

	-- Cables
	self.imageCables = ISImage:new(52, 358, 403, 24, self.textureCables)
	self.imageCables.scaledWidth = 403
	self.imageCables.scaledHeight = 24
	self.imageCables:initialise()
	self.imageCables.parent = self
    self:addChild(self.imageCables)

	-- Battery
	self.imageBattery = ISImage:new(16, 302, 76, 69, self.textureBattery)
	self.imageBattery.scaledWidth = 76
	self.imageBattery.scaledHeight = 69
	self.imageBattery:initialise()
	self.imageBattery.parent = self
	--self.imageBattery:setMouseOverText("Test")
    self:addChild(self.imageBattery)

	self.imageBatteryCross = ISImage:new(17, 305, 72, 72, self.textureCross)
	self.imageBatteryCross.scaledWidth = 72
	self.imageBatteryCross.scaledHeight = 72
	self.imageBatteryCross:initialise()
	self.imageBatteryCross.parent = self
    self:addChild(self.imageBatteryCross)

	-- Sun and radiation
	self.imageSun = ISImage:new(0, 0, 128, 128, self.textureSun)
	self.imageSun.scaledWidth = 128
	self.imageSun.scaledHeight = 128
	self.imageSun:initialise()
	self.imageSun.parent = self
    self:addChild(self.imageSun)

--[[
	self.imageSolarRadiation1 = ISImage:new(81, 122, 93, 78, self.textureSolarRadiation)
	self.imageSolarRadiation1.scaledWidth = 93
	self.imageSolarRadiation1.scaledHeight = 78
	self.imageSolarRadiation1:initialise()
	self.imageSolarRadiation1.parent = self
    self:addChild(self.imageSolarRadiation1)

	self.imageSolarRadiation2 = ISImage:new(98, 107, 93, 78, self.textureSolarRadiation)
	self.imageSolarRadiation2.scaledWidth = 93
	self.imageSolarRadiation2.scaledHeight = 78
	self.imageSolarRadiation2:initialise()
	self.imageSolarRadiation2.parent = self
    self:addChild(self.imageSolarRadiation2)

	self.imageSolarRadiation3 = ISImage:new(116, 91, 93, 78, self.textureSolarRadiation)
	self.imageSolarRadiation3.scaledWidth = 93
	self.imageSolarRadiation3.scaledHeight = 78
	self.imageSolarRadiation3:initialise()
	self.imageSolarRadiation3.parent = self
    self:addChild(self.imageSolarRadiation3)

	self.imageSolarRadiationCross = ISImage:new(118, 116, 72, 72, self.textureCross)
	self.imageSolarRadiationCross.scaledWidth = 72
	self.imageSolarRadiationCross.scaledHeight = 72
	self.imageSolarRadiationCross:initialise()
	self.imageSolarRadiationCross.parent = self
    self:addChild(self.imageSolarRadiationCross)
	]]

	-- Moon
	self.imageMoon = ISImage:new(0, 0, 128, 128, self.textureMoon)
	self.imageMoon.scaledWidth = 128
	self.imageMoon.scaledHeight = 128
	self.imageMoon:initialise()
	self.imageMoon.parent = self
    self:addChild(self.imageMoon)

	-- Solar Panel (two modes)
	self.imageSolarPanel = ISImage:new(123, 267, 155, 103, self.textureSolarPanel)
	self.imageSolarPanel.scaledWidth = 155
	self.imageSolarPanel.scaledHeight = 103
	self.imageSolarPanel:initialise()
	self.imageSolarPanel.parent = self
    self:addChild(self.imageSolarPanel)
	self.imageSolarPanel:setVisible(false)

	self.imageSolarPanelNoEnergy = ISImage:new(123, 267, 155, 103, self.textureSolarPanelNoEnergy)
	self.imageSolarPanelNoEnergy.scaledWidth = 155
	self.imageSolarPanelNoEnergy.scaledHeight = 103
	self.imageSolarPanelNoEnergy:initialise()
	self.imageSolarPanelNoEnergy.parent = self
    self:addChild(self.imageSolarPanelNoEnergy)

	self.imageSolarPanelCross = ISImage:new(166, 268, 72, 72, self.textureCross)
	self.imageSolarPanelCross.scaledWidth = 72
	self.imageSolarPanelCross.scaledHeight = 72
	self.imageSolarPanelCross:initialise()
	self.imageSolarPanelCross.parent = self
    self:addChild(self.imageSolarPanelCross)

	-- Fix the daytime/nightime icon
	local currentTime = getGameTime():getTimeOfDay()
	if isa.UI.ISAIsDayTime(currentTime) then
		self.imageSun:setVisible(true)
		self.imageMoon:setVisible(false)
		self.night = false
	else
		self.imageSun:setVisible(false)
		self.imageMoon:setVisible(true)
		self.night = true
	end
end

function ISAWindowsSumaryTab:createChildren()
	self:setScrollChildren(true)
	self:addScrollBars()
end

function ISAWindowsSumaryTab:setVisible(visible)
    self.javaObject:setVisible(visible)
	if visible then
		self:setWidthAndParentWidth(580)
		self:setHeightAndParentHeight(390)
		self.currentFrame = 0
	end
end

function ISAWindowsSumaryTab:render()
	local pb = self.parent.parent.luaPB
	if not (pb and pb:getIsoObject()) then return self.parent.parent:close() end

	-- Update every ~1 sec
	if self.currentFrame == 0 then
		pb:updateFromIsoObject()
		self.maxCapacity = pb.maxcapacity
		self.charge = pb.charge
		self.drain = pb.drain
		self.batteryLevel = pb.charge / pb.maxcapacity
		self.panelsMaxInput = pb.luaSystem:getMaxSolarOutput(pb.npanels)
		self.panelsInput = pb.luaSystem:getModifiedSolarOutput(pb.npanels)
		self.difference = self.panelsInput - (pb:shouldDrain() and pb.drain or 0)

		local currentTime = getGameTime():getTimeOfDay()
		if isa.UI.ISAIsDayTime(currentTime) then
			if (self.night == true) then
				self.imageSun:setVisible(true)
				self.imageMoon:setVisible(false)
				self.night = false
			end
		else
			if (self.night == false) then
				self.imageSun:setVisible(false)
				self.imageMoon:setVisible(true)
				self.night = true
			end
		end

		if (pb.batteries > 0) then
			if (self.thereAreBatteries == false) then
				self.imageBatteryCross:setVisible(false)
				self.thereAreBatteries = true
			end
		else
			if (self.thereAreBatteries == true) then
				self.imageBatteryCross:setVisible(true)
				self.thereAreBatteries = false
			end
		end

		if (pb.npanels > 0) then
			if (self.thereArePanels == false) then
				self.imageSolarPanelCross:setVisible(false)
				self.thereArePanels = true
			end
		else
			if (self.thereArePanels == false) then
				self.imageSolarPanelCross:setVisible(true)
				self.thereArePanels = false
			end
		end

		if self.difference > 0 then
			if (self.batteryCharging == false) then
				self.imageSolarPanel:setVisible(true)
				self.imageSolarPanelNoEnergy:setVisible(false)
				self.batteryCharging = true
			end
		else
			if (self.batteryCharging == true) then
				self.imageSolarPanel:setVisible(false)
				self.imageSolarPanelNoEnergy:setVisible(true)
				self.batteryCharging = false
			end
		end

		self.currentFrame = self.fps - 1
	else
		self.currentFrame = self.currentFrame - 1
	end

	-- Summary box
	local line = getTextManager():getFontHeight(UIFont.Small)
	local rectX, rectY, rectW, rectH = self.sumBox.x, 20, self.sumBox.width, 25 + line * 6
	local text_x = self.sumBox.textX
	local text_x2 = text_x + self.sumBox.pad1
	local text_y = 30
	self:drawRect(rectX, rectY, rectW, rectH, 0.5, 0.16, 0.16, 0.16)
	self:drawRectBorder(rectX, rectY, rectW, rectH, 1, 1, 1, 1)

	-- Summary text
	self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_PanelsStatus") .. ":", text_x, text_y + line * 0, 0, 1, 0, 1, UIFont.Small)
	self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_BatteryLevel") .. ":", text_x, text_y + line *1, 0, 1, 0, 1, UIFont.Small)

	-- Solar panels status
	if (self.drain > self.panelsMaxInput) then
		self:drawText(getText("IGUI_ISAWindowsSumaryTab_NoEnoughPanels"), text_x2, text_y + line * 0, 0, 1, 0, 1, UIFont.Small)
	else
		if (self.drain > self.panelsInput) then
			self:drawText(getText("IGUI_ISAWindowsSumaryTab_NoEnoughSun"), text_x2, text_y + line * 0, 0, 1, 0, 1, UIFont.Small)
		else
			self:drawText(getText("IGUI_ISAWindowsSumaryTab_Working"), text_x2, text_y + line * 0, 0, 1, 0, 1, UIFont.Small)
		end
	end

	if (self.maxCapacity > 0) then
		self:drawText(string.format("%d%%", self.batteryLevel * 100), text_x2, text_y + line * 1, 0, 1, 0, 1, UIFont.Small)

		if (self.difference > 0) then
			if self.maxCapacity == self.charge then
				self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_BatteryStatus") .. ":", text_x, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
				self:drawText(getText("IGUI_ISAWindowsSumaryTab_FullyCharged"), text_x2, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
			else
				local ctime = ((self.maxCapacity - self.charge) / self.difference)
				local days = math.floor(ctime / 24)
				local hours = math.floor(ctime % 24)
				local minutes = math.floor((ctime - math.floor(ctime)) * 60)
				self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_ChargedIn"), text_x, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
				self:drawText(days > 0 and (days .. " " .. getText("IGUI_Gametime_days")) or hours > 0 and (hours .. " " .. getText("IGUI_Gametime_hours")) or (minutes .. " " .. getText("IGUI_Gametime_minutes")), text_x2, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
			end
		elseif (self.difference < 0) then
			if (self.charge == 0) then
				self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_BatteryStatus") .. ":", text_x, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
				self:drawText(getText("IGUI_ISAWindowsSumaryTab_FullyDischarged"), text_x2, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
			else
				local dtime = math.abs(self.charge / self.difference)
				local days = math.floor(dtime / 24)
				local hours = math.floor(dtime % 24)
				local minutes = math.floor((dtime - math.floor(dtime)) * 60)
				self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_DischargedIn"), text_x, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
				self:drawText(days > 0 and (days .. " " .. getText("IGUI_Gametime_days")) or hours > 0 and (hours .. " " .. getText("IGUI_Gametime_hours")) or (minutes .. " " .. getText("IGUI_Gametime_minutes")), text_x2, text_y + line * 2, 0, 1, 0, 1, UIFont.Small)
			end
		else
			self:drawText(getText("IGUI_ISAWindowsSumaryTab_NotCharging"), text_x2, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
		end
		if self.charge > 0 and self.drain > 0 then
			local dtime = self.charge / self.drain
			local days = math.floor(dtime / 24)
			local hours = math.floor(dtime % 24)
			local minutes = math.floor((dtime - math.floor(dtime)) * 60)
			self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_BatteryRemaining"), text_x, text_y + line *3, 0, 1, 0, 1, UIFont.Small)
			self:drawText(string.format("%d %s\n%d %s\n%d %s",days,getText("IGUI_Gametime_days"),hours,getText("IGUI_Gametime_hours"),minutes,getText("IGUI_Gametime_minutes")), text_x2, text_y + line *3, 0, 1, 0, 1, UIFont.Small)
		end
	else
		self:drawText(getText("IGUI_ISAWindowsSumaryTab_NoBatteries"), text_x2, text_y + line *1, 0, 1, 0, 1, UIFont.Small)
		self:drawText(getText("IGUI_ISAWindowsSumaryTab_NotCharging"), text_x2, text_y + line *2, 0, 1, 0, 1, UIFont.Small)
	end
end

function ISAWindowsSumaryTab:new(x, y, width, height)
	local o = ISPanelJoypad.new(self, x, y, width, height)
	o:noBackground()

	-- Textures
	o.textureBattery = getTexture("media/ui/isa_battery.png")
	o.textureCables = getTexture("media/ui/isa_cables.png")
	o.textureHouse = getTexture("media/ui/isa_house.png")
	o.textureSolarPanel = getTexture("media/ui/isa_solar_panel.png")
	o.textureSolarPanelNoEnergy = getTexture("media/ui/isa_solar_panel_no_energy.png")
	o.textureCross = getTexture("media/ui/isa_cross.png")
	o.textureSolarRadiation = getTexture("media/ui/isa_solar_radiation.png")
	o.textureSun = getTexture("media/ui/isa_sun.png")
	o.textureMoon = getTexture("media/ui/isa_moon.png")

	local maxMeasured = o.measureTexts()
	local maxLR = maxMeasured.left + maxMeasured.right
	o.sumBox = {}
	if maxLR > 580 then -- resize?
		o.sumBox.x = 0
		o.sumBox.width = 580
		o.sumBox.pad1 = 1
		o.sumBox.textX = maxMeasured.left
	elseif maxLR > 570 then
		o.sumBox.x = 0
		o.sumBox.width = 580
		o.sumBox.pad1 = 580 - maxLR
		o.sumBox.textX = maxMeasured.left
	elseif maxLR > 530 then
		o.sumBox.x = 0
		o.sumBox.width = 580
		o.sumBox.pad1 = 10
		o.sumBox.textX = maxMeasured.left + math.floor((570-maxLR) / 2)
	elseif maxLR > 490 then
		o.sumBox.x = math.floor((570 - maxLR) / 2)
		o.sumBox.width = maxLR + 50
		o.sumBox.pad1 = 10
		o.sumBox.textX = o.sumBox.x + 20 + maxMeasured.left
	else
		o.sumBox.x = 510 - maxLR
		o.sumBox.width = maxLR + 50
		o.sumBox.pad1 = 10
		o.sumBox.textX = o.sumBox.x + 20 + maxMeasured.left
	end

	-- Used variables
	o.currentFrame = 0
	o.thereAreBatteries = false
	o.thereArePanels = false
	o.panelsMaxInput = 0
	o.panelsInput = 0
	o.batteryLevel = 0
	o.batteryCharging = false
	o.difference = 0
	o.night = false

	o.fps = getCore():getOptionUIRenderFPS()
   return o
end

function ISAWindowsSumaryTab.measureTexts()
	local textTable = {
		left = {
			"IGUI_ISAWindowsSumaryTab_PanelsStatus",
			"IGUI_ISAWindowsSumaryTab_BatteryLevel",
			"IGUI_ISAWindowsSumaryTab_BatteryStatus",
			"IGUI_ISAWindowsSumaryTab_ChargedIn",
			"IGUI_ISAWindowsSumaryTab_DischargedIn",
			"IGUI_ISAWindowsSumaryTab_BatteryRemaining",
		},
		right = {
			"IGUI_ISAWindowsSumaryTab_NoEnoughPanels",
			"IGUI_ISAWindowsSumaryTab_NoEnoughSun",
			"IGUI_ISAWindowsSumaryTab_FullyCharged",
			"IGUI_ISAWindowsSumaryTab_FullyDischarged",
			"IGUI_ISAWindowsSumaryTab_NotCharging",
			"IGUI_ISAWindowsSumaryTab_NoBatteries",
		}
	}

	local max = { left = 0, right = 0}
	for type,texts in pairs(textTable) do
		for _,text in ipairs(texts) do
			local width = getTextManager():MeasureStringX(UIFont.Small, getText(text))
			max[type] = math.max(max[type], width)
		end
	end

	return max
end

isa.StatusWindowSummaryView = ISAWindowsSumaryTab