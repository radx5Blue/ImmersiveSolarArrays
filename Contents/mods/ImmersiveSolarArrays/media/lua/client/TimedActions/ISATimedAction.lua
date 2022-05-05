require "TimedActions/ISActivateGenerator"
require "TimedActions/ISPlugGenerator"
require "TimedActions/ISInventoryTransferAction"

local ISActivateGeneratorperform = ISActivateGenerator.perform
function ISActivateGenerator:perform(...)
    CPowerbankSystem.onActivateGenerator(self.character,self.generator,self.activate)
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

local ISMoveablesActionperform = ISMoveablesAction.perform
function ISMoveablesAction:perform(...)
    local type = ISAScan.Types[self.origSpriteName]
    if self.mode == "pickup" then
        local isoObject = ISAScan.findOnSquare(self.square,self.origSpriteName)
        if type == "Powerbank" then
            isoObject:getModData().charge = nil
        elseif type == "Panel" then
            local modData = isoObject:getModData()
            modData.connectDelta = nil
        end
    end

    local o = ISMoveablesActionperform(self,...)

    --if self.origSpriteName == "solarmod_tileset_01_0" then
    --    --CPowerbankSystem.instance.onMoveableAction(self)
    --    if self.mode == "pickup" then
    --        CPowerbankSystem.instance:removeGenerator(self.square)
    --    elseif self.mode == "place" then
    --        CPowerbankSystem.instance:createGenerator(self.square)
    --    end
    --end
    return o
end
