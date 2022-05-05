require "ISUI/ISPanelJoypad"

ISAWindowsSumaryTab = ISPanelJoypad:derive("ISAWindowsSumaryTab");

function ISAWindowsSumaryTab:initialise()
	ISPanelJoypad.initialise(self);

	-- House
	self.imageHouse = ISImage:new(321, 185, 254, 185, self.textureHouse);
	self.imageHouse.scaledWidth = 254;
	self.imageHouse.scaledHeight = 185;
	self.imageHouse:initialise();
	self.imageHouse.parent = self;
    self:addChild(self.imageHouse);

	-- Cables
	self.imageCables = ISImage:new(52, 358, 403, 24, self.textureCables);
	self.imageCables.scaledWidth = 403;
	self.imageCables.scaledHeight = 24;
	self.imageCables:initialise();
	self.imageCables.parent = self;
    self:addChild(self.imageCables);

	-- Battery
	self.imageBattery = ISImage:new(16, 302, 76, 69, self.textureBattery);
	self.imageBattery.scaledWidth = 76;
	self.imageBattery.scaledHeight = 69;
	self.imageBattery:initialise();
	self.imageBattery.parent = self;
	--self.imageBattery:setMouseOverText("Test");
    self:addChild(self.imageBattery);

	self.imageBatteryCross = ISImage:new(17, 305, 72, 72, self.textureCross);
	self.imageBatteryCross.scaledWidth = 72;
	self.imageBatteryCross.scaledHeight = 72;
	self.imageBatteryCross:initialise();
	self.imageBatteryCross.parent = self;
    self:addChild(self.imageBatteryCross);

	-- Sun and radiation
	self.imageSun = ISImage:new(0, 0, 128, 128, self.textureSun);
	self.imageSun.scaledWidth = 128;
	self.imageSun.scaledHeight = 128;
	self.imageSun:initialise();
	self.imageSun.parent = self;
    self:addChild(self.imageSun);

--[[
	self.imageSolarRadiation1 = ISImage:new(81, 122, 93, 78, self.textureSolarRadiation);
	self.imageSolarRadiation1.scaledWidth = 93;
	self.imageSolarRadiation1.scaledHeight = 78;
	self.imageSolarRadiation1:initialise();
	self.imageSolarRadiation1.parent = self;
    self:addChild(self.imageSolarRadiation1);

	self.imageSolarRadiation2 = ISImage:new(98, 107, 93, 78, self.textureSolarRadiation);
	self.imageSolarRadiation2.scaledWidth = 93;
	self.imageSolarRadiation2.scaledHeight = 78;
	self.imageSolarRadiation2:initialise();
	self.imageSolarRadiation2.parent = self;
    self:addChild(self.imageSolarRadiation2);

	self.imageSolarRadiation3 = ISImage:new(116, 91, 93, 78, self.textureSolarRadiation);
	self.imageSolarRadiation3.scaledWidth = 93;
	self.imageSolarRadiation3.scaledHeight = 78;
	self.imageSolarRadiation3:initialise();
	self.imageSolarRadiation3.parent = self;
    self:addChild(self.imageSolarRadiation3);

	self.imageSolarRadiationCross = ISImage:new(118, 116, 72, 72, self.textureCross);
	self.imageSolarRadiationCross.scaledWidth = 72;
	self.imageSolarRadiationCross.scaledHeight = 72;
	self.imageSolarRadiationCross:initialise();
	self.imageSolarRadiationCross.parent = self;
    self:addChild(self.imageSolarRadiationCross);
	]]

	-- Moon
	self.imageMoon = ISImage:new(0, 0, 128, 128, self.textureMoon);
	self.imageMoon.scaledWidth = 128;
	self.imageMoon.scaledHeight = 128;
	self.imageMoon:initialise();
	self.imageMoon.parent = self;
    self:addChild(self.imageMoon);

	-- Solar Panel (two modes)
	self.imageSolarPanel = ISImage:new(123, 267, 155, 103, self.textureSolarPanel)
	self.imageSolarPanel.scaledWidth = 155;
	self.imageSolarPanel.scaledHeight = 103;
	self.imageSolarPanel:initialise();
	self.imageSolarPanel.parent = self;
    self:addChild(self.imageSolarPanel);
	self.imageSolarPanel:setVisible(false);

	self.imageSolarPanelNoEnergy = ISImage:new(123, 267, 155, 103, self.textureSolarPanelNoEnergy)
	self.imageSolarPanelNoEnergy.scaledWidth = 155;
	self.imageSolarPanelNoEnergy.scaledHeight = 103;
	self.imageSolarPanelNoEnergy:initialise();
	self.imageSolarPanelNoEnergy.parent = self;
    self:addChild(self.imageSolarPanelNoEnergy);

	self.imageSolarPanelCross = ISImage:new(166, 268, 72, 72, self.textureCross);
	self.imageSolarPanelCross.scaledWidth = 72;
	self.imageSolarPanelCross.scaledHeight = 72;
	self.imageSolarPanelCross:initialise();
	self.imageSolarPanelCross.parent = self;
    self:addChild(self.imageSolarPanelCross);

	-- Fix the daytime/nightime icon
	local currentTime = getGameTime():getTimeOfDay();
	if ISAIsDayTime(currentTime) then
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
    self.javaObject:setVisible(visible);
	if visible then
		local th = self.parent.parent:titleBarHeight()
		-- Set the Window size
		self.parent.parent:setWidth(580);
		self.parent.parent:setHeight(410 + th);

		-- Set the Panel size
		self.parent:setWidth(580);
		self.parent:setHeight(410 + th);
	end
end

function ISAWindowsSumaryTab:prerender()
	ISPanelJoypad.prerender(self);
end

function ISAWindowsSumaryTab:render()
	-- Update every 30 frames
	if ((self.currentFrame % 30) == 0) then
		if not (self.powerbank and self.powerbank:getIsoObject()) then return ISAStatusWindow.instance:close() end
		self.powerbank:updateFromIsoObject()
		self.connectedPanels = self.powerbank.npanels
		self.batteryLevel = self.powerbank.charge / self.powerbank.maxcapacity
		self.capacity = self.powerbank.maxcapacity
		self.batteryNumber = self.powerbank.batteries
		self.panelsMaxInput = CPowerbankSystem.instance.getMaxSolarOutput(self.connectedPanels)
		self.panelsInput = CPowerbankSystem.instance.getModifiedSolarOutput(self.connectedPanels)
		self.actualCharge = self.powerbank.charge
		self.drain = self.powerbank:shouldDrain() and self.powerbank.drain or 0
		self.difference = self.panelsInput - self.drain

		local currentTime = getGameTime():getTimeOfDay();
		if ISAIsDayTime(currentTime) then
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

		if (self.batteryNumber > 0) then
			if (self.thereAreBatteries == false) then
				self.imageBatteryCross:setVisible(false)
				self.thereAreBatteries = true;
			end
		else
			if (self.thereAreBatteries == true) then
				self.imageBatteryCross:setVisible(true)
				self.thereAreBatteries = false;
			end
		end

		if (self.connectedPanels > 0) then
			if (self.thereArePanels == false) then
				self.imageSolarPanelCross:setVisible(false)
				self.thereArePanels = true;
			end
		else
			if (self.thereArePanels == false) then
				self.imageSolarPanelCross:setVisible(true)
				self.thereArePanels = false;
			end
		end

		if self.difference > 0 then
			if (self.batteryCharging == false) then
				self.imageSolarPanel:setVisible(true);
				self.imageSolarPanelNoEnergy:setVisible(false);
				self.batteryCharging = true;
			end
		else
			if (self.batteryCharging == true) then
				self.imageSolarPanel:setVisible(false);
				self.imageSolarPanelNoEnergy:setVisible(true);
				self.batteryCharging = false;
			end
		end
		-- Reset the frames count to avoid overflow
		self.currentFrame = 0;
	end

	self.currentFrame = self.currentFrame + 1;

	-- Sumary box
	--self:drawRect(310, 25, 250, 125, 1.0, 1.0, 1.0, 1.0);
	self:drawRectBorder(310, 25, 250, 125, 1.0, 1.0, 1.0, 1.0);

	-- Sumary text
	local text_x = 435;
	local text_y = 30;
	self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_ConnectedPanels") .. ":", text_x, text_y, 0, 1, 0, 1, UIFont.Small);
	self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_PanelsStatus") .. ":", text_x, text_y + 15, 0, 1, 0, 1, UIFont.Small);
	self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_BatteryLevel") .. ":", text_x, text_y + 30, 0, 1, 0, 1, UIFont.Small);
	self:drawTextRight(getText("IGUI_ISAWindowsSumaryTab_BatteryStatus") .. ":", text_x, text_y + 45, 0, 1, 0, 1, UIFont.Small);

	-- Connected panels
	self:drawText(tostring(self.connectedPanels), text_x + 15, text_y, 0, 1, 0, 1, UIFont.Small);

	-- Solar panels status
	if (self.drain > self.panelsMaxInput) then
		self:drawText(getText("IGUI_ISAWindowsSumaryTab_NoEnoughPanels"), text_x + 15, text_y + 15, 0, 1, 0, 1, UIFont.Small);
	--elseif (self.drain > self.panelsMaxInput) then
	--	self:drawText(getText("IGUI_ISAWindowsSumaryTab_WillNotCharge"), text_x + 15, text_y + 15, 0, 1, 0, 1, UIFont.Small);
	else
		if (self.drain > self.panelsInput) then
			self:drawText(getText("IGUI_ISAWindowsSumaryTab_NoEnoughSun"), text_x + 15, text_y + 15, 0, 1, 0, 1, UIFont.Small);
		else
			self:drawText(getText("IGUI_ISAWindowsSumaryTab_Working"), text_x + 15, text_y + 15, 0, 1, 0, 1, UIFont.Small);
		end
	end

	if (self.batteryNumber > 0) then
		self:drawText(string.format("%d%%", (self.batteryLevel or 0) * 100), text_x + 15, text_y + 30, 0, 1, 0, 1, UIFont.Small);

		if (self.difference > 0) then
			local ctime = ((self.capacity - self.actualCharge) / self.difference);

			if (ctime == 0) then
				self:drawText(getText("IGUI_ISAWindowsSumaryTab_FullyCharged"), text_x + 15, text_y + 45, 0, 1, 0, 1, UIFont.Small);
			else
				local days = math.floor(ctime / 24);
				local hours = math.floor(ctime % 24);
				local minutes = (ctime - math.floor(ctime)) * 60;
				self:drawText(string.format(ISAFixedGetText("IGUI_ISAWindowsSumaryTab_ChargedIn"), days, hours, minutes), text_x + 15, text_y + 45, 0, 1, 0, 1, UIFont.Small);
			end

		elseif (self.difference < 0) then
			local dtime = math.abs(self.actualCharge / self.difference);

			if (dtime == 0) then
				self:drawText(getText("IGUI_ISAWindowsSumaryTab_FullyDischarged"), text_x + 15, text_y + 45, 0, 1, 0, 1, UIFont.Small);
			else
				local days = math.floor(dtime / 24);
				local hours = math.floor(dtime % 24);
				local minutes = (dtime - math.floor(dtime)) * 60;
				self:drawText(string.format(ISAFixedGetText("IGUI_ISAWindowsSumaryTab_DischargedIn"), days, hours, minutes), text_x + 15, text_y + 45, 0, 1, 0, 1, UIFont.Small);
			end
		else
			self:drawText(getText("IGUI_ISAWindowsSumaryTab_NotCharging"), text_x + 15, text_y + 45, 0, 1, 0, 1, UIFont.Small);
		end
	else
		self:drawText(getText("IGUI_ISAWindowsSumaryTab_NoBatteries"), text_x + 15, text_y + 30, 0, 1, 0, 1, UIFont.Small);
		self:drawText(getText("IGUI_ISAWindowsSumaryTab_NotCharging"), text_x + 15, text_y + 45, 0, 1, 0, 1, UIFont.Small);
	end
end

function ISAWindowsSumaryTab:new(x, y, width, height)
	local o = {};
	o = ISPanelJoypad:new(x, y, width, height);
	setmetatable(o, self);
    self.__index = self;
	o:noBackground();
	o.txtLen = 0;

	-- Textures
	o.textureBattery = getTexture("media/ui/isa_battery.png");
	o.textureCables = getTexture("media/ui/isa_cables.png");
	o.textureHouse = getTexture("media/ui/isa_house.png");
	o.textureSolarPanel = getTexture("media/ui/isa_solar_panel.png");
	o.textureSolarPanelNoEnergy = getTexture("media/ui/isa_solar_panel_no_energy.png");
	o.textureCross = getTexture("media/ui/isa_cross.png");
	o.textureSolarRadiation = getTexture("media/ui/isa_solar_radiation.png");
	o.textureSun = getTexture("media/ui/isa_sun.png");
	o.textureMoon = getTexture("media/ui/isa_moon.png");

    ISAWindowsSumaryTab.instance = o;

	-- Used variables
	self.currentFrame = 0;
	self.thereAreBatteries = false;
	self.thereArePanels = false;
	self.connectedPanels = 0;
	self.panelsMaxInput = 0;
	self.panelsInput = 0;
	self.batteryNumber = 0;
	self.batteryLevel = 0;
	self.batteryCharging = false;
	self.capacity = 0;
	self.actualCharge = 0;
	self.difference = 0;
	self.night = false;
   return o;
end

function ISAWindowsSumaryTab:close()
	ISPanelJoypad.close();

	-- Reset the currentFrame
	self.currentFrame = 0;

	-- Battery
	self:removeChild(self.imageBatteryCross);

	-- Sun and radiation
	self:removeChild(self.imageSun);
	self:removeChild(self.imageSolarRadiation1);
	self:removeChild(self.imageSolarRadiation2);
	self:removeChild(self.imageSolarRadiation3);
	self:removeChild(self.imageSolarRadiationCross);

	-- Solar Panel (two modes)
	self:removeChild(self.imageSolarPanel);
	self:removeChild(self.imageSolarPanelNoEnergy);
	self:removeChild(self.imageSolarPanelCross);

	self:removeFromUIManager()
end