require "ISUI/ISCollapsableWindow"
require "ISUI/ISLayoutManager"

ISAStatusWindow = ISCollapsableWindow:derive("ISAStatusWindow")

function ISAStatusWindow:initialise()
	ISCollapsableWindow.initialise(self)
	self.title = getText("IGUI_ISAWindowsStatus_Title")
end

function ISAStatusWindow:createChildren()
	ISCollapsableWindow.createChildren(self);
	local th = self:titleBarHeight()
	self.panel = ISTabPanel:new(0, th, self.width, self.height-th);
	self.panel:initialise();
	self.panel.tabPadX = 15;
	self.panel.equalTabWidth = false;
	self:addChild(self.panel);
	--self.panel:setOnTabTornOff(self, ISAStatusWindow.onTabTornOff)

	self.sumaryView = ISAWindowsSumaryTab:new(0, 8, self.width, self.height-8)
	self.sumaryView:initialise()
    self.sumaryView.infoText = getText("IGUI_ISAWindowsSumaryTab_InfoText")
	self.panel:addView(getText("IGUI_ISAWindowsSumaryTab_TabTitle"), self.sumaryView)

	self.detailsView = ISAWindowDetails:new(0, 8, self.width, self.height-8)
	self.detailsView:initialise()
	self.detailsView.infoText = getText("IGUI_ISAWindow_Details_InfoText")
	self.panel:addView(getText("IGUI_ISAWindow_Details_TabTitle"), self.detailsView)

	self.debugView = ISAWindowDebug:new(0, 8, 200, 25)
	self.debugView:initialise()
	self.debugView.infoText = "Debug"
	self.panel:addView("Debug", self.debugView)

	-- Set the correct size before restoring the layout.  Currently, ISCharacterScreen:render sets the height/width.
	--self:setWidth(self.charScreen.width)
	--self:setHeight(self.charScreen.height);
	--ISLayoutManager.RegisterWindow('isastatuswindow', ISAStatusWindow, self)
    self.visibleOnStartup = self:getIsVisible() -- hack, see ISPlayerDataObject.lua
end

function ISAStatusWindow:new(x, y, width, height)
	local o = {};
	o = ISCollapsableWindow:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
--	o:noBackground();
	o:setResizable(false)
	o.visibleOnStartup = false

	--ISCharacterInfoWindow.instance = o;
	return o;
end

function ISAStatusWindow.OnOpenPanel(fsquare,player)
	if ISAStatusWindow.instance == nil then
		local ui = ISAStatusWindow:new(100, 100, 200, 200)
		ui:initialise()
		ISAStatusWindow.instance = ui
	end
	local instance = ISAStatusWindow.instance
	instance:addToUIManager()

	instance.luaPB = CPowerbankSystem.instance:getLuaObjectAt(fsquare:getX(),fsquare:getY(),fsquare:getZ())
	instance.player = player
	instance.sumaryView.powerbank = ISAStatusWindow.instance.luaPB
	instance.sumaryView.currentFrame = 0

	--instance.panel:activateView(getText("IGUI_ISAWindowsSumaryTab_TabTitle"))
end

function ISAStatusWindow:close()
	self:removeFromUIManager()
end