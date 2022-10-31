local function wrap(class,method,before,after)
    local original = class[method]
    class[method] = function(...)
        if before then before(...) end
        local result = original(...)
        if after then after(...) end
        --if after then result = after(result,...) end
        return result
    end
end

require "TimedActions/ISActivateGenerator"
--local ISActivateGeneratorperform = ISActivateGenerator.perform
--function ISActivateGenerator:perform(...)
--    CPowerbankSystem.onActivateGenerator(self.character,self.generator,self.activate)
--    return ISActivateGeneratorperform(self,...)
--end
wrap(ISActivateGenerator,"perform",nil,CPowerbankSystem.postActivateGenerator)

require "TimedActions/ISPlugGenerator"
--local ISPlugGeneratorperform = ISPlugGenerator.perform
--function ISPlugGenerator:perform(...)
--    CPowerbankSystem.instance.onPlugGenerator(self.character,self.generator,self.plug)
--    return ISPlugGeneratorperform(self,...)
--end
wrap(ISPlugGenerator,"perform",nil,CPowerbankSystem.postPlugGenerator)

require "TimedActions/ISInventoryTransferAction"
--local ISInventoryTransferActiontransferItem = ISInventoryTransferAction.transferItem
--function ISInventoryTransferAction:transferItem(item,...)
--    local original = ISInventoryTransferActiontransferItem(self,item,...)
--
--    CPowerbankSystem.instance.onInventoryTransfer(self.srcContainer:getParent(), self.destContainer:getParent(), item, self.character)
--
--    return original
--end
wrap(ISInventoryTransferAction,"transferItem",nil,CPowerbankSystem.postInventoryTransferAction)

require "Moveables/ISMoveablesAction"
--local ISMoveablesActionperform = ISMoveablesAction.perform
--function ISMoveablesAction:perform(...)
--    local type = ISAScan.Types[self.origSpriteName]
--    if type and self.mode == "pickup" then
--        local isoObjectSpecial = ISAScan.findOnSquare(self.square,self.origSpriteName)
--        if isoObjectSpecial then
--            if type == "Powerbank" then
--                isoObjectSpecial:getModData().charge = nil
--            elseif type == "Panel" then
--                isoObjectSpecial:getModData().connectDelta = nil
--            end
--        end
--    end
--
--    local o = ISMoveablesActionperform(self,...)
--
--    return o
--end
wrap(ISMoveablesAction,"perform",CPowerbankSystem.onMoveablesAction,nil)
