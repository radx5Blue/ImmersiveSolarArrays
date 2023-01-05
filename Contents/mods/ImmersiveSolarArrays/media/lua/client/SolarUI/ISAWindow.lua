require "ISUI/ISCollapsableWindow"
require "ISUI/ISLayoutManager"

ISAStatusWindow = ISCollapsableWindow:derive("ISAStatusWindow")

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
	self:setInfo(self.sumaryView.infoText) --need first time we open window

	self.detailsView = ISAWindowDetails:new(0, 8, self.width, self.height-8)
	self.detailsView:initialise()
	self.panel:addView(getText("IGUI_ISAWindow_Details_TabTitle"), self.detailsView)

	self.debugView = ISAWindowDebug:new(0, 8, 200, 25)
	self.debugView:initialise()
	self.panel:addView("Debug", self.debugView)

	ISLayoutManager.RegisterWindow('isastatuswindow', ISAStatusWindow, self)
end

function ISAStatusWindow:new(x, y, width, height)
	local o = {}
	o = ISCollapsableWindow:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self
	o:setResizable(false)
	o.title = getText("IGUI_ISAWindowsStatus_Title")

	ISAStatusWindow.instance = o
	return o
end

function ISAStatusWindow.OnOpenPanel(worldobjects,square,player)
	local instance = ISAStatusWindow.instance or ISAStatusWindow:new(100, 100, 580, 400)
	instance:addToUIManager()

	instance.square = square
	instance.luaPB = CPowerbankSystem.instance:getLuaObjectAt(square:getX(),square:getY(),square:getZ())
	instance.playerNum = player
	instance.player = getSpecificPlayer(player)

	if instance.panel.activeView and instance.panel:getActiveViewIndex() ~= 1 then
		instance.panel:activateView(getText("IGUI_ISAWindowsSumaryTab_TabTitle"))
	end
	instance.sumaryView.currentFrame = 0
end

function ISAStatusWindow:close()
	self:removeFromUIManager()
end