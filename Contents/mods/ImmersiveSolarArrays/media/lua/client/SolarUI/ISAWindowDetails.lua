require "ISUI/ISPanelJoypad"

ISAWindowDetails = ISPanelJoypad:derive("ISAWindowDetails")

function ISAWindowDetails:new(x, y, width, height)
    local o = {}
    o = ISPanelJoypad:new(x, y, ISAWindowDetails.measureWidth(), height)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()

    ISAWindowDetails.instance = o
    return o
end

function ISAWindowDetails:createChildren()
    local y = getTextManager():getFontHeight(UIFont.Medium) + getTextManager():getFontHeight(UIFont.Small) * 4 + 15
    local width = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ISA_Update")) + 10
    self.devButton = ISButton:new(self.width-width-10, y, width, getTextManager():getFontHeight(UIFont.Medium), getText("IGUI_ISA_Update"), self, self.updateDevices)
    self:addChild(self.devButton)

    --self:setScrollChildren(true)
    --self:addScrollBars()
end

function ISAWindowDetails:setVisible(visible)
    ISPanelJoypad.setVisible(self,visible)
    if visible then
        self:setWidthAndParentWidth(self.width)
    end
end

function ISAWindowDetails:render()
    local pb = self.parent.parent.luaPB
    if not (pb and pb:getIsoObject()) then print("ISA no Lua Obj"); return ISAStatusWindow.instance:close() end

    local textX = 10
    local textXr = self.width -10
    local textY = 10
    local borderY
    local fontHeightSm = getTextManager():getFontHeight(UIFont.Small)
    local fontHeightMed = getTextManager():getFontHeight(UIFont.Medium)

    pb:updateFromIsoObject()
    local player = self.parent.parent.player
    local canSee = self.parent.parent.square:getCanSee(self.parent.parent.playerNum)
    local area = ISAScan.getValidBackupArea(player)
    local validArea = IsoUtils.DistanceToSquared(player:getX(),player:getY(),player:getZ(),pb.x+0.5,pb.y+0.5,pb.z) <= area.distance and math.abs(player:getZ()-pb.z) <= area.levels
    if canSee and validArea then
        local devices = pb:getSquare():getGenerator():getItemsPowered()

        self:drawText(getText("ContextMenu_ISA_BatteryBank"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
        textY = textY + fontHeightMed + 5
        borderY = textY-3
        self:drawText(getText("IGUI_ISAWindow_Details_MaxCapacity"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(tostring(math.floor(pb.maxcapacity) .. " Ah"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        self:drawText(getText("IGUI_ISAWindow_Details_ConnectedPanels"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(tostring(pb.npanels), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        self:drawText(getText("IGUI_ISAWindow_Details_MaxPanelOutput"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(string.format("%.1f",CPowerbankSystem.getMaxSolarOutput(pb.npanels)) .. " Ah", textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        self:drawRect(5, borderY, self.width-10, textY-borderY+3, 0.18, 1, 1, 1)

        textY = textY + fontHeightSm
        self:drawText(getText("IGUI_ISAWindow_Details_ElectricalDevices"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
        --self.devButton:setY(textY)
        self.devButton:setVisible(true)
        textY = textY + fontHeightMed + 5
        borderY = textY-3
        self:drawText(getText("IGUI_Total") .. " " .. getText("IGUI_PowerConsumption") .. ": ", textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(string.format("%.1f",pb.drain) .. " Ah", textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
        for i=0, devices:size() -1 do
            local itext = devices:get(i):split("\\(")[1]
            self:drawText(itext, textX, textY, 1, 1, 1, 1, UIFont.Small)
            textY = textY + fontHeightSm
        end
        self:drawRect(5, borderY, self.width-10, textY-borderY+3, 0.18, 1, 1, 1)


        --if getWorld().isHydroPowerOn then
        --    self:drawText(getText("IGUI_ISAWindow_Details_GlobalGrid"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        --    self:drawTextRight(getWorld():isHydroPowerOn() and getText("UI_Yes") or getText("UI_No"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        --    textY = textY + fontHeightSm
        --end

    else
        self.devButton:setVisible(false)
        self:drawText(getText("IGUI_ISAWindow_Details_Far"), textX, textY, 1, 0, 0, 1, UIFont.Medium)
        textY = textY + fontHeightMed
    end

    textY = textY + fontHeightSm
    self:drawText(getText("IGUI_ISAWindow_Details_ElectricityExternal"), textX, textY, 1, 1, 1, 1, UIFont.Medium)
    textY = textY + fontHeightMed + 5
    borderY = textY-3
    self:drawText(getText("IGUI_ISAWindow_Details_conGenerator"), textX, textY, 1, 1, 1, 1, UIFont.Small)
    self:drawTextRight((pb.conGenerator and getText("UI_Yes") or getText("UI_No")), textXr, textY, 1, 1, 1, 1, UIFont.Small)
    textY = textY + fontHeightSm
    if pb.conGenerator then
        self:drawText(getText("IGUI_ISAWindow_Details_Failsafe"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight((ISAScan.findOnSquare(getSquare(pb.conGenerator.x,pb.conGenerator.y,pb.conGenerator.z), "solarmod_tileset_01_15") and getText("UI_Yes") or getText("UI_No")), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm
    else
        local generators = CPowerbankSystem.getGeneratorsInAreaInfo(pb,area)
        self:drawText(getText("IGUI_ISAWindow_Details_GenInRange"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(tostring(generators), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm

        self:drawText("Player is inside valid area for backup: ", textX, textY, 1, 1, 1, 1, UIFont.Small)
        self:drawTextRight(validArea and getText("UI_Yes") or getText("UI_No"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        textY = textY + fontHeightSm



        --self:drawText(getText("IGUI_ISAWindow_Details_ValidRadius"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        --self:drawTextRight(tostring(info.radius), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        --textY = textY + fontHeightSm
        --self:drawText(getText("IGUI_ISAWindow_Details_ValidLevels"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        --self:drawTextRight(tostring(info.levels), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        --textY = textY + fontHeightSm
        --self:drawText(getText("IGUI_ISAWindow_Details_GenOutOfRange"), textX, textY, 1, 1, 1, 1, UIFont.Small)
        --self:drawTextRight(tostring(outofrange), textXr, textY, 1, 1, 1, 1, UIFont.Small)
        --textY = textY + fontHeightSm
    end
    self:drawRect(5, borderY, self.width-10, textY-borderY+3, 0.18, 1, 1, 1)

    --self:drawText("Should Drain: ", textX, textY, 1, 1, 1, 1, UIFont.Small)
    --self:drawTextRight(pb:shouldDrain() and getText("UI_Yes") or getText("UI_No"), textXr, textY, 1, 1, 1, 1, UIFont.Small)
    --textY = textY + fontHeightSm

    --self:setScrollHeight(textY+10)
    self:setHeightAndParentHeight(textY+10)
end

function ISAWindowDetails:updateDevices()
    local luapb = self.parent.parent.luaPB
    CPowerbankSystem.instance:sendCommand(self.parent.parent.player,"activatePowerbank", { pb = { x = luapb.x, y = luapb.y, z = luapb.z }, activate = luapb.on })
end

local function maxWidthOfTexts(texts)
    local max = 0
    for _,text in ipairs(texts) do
        local width = getTextManager():MeasureStringX(UIFont.Small, getText(text))
        max = math.max(max, width)
    end
    return max
end

function ISAWindowDetails.measureWidth()
    local len1 = maxWidthOfTexts({
        "IGUI_ISAWindow_Details_MaxCapacity",
        "IGUI_ISAWindow_Details_MaxPanelOutput",
        --"IGUI_ISAWindow_Details_ConnectedPanels",
    }) + getTextManager():MeasureStringX(UIFont.Small, "100000 Ah")
    local lenTPU = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_Total") .. " " .. getText("IGUI_PowerConsumption") .. ": 99999.9 Ah")
    local len2 = maxWidthOfTexts({
        "IGUI_ISAWindow_Details_conGenerator",
        "IGUI_ISAWindow_Details_Failsafe",
        "IGUI_ISAWindow_Details_GenInRange",
        "IGUI_ISAWindow_Details_GenOutOfRange",
        "IGUI_ISAWindow_Details_GlobalGrid",
    }) + maxWidthOfTexts({"UI_Yes","UI_No"})
    local lenButton = getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_ISAWindow_Details_ElectricalDevices")) + getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ISA_Update")) + 40
    return math.max(math.max(len1,lenTPU, len2) + 20, lenButton)
end
