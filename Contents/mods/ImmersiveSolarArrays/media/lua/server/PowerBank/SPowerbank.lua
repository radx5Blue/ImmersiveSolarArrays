if isClient() then return end

require "Map/SGlobalObject"

SPowerbank = SGlobalObject:derive("SPowerbank")

function SPowerbank:initNew()
    self.on = false
    self.batteries = 0
    self.charge = 0
    self.maxcapacity = 0
    self.panels = {}
    self.npanels = 0
    self.drain = 0
    self.lastHour = 0
    self.conGenerator = nil
end

function SPowerbank:new(luaSystem, globalObject)
    local o = SGlobalObject.new(self, luaSystem, globalObject)
    return o
end

function SPowerbank:aboutToRemoveFromSystem()
    SPowerbankSystem.genRemove(self:getSquare())
end

--when you load isoobject without luaobject, place object
function SPowerbank:stateFromIsoObject(isoObject)
    self:initNew()

    if SPowerbankSystem.isValidModData(isoObject:getModData()) then
        self:noise("Valid Data")
        self:fromModData(isoObject:getModData())
    else
        --if ModData.exists("PBK") then
        --    self:fromPBK(isoObject)
        --end

        --self:createGenerator()
    end

    self:autoConnectToGenerator()
    self:loadGenerator()
    self:updateSprite()
    self:toModData(isoObject:getModData())
    isoObject:transmitModData()
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

function SPowerbank:fromPBK(isoObject)
    local isaData = {}
    isaData.key = ModData.get("PBK") --powerBankKey
    isaData.x = ModData.get("PBX") --powerBankX
    isaData.y = ModData.get("PBY") --powerBankY
    isaData.z = ModData.get("PBZ") --powerBankZ
    isaData.charge = ModData.get("PBCH") --PowerBankCharge
    local key
    for i=1,#isaData.key do
        if self.x == isaData.x[i] and self.y == isaData.y[i] and self.z == isaData.z[i] then
            key = i
            break
        end
    end
    local square = self:getSquare()
    for i = 1, square:getObjects():size() do
        local obj = square:getObjects():get(i-1)
        if obj and instanceof(obj, "IsoGenerator") then
            obj:remove()
        end
    end
    self:handleBatteries(isoObject:getContainer())
    if key then
        self.charge = isaData.charge[key] * self.maxcapacity
    end
end

function SPowerbank:shouldDrain(isoPb)
    if self.switchchanged then self.switchchanged = nil elseif not self.on then return false end
    if self.conGenerator and self.conGenerator.ison then return false end
    --v.41.69+
    if getWorld().isHydroPowerOn and getWorld():isHydroPowerOn() then
        if isoPb then
            if not isoPb:getSquare():isOutside() then return false end
        else
            if getWorld():getMetaGrid():getRoomAt(self.x,self.y,self.z) then return false end
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
    if SandboxVars.ISA.DrainCalc == 1 then
        self.drain = solarscan(square, false, true, false, 0)
    else
        self.drain = SPowerbank:getDrainVanilla(square)
    end
end

function SPowerbank:chargeBatteries(container,charge)
    local max = ISAPowerbank.maxBatteryCapacity
    local items = container:getItems()
    for i=1,items:size() do
        local item = items:get(i-1)
        if max[item:getType()] then
            item:setUsedDelta(charge)
        end
    end
end

function SPowerbank:degradeBatteries(container)
    local ISABatteryDegradeChance = SandboxVars.ISA.batteryDegradeChance
    if SandboxVars.ISA.batteryDegradeChance == nil then
        ISABatteryDegradeChance = 100
    end
    local items = container:getItems()
    for i=1,items:size() do
        if ZombRand(100) < ISABatteryDegradeChance then
            local item = items:get(i-1)
            local type = item:getType()
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
    end
end

function SPowerbank:handleBatteries(container)
    local capacity = 0
    local batteries = 0
    for i=1,container:getItems():size() do
        local item = container:getItems():get(i-1)
        local cond = 1 - (item:getCondition()/100)
        local condition = 1 - math.pow(cond,6)
        local type = item:getType()
        if type == "50AhBattery" and item:getCondition() > 0 then
            capacity = capacity + 50 * condition
            batteries = batteries + 1
        end
        if type == "75AhBattery" and item:getCondition() > 0 then
            capacity = capacity + 75 * condition
            batteries = batteries + 1
        end
        if type == "100AhBattery" and item:getCondition() > 0 then
            capacity = capacity + 100 * condition
            batteries = batteries + 1
        end
        if type == "DeepCycleBattery" and item:getCondition() > 0 then
            capacity = capacity + 200 * condition
            batteries = batteries + 1
        end
        if type == "SuperBattery" and item:getCondition() > 0 then
            capacity = capacity + 400 * condition
            batteries = batteries + 1
        end
        if type == "DIYBattery" and item:getCondition() > 0 then
            capacity = capacity + (SandboxVars.ISA.DIYBatteryCapacity or 200) * condition
            batteries = batteries + 1
        end
    end
    self.maxcapacity = capacity
    self.batteries = batteries
    return capacity , batteries
end

function SPowerbank:getSprite(updatedCH)
    if self.batteries == 0 then return nil end
    --if self.batteries == 0 then return "solarmod_tileset_01_11" end
    if updatedCH == nil then updatedCH = self.maxcapacity > 0 and self.charge / self.maxcapacity or 0 end
    if updatedCH < 0.25 then
        --show 0 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_1"
        elseif self.batteries >= 5 and self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_2"
        elseif self.batteries >= 9 and self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_3"
        elseif self.batteries >= 13 and self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_4"
        elseif self.batteries >= 17 then
            --show five shelves
            return "solarmod_tileset_01_5"
        end
    elseif updatedCH >= 0.25 and updatedCH < 0.50 then
        --show 25 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_16"
        elseif self.batteries >= 5 and self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_20"
        elseif self.batteries >= 9 and self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_24"
        elseif self.batteries >= 13 and self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_28"
        elseif self.batteries >= 17 then
            --show five shelves
            return "solarmod_tileset_01_32"
        end
    elseif updatedCH >= 0.50 and updatedCH < 0.75 then
        -- show 50 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_17"
        elseif self.batteries >= 5 and self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_21"
        elseif self.batteries >= 9 and self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_25"
        elseif self.batteries >= 13 and self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_29"
        elseif self.batteries >= 17 then
            --show five shelves
            return "solarmod_tileset_01_33"
        end
    elseif updatedCH >= 0.75 and updatedCH < 0.95 then
        -- show 75 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_18"
        elseif self.batteries >= 5 and self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_22"
        elseif self.batteries >= 9 and self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_26"
        elseif self.batteries >= 13 and self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_30"
        elseif self.batteries >= 17 then
            --show five shelves
            return "solarmod_tileset_01_34"
        end
    elseif updatedCH >= 0.95 then
        --show 100 charge
        if self.batteries < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_19"
        elseif self.batteries >= 5 and self.batteries < 9 then
            --show two shelves
            return "solarmod_tileset_01_23"
        elseif self.batteries >= 9 and self.batteries < 13 then
            --show three shelves
            return "solarmod_tileset_01_27"
        elseif self.batteries >= 13 and self.batteries < 17 then
            --show four shelves
            return "solarmod_tileset_01_31"
        elseif self.batteries >= 17 then
            --show five shelves
            return "solarmod_tileset_01_35"
        end
    end
end

function SPowerbank:updateSprite(chargemod)
    local newsprite = self:getSprite(chargemod)
    local gen = self:getSquare():getGenerator()
    --self:noise("updateSprite / "..tostring(newsprite).." / ".. tostring(gen:getSpriteName()))
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
        dif = SPowerbankSystem.instance.getModifiedSolarOutput(self.npanels) - self.drain
        if SandboxVars.ISA.ChargeFreq == 1 then
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

    self:fixGeneratorNumber()

    local gen = square:getGenerator()
    gen:setSurroundingElectricity()
    gen:getCell():addToProcessIsoObjectRemove(gen)

    self:updateGenerator()

    self:updateConGenerator()

end

--todo remove this, fix prev errors
function SPowerbank:fixGeneratorNumber()
    local square = self:getSquare()
    local bank,hasGen
    local special = square:getSpecialObjects()
    local i = 0
    while i < special:size() do
        local obj = special:get(i)
        if not bank then
            if obj:getSprite() and obj:getSprite():getName() == "solarmod_tileset_01_0" then bank = true;
            elseif instanceof(obj, "IsoGenerator") then obj:remove(); i=i-1;
            end
        else
            if instanceof(obj, "IsoGenerator") then
                if hasGen then
                    obj:remove()
                    i=i-1
                else
                    hasGen = true
                end
            end
        end
        i = i +1
    end
    if self.conGenerator then
        local conGenerator,square = self:getConGenerator()
        if not conGenerator or ISAScan.findTypeOnSquare(square,"Powerbank") then
            self:autoConnectToGenerator()
        end
    end
    if not hasGen then self:createGenerator() end
end

function SPowerbank:connectGenerator(generator,x,y,z)
    self.conGenerator = {}
    self.conGenerator.x = x
    self.conGenerator.y = y
    self.conGenerator.z = z
    self.conGenerator.ison = generator:isActivated()
    self.lastHour = 0

    local data = generator:getModData()
    data["ISA_conGenerator"] = { x = self.x, y = self.y, z = self.z }
    generator:transmitModData()
end

function SPowerbank:autoConnectToGenerator()
    local radius = 3
    local x = self.x
    local y = self.y

    for ix = x - radius, x + radius do
        for iy = y - radius, y + radius do
            local distance = IsoUtils.DistanceToSquared(x,y,ix,iy)
            if distance <= 10 then
                local isquare = getSquare(ix, iy, self.z)
                local generator = isquare and isquare:getGenerator()
                if generator and generator:isConnected() and not ISAScan.findOnSquare(isquare,"solarmod_tileset_01_0") then
                    self:connectGenerator(generator,ix,iy,self.z)
                    return
                end
            end
        end
    end
    self.conGenerator = nil
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

            if self.on and ISAScan.findOnSquare(square, "solarmod_tileset_01_15") then
                local minfailsafe = self.drain
                if conGenerator:isActivated() then
                    if self.charge > minfailsafe then conGenerator:setActivated(false)end
                else
                    if self.charge < minfailsafe and conGenerator:getFuel() > 0 and conGenerator:getCondition() > 20 then conGenerator:setActivated(true) end
                end
                --else
                --    if conGenerator:isActivated() then
                --        if self.charge == self.maxcapacity then conGenerator:setActivated(false);self.conGenerator.ison = false end --no electricity
                --    else
                --        if self.charge < self.maxcapacity and conGenerator:getFuel() > 0 and conGenerator:getCondition() > 20 then conGenerator:setActivated(true);self.conGenerator.ison = true end
                --    end
            end
            self.lastHour = math.floor(getGameTime():getWorldAgeHours())
            self.conGenerator.ison = conGenerator:isActivated()
        else
            self.conGenerator = nil
        end
    end
end
