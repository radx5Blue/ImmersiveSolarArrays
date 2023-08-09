--[[
"isa_powerbank" server system
--]]

if isClient() then return end

require "Map/SGlobalObjectSystem"
local isa = require "ISAUtilities"
local Powerbank = require "Powerbank/ISAPowerbank_server"

---@class PowerbankSystem_Server : PowerbankSystem, SGlobalObjectSystem
local PbSystem = require("ISAPowerbankSystem_shared"):new(SGlobalObjectSystem:derive("ISAPowerbankSystem_server"))

--called when making the instance, triggered by: Events.OnSGlobalObjectSystemInit
function PbSystem:new()
    local o = SGlobalObjectSystem.new(self, "isa_powerbank")
    isa.PbSystem_server = o
    return o
end

--called in C/SGlobalObjectSystem:new(name)
PbSystem.savedObjectModData = { 'on', 'batteries', 'charge', 'maxcapacity', 'drain', 'npanels', 'panels', "lastHour", "conGenerator"}
function PbSystem:initSystem()
    --SGlobalObjectSystem.initSystem(self) --does nothing
    --set saved fields
    self.system:setObjectModDataKeys(self.savedObjectModData)

    --sandbox options, *Events.Event.Add() doesn't need to be specifically inside a function call
    self.updateEveryTenMinutes = SandboxVars.ISA.ChargeFreq == 1 and true
    if self.updateEveryTenMinutes then
        Events.EveryTenMinutes.Add(PbSystem.updatePowerbanks)
    else
        Events.EveryHours.Add(PbSystem.updatePowerbanks)
    end
    Events.EveryDays.Add(PbSystem.EveryDays)
end

function PbSystem:newLuaObject(globalObject)
    return Powerbank:new(self, globalObject)
end

---triggered by: Events.OnObjectAdded (SGlobalObjectSystem)
function PbSystem:OnObjectAdded(isoObject)
    local isaType = isa.WorldUtil.getType(isoObject)
    if not isaType then return end
    if isaType == "Powerbank" and self:isValidIsoObject(isoObject) then
        self:loadIsoObject(isoObject)
    elseif isaType == "Panel" then
        local modData = isoObject:getModData()
        modData.pbLinked = nil
        modData.connectDelta = nil
        isoObject:transmitModData()
    end
end

---triggered by: Events.OnObjectAboutToBeRemoved, Events.OnDestroyIsoThumpable  (SGlobalObjectSystem)
---v41.78 object data has already been copied to InventoryItem on pickup
function PbSystem:OnObjectAboutToBeRemoved(isoObject)
    local isaType = isa.WorldUtil.getType(isoObject)
    if not isaType then return end
    if isaType == "Powerbank" and self:isValidIsoObject(isoObject) then
        local luaObject = self:getLuaObjectOnSquare(isoObject:getSquare())
        if not luaObject then return end
        self:removeLuaObject(luaObject)
        self.processRemoveObj:addItem(isoObject)
    elseif isaType == "Panel" then
        self:removePanel(isoObject)
    end
end

function PbSystem:OnClientCommand(command, playerObj, args)
    local command = self.Commands[command]
    if command ~= nil then
        command(playerObj, args)
    end
end

function PbSystem:removePanel(xpanel)
    local pbData = xpanel:getModData()["pbLinked"]
    local pb = pbData and self:getLuaObjectAt(pbData.x,pbData.y,pbData.z)
    if pb then
        local x = xpanel:getX()
        local y = xpanel:getY()
        local z = xpanel:getZ()
        for i = #pb.panels, 1, -1 do
            local panel = pb.panels[i]
            if panel.x == x and panel.y == y and panel.z == z then
                table.remove(pb.panels,i)
                pb.npanels = pb.npanels - 1
                break
            end
        end
        pb:saveData(true)
    end
end

do
    local o = isa.delayedProcess:new{maxTimes=999}

    function o.process(tick)
        if not o.data then o:stop() return end

        for i = #o.data, 1, -1 do
            if o.data[i].obj:getObjectIndex() == -1 then
                local square = o.data[i].sq
                local generator = square and square:getGenerator()
                if generator then
                    generator:setActivated(false)
                    generator:remove()
                end
                table.remove(o.data,i)
            end
        end

        if #o.data == 0 or o.times <= 1 then o:stop() return end
        o.times = o.times - 1
    end

    function o:addItem(isoObject)
        if not self.data then
            self.data = {}
            self.event.Add(self.process)
        end
        self.times = self.maxTimes
        table.insert(self.data, { obj = isoObject, sq = isoObject:getSquare() })
    end

    PbSystem.processRemoveObj = o
end

function PbSystem.EveryDays()
    local self = PbSystem.instance
    for i=0,self.system:getObjectCount()-1 do
        local pb = self.system:getObjectByIndex(i):getModData()
        local isopb = pb:getIsoObject()
        if isopb then
            local inv = isopb:getContainer()
            pb:degradeBatteries(inv) --todo x days passed
            pb:handleBatteries(inv)
            isopb:sendObjectChange("containers")
        end
        pb:checkPanels() -- bugfix
    end
end

function PbSystem.updatePowerbanks()
    ---@type PowerbankSystem_Server
    local self = PbSystem.instance
    local solaroutput = self:getModifiedSolarOutput(1)
    for i=0,self.system:getObjectCount() - 1 do
        ---@type PowerbankObject_Server
        local pb = self.system:getObjectByIndex(i):getModData()
        local isopb = pb:getIsoObject()
        local drain
        if pb:shouldDrain(isopb) then
            pb:updateDrain()
            drain = pb.drain
        else
            drain = 0
        end

        local dif = solaroutput * pb.npanels - drain
        if self.updateEveryTenMinutes then dif = dif / 6 end
        local charge = pb.charge + dif
        if charge < 0 then charge = 0 elseif charge > pb.maxcapacity then charge = pb.maxcapacity end
        local chargemod = pb.maxcapacity > 0 and charge / pb.maxcapacity or 0
        pb.charge = charge
        if isopb then
            pb:chargeBatteries(isopb:getContainer(),chargemod)
            pb:updateGenerator(dif)
            pb:updateSprite(chargemod)
        end
        pb:updateConGenerator()
        pb:saveData(true)

        self:noise(string.format("/charge: (%d) Battery at: %d %%, charge dif: %.1f, output: %.1f, drain: %.1f",i,chargemod*100,dif,pb.npanels*solaroutput,drain))
    end
end

SGlobalObjectSystem.RegisterSystemClass(PbSystem)

return PbSystem