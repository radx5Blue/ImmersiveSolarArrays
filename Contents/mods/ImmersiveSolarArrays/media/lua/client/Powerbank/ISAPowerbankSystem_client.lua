require "Map/CGlobalObjectSystem"
local isa = require "ISAUtilities"
local Powerbank = require "Powerbank/ISAPowerbank_client"

local PbSystem = require("ISAPowerbankSystem_shared"):new(CGlobalObjectSystem:derive("ISAPowerbankSystem_client"))

function PbSystem:new()
    local o = CGlobalObjectSystem.new(self, "isa_powerbank")
    isa.PbSystem_client = o
    return o
end

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

    function o.process()
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
    local o = isa.delayedProcess:new{maxTimes=999}

    function o.process()
        if not o.data then return o:stop() end

        for i = #o.data, 1, -1 do
            local obj = o.data[i]
            if obj:getObjectIndex() == -1 then
                table.remove(o.data,i)
            else
                local container = obj:getContainer()
                if container:getAcceptItemFunction() == nil then
                    PbSystem.instance:noise("Container reset")

                    container:setAcceptItemFunction("AcceptItemFunction.ISA_Batteries")
                    triggerEvent("OnContainerUpdate",obj)
                    table.remove(o.data,i)

                    --shortcut for container changed, bugged transfer action
                    local players = IsoPlayer.getPlayers()
                    for i=0, players:size() -1 do
                        local player = players:get(i)
                        if player and player:getZ() == obj:getZ() and IsoUtils.DistanceToSquared(player:getX(),player:getY(),obj:getX()+0.5,obj:getY()+0.5) <= 4 then
                            --clear both java / lua
                            ISTimedActionQueue.clear(player)
                        end
                    end

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
    for i=0, PbSystem.instance.system:getObjectCount() -1  do
        local pb = PbSystem.instance.system:getObjectByIndex(i):getModData()
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

--draw debug num of valid generators
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
                    if generator and DistanceToSquared(luaPb.x,luaPb.y,luaPb.z,ix,iy,iz) <= area.distance then
                        generators = generators + 1
                    end
                end
            end
        end
    end
    return generators
end

function PbSystem.ISActivateGenerator_perform(ISActivateGenerator_perform)
    return function(self,...)
        local result = ISActivateGenerator_perform(self,...)

        --check perform was successful
        if self.activate and not self.generator:isActivated() then return result end

        local x, y, z = self.generator:getX(), self.generator:getY(), self.generator:getZ()
        for i=1,PbSystem.instance:getLuaObjectCount() do
            local pb = PbSystem.instance:getLuaObjectByIndex(i)
            pb:updateFromIsoObject()
            if pb.conGenerator and pb.conGenerator.x == x and pb.conGenerator.y == y and pb.conGenerator.z == z then
                PbSystem.instance:sendCommand(self.character,"activateGenerator", { pb = { x = pb.x, y = pb.y, z = pb.z }, activate = self.activate })
            end
        end

        return result
    end
end

--used to be overlay needed to be reset here, will need to be updated in v42 probably
function PbSystem.ISInventoryTransferAction_transferItem(ISInventoryTransferAction_transferItem)
    return function(self,item,...)
        local maxCapacity = item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()]
        --check if item is valid battery, and not moved already
        if maxCapacity and not self.destContainer:contains(item) then
            --check if item is moved to/from BatteryBank successfully
            local src = self.srcContainer:getParent()
            local dest = self.destContainer:getParent()
            local take = src and isa.WorldUtil.Types[src:getTextureName()] == "Powerbank"
            local put = dest and isa.WorldUtil.Types[dest:getTextureName()] == "Powerbank"
            if take or put then
                local success, result = pcall(ISInventoryTransferAction_transferItem,self,item,...)

                if self.destContainer:contains(item) then
                    local capacity = maxCapacity * (1 - math.pow((1 - (item:getCondition()/100)),6))
                    local charge = capacity * item:getUsedDelta()
                    if take then
                        PbSystem.instance:sendCommand(self.character,"Battery", { { x = src:getX(), y = src:getY(), z = src:getZ()} ,"take", charge, capacity})
                    end
                    if put then
                        PbSystem.instance:sendCommand(self.character,"Battery", { { x = dest:getX(), y = dest:getY(), z = dest:getZ()} ,"put", charge, capacity})
                    end
                    if take and put then HaloTextHelper.addText(self.character,"bzzz ... BZZZZZ ... bzzz") end
                end

                if success then
                    return result
                else
                    return error(result)
                end
            end
        end

        return ISInventoryTransferAction_transferItem(self,item,...)
    end
end

function PbSystem.ISPlugGenerator_perform(ISPlugGenerator_perform)
    return function(self,...)

        local generator = self.generator
        local area = isa.WorldUtil.getValidBackupArea(self.plug and self.character,10)
        local luaPowerbanks = isa.WorldUtil.getLuaObjects(generator:getSquare(),area.radius, area.levels, area.distance)
        if #luaPowerbanks > 0 then
            local args = { pbList = {}, gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }, plug = self.plug}
            for i,luaPb in ipairs(luaPowerbanks) do
                args.pbList[i] = { x = luaPb.x, y = luaPb.y, z = luaPb.z }
            end
            PbSystem.instance:sendCommand(self.character,"plugGenerator",args)
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

--this might run before new data is received
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
                --all items should be valid batteries and drainable here already
                if item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()] then
                    item:setUsedDelta(delta)
                end
            end
        end
    end
end

function PbSystem.OnInitGlobalModData()
    if isClient() then
        Events.EveryTenMinutes.Add(PbSystem.updateBanksForClient)
        --if SandboxVars.ISA.ChargeFreq == 1 then
        --    Events.EveryTenMinutes.Add(PbSystem.updateBanksForClient)
        --else
        --    Events.EveryHours.Add(PbSystem.updateBanksForClient)
        --end
    end
    Events.EveryDays.Add(PbSystem.resetAcceptItemFunction.addItems) --added after server function with sendObjectChange("containers") so SP need only one check
end

CGlobalObjectSystem.RegisterSystemClass(PbSystem)

Events.OnInitGlobalModData.Add(PbSystem.OnInitGlobalModData)

return PbSystem