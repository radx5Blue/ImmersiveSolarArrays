require "ISUI/ISPanelJoypad"

ISAWindowDetails = ISPanelJoypad:derive("ISAWindowDetails")

function ISAWindowDetails:render()
    local medFont = getTextManager():getFontHeight(UIFont.Medium)
    local textX = 10
    local textXb = self.len1
    local textY = medFont
    local pb = self.parent.parent.luaPB

    if getPlayer():DistToSquared(pb.x + 0.5, pb.y + 0.5) <= 10 then
        if pb then
            pb:updateFromIsoObject()
            self:drawText(getText("IGUI_ISAWindow_Details_conGenerator"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
            self:drawText((pb.conGenerator and getText("UI_Yes") or getText("UI_No")), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
            textY = textY + medFont
            if pb.conGenerator then
                self:drawText(getText("IGUI_ISAWindow_Details_Failsafe"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
                self:drawText((ISAScan.findOnSquare(getSquare(pb.conGenerator.x,pb.conGenerator.y,pb.conGenerator.z), "solarmod_tileset_01_15") and getText("UI_Yes") or getText("UI_No")), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
                textY = textY + medFont
            else
                local inrange, outofrange = pb:getGeneratorsInAreaInfo()
                self:drawText(getText("IGUI_ISAWindow_Details_GenInRange"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
                self:drawText(tostring(inrange), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
                textY = textY + medFont
                self:drawText(getText("IGUI_ISAWindow_Details_GenOutOfRange"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
                self:drawText(tostring(outofrange), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
                textY = textY + medFont
            end
            textY = textY + medFont
            self:drawText(getText("IGUI_ISAWindow_Details_ShouldDrain"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
            self:drawText((pb:shouldDrain() and getText("UI_Yes") or getText("UI_No")), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
            textY = textY + medFont
            self:drawText(getText("IGUI_ISAWindow_Details_MaxCapacity"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
            self:drawText(tostring(math.floor(pb.maxcapacity) .. "Ah"), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
            textY = textY + medFont
            if pb.drain > 0 then
                local autonomy =  pb.charge / pb.drain
                local days = math.floor(autonomy / 24)
                local hours = math.floor(autonomy % 24)
                local minutes = math.floor((autonomy - math.floor(autonomy)) * 60)
                self:drawText(getText("IGUI_ISAWindow_Details_Autonomy"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
                self:drawText(days .. " " .. getText("IGUI_Gametime_days") .. ", " .. hours .. " " .. getText("IGUI_Gametime_hours") .. ", " .. minutes .. " " .. getText("IGUI_Gametime_minutes"), textXb, textY, 1, 1, 1, 1, UIFont.Medium)
                textY = textY + medFont
            end
        else
            ISAStatusWindow.instance:close()
        end
    else
        self:drawText(getText("IGUI_ISAWindow_Details_Far"), textX, textY, 1, 0, 0, 1, UIFont.Medium)
    end
end

function ISAWindowDetails:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    local len = getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_ISAWindow_Details_Autonomy")) + 20
    o.len1 = len > 300 and len or 300

    ISAWindowDetails.instance = o
    return o
end
