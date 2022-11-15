local util = require "ISAUtilities"

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

local function patch(class,method,newFn)
    class[method] = newFn(class[method])
end

util.patchClassMetaMethod(zombie.inventory.types.DrainableComboItem.class,"DoTooltip",ISAMenu.DoTooltip_patch)

require "ISUI/ISInventoryPane"
patch(ISInventoryPane,"drawItemDetails",ISAMenu.ISInventoryPane_drawItemDetails_patch)

require "TimedActions/ISActivateGenerator"
wrap(ISActivateGenerator,"perform",nil,CPowerbankSystem.postActivateGenerator)

require "TimedActions/ISPlugGenerator"
wrap(ISPlugGenerator,"perform",nil,CPowerbankSystem.postPlugGenerator)

require "TimedActions/ISInventoryTransferAction"
wrap(ISInventoryTransferAction,"transferItem",nil,CPowerbankSystem.postInventoryTransferAction)

require "Moveables/ISMoveablesAction"
wrap(ISMoveablesAction,"perform",CPowerbankSystem.onMoveablesAction,nil)
