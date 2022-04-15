if isClient() then return end

SPowerbankSystem = SGlobalObjectSystem:derive("SPowerbankSystem")

function SPowerbankSystem:new()
    return SGlobalObjectSystem.new(self, "Powerbank")
end

function SPowerbankSystem:initSystem()
    SGlobalObjectSystem.initSystem(self)
    self.system:setModDataKeys({})
    self.system:setObjectModDataKeys({'on', 'batteries', 'charge', 'maxcapacity', 'drain', 'npanels', 'panels', "lastHour", "conGenerator"})
end

function SPowerbankSystem:newLuaObject(globalObject)
    return SPowerbank:new(self, globalObject)
end

function SPowerbankSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function SPowerbankSystem.isValidModData(modData)
    return modData.charge ~= nil
end

function SPowerbankSystem:getIsoObjectOnSquare(square)
    if square then
        for i=1,square:getSpecialObjects():size() do
            local isoObject = square:getSpecialObjects():get(i-1)
            if self:isValidIsoObject(isoObject) then
                return isoObject
            end
        end
    end
    return nil
end

function SPowerbankSystem:OnClientCommand(command, playerObj, args)
    SPowerbankSystemCommands[command](playerObj, args)
end

SPowerbankSystem.maxBatteryCapacity = {
    ["50AhBattery"] = 50,
    ["75AhBattery"] = 75,
    ["100AhBattery"] = 100,
    ["DeepCycleBattery"] = 200,
    ["SuperBattery"] = 400,
    ["DIYBattery"] = (SandboxVars.ISA.DIYBatteryCapacity or 200)
}

function SPowerbankSystem.removePanel(xpanel)
    local data = xpanel:getModData()
    data.connectDelta = nil
    if not data["powerbank"] then return end
    local x = xpanel:getX()
    local y = xpanel:getY()
    local z = xpanel:getZ()

    local pb = SPowerbankSystem.instance:getLuaObjectAt(data["powerbank"].x,data["powerbank"].y,data["powerbank"].z)
    if pb then
        for v,panel in ipairs(pb.panels) do
            if panel.x == x and panel.y == y and panel.z == z then
                table.remove(pb.panels,v)
                pb.npanels = pb.npanels - 1
                data["powerbank"] = nil
                return
            end
        end
    end
end

function SPowerbankSystem.getMaxSolarOutput(SolarInput)
    local ISASolarEfficiency = SandboxVars.ISA.solarPanelEfficiency
    if ISASolarEfficiency == nil then
        ISASolarEfficiency = 90
    end

    local output = SolarInput * (83 * ((ISASolarEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
    return output
end

function SPowerbankSystem.getModifiedSolarOutput(SolarInput)
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

function SPowerbankSystem:EveryDays()
    for i=1,self.system:getObjectCount() do
        local pb = self.system:getObjectByIndex(i-1):getModData()
        local isopb = pb:getIsoObject()
        if isopb then
            local inv = isopb:getContainer()
            pb:degradeBatteries(inv) -- x days passed
            pb:handleBatteries(inv)
        end
    end
end

function SPowerbankSystem:updateCharge(chargefreq)
    local solaroutput = self.getModifiedSolarOutput(1)
    for i=1,self.system:getObjectCount() do
        local pb = self.system:getObjectByIndex(i-1):getModData()
        local isopb = pb:getIsoObject()
        local drain
        if pb.switchchanged then pb.switchchanged = nil elseif not pb.on then drain = 0 end
        if pb.conGenerator and pb.conGenerator.ison then drain = 0 end
        --sandbox check,electricity on
        if drain ~= 0 then
            if isopb then pb:updateDrain() end
            drain = pb.drain
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
            pb:updateConGenerator()
            pb:updateSprite(chargemod)
            pb:saveData(true)
        end
        if getDebug() then
            print("Isa Log charge: "..i.." / "..tostring(math.floor(chargemod*100)).."%".." / "..math.floor(dif).." / "..math.floor(self.getModifiedSolarOutput(pb.npanels)).." - "..math.floor(drain))
        end
    end
end

function SPowerbankSystem.rebootSystem(arg)
    local square = getSquare(arg.x,arg.y,arg.z)
    local isopb = ISAScan.squareHasPowerbank(square)
    local data = isopb:getModData()
    local luaObj = SPowerbankSystem.instance:getLuaObjectOnSquare(square)
    local oldcharge = data.charge or luaObj.charge or 0

    if luaObj then SPowerbankSystem.instance:removeLuaObject(luaObj) end
    local special = isopb:getSquare():getSpecialObjects()
    for i = 1, special:size() do
        local obj = special:get(i-1)
        if instanceof(obj, "IsoGenerator") then
            obj:remove()
        end
    end

    local newlua = SPowerbankSystem.instance:newLuaObjectAt(isopb:getX(),isopb:getY(),isopb:getZ())
    newlua:initNew()
    newlua.charge = oldcharge
    newlua:handleBatteries(isopb:getContainer())
    newlua:autoConnectToGenerator()
    newlua:createGenerator()
    newlua:updateSprite()
    newlua:saveData(true)
end

SGlobalObjectSystem.RegisterSystemClass(SPowerbankSystem)

local function addEvents()
    if not SandboxVars.ISA.ChargeFreq then SandboxVars.ISA.ChargeFreq = 1 end
    if not SandboxVars.ISA.DrainCalc then SandboxVars.ISA.DrainCalc = 1 end

    Events.EveryDays.Add(function()SPowerbankSystem.instance:EveryDays() end)
    if SandboxVars.ISA.ChargeFreq == 1 then
        Events.EveryTenMinutes.Add(function()SPowerbankSystem.instance:updateCharge(1) end)
    else
        Events.EveryHours.Add(function()SPowerbankSystem.instance:updateCharge(2) end)
    end
end
Events.OnLoad.Add(addEvents)
