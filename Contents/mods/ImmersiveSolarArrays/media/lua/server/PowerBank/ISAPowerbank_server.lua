if isClient() then return end

require "Map/SGlobalObject"
local isa = require "ISAUtilities"
local solarscan = require "Powerbank/ISA_solarscan"
local sandbox = SandboxVars.ISA

local SPowerbank = SGlobalObject:derive("SPowerbank")

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

function SPowerbank:new(luaSystem, globalObject)
    return SGlobalObject.new(self, luaSystem, globalObject)
end

--when you load isoobject without luaobject, place object
function SPowerbank:stateFromIsoObject(isoObject)
    self:initNew()

    if self.luaSystem.isValidModData(isoObject:getModData()) then
        self:noise("Valid Data")
        self:fromModData(isoObject:getModData())
    end

    self:handleBatteries(isoObject:getContainer())
    self:autoConnectToGenerator()
    self:createGenerator() --if generator...
    self:loadGenerator()
    self:updateDrain()
    self:updateSprite()
    self:saveData(true)
end

function SPowerbank:stateToIsoObject(isoObject)
    self:toModData(isoObject:getModData())
    isoObject:transmitModData()
    self:loadGenerator()
    self:updateSprite()
end

function SPowerbank:fromModData(modData)
    self.on = modData["on"]
    self.batteries = modData["batteries"]
    self.charge = modData["charge"]
    self.maxcapacity = modData["maxcapacity"]
    self.drain = modData["drain"]
    self.npanels = modData["npanels"]
    self.panels = modData["panels"]
    self.lastHour = modData["lastHour"]
    self.conGenerator = modData["conGenerator"]
end

function SPowerbank:toModData(modData)
    modData["on"] = self.on
    modData["batteries"] = self.batteries
    modData["charge"] = self.charge
    modData["maxcapacity"] = self.maxcapacity
    modData["panels"] = self.panels
    modData["npanels"] = self.npanels
    modData["drain"] = self.drain
    modData["lastHour"] = self.lastHour
    modData["conGenerator"] = self.conGenerator
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

function SPowerbank:getDrainVanilla(square)
    local scale = 800
    local gen = square:getGenerator()
    if gen:isActivated() then
        gen:setSurroundingElectricity()
        return gen:getTotalPowerUsing() * scale
    else
        return SPowerbank.getTotalWhenoff(gen) * scale
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

function SPowerbank:chargeBatteries(container,charge)
    --local max = ISAUtilities.maxBatteryCapacity
    local items = container:getItems()
    for i=1,items:size() do
        local item = items:get(i-1)
        --if max[item:getType()] then
            item:setUsedDelta(charge)
        --end
    end
end

-- could be better to have a standard value * sandbox for lost condition, rather than random, reminder condition has only integers
local degradeOpt = 1
function SPowerbank:degradeBatteries(container)
    local ISABatteryDegradeChance = sandbox.batteryDegradeChance
    degradeOpt = ISABatteryDegradeChance / 100
    if ISABatteryDegradeChance == 0 then return end

    local ZombRand = ZombRand

    local items = container:getItems()
    for i=0,items:size()-1 do
        local item = items:get(i)
        --local condition = item:getCondition()
        --if condition > 0 then
            local type = item:getType()
            if type ~= "WiredCarBattery" then
                if ZombRand(100) < ISABatteryDegradeChance then
                    if type == "50AhBattery" then
                        item:setCondition(item:getCondition() - ZombRand(1, 10))
                        --breaks in 20 days
                    end
                    if type == "75AhBattery" then
                        item:setCondition(item:getCondition() - ZombRand(1, 8))
                        --breaks in 25 days
                    end
                    if type == "100AhBattery" then
                        item:setCondition(item:getCondition() - ZombRand(2, 6))
                        --breaks in 33 days
                    end
                    if type == "DeepCycleBattery" then
                        local chance = ZombRand(1, 33)
                        if chance == 1 then
                            item:setCondition(item:getCondition() - 1)
                        end
                        --breaks in 9+ years
                    end
                    if type == "SuperBattery" then
                        local chance = ZombRand(1, 33)
                        if chance == 1 then
                            item:setCondition(item:getCondition() - 1)
                        end
                        --breaks in 9+ years
                    end
                    if type == "DIYBattery" then
                        local chance = ZombRand(1, 8)
                        if chance == 1 then
                            item:setCondition(item:getCondition() - 1)
                        end
                        --breaks in 2 years
                    end
                end
            else
                local degrade = 3.333
                item:setCondition(item:getCondition() - degrade * degradeOpt * ZombRand(8,12)/10) --fixme only int
            end
        --end
    end
end

function SPowerbank:handleBatteries(container)
    local batteries = 0
    local capacity = 0
    local charge = 0
    local maxCap = isa.maxBatteryCapacity
    for i=0,container:getItems():size()-1 do
        local item = container:getItems():get(i)
        --local type = item:getType()
        local maxCapType = (item:hasModData() and item:getModData().ISAMaxCapacityAh or maxCap[item:getType()])
        if maxCapType and not item:isBroken() then
            batteries = batteries + 1
            local cap = maxCapType * (1 - math.pow((1 - (item:getCondition()/100)),6))
            capacity = capacity + cap
            charge = charge + cap * item:getUsedDelta()
        end
    end
    self.batteries = batteries
    self.maxcapacity = capacity
    self.charge = charge
end

function SPowerbank:checkPanels()
    for i = #self.panels, 1, -1 do
        local panel = self.panels[i]
        local square = getSquare(panel.x, panel.y, panel.z)
        if square and (not square:isOutside() or not isa.WorldUtil.findTypeOnSquare(square,"Panel")) then
            table.remove(self.panels,i)
        end
    end
end

function SPowerbank:getSprite(updatedCH)
    if self.batteries == 0 then return nil end
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

--todo remove this fix for prev errors
function SPowerbank:fixIndex()
    if self.doneFix then return end
    self.doneFix = true

    local square = self:getSquare()
    local bank,hasGen
    local special = square:getSpecialObjects()
    local i = 0
    while i < special:size() do
        local obj = special:get(i)
        if instanceof(obj,"Isogenerator") then
            if not bank or hasGen then
                obj:remove()
                i=i-1
            else
                hasGen = true
            end
        elseif not bank and obj:getTextureName() == "solarmod_tileset_01_0" then
            bank = true
        end

        --if not bank then
        --    if obj:getSprite() and obj:getSprite():getName() == "solarmod_tileset_01_0" then
        --        bank = true
        --    elseif instanceof(obj, "IsoGenerator") then
        --        obj:remove()
        --        i=i-1
        --    end
        --else
        --    if instanceof(obj, "IsoGenerator") then
        --        if hasGen then
        --            obj:remove()
        --            i=i-1
        --        else
        --            hasGen = true
        --        end
        --    end
        --end
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
                    --local generator = isquare and isquare:getGenerator()
                    --if generator and self.luaSystem:isValidBackup(generator,isquare) then
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
            return generator, square
        end
    end
    return nil
end

function SPowerbank:updateConGenerator()
    if self.lastHour == math.floor(getGameTime():getWorldAgeHours()) then return end
    local conGenerator,square = self:getConGenerator()
    if square then
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
            self.lastHour = math.floor(getGameTime():getWorldAgeHours())
            self.conGenerator.ison = conGenerator:isActivated()
        else
            self.conGenerator = false
        end
    end
end

return SPowerbank