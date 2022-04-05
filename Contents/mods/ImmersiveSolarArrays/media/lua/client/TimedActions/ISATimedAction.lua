require "TimedActions/ISActivateGenerator"
require "TimedActions/ISPlugGenerator"
require "TimedActions/ISInventoryTransferAction"

local ISActivateGeneratorperform = ISActivateGenerator.perform
function ISActivateGenerator:perform(...)
    local pbdata = self.generator:getModData()["ISA_conGenerator"]
    if pbdata then
        if CPowerbankSystem.instance:getLuaObjectAt(pbdata.x,pbdata.y,pbdata.z) then
            local gen = { x = self.generator:getX(), y = self.generator:getY(), z = self.generator:getZ() }
            CPowerbankSystem.instance:sendCommand(self.character,"activateGenerator", { pb = pbdata, gen = gen , activate = self.activate })
        else
            pbdata = nil
            self.generator:transmitModData()
        end
    end

    return ISActivateGeneratorperform(self,...)
end

local ISPlugGeneratorperform = ISPlugGenerator.perform
function ISPlugGenerator:perform(...)
    CPowerbankSystem.instance.onPlugGenerator(self.character,self.generator,self.plug)
    return ISPlugGeneratorperform(self,...)
end

local ISInventoryTransferActiontransferItem = ISInventoryTransferAction.transferItem
function ISInventoryTransferAction:transferItem(item,...)
    local original = ISInventoryTransferActiontransferItem(self,item,...)

    local take = self.srcContainer:getParent() and self.srcContainer:getParent():getSprite() and  self.srcContainer:getParent():getSprite():getName() == "solarmod_tileset_01_0"
    local put = self.destContainer:getParent() and self.destContainer:getParent():getSprite() and  self.destContainer:getParent():getSprite():getName() == "solarmod_tileset_01_0"

    if not (take or put) then return original end

    if take then CPowerbankSystem.instance.updateSprite(self.srcContainer:getParent()) end
    if put then CPowerbankSystem.instance.updateSprite(self.destContainer:getParent()) end

    local type = item:getType()
    local isBattery = false
    if type == "50AhBattery" then isBattery = true end
    if type == "75AhBattery" then isBattery = true end
    if type == "100AhBattery" then isBattery = true end
    if type == "DeepCycleBattery" then isBattery = true end
    if type == "SuperBattery" then isBattery = true end
    if type == "DIYBattery" then isBattery = true end
    if not isBattery or item:getCondition() == 0 then
        if put then self.character:Say(getText("IGUI_ISAContainerNotBattery")..item:getDisplayName()) end
        return original
    end

    local batterypower = item:getUsedDelta()
    local capacity = 0
    local cond = 1 - (item:getCondition()/100)
    local condition = 1 - math.pow(cond,6)
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
        local powerbank = CPowerbankSystem.instance:getLuaObjectOnSquare(self.srcContainer:getParent():getSquare())
        if powerbank then
            --powerbank:updateFromIsoObject()
            --powerbank.batteries = powerbank.batteries - 1
            --powerbank.maxcapacity = powerbank.maxcapacity - capacity
            --powerbank.charge = powerbank.charge - batterypower * capacity
            --powerbank:updateSprite()

            CPowerbankSystem.instance:sendCommand(self.character,"Battery", { { x = powerbank.x, y = powerbank.y, z = powerbank.z} ,"take", batterypower, capacity})
        end
    end

    if put then
        --local powerbank = CPowerbankSystem.instance:getLuaObjectOnSquare(self.destContainer:getParent():getSquare())
        --if powerbank then
            --powerbank:updateFromIsoObject()
            --powerbank.batteries = powerbank.batteries + 1
            --powerbank.maxcapacity = powerbank.maxcapacity + capacity
            --powerbank.charge = powerbank.charge + batterypower * capacity
            --powerbank:updateSprite()

            --CPowerbankSystem.instance:sendCommand(self.character,"Battery", { { x = powerbank.x, y = powerbank.y, z = powerbank.z} ,"put", batterypower, capacity})
        --end
        local powerbank = self.destContainer:getParent()
        CPowerbankSystem.instance:sendCommand(self.character,"Battery", { { x = powerbank:getX(), y = powerbank:getY(), z = powerbank:getZ()} ,"put", batterypower, capacity})
    end

    if take and put then HaloTextHelper.addText(self.character,"bzzz ... BZZZZZ ... bzzz") end

    --item:setUsedDelta(...)

    return original
end
