local isa = require "ISAUtilities"
require "UI/ISAUI"
local PbSystem = require "Powerbank/ISAPowerbankSystem_client"

isa.patchClassMetaMethod(zombie.inventory.types.DrainableComboItem.class,"DoTooltip",isa.UI.DoTooltip_patch)

require "ISUI/ISInventoryPane"
ISInventoryPane.drawItemDetails = isa.UI.ISInventoryPane_drawItemDetails_patch(ISInventoryPane.drawItemDetails)

require "TimedActions/ISActivateGenerator"
ISActivateGenerator.perform = PbSystem.ISActivateGenerator_perform(ISActivateGenerator.perform)

require "TimedActions/ISInventoryTransferAction"
ISInventoryTransferAction.transferItem = PbSystem.ISInventoryTransferAction_transferItem(ISInventoryTransferAction.transferItem)

require "TimedActions/ISPlugGenerator"
ISPlugGenerator.perform = PbSystem.ISPlugGenerator_perform(ISPlugGenerator.perform)

require "Moveables/ISMoveablesAction"
ISMoveablesAction.perform = PbSystem.ISMoveablesAction_perform(ISMoveablesAction.perform)
