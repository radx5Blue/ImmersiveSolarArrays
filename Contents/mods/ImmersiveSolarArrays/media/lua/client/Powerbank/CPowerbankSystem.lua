require "Map/CGlobalObjectSystem"

CPowerbankSystem = CGlobalObjectSystem:derive("CPowerbankSystem")

function CPowerbankSystem:new()
    return CGlobalObjectSystem.new(self, "Powerbank")
end

function CPowerbankSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function CPowerbankSystem:newLuaObject(globalObject)
    return CPowerbank:new(self, globalObject)
end

function CPowerbankSystem.canConnectPanelTo(square)
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    local options = {}
    for i=1, CPowerbankSystem.instance.system:getObjectCount() do
        local pb = CPowerbankSystem.instance.system:getObjectByIndex(i-1):getModData()
        if IsoUtils.DistanceToSquared(x, y, pb.x, pb.y) <= 400.0 and math.abs(z - pb.z) <= 3 then
            table.insert(options, {pb.x-x,pb.y-y, pb})
        end
    end
    return options
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
    --local myWeather = getClimateManager()
    --local currentHour = getGameTime():getHour()

    -- print("My weather: ", myWeather)
    -- print("My time: ", currentHour)
    local cloudiness = getClimateManager():getCloudIntensity()
    local light = getClimateManager():getDayLightStrength()
    local fogginess = getClimateManager():getFogIntensity()
    local CloudinessFogginessMean = 1 - (((cloudiness + fogginess) / 2) * 0.25) --make it so that clouds and fog can only reduce output by 25%
    local output = SPowerbankSystem.instance.getMaxSolarOutput(SolarInput)
    local temperature = getClimateManager():getTemperature()
    local temperaturefactor = temperature * -0.0035 + 1.1 --based on linear single crystal sp efficiency
    output = output * CloudinessFogginessMean
    output = output * temperaturefactor
    output = output * light
    return output
end

function CPowerbankSystem.onPlugGenerator(character,generator,plug)
    local gendata = generator:getModData()
    if plug then
        local isopb = ISAScan.findPowerbank(generator:getSquare(),3,0,10)
        if isopb then
            local pb = { x = isopb:getX(), y = isopb:getY(), z = isopb:getZ() }
            local gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }
            gendata["ISA_conGenerator"] = pb
            generator:transmitModData()
            CPowerbankSystem.instance:sendCommand(character,"plugGenerator",{ pb = pb, gen = gen, plug = plug })
        end
    else
        if gendata["ISA_conGenerator"] then
            local pbdata = gendata["ISA_conGenerator"]
            if CPowerbankSystem.instance:getLuaObjectAt(pbdata.x,pbdata.y,pbdata.z) then
                local gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }
                CPowerbankSystem.instance:sendCommand(character,"plugGenerator",{ pb = pbdata, gen = gen, plug = plug })
            end
            gendata["ISA_conGenerator"] = nil
            generator:transmitModData()
        end
    end
end

function CPowerbankSystem.onActivateGenerator(character,generator,activate)
    local pbdata = generator:getModData()["ISA_conGenerator"]
    if pbdata then
        if CPowerbankSystem.instance:getLuaObjectAt(pbdata.x,pbdata.y,pbdata.z) then
            local gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }
            CPowerbankSystem.instance:sendCommand(character,"activateGenerator", { pb = pbdata, gen = gen , activate = activate })
        else
            pbdata = nil
            generator:transmitModData()
        end
    end
end

--CPowerbankSystem.maxBatteryCapacity = {
--    ["50AhBattery"] = 50,
--    ["75AhBattery"] = 75,
--    ["100AhBattery"] = 100,
--    ["DeepCycleBattery"] = 200,
--    ["SuperBattery"] = 400,
--    ["DIYBattery"] = (SandboxVars.ISA.DIYBatteryCapacity or 200)
--}

function CPowerbankSystem.onInventoryTransfer(src, dest, item, character)

    local take =  src and src:getTextureName() == "solarmod_tileset_01_0"
    local put =  dest and dest:getTextureName() == "solarmod_tileset_01_0"
    if not (take or put) then return end

    local type = item:getType()
    if not ( type == "50AhBattery" or type == "75AhBattery" or type == "100AhBattery" or type == "DeepCycleBattery" or type == "SuperBattery" or
        type == "DIYBattery") or item:getCondition() == 0 then
        if put then character:Say(getText("IGUI_ISAContainerNotBattery")..item:getDisplayName()) end
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

CGlobalObjectSystem.RegisterSystemClass(CPowerbankSystem)
