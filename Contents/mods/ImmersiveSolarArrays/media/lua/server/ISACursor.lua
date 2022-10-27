require "BuildingObjects/ISBuildingObject"
require "ISUI/ISAUI"
local rGood, gGood, bGood, rBad, gBad, bBad = ISAMenu.getRGB()
local richGood, richBad, richNeutral = ISAMenu.getRGBRich()
--local function stringXYZ(iso)
--    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
--end

ISACursor = ISBuildingObject:derive("ISACursor");

function ISACursor:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ISACursor:deactivate()
    self:hideTooltip();
end

function ISACursor:close()
    getCell():setDrag(nil,self.player)
end

--function ISACursor:isVisible()
--    print()
--    return ISACursor.cursor and getCell():getDrag(self.player) == ISACursor.cursor
--end

function ISACursor:hideTooltip()
    if self.tooltip then
        self.tooltip:removeFromUIManager()
        self.tooltip:setVisible(false)
        self.tooltip = nil
    end
end

ISAConnectPanelCursor = ISACursor:derive("ISAConnectPanelCursor")

function ISAConnectPanelCursor:new(player,powerbank)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    --o:init()

    --o.skipBuildAction = true
    --o.noNeedHammer = false
    --o.skipWalk = true

    o.player = player
    o.playerObj = getSpecificPlayer(player)
    o.luaPb = CPowerbankSystem.instance:getLuaObjectOnSquare(powerbank:getSquare())
    --o:makePanelTable()
    return o
end

--function ISAConnectPanelCursor:makePanelTable()
--    self.panels = {}
--    for _,ipanel in ipairs(self.luaPb.panels) do
--        self.panels[string.format("%d,%d,%d",ipanel.x,ipanel.y,ipanel.z)] = true
--    end
--end

function ISAConnectPanelCursor:isValid(square,...)
    if self.sq ~= square then
        if not (self.luaPb and self.luaPb:getIsoObject()) then self:close() end
        self.sq = square
        local panel = ISAScan.findTypeOnSquare(square,"Panel")
        self.panel = panel
        if not panel then
            self.validPanel = false
            --self.connected = false
        else
            self.validPanel = panel:getSquare():isOutside()
            local dataPb, luaPb = panel:getModData().powerbank, self.luaPb
            self.connected = dataPb and dataPb.x == luaPb.x and dataPb.y == luaPb.y and dataPb.z == luaPb.z
        end
    end
    return self.validPanel
end

function ISAConnectPanelCursor:render(x,y,z,square,...)
    if not self.floorSprite then
        self.floorSprite = IsoSprite.new()
        self.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
    end

    if self.validPanel then
        self.floorSprite:RenderGhostTileColor(x, y, z, rGood, gGood, bGood, 0.8)
    else
        self.floorSprite:RenderGhostTileColor(x, y, z, rBad, gBad, bBad, 0.8)
    end

    self:renderTooltip()
end

function ISAConnectPanelCursor:renderTooltip()
    local tooltip = self.tooltip
    if not tooltip then
        tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setVisible(true)
        tooltip:addToUIManager()
        tooltip.followMouse = not self.joyfocus
        tooltip.maxLineWidth = 1000
        --tooltip:setName(getText("ContextMenu_ISA_SolarPanel"))
        self.tooltip = tooltip
    end
    if not self.panel then
        tooltip.description = richBad .. "No Panel"
    else
        tooltip.description = self.connected and richGood .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected") or richBad .. getText("ContextMenu_ISA_Connect_Panel_toolTip_isConnected_false")
        if not self.validPanel then tooltip.description = string.format("%s\n%s%s",tooltip.description,richBad,getText("ContextMenu_ISA_Connect_Panel_toolTip_isOutside")) end
    end
end

function ISAConnectPanelCursor:tryBuild(x,y,z)
    return ISAMenu.onConnectPanel(nil,self.player,self.panel,self.luaPb)
end

--function ISFarmingCursor:onJoypadPressButton(joypadIndex, joypadData, button)
--    if button == Joypad.AButton or button == Joypad.BButton then
--        return ISBuildingObject.onJoypadPressButton(self, joypadIndex, joypadData, button)
--    end
--end
--
--function ISFarmingCursor:getAPrompt()
--    if #self:getObjectList() > 0 then
--        return getText("ContextMenu_Farming")
--    end
--end
--function ISFarmingCursor:getLBPrompt()
--    return nil
--end
--
--function ISFarmingCursor:getRBPrompt()
--    return nil
--end
