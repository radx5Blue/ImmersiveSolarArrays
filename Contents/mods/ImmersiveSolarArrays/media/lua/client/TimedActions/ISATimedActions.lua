require "TimedActions/ISActivateGenerator"
require "TimedActions/ISPlugGenerator"
require "TimedActions/ISInventoryTransferAction"

local ISActivateGeneratorperform = ISActivateGenerator.perform
function ISActivateGenerator:perform(...)
    if self.powerbank then
        local key = ISA.findKeyFromSquare(self.generator:getSquare())
        if key then
            local powerup = ISA.canPowerUpPB(self.powerbank,key)
            --local pbswitch = self.activate
            if self.activate and powerup then
                local level = self.character:getPerkLevel(Perks.Electricity)
                if level < 3 and ZombRand(6-2*level) ~= 0 then
                    self.character:playSound("GeneratorFailedToStart")
                    powerup = false
                end
            elseif self.activate and not powerup then
                self.character:playSound("GeneratorFailedToStart")
                ISAStatusWindow.OnOpenPanel(self.generator:getSquare())
                --pbswitch = not cheatData[key].switch
                --local text = switch and getText("ContextMenu_Turn_On") or getText("ContextMenu_Turn_Off")
                --HaloTextHelper.addText(self.character,text)
            else
                if self.generator:isActivated() then
                    cheatData[key].switchchanged = true
                end
                powerup = false
            end
            ISA.PBGeneratorSwitch(self.generator,powerup,key)
            --cheatData[key].switch = pbswitch
            cheatData[key].switch = self.activate
        end
        ISBaseTimedAction.perform(self)
        return
    else
        local key = ISA.findKeyFromGen(self.generator)
        if key then
            if self.activate then
                cheatData[key].gen.ison = true
            else
                cheatData[key].gen.ison = false
            end
        end
    end

    return ISActivateGeneratorperform(self,...)
end

local ISActivateGeneratornew = ISActivateGenerator.new
function ISActivateGenerator:new(character, generator, activate,time,...)
    --self.ignoreAction = nil
    local o = ISActivateGeneratornew(self, character, generator, activate,time,...)
    local powerbank = ISMoveableSpriteProps:findOnSquare(generator:getSquare(), "solarmod_tileset_01_0")
    if powerbank then
        o.powerbank = powerbank
        local level = getSpecificPlayer(character):getPerkLevel(Perks.Electricity)
        o.maxTime = 40 - 3 * level

        --local key = ISA.findKeyFromSquare(generator:getSquare())
        --if key then
        --    o.key = key
        --    local switch = ISA.canPowerUpPB(powerbank,key)
        --    if activate and switch then
        --        ISA.PBGeneratorSwitch(generator,true,key)
        --    else
        --        ISA.PBGeneratorSwitch(generator,false,key)
        --    end
        --    if activate and not switch then
        --        ISAStatusWindow.OnOpenPanel(generator:getSquare())
        --        --OpenBatterBankInfo(generator:getSquare())
        --    end
        --end
        --print(self.ignoreAction,"activate")
        --self.ignoreAction = true
    end
    return o
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

--ISA.ActivatePowerbank = ISActivateGenerator:new()

--???

--ISA.onActivateGenerator = function(worldobjects, enable, generator, player)
--    local playerObj = getSpecificPlayer(player)
--    if luautils.walkAdj(playerObj, generator:getSquare()) then
--        ISTimedActionQueue.add(ISA.ActivatePowerbank:new(player, generator, enable, 30));
--    end
--end

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
        capacity = (SandboxVars.ISA.DIYBatteryCapacity or 200) * condition
    end

    if take then
        local powerbank = self.srcContainer:getParent()
        local key = ISA.findKeyFromSquare(powerbank:getSquare())
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
        local key = ISA.findKeyFromSquare(powerbank:getSquare())
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
