require "Map/CGlobalObjectSystem"
local isa = require "ISAUtilities"
local Powerbank = require "Powerbank/ISAPowerbank_client"

--local PbSystem = CGlobalObjectSystem:derive("ISAPowerbankSystem_client")
--require("ISAPowerbankSystem_shared"):addCommon(PbSystem)

local PbSystem = require("ISAPowerbankSystem_shared"):new(CGlobalObjectSystem:derive("ISAPowerbankSystem_client"))

function PbSystem:new()
    local o = CGlobalObjectSystem.new(self, "isa_powerbank")
    isa.PbSystem_client = o
    return o
end

--function PbSystem:isValidIsoObject(isoObject)
--    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
--end

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

function PbSystem:newLuaObject(globalObject)
    return Powerbank:new(self, globalObject)
end

--called by java receiveNewLuaObjectAt
function PbSystem:newLuaObjectAt(x, y, z)
    self:noise("adding luaObject "..x..','..y..','..z)
    local globalObject = self.system:newObject(x, y, z)
    self.processNewLua:addItem(x,y,z)
    return self:newLuaObject(globalObject)
end

do
    local o = isa.delayedProcess:new{maxTimes=999}

    function o.process(tick)
        if not o.data then return o:stop() end
        for i = #o.data, 1 , -1 do
            local gen = o.data[i]:getGenerator()
            if gen then
                local isoPb = PbSystem.instance:getIsoObjectOnSquare(o.data[i])
                if isoPb then
                    isoPb:getContainer():setAcceptItemFunction("AcceptItemFunction.ISA_Batteries")
                    gen:getCell():addToProcessIsoObjectRemove(gen)
                end
                table.remove(o.data,i)
            end
        end
        if #o.data == 0 or o.times <= 1 then o:stop() end
        o.times = o.times - 1
    end

    function o:addItem(x,y,z)
        local square = getSquare(x,y,z)
        if not square then return end
        if not self.data then
            self.data = {}
            self:start()
        end
        self.times = self.maxTimes
        table.insert(self.data, square)
    end

    PbSystem.processNewLua = o
end

do
    local o = isa.delayedProcess:new{event=Events.EveryOneMinute,maxTimes=10}

    function o.process()
        if not o.data then return o:stop() end

        for i = #o.data, 1, -1 do
            local obj = o.data[i]
            if obj:getObjectIndex() == -1 then
                table.remove(o.data,i)
            else
                local container = obj:getContainer()
                if container:getAcceptItemFunction() == nil then
                    print("ISAtest AcceptItemFunction resetting") --todo remove
                    container:setAcceptItemFunction("AcceptItemFunction.ISA_Batteries")
                    triggerEvent("OnContainerUpdate",obj)
                    table.remove(o.data,i)
                end
            end
        end

        if #o.data == 0 or o.times <= 1 then return o:stop() end
        o.times = o.times - 1
    end

    function o.addItems()
        o.data = {}
        for i=1,PbSystem.instance:getLuaObjectCount() do
            local isoObject = PbSystem.instance:getLuaObjectByIndex(i):getIsoObject()
            if isoObject then
                table.insert(o.data,isoObject)
            end
        end
        if #o.data > 0 then
            o.times = o.maxTimes
            o:start()
        else
            o.data = nil
        end
    end
    PbSystem.resetAcceptItemFunction = o
end

function PbSystem.canConnectPanelTo(panel)
    local x = panel:getX()
    local y = panel:getY()
    local z = panel:getZ()
    local options = {}
    for i=1, PbSystem.instance.system:getObjectCount() do
        local pb = PbSystem.instance.system:getObjectByIndex(i-1):getModData()
        if IsoUtils.DistanceToSquared(x, y, pb.x, pb.y) <= 400.0 and math.abs(z - pb.z) <= 3 then
            pb:updateFromIsoObject()
            local isConnected
            for _,ipanel in ipairs(pb.panels) do
                if x == ipanel.x and y == ipanel.y and z == ipanel.z then
                    isConnected = true
                    break
                end
            end
            table.insert(options, {pb, pb.x-x,pb.y-y, isConnected})
        end
    end
    return options
end

--draw debug text for player square
function PbSystem.getGeneratorsInAreaInfo(luaPb,area)
    local getSquare = getSquare
    local DistanceToSquared = IsoUtils.DistanceToSquared

    local generators = 0
    for ix = luaPb.x - area.radius, luaPb.x + area.radius do
        for iy = luaPb.y - area.radius, luaPb.y + area.radius do
            for iz = luaPb.z - area.levels, luaPb.z + area.levels do
                if ix >= 0 and iy >= 0 and iz >= 0 then
                    local isquare = getSquare(ix, iy, iz)
                    local generator = isquare and luaPb.luaSystem:getValidBackupOnSquare(isquare)
                    --getValidBackupOnSquare
                    if generator and DistanceToSquared(luaPb.x,luaPb.y,luaPb.z,ix,iy,iz) <= area.distance then
                    --if generator and not isa.WorldUtil.findTypeOnSquare(isquare,"Powerbank") then
                    --if generator and PbSystem.instance:isValidBackup(generator) then
                    --    if IsoUtils.DistanceToSquared(luaPb.x,luaPb.y,luaPb.z,ix,iy,iz) <= area.distance then
                            generators = generators + 1
                        --end
                    end
                end
            end
        end
    end
    return generators
end

--function PbSystem.getMaxSolarOutput(SolarInput)
--    return SolarInput * (83 * ((SandboxVars.ISA.solarPanelEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
--end

--local climateManager
--function PbSystem.getModifiedSolarOutput(SolarInput)
--    if not climateManager then climateManager = getClimateManager() end
--    local cloudiness = climateManager:getCloudIntensity()
--    local light = climateManager:getDayLightStrength()
--    local fogginess = climateManager:getFogIntensity()
--    local CloudinessFogginessMean = 1 - (((cloudiness + fogginess) / 2) * 0.25) --make it so that clouds and fog can only reduce output by 25%
--    local temperature = climateManager:getTemperature()
--    local temperaturefactor = temperature * -0.0035 + 1.1 --based on linear single crystal sp efficiency
--    local output = PbSystem.getMaxSolarOutput(SolarInput)
--    output = output * CloudinessFogginessMean
--    output = output * temperaturefactor
--    output = output * light
--    return output
--end

function PbSystem.ISActivateGenerator_perform(ISActivateGenerator_perform)
    return function(self,...)
        local res = ISActivateGenerator_perform(self,...)

        --check perform was successful
        if self.activate and not self.generator:isActivated() then return res end

        local x, y, z = self.generator:getX(), self.generator:getY(), self.generator:getZ()
        for i=1,PbSystem.instance:getLuaObjectCount() do
            local pb = PbSystem.instance:getLuaObjectByIndex(i)
            pb:updateFromIsoObject()
            if pb.conGenerator and pb.conGenerator.x == x and pb.conGenerator.y == y and pb.conGenerator.z == z then
                PbSystem.instance:sendCommand(self.character,"activateGenerator", { pb = { x = pb.x, y = pb.y, z = pb.z }, activate = self.activate })
            end
        end

        return res
    end
end

function PbSystem.ISInventoryTransferAction_transferItem(ISInventoryTransferAction_transferItem)
    return function(self,item,...)
        --check if item is valid battery
        local maxCapacity = (item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()])
        if not maxCapacity then return ISInventoryTransferAction_transferItem(self,item,...) end

        --check if battery was moved to/from BatteryBank
        local wasInDest = self.destContainer:contains(item)
        local res = ISInventoryTransferAction_transferItem(self,item,...)
        local src, dest, character = self.srcContainer:getParent(), self.destContainer:getParent(), self.character
        local take = src and isa.WorldUtil.Types[src:getTextureName()] == "Powerbank"
        local put = dest and isa.WorldUtil.Types[dest:getTextureName()] == "Powerbank"
        if not (take or put and self.destContainer:contains(item)) or wasInDest then return res end

        local capacity = maxCapacity * (1 - math.pow((1 - (item:getCondition()/100)),6))
        local charge = capacity * item:getUsedDelta()

        if take then
            PbSystem.instance:sendCommand(character,"Battery", { { x = src:getX(), y = src:getY(), z = src:getZ()} ,"take", charge, capacity})
        end
        if put then
            PbSystem.instance:sendCommand(character,"Battery", { { x = dest:getX(), y = dest:getY(), z = dest:getZ()} ,"put", charge, capacity})
        end
        if take and put then HaloTextHelper.addText(character,"bzzz ... BZZZZZ ... bzzz") end

        return res
    end
end

function PbSystem.ISPlugGenerator_perform(ISPlugGenerator_perform)
    return function(self,...)

        local character,generator,plug = self.character,self.generator,self.plug
        local area = isa.WorldUtil.getValidBackupArea(plug and character,10)
        local luaPowerbanks = isa.WorldUtil.getLuaObjects(generator:getSquare(),area.radius, area.levels, area.distance)
        if #luaPowerbanks > 0 then
            local args = { pbList = {}, gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }, plug = plug}
            for i,luaPb in ipairs(luaPowerbanks) do
                args.pbList[i] = { x = luaPb.x, y = luaPb.y, z = luaPb.z }
            end
            PbSystem.instance:sendCommand(character,"plugGenerator",args)
        end

        return ISPlugGenerator_perform(self,...)
    end
end

function PbSystem.ISMoveablesAction_perform(ISMoveablesAction_perform)
    return function(self,...)
        local type = isa.WorldUtil.Types[self.origSpriteName]
        if type and self.mode == "pickup" then
            local isoObjectSpecial = isa.WorldUtil.findOnSquare(self.square,self.origSpriteName)
            if isoObjectSpecial then
                if type == "Powerbank" then
                    isoObjectSpecial:getModData().on = nil
                elseif type == "Panel" then
                    isoObjectSpecial:getModData().connectDelta = nil
                    --isoObjectSpecial:getModData().pbLinked = nil --need to remove panel from pb luaObj, alt send disconnectPanel
                end
            end
        end
        return ISMoveablesAction_perform(self,...)
    end
end

function PbSystem.updateBanksForClient()
    for i=1,PbSystem.instance:getLuaObjectCount() do
        local pb = PbSystem.instance:getLuaObjectByIndex(i)
        local isopb = pb:getIsoObject()
        if isopb then
            pb:fromModData(isopb:getModData())
            local delta = pb.maxcapacity > 0 and pb.charge / pb.maxcapacity or 0
            local items = isopb:getContainer():getItems()
            for v=0,items:size()-1 do
                local item = items:get(v)
                --all items should be drainable (valid batteries) here
                if item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()] then
                    item:setUsedDelta(delta)
                end
            end
        end
    end
end

function PbSystem.OnInitGlobalModData()
    if isClient() then
        if SandboxVars.ISA.ChargeFreq == 1 then
            Events.EveryTenMinutes.Add(PbSystem.updateBanksForClient)
        else
            Events.EveryHours.Add(PbSystem.updateBanksForClient)
        end
    end
    Events.EveryDays.Add(PbSystem.resetAcceptItemFunction.addItems) --added after server function with sendObjectChange("containers") so SP need only one check
end

CGlobalObjectSystem.RegisterSystemClass(PbSystem)

Events.OnInitGlobalModData.Add(PbSystem.OnInitGlobalModData)

return PbSystem