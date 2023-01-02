if isClient() then return end

require "Map/SGlobalObjectSystem"
local isa = require "ISAUtilities"
local Powerbank = require "Powerbank/ISAPowerbank_server"

local PbSystem = SGlobalObjectSystem:derive("ISAPowerbankSystem_server")
require("ISAPowerbankSystem_shared"):addCommon(PbSystem)

function PbSystem:new()
    local o = SGlobalObjectSystem.new(self, "isa_powerbank")
    isa.PbSystem_server = o
    return o
end

PbSystem.savedObjModData = {'on', 'batteries', 'charge', 'maxcapacity', 'drain', 'npanels', 'panels', "lastHour", "conGenerator"}
function PbSystem:initSystem()
    SGlobalObjectSystem.initSystem(self)
    --self.system:setModDataKeys(nil)
    --self.system:setModDataKeys({})
    self.system:setObjectModDataKeys(self.savedObjModData)
end

function PbSystem:newLuaObject(globalObject)
    return Powerbank:new(self, globalObject)
end

--function PbSystem:isValidIsoObject(isoObject)
--    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
--end

function PbSystem.isValidModData(modData)
    return modData.on ~= nil
end

--function PbSystem:getIsoObjectOnSquare(square)
--    if not square then return end
--    local objects = square:getSpecialObjects()
--    for i=0,objects:size()-1 do
--        local isoObject = objects:get(i)
--        if self:isValidIsoObject(isoObject) then
--            return isoObject
--        end
--    end
--end

function PbSystem:OnObjectAboutToBeRemoved(isoObject)
    if not self:isValidIsoObject(isoObject) then return end
    local luaObject = self:getLuaObjectOnSquare(isoObject:getSquare())
    if not luaObject then return end
    self:removeLuaObject(luaObject)
    --self:addToRemoveGenerators(isoObject)
    self.processRemoveObj:addItem(isoObject)
end

function PbSystem:OnClientCommand(command, playerObj, args)
    return self.Commands[command](playerObj, args)
end

function PbSystem:removePanel(xpanel)
    local data = xpanel:getModData()
    local pb = data["pbLinked"] and self:getLuaObjectAt(data["pbLinked"].x,data["pbLinked"].y,data["pbLinked"].z)
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
        if not o.data then return o:stop() end

        for i = #o.data, 1, -1 do
            --print("delayed, index: ",checkoutObjects[i].obj:getObjectIndex())
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

        if #o.data == 0 or o.times <= 1 then o:stop() end
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

--local checkoutObjects = {}
--local dgrTick
--local function delayedGenRemove()
--    for i = #checkoutObjects, 1, -1 do
--        --print("delayed, index: ",checkoutObjects[i].obj:getObjectIndex())
--        if checkoutObjects[i].obj:getObjectIndex() == -1 then
--            local square = checkoutObjects[i].sq
--            local generator = square and square:getGenerator()
--            if generator then
--                generator:setActivated(false)
--                generator:remove()
--            end
--            table.remove(checkoutObjects,i)
--        end
--    end
--    if #checkoutObjects == 0 or dgrTick > 255 then
--        dgrTick = nil
--        return Events.OnTick.Remove(delayedGenRemove)
--    end
--    dgrTick = dgrTick + 1
--end
--
--function PbSystem:addToRemoveGenerators(isoObject)
--    table.insert(checkoutObjects, { obj = isoObject, sq = isoObject:getSquare() })
--    if not dgrTick then Events.OnTick.Add(delayedGenRemove) end
--    dgrTick = 0
--end

--function PbSystem:isValidBackup(generator,square)
--    --return generator and instanceof(generator,"IsoGenerator") and generator:isConnected() and not isa.Scan.findTypeOnSquare(square,"Powerbank")
--    return generator:isConnected() and not isa.Scan.findTypeOnSquare(square,"Powerbank")
--end

--function PbSystem:getMaxSolarOutput(SolarInput)
--    local ISASolarEfficiency = SandboxVars.ISA.solarPanelEfficiency
--    local output = SolarInput * (83 * ((ISASolarEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
--    return output
--end

--function PbSystem:getModifiedSolarOutput(SolarInput)
--    local cloudiness = getClimateManager():getCloudIntensity()
--    local light = getClimateManager():getDayLightStrength()
--    local fogginess = getClimateManager():getFogIntensity()
--    local CloudinessFogginessMean = 1 - (((cloudiness + fogginess) / 2) * 0.25) --make it so that clouds and fog can only reduce output by 25%
--    local output = PbSystem.instance:getMaxSolarOutput(SolarInput)
--    local temperature = getClimateManager():getTemperature()
--    local temperaturefactor = temperature * -0.0035 + 1.1 --based on linear single crystal sp efficiency
--    output = output * CloudinessFogginessMean
--    output = output * temperaturefactor
--    output = output * light
--    return output
--end

function PbSystem.EveryDays()
    for i=1,PbSystem.instance.system:getObjectCount() do
        local pb = PbSystem.instance.system:getObjectByIndex(i-1):getModData()
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

function PbSystem:updatePowerbanks(chargefreq)
    local solaroutput = self:getModifiedSolarOutput(1)
    for i=1,self.system:getObjectCount() do
        local pb = self.system:getObjectByIndex(i-1):getModData()
        local isopb = pb:getIsoObject()
        local drain
        if pb:shouldDrain(isopb) then
            pb:updateDrain()
            drain = pb.drain
        else
            drain = 0
        end

        local dif = solaroutput * pb.npanels - drain
        if chargefreq == 1 then dif = dif / 6 end
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

function PbSystem.sandbox()
    if SandboxVars.ISA.ChargeFreq == 1 then
        Events.EveryTenMinutes.Add(function()PbSystem.instance:updatePowerbanks(1) end)
    else
        Events.EveryHours.Add(function()PbSystem.instance:updatePowerbanks(2) end)
    end
end

SGlobalObjectSystem.RegisterSystemClass(PbSystem)

Events.OnInitGlobalModData.Add(PbSystem.sandbox)
Events.EveryDays.Add(PbSystem.EveryDays)

return PbSystem