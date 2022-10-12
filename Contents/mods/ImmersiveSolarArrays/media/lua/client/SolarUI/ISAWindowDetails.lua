require "ISUI/ISPanelJoypad"

ISAWindowDetails = ISPanelJoypad:derive("ISAWindowDetails")

function ISAWindowDetails:createChildren()
    self.devButton = ISButton:new(self.width-120, 20, 100, 25, getText("IGUI_ISAWindow_Details_UpdateDevices"), self, self.updateDevices)
    self:addChild(self.devButton)

    --self:setScrollChildren(true)
    --self:addScrollBars()
end

function ISAWindowDetails:render()
    local textX = 10
    local textXb = self.len1
    local textY = 10
    local fontHeightSm = getTextManager():getFontHeight(UIFont.Small)
    local fontHeightMed = getTextManager():getFontHeight(UIFont.Medium)

    local pb = self.parent.parent.luaPB
    if not (pb and pb:getIsoObject()) then print("ISA no Lua Obj"); return ISAStatusWindow.instance:close() end

    if getPlayer():DistToSquared(pb.x + 0.5, pb.y + 0.5) <= 10 then
        pb:updateFromIsoObject()
        local devices = pb:getSquare():getGenerator():getItemsPowered()

        self:drawText(getText("ContextMenu_ISA_BatteryBank"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
        textY = textY + fontHeightMed + 3
        self:drawText(getText("IGUI_ISAWindow_Details_MaxCapacity"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawText(tostring(math.floor(pb.maxcapacity) .. "Ah"), textXb, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        if pb.drain > 0 then
            local autonomy =  pb.charge / pb.drain
            local days = math.floor(autonomy / 24)
            local hours = math.floor(autonomy % 24)
            local minutes = math.floor((autonomy - math.floor(autonomy)) * 60)
            self:drawText(getText("IGUI_ISAWindow_Details_Autonomy"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawText(days .. " " .. getText("IGUI_Gametime_days") .. ", " .. hours .. " " .. getText("IGUI_Gametime_hours") .. ", " .. minutes .. " " .. getText("IGUI_Gametime_minutes"), textXb, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end
        self:drawText(getText("IGUI_ISAWindow_Details_ShouldDrain"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawText((pb:shouldDrain() and getText("UI_Yes") or getText("UI_No")), textXb, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm

        textY = textY + fontHeightSm
        self:drawText(getText("ISA_ElectricalDevices"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
        self.devButton:setY(textY)
        self.devButton:setVisible(true)
        textY = textY + fontHeightMed + 3
        self:drawText(getText("IGUI_Total") .. " " .. getText("IGUI_PowerConsumption") .. ": " .. string.format("%.2f",pb.drain) .. " Ah", textX, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        for i=0, devices:size() -1 do
            local itext = devices:get(i):split("\\(")[1]
            self:drawText(itext, textX, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end

        textY = textY + fontHeightSm
        self:drawText(getText("IGUI_ISAWindow_Details_ElectricityExternal"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
        textY = textY + fontHeightMed + 3
        self:drawText(getText("IGUI_ISAWindow_Details_conGenerator"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawText((pb.conGenerator and getText("UI_Yes") or getText("UI_No")), textXb, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        if pb.conGenerator then
            self:drawText(getText("IGUI_ISAWindow_Details_Failsafe"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawText((ISAScan.findOnSquare(getSquare(pb.conGenerator.x,pb.conGenerator.y,pb.conGenerator.z), "solarmod_tileset_01_15") and getText("UI_Yes") or getText("UI_No")), textXb, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        else
            local inrange, outofrange = pb:getGeneratorsInAreaInfo()
            self:drawText(getText("IGUI_ISAWindow_Details_GenInRange"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawText(tostring(inrange), textXb, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
            self:drawText(getText("IGUI_ISAWindow_Details_GenOutOfRange"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawText(tostring(outofrange), textXb, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end
        if getWorld().isHydroPowerOn then
            self:drawText(getText("IGUI_ISAWindow_Details_GlobalGrid"), textX, textY, 1, 1, 1, 1, UIFont.Small)
            self:drawText(getWorld():isHydroPowerOn() and getText("UI_Yes") or getText("UI_No"), textXb, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end

        --self:setScrollHeight(textY+10)
        self:setHeightAndParentHeight(textY+10)
    else
        self.devButton:setVisible(false)
        self:drawText(getText("IGUI_ISAWindow_Details_Far"), textX, textY, 1, 0, 0, 1, UIFont.Medium)
    end
end

function ISAWindowDetails:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    local len = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ISAWindow_Details_Autonomy")) + 20
    o.len1 = len > 250 and len or 250

    ISAWindowDetails.instance = o
    return o
end

function ISAWindowDetails:updateDevices()
    local luapb = self.parent.parent.luaPB
    --local generator = luapb:getSquare():getGenerator()
    --gen:setSurroundingElectricity()
    local pb =  { x = luapb.x, y = luapb.y, z = luapb.z }
    CPowerbankSystem.instance:sendCommand(getPlayer(),"activatePowerbank", { pb = pb, activate = luapb.on })
end

ISAStatusWindow.instance = nil
