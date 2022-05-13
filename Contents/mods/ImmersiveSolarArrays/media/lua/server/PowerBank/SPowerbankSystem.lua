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

--function SPowerbankSystem:OnObjectAboutToBeRemoved(isoObject)
--    if not self:isValidIsoObject(isoObject) then return end
--
--    return SGlobalObjectSystem.OnObjectAboutToBeRemoved(self,isoObject)
--end

function SPowerbankSystem.removePanel(xpanel)
    local data = xpanel:getModData()
    local pb = data["powerbank"] and SPowerbankSystem.instance:getLuaObjectAt(data["powerbank"].x,data["powerbank"].y,data["powerbank"].z)
    if pb then
        local x = xpanel:getX()
        local y = xpanel:getY()
        local z = xpanel:getZ()
        for v,panel in ipairs(pb.panels) do
            if panel.x == x and panel.y == y and panel.z == z then
                table.remove(pb.panels,v)
                pb.npanels = pb.npanels - 1
                break
            end
        end
        pb:saveData(true)
    end
end

--function SPowerbankSystem.fixForGenerators(square, index, bank, first)
--    if index == nil then index = 1 end
--    local special = square:getSpecialObjects()
--    for i = index, special:size() do
--        local obj = special:get(i-1)
--        if not bank then
--            if obj:getSprite() and obj:getSprite():getName() == "solarmod_tileset_01_0" then bank = true;
--            elseif instanceof(obj, "IsoGenerator") then obj:remove();
--            end
--        else
--            if instanceof(obj, "IsoGenerator") then
--                if first then
--                    obj:remove()
--                    return SPowerbankSystem.instance.fixForGenerators(square,i,bank,first)
--                else
--                    first = true
--                end
--            end
--        end
--    end
--end

local delayedRemove = {}
local dgrTick
function SPowerbankSystem.delayedGenRemove()
    for i,entry in ipairs(delayedRemove) do
        local generator = entry[1]
        if entry[2] > generator:getSquare():getObjects():size() then
            generator:setActivated(false)
            generator:remove()
            table.remove(delayedRemove,i)
        end
    end
    dgrTick = dgrTick + 1
    if #delayedRemove == 0 or dgrTick == 15 then
        dgrTick = nil
        Events.OnTick.Remove(SPowerbankSystem.instance.delayedGenRemove)
    end
end

--remove generator after powerbank has been removed
function SPowerbankSystem.genRemove(square)
    local gen = square:getGenerator()
    if gen then
        table.insert(delayedRemove, { gen, square:getObjects():size() })
        if not dgrTick then Events.OnTick.Add(SPowerbankSystem.instance.delayedGenRemove) end
        dgrTick = 0
    end
end

function SPowerbankSystem.getMaxSolarOutput(SolarInput)
    local ISASolarEfficiency = SandboxVars.ISA.solarPanelEfficiency
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

--add debug functions
function SPowerbankSystem.rebootSystem(player,arg)
    local square = getSquare(arg.x,arg.y,arg.z)
    local isopb = ISAScan.findOnSquare(square,"solarmod_tileset_01_0")
    local data = isopb and isopb:getModData()
    local luaObj = SPowerbankSystem.instance:getLuaObjectOnSquare(square)
    local oldcharge = luaObj and luaObj.charge or data and data.charge or 0

    if luaObj then SPowerbankSystem.instance:removeLuaObject(luaObj) end
    if isopb then
        local special = isopb:getSquare():getSpecialObjects()
        for i = special:size() , 1, -1  do
            local obj = special:get(i-1)
            if instanceof(obj, "IsoGenerator") then
                obj:remove()
            end
        end
    end
    if data then data.charge = nil end
    HaloTextHelper.addText(player,"powerbank", HaloTextHelper.getColorRed())

    if isopb then
        SPowerbankSystem.instance:loadIsoObject(isopb)
        local newlua = SPowerbankSystem.instance:getLuaObjectOnSquare(square)
        newlua.charge = oldcharge
        newlua:handleBatteries(isopb:getContainer())
        newlua:saveData(true)
        HaloTextHelper.addText(player,"powerbank", HaloTextHelper.getColorGreen())
        newlua:degradeBatteries(isopb:getContainer())
        isopb:sendObjectChange("containers")
    end
end

function SPowerbankSystem.EveryDays()
    for i=1,SPowerbankSystem.instance.system:getObjectCount() do
        local pb = SPowerbankSystem.instance.system:getObjectByIndex(i-1):getModData()
        local isopb = pb:getIsoObject()
        if isopb then
            local prevCap = pb.maxcapacity
            local inv = isopb:getContainer()
            pb:degradeBatteries(inv) --todo x days passed
            pb:handleBatteries(inv)
            pb.charge = prevCap > 0 and pb.charge * pb.maxcapacity / prevCap or 0
            isopb:sendObjectChange("containers")
        end
    end
end

function SPowerbankSystem:updatePowerbanks(chargefreq)
    local solaroutput = self.getModifiedSolarOutput(1)
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
            pb:saveData(true)
        end
        pb:updateConGenerator()
        if getDebug() then
            print("Isa Log charge: "..i.." / "..tostring(math.floor(chargemod*100)).."%".." / "..math.floor(dif).." / "..math.floor(self.getModifiedSolarOutput(pb.npanels)).." - "..math.floor(drain))
        end
    end
end

function SPowerbankSystem.sandbox()
    if getDebug() then print("Powerbank sandbox: "..tostring(SandboxVars.ISA.DrainCalc).." / "..tostring(SandboxVars.ISA.ChargeFreq)) end
    --if not SandboxVars.ISA.ChargeFreq then SandboxVars.ISA.ChargeFreq = 1 end
    --if not SandboxVars.ISA.DrainCalc then SandboxVars.ISA.DrainCalc = 1 end
    --if not SandboxVars.ISA.solarPanelEfficiency then SandboxVars.ISA.solarPanelEfficiency = 90 end

    Events.EveryDays.Add(SPowerbankSystem.EveryDays)
    if SandboxVars.ISA.ChargeFreq == 1 then
        Events.EveryTenMinutes.Add(function()SPowerbankSystem.instance:updatePowerbanks(1) end)
    else
        Events.EveryHours.Add(function()SPowerbankSystem.instance:updatePowerbanks(2) end)
    end
end
Events.OnInitWorld.Add(SPowerbankSystem.sandbox)

SGlobalObjectSystem.RegisterSystemClass(SPowerbankSystem)
