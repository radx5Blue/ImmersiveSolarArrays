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
    if type and self.mode == "pickup" then
        local isoObjectSpecial = ISAScan.findOnSquare(self.square,self.origSpriteName)
        if isoObjectSpecial then
            if type == "Powerbank" then
                isoObjectSpecial:getModData().charge = nil
            elseif type == "Panel" then
                isoObjectSpecial:getModData().connectDelta = nil
            end
        end
    end

    local o = ISMoveablesActionperform(self,...)

    return o
end
