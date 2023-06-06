require "ISUI/ISCollapsableWindow"
local isa = require "ISAUtilities"

local ISAStatusWindow = ISCollapsableWindow:derive("ISAStatusWindow")

function ISAStatusWindow:new(x, y, width, height)
	local o = ISCollapsableWindow.new(self,x, y, width, height)
	o.title = getText("IGUI_ISAWindowsStatus_Title")
	o:setResizable(false)

	ISAStatusWindow.instance = o
	return o
end

function ISAStatusWindow:createChildren()
	ISCollapsableWindow.createChildren(self);
	local th = self:titleBarHeight()
	self.panel = ISTabPanel:new(0, th, self.width, self.height-th)
	self.panel:initialise()
	self.panel.equalTabWidth = false
	self:addChild(self.panel)

	self.summaryView = isa.StatusWindowSummaryView:new(0, 8, self.width, self.height-8)
	self.summaryView:initialise()
    self.summaryView.infoText = getText("IGUI_ISAWindowsSumaryTab_InfoText")
	self.panel:addView(getText("IGUI_ISAWindowsSumaryTab_TabTitle"), self.summaryView)
	self:setInfo(self.summaryView.infoText) --need first time we open window

	self.detailsView = isa.StatusWindowDetailsView:new(0, 8, self.width, self.height-8)
	self.detailsView:initialise()
	self.panel:addView(getText("IGUI_ISAWindow_Details_TabTitle"), self.detailsView)

	self.debugView = isa.StatusWindowDebugView:new(0, 8, 200, 25)
	self.debugView:initialise()
	self.panel:addView("Debug", self.debugView)
end

function ISAStatusWindow.OnOpenPanel(player,square)
	local instance = ISAStatusWindow.instance
	if not instance then
		instance = ISAStatusWindow:new(100, 100, 580, 400)
		ISLayoutManager.RegisterWindow('isastatuswindow', ISAStatusWindow, instance)
	else
		if instance.panel.activeView and instance.panel:getActiveViewIndex() ~= 1 then
			instance.panel:activateView(getText("IGUI_ISAWindowsSumaryTab_TabTitle"))
		end
		instance.summaryView.currentFrame = 0
	end

	instance.player = player
	instance.playerObj = getSpecificPlayer(player)
	instance.square = square
	instance.luaPB = isa.PbSystem_client:getLuaObjectAt(square:getX(),square:getY(),square:getZ())

	instance:addToUIManager()
end

function ISAStatusWindow:close()
	self:removeFromUIManager()
	if JoypadState.players[self.player+1] then setPrevFocusForPlayer(self.player) end
end

isa.StatusWindow = ISAStatusWindow