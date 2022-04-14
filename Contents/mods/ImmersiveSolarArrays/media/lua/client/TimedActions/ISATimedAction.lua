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

    CPowerbankSystem.instance.onInventoryTransfer(self.srcContainer:getParent(), self.destContainer:getParent(), item, self.character)

    return original
end
