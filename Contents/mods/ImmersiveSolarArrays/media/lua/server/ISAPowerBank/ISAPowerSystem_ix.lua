require "TimedActions/ISActivateGenerator"
require "TimedActions/ISPlugGenerator"
require "TimedActions/ISInventoryTransferAction"
require "ISAPowerBank/ISAPowerSystem"
--etc

local isaData = {}
isaData.key = {}
local cheatData = {}
local ISA = {}

local ISADIYBatteryCapacity = SandboxVars.ISA.DIYBatteryCapacity
if SandboxVars.ISA.DIYBatteryCapacity == nil then
    ISADIYBatteryCapacity = 200
end
local resetcharge = nil


function resetAllisaData()
    ModData.remove("PBK") --powerBankKey
    ModData.remove("PBX") --powerBankX
    ModData.remove("PBY") --powerBankY
    ModData.remove("PBZ") --powerBankZ
    ModData.remove("PBNP") --NumberOfPanels
    ModData.remove("PBLD") --PowerBankLoaded
    ModData.remove("PBCH") --PowerBankCharge
    ModData.remove("PBBO") --PowerBankOn
    ModData.remove("PBGN") --PowerBankGen
    ModData.remove("PBLiteDrain") --PowerBankLiteDrain
    ModData.remove("PBLiteMode") --PowerBankLiteMode
    ModData.remove("ISACheatFuel")
    init_isaData()
	resetcharge = 0.5
end

function init_isaData()
	--resetAllisaData()
    CheckGlobalData()
    isaData.key = ModData.get("PBK") --powerBankKey
    isaData.x = ModData.get("PBX") --powerBankX
    isaData.y = ModData.get("PBY") --powerBankY
    isaData.z = ModData.get("PBZ") --powerBankZ
    isaData.npanels = ModData.get("PBNP") --NumberOfPanels
    isaData.load = ModData.get("PBLD") --PowerBankLoaded
    isaData.charge = ModData.get("PBCH") --PowerBankCharge
    isaData.on = ModData.get("PBBO") --PowerBankOn
    isaData.gen = ModData.get("PBGN") --PowerBankGen
    isaData.litedrain = ModData.get("PBLiteDrain") --PowerBankLiteDrain
    isaData.litemode = ModData.get("PBLiteMode") --PowerBankLiteMode
    cheatData = ModData.getOrCreate("ISACheatFuel")


    for key=1, #isaData.key do
        if cheatData[key] == nil then cheatData[key] = {} end
        if cheatData[key].acu == nil then cheatData[key].acu = 0 end
        if cheatData[key].lasthour == nil then cheatData[key].lasthour = math.floor(getGameTime():getWorldAgeHours()) end
        if cheatData[key].poweron == nil then cheatData[key].poweron = false end
        --if cheatData[key].gen == nil then cheatData[key].gen = {} end
        if cheatData[key].batteries == nil then cheatData[key].batteries = 0 end
        if cheatData[key].maxcapacity == nil then cheatData[key].maxcapacity = 0 end
    end
end

function findGenerator(key,distance)
    distance = distance or 1
    local x = isaData.x[key]
    local y = isaData.y[key]

    for ix = x - distance, x + distance do
        for iy = y - distance, y + distance do
            local isquare = getSquare(ix, iy, isaData.z[key])
            if isquare then
                local igen = isquare:getGenerator()
                if igen and igen:isConnected() then

                    cheatData[key].gen = {}
                    cheatData[key].gen.x = igen:getX()
                    cheatData[key].gen.y = igen:getY()
                    cheatData[key].gen.z = igen:getZ()
                    cheatData[key].gen.ison = igen:isActivated()

					return igen
                end
            end
        end
    end
    return false
end

local function findKeyFromGen(gen)
    for key=1,#isaData.key do
        if cheatData[key].gen then
            if gen:getX() == cheatData[key].gen.x and gen:getY() == cheatData[key].gen.y and gen:getZ() == cheatData[key].gen.z then
                return key
            end
        end
    end
    return false
end

local function findKeyFromSquare(square)
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    for key=1,#isaData.key do
        if x == isaData.x[key] and y == isaData.y[key] and z == isaData.z[key] then
            return key
        end
    end
    return false
end

function connectGenerator(generator,distance)
    local x = generator:getX()
    local y = generator:getY()
    distance = distance or 10
    for key=1,#isaData.key do
        if IsoUtils.DistanceToSquared(x,y,isaData.x[key],isaData.y[key]) <= distance then
            cheatData[key].gen = {}
            cheatData[key].gen.x = generator:getX()
            cheatData[key].gen.y = generator:getY()
            cheatData[key].gen.z = generator:getZ()
            cheatData[key].gen.ison = generator:isActivated()
            return
        end
    end
end

function disconnectGenerator(generator)
    local key = findKeyFromGen(generator)
    if key then
        cheatData[key].gen = nil
    end
end

function accumulator ()
    for key=1, #isaData.key do
        cheatData[key].acu = cheatData[key].acu + getModifiedSolarOutput(tonumber(isaData.npanels[key])) / 6
    end
end

function updateBanks()
    for key=1, #isaData.key do
        local square = getSquare(tonumber(isaData.x[key]),tonumber(isaData.y[key]),tonumber(isaData.z[key]))
        if square then
            -- getGameTime():update(true)
            local newhour = math.floor(getGameTime():getWorldAgeHours())
			if newhour < cheatData[key].lasthour and getGameTime():getHour() == 7 then newhour = newhour + 24 end --recheck later
            local hourspassed = newhour - cheatData[key].lasthour

            print("Isa Time hours log",hourspassed," /ns ",getGameTime():getNightsSurvived()," /td ",getGameTime():getTimeOfDay())

            local powerbank = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
            if hourspassed >= 1 then
				local drain = isaData.litedrain[key] --can it be nil?
				if isaData.litemode[1] == 0 then drain = solarscan(square, false, true, false, 0) end
				local minfailsafe = drain

				local generator = false
				if cheatData[key].gen then
					generator = getSquare(cheatData[key].gen.x,cheatData[key].gen.y,cheatData[key].gen.z) and getSquare(cheatData[key].gen.x,cheatData[key].gen.y,cheatData[key].gen.z):getGenerator()
					if generator and generator:isActivated() then
						drain = 0

						----cheatfuel testing

						--local gendata = generator:getModData()
						--local fuel = generator:getFuel()

						generator:update()

						--local fuel2 = generator:getFuel()
						--if gendata.genfuel ~= nil then
						--	print("ISA generator sync testing: h: ",hourspassed," TPU: ",generator:getTotalPowerUsing())
						--	print("ISA generator fuel test1: ",fuel-gendata.genfuel)
						--	print("ISA generator fuel test2: ",fuel2 - fuel)
						--end
						--gendata.genfuel = fuel2

					elseif cheatData[key].gen.ison then
						drain = 0
					end
				end

				local inventory = powerbank:getContainer()
				local charge = isaData.charge[key]
				local capacity = cheatData[key].maxcapacity
				local actualCharge = capacity * charge + cheatData[key].acu - drain * hourspassed
				local newcharge = capacity > 0 and actualCharge  / capacity or 0
				if newcharge > 1 then newcharge = 1 end
				if newcharge < 0 then newcharge = 0 end
                local sprite = ISA.getOverlay(cheatData[key].batteries,newcharge)

                print("ISA charge log: ",math.floor(newcharge*100)/100," / ",math.floor((newcharge-isaData.charge[key])*100)/100,actualCharge,drain)

                cheatData[key].acu = 0
				isaData.charge[key] = newcharge
				cheatData[key].lasthour = newhour
				
				
				chargeBatteries(inventory,newcharge)

                local switch = actualCharge > minfailsafe
                ISAPowerSwitch(key,square,switch)

                local pbgen = square:getGenerator()
                if not pbgen then pbgen = ISA.createPBGenerator(square,sprite) end
                ISA.PBGeneratorSwitch(pbgen,switch,key)

                if generator and ISMoveableSpriteProps:findOnSquare(generator:getSquare(), "solarmod_tileset_01_15") then
                    if generator:isActivated() then
                        if actualCharge > minfailsafe then generator:setActivated(false);cheatData[key].gen.ison = false end
                    else
                        if actualCharge < minfailsafe and generator:getFuel() > 0 and generator:getCondition() > 20 then generator:setActivated(true);cheatData[key].gen.ison = true end
                    end
                end
                powerbank:setOverlaySprite(sprite)
                pbgen:setSprite(sprite)

				return
			else
				--ISAPowerSwitch(key,square,cheatData[key].poweron)
				-- ISAsetOverlay(powerbank,cheatData[key].batteries,isaData.charge[key])
			end
        end
    end
end

function ISAPowerSwitch(key,square,b)
     local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
     NewGenerator:setConnected(b)
     NewGenerator:setFuel(100)
     NewGenerator:setCondition(100)
     NewGenerator:setActivated(b)
     NewGenerator:setSurroundingElectricity()
     NewGenerator:remove()

     if square:getBuilding() ~= nil then
         square:getBuilding():setToxic(false)
     end
     if key then
         cheatData[key].poweron = b
     end
end

function ISA.PBGeneratorSwitch(generator,switch,key)
    generator:setActivated(switch)
    generator:getCell():addToProcessIsoObjectRemove(generator)
    local square = generator:getSquare()
    if square:getBuilding() ~= nil then square:getBuilding():setToxic(false) end
    if key then
        cheatData[key].poweron = switch
    end
end
 
function ISA.createPBGenerator(square,sprite)
    local NewGenerator = IsoGenerator.new(nil, square:getCell(), square)
    NewGenerator:setConnected(true)
    NewGenerator:setFuel(100)
    NewGenerator:setCondition(100)

    NewGenerator:setSprite(sprite)

    if square:getBuilding() ~= nil then
        square:getBuilding():setToxic(false)
    end
    return NewGenerator
end

function ISAsetOverlay(batterybank,batterynumber,updatedCH)
	--update battery inventory sprites
    if updatedCH < 0.25 then
        --batterybank:setOverlaySprite(nil)
        --show 0 charge
        if batterynumber == 0 then
            batterybank:setOverlaySprite(nil)
        elseif batterynumber > 0 and batterynumber < 5 then
            --show bottom shelf
            batterybank:setOverlaySprite("solarmod_tileset_01_1")
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_2")
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_3")
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_4")
        elseif batterynumber >= 17 then
            --show five shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_5")
        end
    elseif updatedCH >= 0.25 and updatedCH < 0.50 then
        --
        --show 25 charge
        if batterynumber == 0 then
            batterybank:setOverlaySprite(nil)
        elseif batterynumber > 0 and batterynumber < 5 then
            --show bottom shelf
            batterybank:setOverlaySprite("solarmod_tileset_01_16")
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_20")
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_24")
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_28")
        elseif batterynumber >= 17 then
            --show five shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_32")
        end
    elseif updatedCH >= 0.50 and updatedCH < 0.75 then
        --batterybank:setOverlaySprite("solarmod_tileset_01_12")
        -- show 50 charge
        if batterynumber == 0 then
            batterybank:setOverlaySprite(nil)
        elseif batterynumber > 0 and batterynumber < 5 then
            --show bottom shelf
            batterybank:setOverlaySprite("solarmod_tileset_01_17")
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_21")
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_25")
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_29")
        elseif batterynumber >= 17 then
            --show five shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_33")
        end
    elseif updatedCH >= 0.75 and updatedCH < 0.95 then
        --batterybank:setOverlaySprite("solarmod_tileset_01_13")
        -- show 75 charge
        if batterynumber == 0 then
            batterybank:setOverlaySprite(nil)
        elseif batterynumber > 0 and batterynumber < 5 then
            --show bottom shelf
            batterybank:setOverlaySprite("solarmod_tileset_01_18")
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_22")
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_26")
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_30")
        elseif batterynumber >= 17 then
            --show five shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_34")
        end
    elseif updatedCH >= 0.95 then
        --show 100 charge
        if batterynumber == 0 then
            batterybank:setOverlaySprite(nil)
        elseif batterynumber > 0 and batterynumber < 5 then
            --show bottom shelf
            batterybank:setOverlaySprite("solarmod_tileset_01_19")
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_23")
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_27")
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_31")
        elseif batterynumber >= 17 then
            --show five shelves
            batterybank:setOverlaySprite("solarmod_tileset_01_35")
        end
    end
end

function ISA.updateSprites(powerbank)
    local square = powerbank:getSquare()
    local key = findKeyFromSquare(square)
    if key then
        local sprite = ISA.getOverlay(cheatData[key].batteries,isaData.charge[key])
        powerbank:setOverlaySprite(sprite)
        if square:getGenerator() then
            square:getGenerator():setSprite(sprite)
        end
    end
end

function ISA.getOverlay(batterynumber,updatedCH)
    --update battery inventory sprites
    if batterynumber == 0 then return nil end
    if updatedCH < 0.25 then
        --show 0 charge
        if batterynumber < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_1"
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            return "solarmod_tileset_01_2"
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            return "solarmod_tileset_01_3"
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            return "solarmod_tileset_01_4"
        elseif batterynumber >= 17 then
            --show five shelves
            return "solarmod_tileset_01_5"
        end
    elseif updatedCH >= 0.25 and updatedCH < 0.50 then
        --show 25 charge
        if batterynumber < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_16"
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            return "solarmod_tileset_01_20"
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            return "solarmod_tileset_01_24"
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            return "solarmod_tileset_01_28"
        elseif batterynumber >= 17 then
            --show five shelves
            return "solarmod_tileset_01_32"
        end
    elseif updatedCH >= 0.50 and updatedCH < 0.75 then
        -- show 50 charge
        if batterynumber < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_17"
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            return "solarmod_tileset_01_21"
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            return "solarmod_tileset_01_25"
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            return "solarmod_tileset_01_29"
        elseif batterynumber >= 17 then
            --show five shelves
            return "solarmod_tileset_01_33"
        end
    elseif updatedCH >= 0.75 and updatedCH < 0.95 then
        -- show 75 charge
        if batterynumber < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_18"
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            return "solarmod_tileset_01_22"
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            return "solarmod_tileset_01_26"
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            return "solarmod_tileset_01_30"
        elseif batterynumber >= 17 then
            --show five shelves
            return "solarmod_tileset_01_34"
        end
    elseif updatedCH >= 0.95 then
        --show 100 charge
        if batterynumber < 5 then
            --show bottom shelf
            return "solarmod_tileset_01_19"
        elseif batterynumber >= 5 and batterynumber < 9 then
            --show two shelves
            return "solarmod_tileset_01_23"
        elseif batterynumber >= 9 and batterynumber < 13 then
            --show three shelves
            return "solarmod_tileset_01_27"
        elseif batterynumber >= 13 and batterynumber < 17 then
            --show four shelves
            return "solarmod_tileset_01_31"
        elseif batterynumber >= 17 then
            --show five shelves
            return "solarmod_tileset_01_35"
        end
    end
end

local ISActivateGeneratorperform = ISActivateGenerator.perform
function ISActivateGenerator:perform(...)
    local key = findKeyFromGen(self.generator)
    if key then
        if self.activate then
            cheatData[key].gen.ison = true
        else
            cheatData[key].gen.ison = false
        end
    end

    return ISActivateGeneratorperform(self,...)
end

local ISActivateGeneratornew = ISActivateGenerator.new
function ISActivateGenerator:new(character, generator, activate,...)
    self.ignoreAction = nil
    local powerbank = ISMoveableSpriteProps:findOnSquare(generator:getSquare(), "solarmod_tileset_01_0")
    if powerbank then
        local key = findKeyFromSquare(generator:getSquare())
        if key then
            local switch = isaData.charge[key] * cheatData[key].maxcapacity > isaData.litedrain[key]
            if activate and switch then
                ISA.PBGeneratorSwitch(generator,true,key)
            else
                ISA.PBGeneratorSwitch(generator,false,key)
            end
            if activate and not switch then
                OpenBatterBankInfo(generator:getSquare())
            end
        end
        self.ignoreAction = true
    end
    return ISActivateGeneratornew(self, character, generator, activate,...)
end

local ISPlugGeneratorperform = ISPlugGenerator.perform
function ISPlugGenerator:perform(...)
    if self.plug then
        connectGenerator(self.generator)
    else
        disconnectGenerator(self.generator)
    end
    return ISPlugGeneratorperform(self,...)
end

--local ISPlugGeneratorisValid = ISPlugGenerator.isValid
--function ISPlugGenerator:isValid(...)
--    local powerbank = ISMoveableSpriteProps:findOnSquare(self.generator:getSquare(), "solarmod_tileset_01_0")
--    if powerbank then
--        self.character:Say("I shouldn't do that")
--        return false
--    end
--    return ISPlugGeneratorisValid(self,...)
--end

local ISPlugGeneratornew = ISPlugGenerator.new
function ISPlugGenerator:new(character, generator, ...)
    self.ignoreAction = nil
    local powerbank = ISMoveableSpriteProps:findOnSquare(generator:getSquare(), "solarmod_tileset_01_0")
    if powerbank then
        getSpecificPlayer(character):Say("I shouldn't do that")
        self.ignoreAction = true
    end
    return ISPlugGeneratornew(self, character, generator, ...)
end

local ISInventoryTransferActiontransferItem = ISInventoryTransferAction.transferItem
function ISInventoryTransferAction:transferItem(item,...)
    local original = ISInventoryTransferActiontransferItem(self,item,...)

    local take = self.srcContainer:getParent() and self.srcContainer:getParent():getSprite() and  self.srcContainer:getParent():getSprite():getName() == "solarmod_tileset_01_0"
    local put = self.destContainer:getParent() and self.destContainer:getParent():getSprite() and  self.destContainer:getParent():getSprite():getName() == "solarmod_tileset_01_0"

    if not (take or put) then return original end

    local type = item:getType()
    local isBattery = false
    if type == "50AhBattery" then isBattery = true end
    if type == "75AhBattery" then isBattery = true end
    if type == "100AhBattery" then isBattery = true end
    if type == "DeepCycleBattery" then isBattery = true end
    if type == "SuperBattery" then isBattery = true end
    if type == "DIYBattery" then isBattery = true end
    if not isBattery or item:getCondition() == 0 then
        if take then ISA.updateSprites(self.srcContainer:getParent()) end
        if put then ISA.updateSprites(self.destContainer:getParent()) end
        if put then self.character:Say("This seems like a good place to store my "..type) end
        return original
    end

    local batterypower = item:getUsedDelta()
    local capacity = 0
    local cond = 1 - (item:getCondition()/100)
    local condition = 1 - (cond*cond*cond*cond*cond*cond)
    if type == "50AhBattery" and item:getCondition() > 0 then
        capacity = 50 * condition
    end
    if type == "75AhBattery" and item:getCondition() > 0 then
        capacity = 75 * condition
    end
    if type == "100AhBattery" and item:getCondition() > 0 then
        capacity = 100 * condition
    end
    if type == "DeepCycleBattery" and item:getCondition() > 0 then
        capacity = 200 * condition
    end
    if type == "SuperBattery" and item:getCondition() > 0 then
        capacity = 400 * condition
    end
    if type == "DIYBattery" and item:getCondition() > 0 then
        capacity = ISADIYBatteryCapacity * condition
    end

    if take then
        local powerbank = self.srcContainer:getParent()
        local key = findKeyFromSquare(powerbank:getSquare())
        if key then
            local charge = isaData.charge[key]
            local totalcharge = cheatData[key].maxcapacity * charge - batterypower * capacity
            local totalcapacity = cheatData[key].maxcapacity - capacity
            local newcharge = totalcapacity > 0 and totalcharge / totalcapacity or 0
            if newcharge > 1 then newcharge = 1 end
            if newcharge < 0 then newcharge = 0 end
            cheatData[key].maxcapacity = totalcapacity
            cheatData[key].batteries = cheatData[key].batteries - 1
            isaData.charge[key] = newcharge
            ISA.updateSprites(powerbank)
        end
    end

    if put then
        local powerbank = self.destContainer:getParent()
        local key = findKeyFromSquare(powerbank:getSquare())
        if key then
            local charge = isaData.charge[key]
            local totalcharge = cheatData[key].maxcapacity * charge + batterypower * capacity
            local totalcapacity = cheatData[key].maxcapacity + capacity
            local newcharge = totalcapacity > 0 and totalcharge / totalcapacity or 0
            if newcharge > 1 then newcharge = 1 end
            if newcharge < 0 then newcharge = 0 end
            cheatData[key].maxcapacity = totalcapacity
            cheatData[key].batteries = cheatData[key].batteries + 1
            isaData.charge[key] = newcharge
            ISA.updateSprites(powerbank)
        end
    end

    if take and put then HaloTextHelper.addText(self.character,"BZZZ") end

    --item:setUsedDelta(updatedCH)

    return original
end

local isaTurnOnPower = TurnOnPower
function TurnOnPower(powerConsumption, numberOfPanels, square, createKey)
    local original = isaTurnOnPower(powerConsumption, numberOfPanels, square, createKey)
    if createKey then
        local key = #isaData.key
        local charge = resetcharge or 0
        local powerbank = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
        local container = powerbank:getContainer()
        local cap,bat = HandleBatteriesEdit(container, charge)
        local sprite = ISA.getOverlay(bat,charge)
        isaData.charge[key] = charge
        cheatData[key] = {}
        cheatData[key].acu = 0
        cheatData[key].lasthour = math.floor(getGameTime():getWorldAgeHours())
		cheatData[key].poweron = false
        --cheatData[key].gen = {}
        cheatData[key].maxcapacity = cap
        cheatData[key].batteries = bat

        local pbdata = powerbank:getModData()
        pbdata.key = key
        pbdata.overlay = sprite

        findGenerator(key,1)

        local generator = ISA.createPBGenerator(square,sprite)
        if charge * cap > powerConsumption then
            ISAPowerSwitch(key,square,true)
            ISA.PBGeneratorSwitch(generator,true,key)
        end

        isaData.litedrain[key] = powerConsumption
        table.remove(isaData.on, key+1)
        resetcharge = nil
    end
    return original
end

local isaDisconnectPower = DisconnectPower
function DisconnectPower(square,key)
    ----need to pass object when picking up
    local pb = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
    local pbdata = pb and pb:getModData()
    if pbdata then
        key = pbdata.key
        pbdata = nil
    end
    if key == nil then key = findKeyFromSquare(square) end

    GenRemove(square)

    if key then
        ISAPowerSwitch(false,square,false)

        table.remove(cheatData,key)

        table.remove(isaData.gen, key)
        table.remove(isaData.litedrain ,key)
        return isaDisconnectPower(square)
    end
end

--reset even if no key, pass charge without moddata
function ResetBatteryBank(square)
    local pb = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0")
    local pbdata = pb:getModData()
    local key = pbdata.key
    if key == nil then key = findKeyFromSquare(square) end

    resetcharge = key and isaData.charge[key] or resetcharge or 0

    DisconnectPower(square,key)
    solarscan(square, false, true, true, 0)
end

--only charge
function chargeBatteries(container,charge)
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

--daily degrade and recalc
function batteryDegradeEdit()
    for key=1,#isaData.key do
        local square = getSquare(isaData.x[key], isaData.y[key], isaData.z[key])
        if square then
            local container = ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0"):getContainer()
            DegradeBatteries(container) -- x Days missed
            local cap,bat = HandleBatteriesEdit(container, isaData.charge[key])
            cheatData[key].maxcapacity = cap
            cheatData[key].batteries = bat
        end
    end
end

--for recalculating
function HandleBatteriesEdit(container, powerpercentage)
    --percentage from 0 to 1 to set battery charge
    local capacity = 0
    local batteries = 0
    for i=1,container:getItems():size() do
        local item = container:getItems():get(i-1)
        local cond = 1 - (item:getCondition()/100)
        local condition = 1 - (cond*cond*cond*cond*cond*cond)
        local type = item:getType()
        if type == "50AhBattery" and item:getCondition() > 0 then
            capacity = capacity + 50 * condition
            item:setUsedDelta(powerpercentage)
            batteries = batteries + 1
        end
        if type == "75AhBattery" and item:getCondition() > 0 then
            capacity = capacity + 75 * condition
            item:setUsedDelta(powerpercentage)
            batteries = batteries + 1

        end
        if type == "100AhBattery" and item:getCondition() > 0 then
            capacity = capacity + 100 * condition
            item:setUsedDelta(powerpercentage)
            batteries = batteries + 1

        end
        if type == "DeepCycleBattery" and item:getCondition() > 0 then
            capacity = capacity + 200 * condition
            item:setUsedDelta(powerpercentage)
            batteries = batteries + 1
        end
        if type == "SuperBattery" and item:getCondition() > 0 then
            capacity = capacity + 400 * condition
            item:setUsedDelta(powerpercentage)
            batteries = batteries + 1
        end
        if type == "DIYBattery" and item:getCondition() > 0 then
            capacity = capacity + ISADIYBatteryCapacity * condition
            item:setUsedDelta(powerpercentage)
            batteries = batteries + 1
        end

    end

    ISAsetOverlay(container:getParent(),batteries,powerpercentage)
    return capacity , batteries
end

--fix for typos,etc
function liteModeFunctionEdit(square)
    for key = 1, #isaData.key do
        local square = getSquare(isaData.x[key], isaData.y[key], isaData.z[key])
        if square then
            isaData.litedrain[key] = solarscan(square, false, true, false, 0)
        end
    end
end

local dubtick
local function delayedUpdateBanks()
    dubtick = (dubtick or 0) + 1
    if dubtick > 60 then
        dubtick = nil
        Events.OnTick.Remove(delayedUpdateBanks)
        return updateBanks()
    end
end

local function LoadGridsquare(square)
    --if ISMoveableSpriteProps:findOnSquare(square, "solarmod_tileset_01_0") then distribute() end

    for i = square:getSpecialObjects():size(),1,-1 do
        local obj = square:getSpecialObjects():get(i-1)
        if obj:getSprite() and obj:getSprite():getName() == "solarmod_tileset_01_0" then
            local gen = square:getGenerator()
            if gen then
                gen:setSurroundingElectricity()
                square:getCell():addToProcessIsoObjectRemove(gen)
            end
            Events.OnTick.Add(delayedUpdateBanks)
            return
        end
    end
end

Events.OnInitGlobalModData.Add(init_isaData)
Events.LoadGridsquare.Add(LoadGridsquare)
--Events.OnGameStart.Add()
Events.EveryTenMinutes.Add(accumulator)
Events.EveryHours.Add(updateBanks)
Events.EveryDays.Add(batteryDegradeEdit,liteModeFunctionEdit)

Events.OnSave.Remove(Test)
Events.EveryDays.Remove(batteryDegrade)
Events.EveryDays.Remove(liteModeFunction)
Events.EveryTenMinutes.Remove(chargeLogic)
Events.OnTick.Remove(PowerCheck)
Events.OnTick.Remove(GenCheck)
Events.OnGameStart.Remove(CheckGlobalData)
Events.OnGameStart.Remove(ReloadPower)

function TestGeneratorsExist()
    for key=1,#isaData.key do
        local square = getSquare(isaData.x[key], isaData.y[key], isaData.z[key])
        if square then
            local generator = square:getGenerator()
            if not generator then
                local sprite = ISA.getOverlay(cheatData[key].batteries,isaData.charge[key])
                generator = ISA.createPBGenerator(square,sprite)
                if isaData.charge[key] * cheatData[key].maxcapacity > isaData.litedrain[key] then
                    ISA.PBGeneratorSwitch(generator,true,key)
                end
            end
        end
    end
end
Events.OnGameStart.Add(TestGeneratorsExist)

