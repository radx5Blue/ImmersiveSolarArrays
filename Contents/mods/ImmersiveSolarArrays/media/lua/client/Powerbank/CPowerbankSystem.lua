require "Map/CGlobalObjectSystem"

CPowerbankSystem = CGlobalObjectSystem:derive("CPowerbankSystem")

function CPowerbankSystem:new()
    return CGlobalObjectSystem.new(self, "Powerbank")
end

function CPowerbankSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function CPowerbankSystem:getIsoObjectOnSquare(square)
    if not square then return end
    for i=0,square:getSpecialObjects():size()-1 do
        local isoObject = square:getSpecialObjects():get(i)
        if self:isValidIsoObject(isoObject) then
            return isoObject
        end
    end
end

function CPowerbankSystem:newLuaObject(globalObject)
    return CPowerbank:new(self, globalObject)
end

--called by java receiveNewLuaObjectAt
function CPowerbankSystem:newLuaObjectAt(x, y, z)
    self:noise("adding luaObject "..x..','..y..','..z)
    local globalObject = self.system:newObject(x, y, z)
    CPowerbankSystem.delayedNewLua(x,y,z)
    return self:newLuaObject(globalObject)
end

local newLuaSquares = {}
local prTick
function CPowerbankSystem.processNewLua()
    for i = #newLuaSquares, 1 , -1 do
        local gen = newLuaSquares[i]:getGenerator()
        if gen then
            local isoPb = CPowerbankSystem.instance:getIsoObjectOnSquare(newLuaSquares[i])
            if isoPb then
                --isoPb:getContainer():setAcceptItemFunction("ISAUtilities.AcceptItemFunction")
                gen:getCell():addToProcessIsoObjectRemove(gen)
            end
            table.remove(newLuaSquares,i)
        end
    end
    if #newLuaSquares == 0 or prTick > 255 then
        prTick = nil
        return Events.OnTick.Remove(CPowerbankSystem.processNewLua)
    end
    prTick = prTick + 1
end

function CPowerbankSystem.delayedNewLua(x,y,z)
    local square = getSquare(x,y,z)
    table.insert(newLuaSquares, square)
    if not prTick then Events.OnTick.Add(CPowerbankSystem.processNewLua) end
    prTick = 0
end

function CPowerbankSystem.canConnectPanelTo(panel)
    local x = panel:getX()
    local y = panel:getY()
    local z = panel:getZ()
    local options = {}
    for i=1, CPowerbankSystem.instance.system:getObjectCount() do
        local pb = CPowerbankSystem.instance.system:getObjectByIndex(i-1):getModData()
        if IsoUtils.DistanceToSquared(x, y, pb.x, pb.y) <= 400.0 and math.abs(z - pb.z) < 3 then
            local isConnected
            pb:updateFromIsoObject()
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

function CPowerbankSystem.getGeneratorsInAreaInfo(luaPb,area)
    local generators = 0

    for ix = luaPb.x - area.radius, luaPb.x + area.radius do
        for iy = luaPb.y - area.radius, luaPb.y + area.radius do
            for iz = luaPb.z - area.levels, luaPb.z + area.levels do
                if ix >= 0 and iy >= 0 and iz >= 0 then
                    local isquare = getSquare(ix, iy, iz)
                    local generator = isquare and isquare:getGenerator()
                    if generator and not ISAScan.findTypeOnSquare(isquare,"Powerbank") then
                        if IsoUtils.DistanceToSquared(luaPb.x,luaPb.y,luaPb.z,ix,iy,iz) <= area.distance then
                            generators = generators + 1
                        end
                    end
                end
            end
        end
    end
    return generators
end

function CPowerbankSystem.getMaxSolarOutput(SolarInput)
    local ISASolarEfficiency = SandboxVars.ISA.solarPanelEfficiency
    if ISASolarEfficiency == nil then
        ISASolarEfficiency = 90
    end
    local output = SolarInput * (83 * ((ISASolarEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
    return output
end

function CPowerbankSystem.getModifiedSolarOutput(SolarInput)
    local cloudiness = getClimateManager():getCloudIntensity()
    local light = getClimateManager():getDayLightStrength()
    local fogginess = getClimateManager():getFogIntensity()
    local CloudinessFogginessMean = 1 - (((cloudiness + fogginess) / 2) * 0.25) --make it so that clouds and fog can only reduce output by 25%
    local output = CPowerbankSystem.getMaxSolarOutput(SolarInput)
    local temperature = getClimateManager():getTemperature()
    local temperaturefactor = temperature * -0.0035 + 1.1 --based on linear single crystal sp efficiency
    output = output * CloudinessFogginessMean
    output = output * temperaturefactor
    output = output * light
    return output
end

function CPowerbankSystem.postPlugGenerator(o)
    local character,generator,plug = o.character,o.generator,o.plug
    local area = ISAScan.getValidBackupArea(plug and character,10)
    local luaPowerbanks = ISAScan.getLuaObjects(generator:getSquare(),area.radius, area.levels, area.distance)
    if #luaPowerbanks > 0 then
        local args = { pbList = {}, gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }, plug = plug}
        for i,luaPb in ipairs(luaPowerbanks) do
            --table.insert(args.pbList,{ x = luaPb.x, y = luaPb.y, z = luaPb.z})
            args.pbList[i] = { x = luaPb.x, y = luaPb.y, z = luaPb.z }
        end
        CPowerbankSystem.instance:sendCommand(character,"plugGenerator",args)
    end
end

function CPowerbankSystem.postActivateGenerator(o)
    local x, y, z = o.generator:getX(), o.generator:getY(), o.generator:getZ()
    for i=1,CPowerbankSystem.instance:getLuaObjectCount() do
        local pb = CPowerbankSystem.instance:getLuaObjectByIndex(i)
        pb:updateFromIsoObject()
        if pb.conGenerator and pb.conGenerator.x == x and pb.conGenerator.y == y and pb.conGenerator.z == z then
            CPowerbankSystem.instance:sendCommand(o.character,"activateGenerator", { pb = { x = pb.x, y = pb.y, z = pb.z }, activate = o.activate })
        end
    end
end

function CPowerbankSystem.postInventoryTransferAction(o,item)
    local src, dest, character = o.srcContainer:getParent(), o.destContainer:getParent(), o.character
    local take = src and src:getTextureName() == "solarmod_tileset_01_0"
    local put = dest and dest:getTextureName() == "solarmod_tileset_01_0"
    if not (take or put) then return end

    local type = item:getType()
    if not ( type == "50AhBattery" or type == "75AhBattery" or type == "100AhBattery" or type == "DeepCycleBattery" or type == "SuperBattery" or
            type == "DIYBattery") or item:getCondition() == 0 then
        if put then character:Say(getText("IGUI_ISAContainerNotBattery", item:getDisplayName())) end
        return
    end

    local batterypower = item:getUsedDelta()
    local capacity = 0
    local cond = 1 - (item:getCondition()/100)
    local condition = 1 - math.pow(cond,6)
    if type == "50AhBattery" then
        capacity = 50 * condition
    elseif type == "75AhBattery" then
        capacity = 75 * condition
    elseif type == "100AhBattery" then
        capacity = 100 * condition
    elseif type == "DeepCycleBattery" then
        capacity = 200 * condition
    elseif type == "SuperBattery" then
        capacity = 400 * condition
    elseif type == "DIYBattery" then
        capacity = (SandboxVars.ISA.DIYBatteryCapacity or 200) * condition
    end

    if take then
        CPowerbankSystem.instance:sendCommand(character,"Battery", { { x = src:getX(), y = src:getY(), z = src:getZ()} ,"take", batterypower, capacity})
    end

    if put then
        CPowerbankSystem.instance:sendCommand(character,"Battery", { { x = dest:getX(), y = dest:getY(), z = dest:getZ()} ,"put", batterypower, capacity})
    end

    if take and put then HaloTextHelper.addText(character,"bzzz ... BZZZZZ ... bzzz") end

end

function CPowerbankSystem.onMoveablesAction(o)
    local type = ISAScan.Types[o.origSpriteName]
    if type and o.mode == "pickup" then
        local isoObjectSpecial = ISAScan.findOnSquare(o.square,o.origSpriteName)
        if isoObjectSpecial then
            if type == "Powerbank" then
                isoObjectSpecial:getModData().charge = nil
            elseif type == "Panel" then
                isoObjectSpecial:getModData().connectDelta = nil
                --isoObjectSpecial:getModData().powerbank = nil
            end
        end
    end
end

function CPowerbankSystem.updateBank()
    local max = ISAUtilities.maxBatteryCapacity
    for i=1,CPowerbankSystem.instance:getLuaObjectCount() do
        local pb = CPowerbankSystem.instance:getLuaObjectByIndex(i)
        local isopb = pb:getIsoObject()
        if isopb then
            pb:fromModData(isopb:getModData())
            local delta = pb.charge / pb.maxcapacity
            local items = isopb:getContainer():getItems()
            for v=1,items:size() do
                local item = items:get(v-1)
                if max[item:getType()] then
                    item:setUsedDelta(delta)
                end
            end
        end
    end
end

if isClient() then
    if SandboxVars.ISA.ChargeFreq == 1 then
        Events.EveryTenMinutes.Add(CPowerbankSystem.updateBank)
    else
        Events.EveryHours.Add(CPowerbankSystem.updateBank)
    end
end

CGlobalObjectSystem.RegisterSystemClass(CPowerbankSystem)
