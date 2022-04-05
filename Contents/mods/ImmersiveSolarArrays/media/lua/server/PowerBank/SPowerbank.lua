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
    self.drain = 0 --calc
    self.overlay = nil
    self.lastHour = math.floor(getGameTime():getWorldAgeHours())
end

--function SPowerbank:new(luaSystem, globalObject)
--    local o = SGlobalObject.new(self, luaSystem, globalObject)
--    return o
--end

function SPowerbank:aboutToRemoveFromSystem()
    self:removeGenerator()
end

--when you load isoobject without luaobject
function SPowerbank:stateFromIsoObject(isoObject)
    self:initNew()

    if SPowerbankSystem.isValidModData(isoObject:getModData()) then
        self:fromModData(isoObject:getModData())
    elseif ModData.exists("PBK") then
        self:fromPBK(isoObject)
    end

    isoObject:setOverlaySprite(self.overlay)
    self:autoConnectToGenerator()
    self:createGenerator()

    isoObject:transmitModData()
end

function SPowerbank:stateToIsoObject(isoObject)
    self:loadGenerator()
    self:toModData(isoObject:getModData())
    isoObject:transmitModData()
end

function SPowerbank:fromModData(modData)
    self.on = modData["on"]
    self.batteries = modData["batteries"]
    self.charge = modData["charge"]
    self.maxcapacity = modData["maxcapacity"]
    self.drain = modData["drain"]
    self.npanels = modData["npanels"]
    self.panels = modData["panels"]
    self.overlay = modData["overlay"]
    self.lastHour = modData["lastHour"]
end

function SPowerbank:toModData(modData)
    modData["on"] = self.on
    modData["batteries"] = self.batteries
    modData["charge"] = self.charge
    modData["maxcapacity"] = self.maxcapacity
    modData["panels"] = self.panels
    modData["npanels"] = self.npanels
    modData["drain"] = self.drain
    modData["overlay"] = self.overlay
    modData["lastHour"] = self.lastHour
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
    self.charge = isaData.charge[key]
    self:handleBatteries(isoObject:getContainer())
end

--function SPowerbank:changeSprite(isoObject,sprite)
--    if sprite ~= self.overlay then
--        self.overlay = sprite
--        isoObject:setOverlaySprite(self.overlay)
--        --isoObject:getSquare():getGenerator():setSprite(self.overlay)
--        isoObject:sendObjectChange('sprite')
--        isoObject:transmitModData()
--    end
--end

function SPowerbank.getDrainVanilla(square)
    local gen = square:getGenerator()
    if gen:isActivated() then
        gen:setSurroundingElectricity()
        return gen:getTotalPowerUsing() * 800
    else
        --return SPowerbank.getTotalWhenoff(gen) * 800
        return self.drain
    end
end

--function SPowerbank.getTotalWhenoff(generator)
--    generator:setActivated(true)
--    local tpu = generator:getTotalPowerUsing()
--    generator:setActivated(false)
--    if generator:getSquare():getBuilding() ~= nil then generator:getSquare():getBuilding():setToxic(false) end
--    generator:getCell():addToProcessIsoObjectRemove(generator)
--    return tpu
--end

function SPowerbank:updateDrain()
    local square = self:getSquare()
    if SandboxVars.ISA.DrainCalc == 1 then
        self.drain = solarscan(square, false, true, false, 0)
    else
        self.drain = SPowerbank.getDrainVanilla(square)
    end
end

function SPowerbank:chargeBatteries(container,charge)
    for i=1,container:getItems():size() do
        local item = container:getItems():get(i-1)
        local type = item:getType()
        if type == "50AhBattery" and item:getCondition() > 0 then
            item:setUsedDelta(charge)
        elseif type == "75AhBattery" and item:getCondition() > 0 then
            item:setUsedDelta(charge)
        elseif type == "100AhBattery" and item:getCondition() > 0 then
            item:setUsedDelta(charge)
        elseif type == "DeepCycleBattery" and item:getCondition() > 0 then
            item:setUsedDelta(charge)
        elseif type == "SuperBattery" and item:getCondition() > 0 then
            item:setUsedDelta(charge)
        elseif type == "DIYBattery" and item:getCondition() > 0 then
            item:setUsedDelta(charge)
        end
    end
end

function SPowerbank:degradeBatteries(container)
    local ISABatteryDegradeChance = SandboxVars.ISA.batteryDegradeChance
    if SandboxVars.ISA.batteryDegradeChance == nil then
        ISABatteryDegradeChance = 100
    end
    for i=1,container:getItems():size() do
        if ZombRand(100) < ISABatteryDegradeChance then
            local item = container:getItems():get(i-1)
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
        local condition = 1 - (cond*cond*cond*cond*cond*cond)
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
    self.capacity = capacity
    self.batteries = batteries
    return capacity , batteries
end

function SPowerbank:getSprite(updatedCH)
    if self.batteries == 0 then return nil end
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

function SPowerbank:autoConnectToGenerator()
    local radius = 3
    local x = self.x
    local y = self.y

    for ix = x - radius, x + radius do
        for iy = y - radius, y + radius do
            if IsoUtils.DistanceToSquared(x,y,ix,iy) <= 10 then
                local isquare = getSquare(ix, iy, self.z)
                if isquare and isquare:getGenerator() and isquare:getGenerator():isConnected() then
                    self.conGenerator = {}
                    self.conGenerator.x = ix
                    self.conGenerator.y = iy
                    self.conGenerator.z = self.z
                    self.conGenerator.ison = isquare:getGenerator():isActivated()
                    return
                end
            end
        end
    end
end

function SPowerbank:createGenerator()
    local square = self:getSquare()
    local invgenerator = InventoryItemFactory.CreateItem("Base.Generator")
    local generator = IsoGenerator.new(invgenerator, square:getCell(), square)
    generator:setConnected(true)
    generator:setFuel(100)
    generator:setCondition(100)
    generator:setSprite(self.overlay)
    --return generator
end

function SPowerbank:removeGenerator()
    local square = self:getSquare()
    local gen = square:getGenerator()
    gen:setActivated(false)
    gen:remove()
    if square:getBuilding() ~= nil then square:getBuilding():setToxic(false) end
end

function SPowerbank:updateGenerator()
    --print("isatest update generator")
    local activate = self.on and self.charge > 0
    local square = self:getSquare()
    local generator = square:getGenerator()
    generator:setActivated(activate)
    if square:getBuilding() ~= nil then square:getBuilding():setToxic(false) end
    generator:getCell():addToProcessIsoObjectRemove(generator)
end

--local dtick
--function SPowerbank.delayedUpdate()
--    dtick = (dtick or 0) + 1
--    if dtick > 30 then
--        dtick = nil
--        Events.OnTick.Remove(SPowerbank.delayedUpdate)
--        self.updateGenerator()
--        self.updateConGenerator()
--    end
--end

--todo check freezer timers, fuel, condition,
function SPowerbank:loadGenerator()
    --print("isatest loadgenerator")
    self:getSquare():getGenerator():setSurroundingElectricity()

    self:updateGenerator()
    --is it loaded
    self:updateConGenerator()

    --gen:setSurroundingElectricity()
    --generator:getCell():addToProcessIsoObjectRemove(generator)
    --Events.OnTick.Add(SPowerbank.delayedUpdate,self)
end

function SPowerbank:getConGenerator()
    if not self.conGenerator then return end
    local square = getSquare(self.conGenerator.x,self.conGenerator.y,self.conGenerator.z)
    return square and square:getGenerator()
end

--todo check if generator is updated before or after
function SPowerbank:updateConGenerator()
    if self.lastHour == math.floor(getGameTime():getWorldAgeHours()) then return end
    local conGenerator = self:getConGenerator()
    if conGenerator and ISMoveableSpriteProps:findOnSquare(conGenerator:getSquare(), "solarmod_tileset_01_15") then
        --print("isatest updateConGenerator")

        --conGenerator:update()
        --conGenerator:getCell():addToProcessIsoObjectRemove(generator)

        local minfailsafe = self.drain
        if self.on then
            if conGenerator:isActivated() then
                if self.charge > minfailsafe then conGenerator:setActivated(false);self.conGenerator.ison = false end
            else
                if self.charge < minfailsafe and conGenerator:getFuel() > 0 and conGenerator:getCondition() > 20 then conGenerator:setActivated(true);self.conGenerator.ison = true end
            end
        else
            if conGenerator:isActivated() then
                if self.charge == 1 then conGenerator:setActivated(false);self.conGenerator.ison = false end
            else
                if self.charge < 1 and conGenerator:getFuel() > 0 and conGenerator:getCondition() > 20 then conGenerator:setActivated(true);self.conGenerator.ison = true end
            end
        end
        self.lastHour = math.floor(getGameTime():getWorldAgeHours())
    end
end
