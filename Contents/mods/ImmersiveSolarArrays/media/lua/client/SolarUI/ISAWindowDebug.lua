require "ISUI/ISPanelJoypad"

ISAWindowDebug = ISPanelJoypad:derive("ISAWindowDebug")

function ISAWindowDebug:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    ISAWindowDebug.instance = o
    return o
end

function ISAWindowDebug:createChildren()
    --local buttons
    local height = 25
    self.containerButton = ISButton:new(0, 0, 200, height, "Check Container Items", self, self.checkContainer)
    self.containerButton:setBackgroundRGBA(0.23,0,0,1)
    self:addChild(self.containerButton)

    --self.containerButton2 = ISButton:new(0, height, 250, height, "Force Battery Update", self, self.checkContainer)
    --self.containerButton2:setBackgroundRGBA(1,0,0,1)
    --self:addChild(self.containerButton2)
    --buttons = 2
    --
    --self:setHeight(buttons*height)
end

function ISAWindowDebug:setVisible(visible)
    ISPanelJoypad.setVisible(self,visible)
    if visible then
        self:setWidthAndParentWidth(self.width)
        self:setHeightAndParentHeight(self.height)
    end
end

function ISAWindowDebug:checkContainer()
    local luapb = self.parent.parent.luaPB
    CPowerbankSystem.instance:sendCommand(getSpecificPlayer(self.parent.parent.player),"countBatteries", { x = luapb.x, y = luapb.y, z = luapb.z })
end
