require "ISUI/ISPanelJoypad"

ISAWindowDevices = ISPanelJoypad:derive("ISAWindowDevices")

function ISAWindowDevices:createChildren()
    self.button = ISButton:new(self.width-120, 20, 100, 25, "Update Devices", self, self.updateDevices)
    self.button:setAnchorLeft(true);
    self.button:setAnchorRight(true);
    self.button:setAnchorTop(true);
    self.button:setAnchorBottom(false);
    self:addChild(self.button)

    --self:setScrollChildren(true)
    self:addScrollBars()

end

function ISAWindowDevices:render()
    local fontHeightSm = getTextManager():getFontHeight(UIFont.Small)
    local fontHeightMed = getTextManager():getFontHeight(UIFont.Medium)
    local textX = 10
    local textY = 10
    local pb = self.parent.parent.luaPB
    if not (pb and pb:getIsoObject()) then return ISAStatusWindow.instance:close() end
    pb:updateFromIsoObject()
    local devices = pb:getSquare():getGenerator():getItemsPowered()

    self:drawText(getText("IGUI_PowerConsumption"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
    textY = textY + fontHeightMed + 5
    for i=0, 50 do
        --myText = itext
        --cut on (
        self:drawText(tostring(i), textX, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
    end
    --for i=0, devices:size() -1 do
    --    local itext = devices:get(i)
    --    --myText = itext
    --    --cut on (
    --    self:drawText(itext, textX, textY, 1, 1, 1, 1, UIFont.Small)
    --    textY = textY + fontHeightSm
    --end
    textY = textY + fontHeightSm
    self:drawText(getText("IGUI_Total") .. ": " .. string.format("%.2f",pb.drain) .. " Ah", textX, textY, 1, 1, 1, 1, UIFont.Small)
    textY = textY + fontHeightSm
    self:setScrollHeight(textY+40)

end

function ISAWindowDevices:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    ISAWindowDevices.instance = o
    return o
end

function ISAWindowDevices:updateDevices()
    local luapb = self.parent.parent.luaPB
    local generator = luapb:getSquare():getGenerator()
    --gen:setSurroundingElectricity()
    local pb =  { x = luapb.x, y = luapb.y, z = luapb.z }
    CPowerbankSystem.instance:sendCommand(getPlayer(),"activatePowerbank", { pb = pb, activate = luapb.on })
end
--ISAStatusWindow.instance = nil
