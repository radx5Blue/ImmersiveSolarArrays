require "ISUI/ISPanelJoypad"

ISAWindowDebug = ISPanelJoypad:derive("ISAWindowDebug")

function ISAWindowDebug:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    ISAWindowDebug.instance = o
    return o
end

function ISAWindowDebug:createChildren()
    self.buttonHeight = 25

    self.showBackupDetailsButton = ISButton:new(0, 0, 200, self.buttonHeight, getText("IGUI_ISAWindow_Debug_ShowBackup"), self, self.showBackupDetails)
    self.showBackupDetailsButton:setBackgroundRGBA(0.2,0.2,0.2,1)
    self.showBackupDetailsButton:setBorderRGBA(0.2,0.2,0.2,1)
    self:addChild(self.showBackupDetailsButton)

    self.containerButton = ISButton:new(0, self.buttonHeight, 200, self.buttonHeight, "Update Container Items", self, self.checkContainer)
    self.containerButton:setBackgroundRGBA(0.3,0.12,0.12,1)
    self.containerButton:setBorderRGBA(0.3,0.12,0.12,1)
    self.containerButton.tooltip = "Use if Battery Bank doesn't update after Inventory Transfer Action"
    self:addChild(self.containerButton)

    self.plugBackupButton = ISButton:new(0, self.buttonHeight*2, 200, self.buttonHeight, "Connect Backup Generator", self, self.plugBackup)
    self.plugBackupButton:setBackgroundRGBA(0.3,0.12,0.12,1)
    self.plugBackupButton:setBorderRGBA(0.3,0.12,0.12,1)
    self:addChild(self.plugBackupButton)
end

function ISAWindowDebug:setVisible(visible)
    ISPanelJoypad.setVisible(self,visible)
    if visible then
        local buttons = 2
        if getDebug() then
            self.plugBackupButton:setY(self.buttonHeight*buttons)
            self.plugBackupButton:setVisible(true)
            buttons = buttons + 1
        else
            self.plugBackupButton:setVisible(false)
        end
        self:setWidthAndParentWidth(self.width)
        self:setHeightAndParentHeight(self.buttonHeight*buttons)
    end
end

function ISAWindowDebug:prerender()
    if self.containerButton.disableFrame then
        self.containerButton.disableFrame = self.containerButton.disableFrame -1
        if self.containerButton.disableFrame <= 0 then self.containerButton.enable = true; self.containerButton.disableFrame = nil end
    end
    if self.plugBackupButton:isVisible() then
        local square = self.parent.parent.player:getSquare()
        local generator = square and square:getGenerator()
        self.plugBackupButton.generator = generator
        self.plugBackupButton.enable = false
        if not generator then self.plugBackupButton.tooltip = " <RGB:1,0,0>No generator on player's square"
        elseif not generator:isConnected() then self.plugBackupButton.tooltip = " <RGB:1,0,0>Generator is not connected"
        elseif ISAScan.findTypeOnSquare(square,"Powerbank") then self.plugBackupButton.tooltip = " <RGB:1,0,0>This is a Powerbank"
        else
            self.plugBackupButton.enable = true
            self.plugBackupButton.tooltip = "Warning: No area check"
        end
    end
end

function ISAWindowDebug:showBackupDetails()
    local show = not ISAWindowDetails.instance.showBackupDetails
    ISAWindowDetails.instance.showBackupDetails = show
    self.showBackupDetailsButton.title = show and getText("IGUI_ISAWindow_Debug_HideBackup") or getText("IGUI_ISAWindow_Debug_ShowBackup")
end

function ISAWindowDebug:checkContainer()
    local luapb = self.parent.parent.luaPB
    CPowerbankSystem.instance:sendCommand(self.parent.parent.player,"countBatteries", { x = luapb.x, y = luapb.y, z = luapb.z })
    self.containerButton.enable = false
    self.containerButton.disableFrame = 3 * getPerformance():getUIRenderFPS()
end

function ISAWindowDebug:plugBackup()
    if self.plugBackupButton.generator then
        local pb = self.parent.parent.luaPB
        local generator = self.plugBackupButton.generator
        CPowerbankSystem.instance:sendCommand(self.parent.parent.player,"plugGenerator", { pbList = { { x = pb.x, y = pb.y, z = pb.z } }, gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }, plug = true })
    end
end
