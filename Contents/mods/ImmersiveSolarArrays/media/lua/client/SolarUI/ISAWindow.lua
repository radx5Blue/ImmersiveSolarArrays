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
	self:setInfo(self.sumaryView.infoText) --need first time we open window

	self.detailsView = ISAWindowDetails:new(0, 8, self.width, self.height-8)
	self.detailsView:initialise()
	self.panel:addView(getText("IGUI_ISAWindow_Details_TabTitle"), self.detailsView)

	self.debugView = ISAWindowDebug:new(0, 8, 200, 25)
	self.debugView:initialise()
	self.panel:addView("Debug", self.debugView)


	-- Set the correct size before restoring the layout.  Currently, ISCharacterScreen:render sets the height/width.
	--self:setWidth(self.charScreen.width)
	--self:setHeight(self.charScreen.height);
	--ISLayoutManager.RegisterWindow('isastatuswindow', ISAStatusWindow, self)
end

function ISAStatusWindow:new(x, y, width, height)
	local o = {}
	o = ISCollapsableWindow:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self
	o:setResizable(false)

	ISAStatusWindow.instance = o
	return o
end

function ISAStatusWindow.OnOpenPanel(worldobjects,square,player)
	local instance = ISAStatusWindow.instance
	if instance == nil then
		instance = ISAStatusWindow:new(590, 100, 200, 200)
		instance:initialise()
	end
	instance:addToUIManager()

	instance.square = square
	instance.luaPB = CPowerbankSystem.instance:getLuaObjectAt(square:getX(),square:getY(),square:getZ())
	instance.playerNum = player
	instance.player = getSpecificPlayer(player)
	--if not instance.panel.activeView then
	--	self:setInfo(getText("IGUI_ISAWindowsSumaryTab_InfoText"))
	--end
	--print("! ",instance.panel.activeView)
	if instance.panel.activeView and instance.panel:getActiveViewIndex() ~= 1 then
		--instance.panel.activeView.view:setVisible(false)
		instance.panel:activateView(getText("IGUI_ISAWindowsSumaryTab_TabTitle"))
	end
end

function ISAStatusWindow:close()
	self:removeFromUIManager()
end