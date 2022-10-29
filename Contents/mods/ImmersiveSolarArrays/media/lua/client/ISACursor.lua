--require "BuildingObjects/ISBuildingObject"
require "SolarUI/ISAUI"
local rGood, gGood, bGood, rBad, gBad, bBad = ISAMenu.getRGB()
local richGood, richBad, richNeutral = ISAMenu.getRGBRich()
--local function stringXYZ(iso)
--    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
--end

--ISACursor = ISBuildingObject:derive("ISACursor");
ISACursor = {}
ISACursor.Type = "ISACursor"

function ISACursor:new(player)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.playerObj = getSpecificPlayer(player)
    return o
end

function ISACursor:derive(type)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.Type = type
    return o
end

function ISACursor:initialise()
    --print("test: init")
end

function ISACursor:rotateMouse(x,y) end
function ISACursor:rotateKey(key) end
function ISACursor:getSprite() end
function ISACursor:isValid(square,north) end
function ISACursor:render(x,y,z,square) end
function ISACursor:tryBuild(x,y,z) end
function ISACursor:reinit() end
function ISACursor:onJoypadPressButton(joypadIndex, joypadData, button) end
function ISACursor:onJoypadDirDown(joypadData) self.yJoypad = self.yJoypad + 1 end
function ISACursor:onJoypadDirUp(joypadData) self.yJoypad = self.yJoypad - 1 end
function ISACursor:onJoypadDirRight(joypadData) self.xJoypad = self.xJoypad + 1 end
function ISACursor:onJoypadDirLeft(joypadData) self.xJoypad = self.xJoypad - 1 end
function ISACursor:getAPrompt() end
function ISACursor:getBPrompt() end
function ISACursor:getYPrompt() end
function ISACursor:getLBPrompt() end
function ISACursor:getRBPrompt() end

function ISACursor:hideTooltip()
    if self.tooltip then
        self.tooltip:removeFromUIManager()
        self.tooltip:setVisible(false)
        self.tooltip = nil
    end
end

function ISACursor:deactivate()
    self:hideTooltip()
end

function ISACursor:close()
    getCell():setDrag(nil,self.player)
end

--function ISACursor:isVisible()
--    print()
--    return ISACursor.cursor and getCell():getDrag(self.player) == ISACursor.cursor
--end

ISAConnectPanelCursor = ISACursor:derive("ISAConnectPanelCursor")

function ISAConnectPanelCursor:new(player,powerbank)
    --local o = {}
    --setmetatable(o, self)
    --self.__index = self
    ----o:init()
    --
    --o.player = player
    --o.playerObj = getSpecificPlayer(player)
    --o.luaPb = CPowerbankSystem.instance:getLuaObjectOnSquare(powerbank:getSquare())
    ----o:makePanelTable()
    --return o
    local o = ISACursor.new(self,player)
    --o.isoPb = powerbank
    o.luaPb = CPowerbankSystem.instance:getLuaObjectOnSquare(powerbank:getSquare())

    return o
end

function ISAConnectPanelCursor:initialise()
    --print("isatest: init")
    ISACursor.initialise(self)
end

--function ISAConnectPanelCursor:makePanelTable()
--    self.panels = {}
--    for _,ipanel in ipairs(self.luaPb.panels) do
--        self.panels[string.format("%d,%d,%d",ipanel.x,ipanel.y,ipanel.z)] = true
--    end
--end

function ISAConnectPanelCursor:isValid(square,...)
    if self.sq ~= square then
        --print("isatest: luasystem",self.luaPb and self.luaPb.luaSystem)
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

function ISAConnectPanelCursor:render(x,y,z,...)
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
        tooltip.followMouse = not self.joyfocus --todo set this, check updatejoypadfocus
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

function ISAConnectPanelCursor:tryBuild()
    return ISAMenu.onConnectPanel(nil,self.player,self.panel,self.luaPb)
end

function ISACursor:onJoypadPressButton(joypadIndex, joypadData, button)
    if button == Joypad.BButton then self:close() end
    if button == Joypad.AButton and self.validPanel then self:tryBuild() end
    if button == Joypad.YButton then
        self.xJoypad = self.playerObj:getCurrentSquare():getX()
        self.yJoypad = self.playerObj:getCurrentSquare():getY()
    end
end

function ISAConnectPanelCursor:getAPrompt()
    if self.validPanel then return "Connect Panel" end
end
