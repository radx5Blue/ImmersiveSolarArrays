--[[
"isa_powerbank" server luaObject
--]]

if isClient() then return end

require "Map/SGlobalObject"
local isa = require "ISAUtilities"
local solarscan = require "Powerbank/ISA_solarscan"
local sandbox = SandboxVars.ISA

local SPowerbank = SGlobalObject:derive("SPowerbank")

function SPowerbank:new(luaSystem, globalObject)
    return SGlobalObject.new(self, luaSystem, globalObject)
end

function SPowerbank:initNew()
    self.on = false
    self.batteries = 0
    self.charge = 0
    self.maxcapacity = 0
    self.panels = {}
    self.npanels = 0
    self.drain = 0
    self.lastHour = 0
    self.conGenerator = false
end

--called from loadIsoObject function when making new globalObject & luaObject, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SPowerbank:stateFromIsoObject(isoObject)
    self:initNew()
    self:handleBatteries(isoObject:getContainer())
    self:autoConnectToGenerator()
    self:createGenerator() --if generator...
    self:loadGenerator()
    self:updateDrain()
    self:updateSprite()
    self:saveData(true)
end

--called from loadIsoObject function when luaObject exists, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SPowerbank:stateToIsoObject(isoObject)
    self:toModData(isoObject:getModData())
    isoObject:transmitModData()
    self:loadGenerator()
    self:updateSprite()
end

function SPowerbank:fromModData(modData)
    self.on = modData.on
    self.batteries = modData.batteries
    self.charge = modData.charge
    self.maxcapacity = modData.maxcapacity
    self.drain = modData.drain
    self.npanels = modData.npanels
    self.panels = modData.panels
    self.lastHour = modData.lastHour
    self.conGenerator = modData.conGenerator
end

function SPowerbank:toModData(modData)
    modData.on = self.on
    modData.batteries = self.batteries
    modData.charge = self.charge
    modData.maxcapacity = self.maxcapacity
    modData.panels = self.panels
    modData.npanels = self.npanels
    modData.drain = self.drain
    modData.lastHour = self.lastHour
    modData.conGenerator = self.conGenerator
end

function SPowerbank:saveData(transmit)
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    self:toModData(isoObject:getModData())
    if transmit then
        isoObject:transmitModData()
    end
end

function SPowerbank:shouldDrain(isoPb)
    if self.switchchanged then self.switchchanged = nil elseif not self.on then return false end
    if self.conGenerator and self.conGenerator.ison then return false end

    local world = getWorld()
    if world:isHydroPowerOn() then
        if isoPb then
            if not isoPb:getSquare():isOutside() then return false end
        else
            if world:getMetaGrid():getRoomAt(self.x,self.y,self.z) then return false end
        end
    end
    return true
end

SPowerbank.fuelToSolarRate = 800
function SPowerbank:getDrainVanilla(square)
    local gen = square:getGenerator()
    if gen:isActivated() then
        gen:setSurroundingElectricity()
        return gen:getTotalPowerUsing() * self.fuelToSolarRate
    else
        return SPowerbank.getTotalWhenoff(gen) * self.fuelToSolarRate
    end
end

function SPowerbank.getTotalWhenoff(generator)
    generator:setActivated(true)
    local tpu = generator:getTotalPowerUsing()
    generator:setActivated(false)
    if generator:getSquare():getBuilding() ~= nil then generator:getSquare():getBuilding():setToxic(false) end
    return tpu
end

function SPowerbank:updateDrain()
    local square = self:getSquare()
    if not square then return end
    if sandbox.DrainCalc == 1 then
        self.drain = solarscan(square, false, true, false, 0)
    else
        self.drain = SPowerbank:getDrainVanilla(square)
    end
end

--all items should be batteries
function SPowerbank:chargeBatteries(container,charge)
    local items = container:getItems()
    for i=0,items:size()-1 do
        local item = items:get(i)
        item:setUsedDelta(charge)
    end
end

SPowerbank.batteryDegrade = {
    ["WiredCarBattery"] = 7, --ModData
    ["DIYBattery"] = 0.125,
    ["DeepCycleBattery"] = 0.033,
    ["SuperBattery"] = 0.033,
}

--condition is an int
function SPowerbank:degradeBatteries(container)
    if sandbox.batteryDegradeChance == 0 then return end

    local ZombRand, math = ZombRand, math
    local mod = sandbox.batteryDegradeChance * ZombRand(8,13) / 1000

    local items = container:getItems()
    for i=0,items:size()-1 do
        local item = items:get(i)
        local degradeVal = item:getModData()["ISA_BatteryDegrade"] or self.batteryDegrade[item:getType()]
        if degradeVal then
            -- average of 1M rolls / 10: 5.5 / 3: 2 / 1.6: 1.37364 / 0.9: 0.90082 / 0.033: 0.03280
            degradeVal = degradeVal * mod
            degradeVal = degradeVal > 1 and 1 + math.floor(ZombRand(degradeVal * 100) / 100) or math.floor(ZombRand(100 / degradeVal) / 100 ) == 0 and 1 or 0
            if degradeVal > 0 then
                item:setCondition(item:getCondition() - degradeVal)
            end
        end
    end
end

function SPowerbank:handleBatteries(container)
    local maxCap = isa.maxBatteryCapacity

    local batteries = 0
    local capacity = 0
    local charge = 0

    local items = container:getItems()
    for i=0,items:size()-1 do
        local item = items:get(i)
        local maxCapType = item:getModData().ISA_maxCapacity or maxCap[item:getType()]
        if maxCapType then
            local condition = item:getCondition()
            if condition > 0 then
                batteries = batteries + 1
                local cap = maxCapType * (1 - math.pow((1 - (condition/100)),6))
                capacity = capacity + cap
                charge = charge + cap * item:getUsedDelta()
            end
        end
    end

    self.batteries = batteries
    self.maxcapacity = capacity
    self.charge = charge
end

function SPowerbank:isValidPanel(panel)
    local x,y,z = panel:getX(), panel:getY(), panel:getZ()
    if IsoUtils.DistanceToSquared(x, y, self.x, self.y) <= 400.0 and math.abs(z - self.z) <= 3 then
        for _,panel in ipairs(self.panels) do
            if x == panel.x and y == panel.y and z == panel.z then return "valid" end
        end
        return "not connected"
    else
        return "far"
    end
end

---checks the square for a panel object and returns the object and status
function SPowerbank:isValidPanelOnSquare(square)
    local panel = isa.WorldUtil.findTypeOnSquare(square,"Panel")
    if panel ~= nil then
        return panel, square:isOutside() and self:isValidPanel(panel) or "inside"
    end
end

function SPowerbank:checkPanels()
    local getSquare = getSquare

    local dup = {}
    for i = #self.panels, 1, -1 do
        local panel = self.panels[i]
        local square = getSquare(panel.x, panel.y, panel.z)
        if square ~= nil then --is chunk loaded?
            local panelObj, status = self:isValidPanelOnSquare(square)
            if not panelObj or status ~= "valid" or dup[square] then
                table.remove(self.panels,i)
            end
            dup[square] = true
        end
    end
    self.npanels = #self.panels
end

function SPowerbank:getSprite(updatedCH)
    if self.batteries <= 0 then return nil end
    if updatedCH == nil then updatedCH = self.maxcapacity > 0 and self.charge / self.maxcapacity or 0 end
    if updatedCH < 0.10 then
        --show 0 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_1"
        elseif self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_2"
        elseif self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_3"
        elseif self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_4"
        else
            --show five shelves
            return "solarmod_tileset_01_5"
        end
    elseif updatedCH < 0.35 then
        --show 25 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_16"
        elseif self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_20"
        elseif self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_24"
        elseif self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_28"
        else
            --show five shelves
            return "solarmod_tileset_01_32"
        end
    elseif updatedCH < 0.65 then
        -- show 50 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_17"
        elseif self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_21"
        elseif self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_25"
        elseif self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_29"
        else
            --show five shelves
            return "solarmod_tileset_01_33"
        end
    elseif updatedCH < 0.95 then
        -- show 75 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_18"
        elseif self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_22"
        elseif self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_26"
        elseif self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_30"
        else
            --show five shelves
            return "solarmod_tileset_01_34"
        end
    else
        --show 100 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_19"
        elseif self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_23"
        elseif self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_27"
        elseif self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_31"
        else
            --show five shelves
            return "solarmod_tileset_01_35"
        end
    end
end

function SPowerbank:updateSprite(chargemod)
    local newsprite = self:getSprite(chargemod)
    local gen = self:getSquare():getGenerator()
    if newsprite ~= gen:getSpriteName() then
        gen:setSprite(newsprite)
        gen:sendObjectChange("sprite")
    end
end

function SPowerbank:createGenerator()
    self:noise("Creating Generator")
    local square = self:getSquare()
    local generator = IsoGenerator.new(nil, square:getCell(), square)
    generator:setSprite(nil)
    generator:transmitCompleteItemToClients()
    generator:setCondition(100)
    generator:setFuel(100)
    generator:setConnected(true)
    generator:getCell():addToProcessIsoObjectRemove(generator)
end

function SPowerbank:removeGenerator()
    local square = self:getSquare()
    local gen = square:getGenerator()
    if gen then
        gen:setActivated(false)
        gen:remove() --index error
        --square:transmitRemoveItemFromSquare(gen) --index error
    end
end

function SPowerbank:updateGenerator(dif)
    if dif == nil then
        dif = self.luaSystem:getModifiedSolarOutput(self.npanels) - self.drain
        if sandbox.ChargeFreq == 1 then
            dif = dif / 6
        end
    end
    local activate = self.on and self.charge + dif > 0
    local square = self:getSquare()
    local generator = square:getGenerator()
    generator:setActivated(activate)
    if square:getBuilding() ~= nil then square:getBuilding():setToxic(false) end
end

--if freezer timers, Powerbank generator condition / fuel are wrong check here
function SPowerbank:loadGenerator()
    local square = self:getSquare()

    self:fixIndex()

    local gen = square:getGenerator()
    gen:setSurroundingElectricity()
    gen:getCell():addToProcessIsoObjectRemove(gen)

    self:updateGenerator()

    self:updateConGenerator()

end

function SPowerbank:fixIndex()
    if self.fixIndex_done then return end
    self.fixIndex_done = true

    local square = self:getSquare()
    local special = square:getSpecialObjects()
    local bank,hasGen
    local i = 0
    while i < special:size() do
        local obj = special:get(i)
        if not bank and obj:getTextureName() == "solarmod_tileset_01_0" then
            bank = true
        elseif instanceof(obj,"IsoGenerator") then
            if bank and not hasGen then
                hasGen = true
            else
                obj:remove()
                i=i-1
            end
        end
        i = i +1
    end
    if self.conGenerator then
        local conGenerator,conSquare = self:getConGenerator()
        if conSquare and not self.luaSystem:getValidBackupOnSquare(conSquare) then
            self:autoConnectToGenerator()
        end
    end
    if not hasGen then self:createGenerator() end
end

function SPowerbank:connectBackupGenerator(generator)
    self.conGenerator = {}
    self.conGenerator.x = generator:getX()
    self.conGenerator.y = generator:getY()
    self.conGenerator.z = generator:getZ()
    self.conGenerator.ison = generator:isActivated()
    self.lastHour = 0
end

function SPowerbank:autoConnectToGenerator()
    local area = isa.WorldUtil.getValidBackupArea(nil,3)

    self.conGenerator = false
    for ix = self.x - area.radius, self.x + area.radius do
        for iy = self.y - area.radius, self.y + area.radius do
            for iz = self.z - area.levels, self.z + area.levels do
                if ix >= 0 and iy >= 0 and iz >= 0 then
                    local isquare = IsoUtils.DistanceToSquared(self.x,self.y,self.z,ix,iy,iz) <= area.distance and getSquare(ix, iy, iz)
                    local generator = isquare and self.luaSystem:getValidBackupOnSquare(isquare)
                    if generator then
                        self:connectBackupGenerator(generator)
                        return
                    end
                end
            end
        end
    end
end

function SPowerbank:getConGenerator()
    if self.conGenerator then
        local square = getSquare(self.conGenerator.x,self.conGenerator.y,self.conGenerator.z)
        if square then
            local generator = square:getGenerator()
            if not generator then self.conGenerator = false end
            return generator, square
        end
    end
    return nil
end

function SPowerbank:updateConGenerator()
    local currentHour = math.floor(getGameTime():getWorldAgeHours())
    if self.lastHour == currentHour then return end
    local conGenerator,square = self:getConGenerator()
    if conGenerator then

        conGenerator:update()

        if self.on and isa.WorldUtil.findOnSquare(square, "solarmod_tileset_01_15") then
            local minfailsafe = self.drain
            if conGenerator:isActivated() then
                if self.charge > minfailsafe then conGenerator:setActivated(false)end
            else
                if self.charge < minfailsafe and conGenerator:getFuel() > 0 and conGenerator:getCondition() > 20 then conGenerator:setActivated(true) end
            end
        end
        self.lastHour = currentHour
        -- if isActive ~= setActive then
        self.conGenerator.ison = conGenerator:isActivated()
    end
end

return SPowerbank